import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['list', 'loadmoreBtn']
  connect() {}

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
        }
      })
      .catch(err => console.log(err))
  }
}
