# README

### Ruby version: 2.6.6
### Rails version: 6.0.3.6

### Postgres version: 12.x

### Gem using:
- Devise: for basic authentication flow
- Pagy: pagination
- Rspec, shoulda-matchers, simplecov, faker: for unit testing and data seeding

### 3rd party using:
- Heroku: Cloud platform

### Heroku production
https://still-caverns-03836.herokuapp.com/

### Environment configuration
```
DATABASE_USERNAME=username
DATABASE_PASSWORD=passowrd
DATABASE_PORT=5432
DATABASE_HOST=localhost
YOUTUBE_API_KEY=yourkey
```

### Setup guide
1. create `.env` on root directory follow `sample.env` file
2. run `rake db:create` command to create database
3. run `rake db:migrate` command to run migration
4. run `rails s` command to start server
5. run `./bin/webpack-dev-server` command to start webpack dev server ( optional )

### How to run test?
run `rspec` command 
