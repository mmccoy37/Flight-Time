#!/usr/bin/ruby
# @Author: matt
# @Date:   2016-09-24 11:15:35
# @Last Modified by:   Matt
# @Last Modified time: 2016-09-24 18:04:07
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
    # post "/result" do
    #     @num = params[:flightinfo] || "unknown"
    #     @airport = params[:airport] || "unknown"
    #     url = url + "?airport=" + @airport + "&apikey=" + key
    #     puts url
    #     uri = URI(url)
    #     response = Net::HTTP.get(uri)
    #     json = JSON.parse(response)
    #     @data = json["WaitTimeResult"][0]["waitTime"]
    #     # puts json
    #     erb :result
    # end

    post "/result" do
        # FLIGHT NUMBER INFO
        @date = params[:flightdate]
        @num = params[:flightnum]
        @API_FLIGHT_URL = "https://demo30-test.apigee.net/v1/hack/status?flightNumber=" + @num + "&flightOriginDate=" + @date + "&apikey=FQFMhNJmXqB34vRNk4THrnT9RiRnLiUG"
        uri = URI(@API_FLIGHT_URL)
        response = Net::HTTP.get(uri)
        json = JSON.parse(response)
        # used for wait time lookup
        @departCode = json["flightStatusResponse"]["statusResponse"]["flightStatusTO"]["flightStatusLegTOList"]["departureAirportCode"]
        # used for google maps
        @departCity = json["flightStatusResponse"]["statusResponse"]["flightStatusTO"]["flightStatusLegTOList"]["departureCityName"]

        # FLIGHT WAITLIST INFO
        @API_WAITLIST_URL = "https://demo30-test.apigee.net/v1/hack/tsa?airport=" + (@departCode || "ORL") + "&apikey=FQFMhNJmXqB34vRNk4THrnT9RiRnLiUG"
        uri = URI(@API_WAITLIST_URL)
        response = Net::HTTP.get(uri)
        json = JSON.parse(response)
        @data = json["WaitTimeResult"][0]["waitTime"]

        #setup and return result erb
        erb :result
    end

    # start if launching file
    run! if app_file == $0
end
