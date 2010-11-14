require "spec_helper"
require "heroscale"

require "json"

describe Heroscale::Middleware do

  # this is our original app (that the middleware is wrapping around)
  let(:orig_app) do
    lambda do |env|
      [ 200, {'Content-Type' => 'application/json'}, "HELLO!"]
    end
  end

  # this is our app with the middleware attached
  let(:app) do
    Heroscale::Middleware.new orig_app
  end

  def heroku_request(opts = {})
    app.call({
      'PATH_INFO' => '/heroscale/status',
      'HTTP_X_HEROKU_QUEUE_WAIT_TIME' => (opts[:wait] || 100),
      'HTTP_X_HEROKU_QUEUE_DEPTH' => (opts[:depth] || 0),
      'HTTP_X_HEROKU_DYNOS_IN_USE' => (opts[:dynos] || 1)
    })
  end

  context "when querying on a heroku instance" do
    before(:each) do
      @rack_response = heroku_request(:wait => 100, :depth => 5, :dynos => 12)
      @json = JSON.parse(@rack_response.last)
    end

    it "should return the 'heroku' field that tells that we're on heroku" do
      @json["heroku"].should == true
    end

    it "should return the 'queue_wait_time' field that tells us the queue wait time" do
      @json["queue_wait_time"].should == 100
    end

    it "should return the 'queue_depth' field that tells us the current queue depth" do
      @json["queue_depth"].should == 5
    end

    it "should return the 'dynos_in_use' field that tells us the current heroku dynos in use" do
      @json["dynos_in_use"].should == 12
    end

  end

  context "when not quering the status link" do
    it "should return the original app's response" do
      app.call({}).last.should == "HELLO!"
      app.call({"PATH_INFO" => "/"}).last.should == "HELLO!"
      app.call({"PATH_INFO" => "/heroscale/"}).last.should == "HELLO!"
      app.call({"PATH_INFO" => "/heroscale/status2"}).last.should == "HELLO!"
    end

  end

  context "when query while not on a heroku instance" do
    before(:each) do
      @rack_response = app.call({"PATH_INFO" => "/heroscale/status"})
      @json = JSON.parse(@rack_response.last)
    end

    it "should return the 'heroku' field telling use we're not on heroku" do
      @json["heroku"].should == false
    end
  end

end