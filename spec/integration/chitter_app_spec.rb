require "spec_helper"
require "rack/test"
require_relative '../../chitter_app'

describe ChitterApp do
  include Rack::Test::Methods

  let(:app) { ChitterApp.new }

  def reset_tables
    seed_sql = File.read('spec/seeds/chitter_seed.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_test' })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_tables
  end

  describe "GET /" do
    it "displays a list of peeps in reverse chronological order" do
      response = get "/"
      expect(response.status).to eq 200
  
      expected_peeps = [
        "Going to the beach tomorrow",
        "Can't wait for the weekend",
        "Just finished a long day at work",
        "I love Chitter!",
        "This is a test peep",
        "Hello, world!"
      ]
      
      # Extracts all peep content from the HTML response body using 
      # regex and stores it in a flattened array called actual_peeps.
      actual_peeps = response.body.scan(/<p class="peep__content">(.+)<\/p>/).flatten
      expect(actual_peeps).to eq(expected_peeps)
    end

    it "displays the username of peeper" do
      response = get "/"
      expect(response.status).to eq 200
    
      expected_username = "by ringofpower"
      actual_username = response.body.scan(/<p class="peep__username">(.+)<\/p>/).flatten.first
      expect(actual_username).to eq(expected_username)
    end

    it "displays the time of peep" do
      response = get "/"
      expect(response.status).to eq 200
    
      expected_time = "2022-04-10 11:00:00"
      actual_time = response.body.scan(/<p class="peep__time">(.+)<\/p>/).flatten.first
      expect(actual_time).to eq(expected_time)
    end
  end
  
  describe "GET /signup" do
    it "displays a form to sign up" do
      response = get "/signup"
      expect(response.status).to eq 200
      expect(response.body).to include("<h1>Sign Up</h1>")
      expect(response.body).to include("Username")
      expect(response.body).to include("Email")
      expect(response.body).to include("Password")
    end
  end
end
  
