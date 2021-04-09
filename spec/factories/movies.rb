FactoryBot.define do
  factory :movie do
    movie_url { "https://www.youtube.com/watch?v=LXb3EKWsInQ" }
    association :user
  end
end