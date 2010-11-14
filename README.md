Heroscale
=============

This gem provides a Rack Interface to your Heroku web app that allows you to query the current `HTTP_X_HEROKU_QUEUE_DEPTH` for your app via an api handler

This allows you to query your app to get the queue size and current dyno count
/heroscale/status

## Installation (Rails 3)

To install Heroscale, just add the following line to your Gemfile:

    gem "heroscale"

Then run `bundle install`

## Deploy to Heroku and test that it works

After adding the gem and configuraton, go ahead and deploy to heroku

    git push heroku master

Once you've deployed and everything seems to be working, go ahead and test it out by running

    rake heroscale:test

This will query your heroku app and verify that it is returning the right response.

## Securing

For most people, having the queue size and dynos on a publically available url is not a big deal. However if you want to secure it, just run:

    rails g heroscale:secure

This will generate an config within config/initializers/heroscale.rb with a generated api key

    Heroscale.configure do |c|
      c.api_key = "my_api_key"
    end

Queries to your app will then need to be: `/heroscale/status?api=my_api_key`

Redeploy to Heroku and then run:

    rake heroscale:test

to verify everything is still working

## Installation (Sinatra)

Just add Heroscale::Middleware to your config.ru

TODO: more details

## Installation (Rails 2)

TODO: more details

