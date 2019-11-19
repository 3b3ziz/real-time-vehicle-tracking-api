# Door2door Backend Challenge README

This app uses Ruby(Rails), Postgres, Redis and Sidekiq.

To initialize the backend app, please run `docker-compose up` then `docker-compose run web rake db:migrate`.

To run the app locally, make sure that those dependencies exist on your machine. Then run the following commands in order: 
1. `rails db:create`.
2. `rails db:migrate`.
3. `bundle exec sidekiq`.
4. `bundle exec rails s -b '0.0.0.0' -p 10000`.

The app uses Postgres to store all vehicles and locations and Firebase to store one real-time location per vehicle.

The app also uses Sidekiq to run the API external request (To Firebase) throught a delayed job in order to reduce the request cycle time.
