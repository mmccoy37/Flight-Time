#!/usr/bin/ruby
# @Author: matt
# @Date:   2016-09-24 11:15:35
# @Last Modified by:   Matt
# @Last Modified time: 2016-09-24 16:35:48
require 'sinatra/base'
require 'net/http'
require 'json'

class FlightServlet < Sinatra::Base
    attr_accessor :name, :key, :url
    url = "https://demo30-test.apigee.net/v1/hack/tsa"
    key = "FQFMhNJmXqB34vRNk4THrnT9RiRnLiUG"
    get "/home" do
        @name = "matt"
        erb :index
    end
    post "/result" do
        @num = params[:flightinfo] || "unknown"
        @airport = params[:airport] || "unknown"
        url = url + "?airport=" + @airport + "&apikey=" + key
        puts url
        uri = URI(url)
        response = Net::HTTP.get(uri)
        JSON.parse(response)
        @data = JSON.parse(response)
        erb :result
    end

    # start if launching file
    run! if app_file == $0
end
