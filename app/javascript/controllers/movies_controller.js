import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['list', 'loadmoreBtn', 'movieItem']
  connect() {
    // Map youtube info to first time rendered video
    this.mapYoutubeInfoIntoDoms(this.movieItemTargets)
  }

  mapYoutubeInfoIntoDoms(movieDomTargets) {
    let movieItemDomHash = {}
    let mappedPromise = movieDomTargets.map(movieItemDom => {
      let youtubeId = movieItemDom.dataset['youtubeId']
      movieItemDomHash[youtubeId] = movieItemDom
      return this.fetchDataFromYoutubeApi(youtubeId)
    })
    Promise.all(mappedPromise)
      .then(res => {
        if (res && res.length > 0) {
          for (let videoRes of res) {
            let snippet = videoRes.items[0].snippet
            let dom = movieItemDomHash[videoRes.items[0].id]
            dom.querySelector(".movie-title").innerHTML = snippet.title
            dom.querySelector(".movie-description").innerHTML = snippet.description.substring(0, 240) + "..."
          }
        }
      })
      .catch(err => console.log({ err }))
  }

  fetchDataFromYoutubeApi(yId) {
    let yApiKey = this.element.dataset['youtubeApiKey']
    let endpoint = "https://www.googleapis.com/youtube/v3/videos?part=snippet&id=" + yId + "&key=" + yApiKey

    return fetch(endpoint).then(response => response.json())
  }

  loadmore() {
    let nextPage = this.element.dataset['nextPage'];
    let lastPage = this.element.dataset['lastPage'];

    if (lastPage == "true") return

    //Load more
    fetch("/?page=" + nextPage)
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          this.listTarget.insertAdjacentHTML("beforeend", data.html)
          this.element.dataset['nextPage'] = data.next_page
          this.element.dataset['lastPage'] = data.last_page
          if (data.last_page) {
            this.loadmoreBtnTarget.disabled = true
            this.loadmoreBtnTarget.innerHTML = "No more movies"
          }

          // Map youtube info into new doms
          if (data.movie_ids && data.movie_ids.length > 0) {
            let filteredTargets = this.movieItemTargets.filter(dom => data.movie_ids.includes(parseInt(dom.dataset['internalId'])))
            this.mapYoutubeInfoIntoDoms(filteredTargets)
          }
        }
      })
      .catch(err => console.log(err))
  }
}
