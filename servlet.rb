#!/usr/bin/ruby
# @Author: matt
# @Date:   2016-09-24 11:15:35
# @Last Modified by:   Matt
# @Last Modified time: 2016-09-24 22:37:57
require 'sinatra/base'
require 'net/http'
require 'json'

class FlightServlet < Sinatra::Base
    attr_accessor :name, :key, :url
    url = "https://demo30-test.apigee.net/v1/hack/tsa"
    key = "FQFMhNJmXqB34vRNk4THrnT9RiRnLiUG"
    get "/" do
        erb :index
    end

    post "/result" do
        # FLIGHT NUMBER INFO
        @date = params[:flightdate]
        @num = params[:flightnum]
        @API_FLIGHT_URL = "https://demo30-test.apigee.net/v1/hack/status?flightNumber=" + @num + "&flightOriginDate=" + @date + "&apikey=FQFMhNJmXqB34vRNk4THrnT9RiRnLiUG"
        uri = URI(@API_FLIGHT_URL)
        response = Net::HTTP.get(uri)
        json = JSON.parse(response)
        @departCode = json["flightStatusResponse"]["statusResponse"]["flightStatusTO"]["flightStatusLegTOList"]["departureAirportCode"]
        @departCity = json["flightStatusResponse"]["statusResponse"]["flightStatusTO"]["flightStatusLegTOList"]["departureCityName"]

        # FLIGHT WAITLIST INFO
        @API_WAITLIST_URL = "https://demo30-test.apigee.net/v1/hack/tsa?airport=" + (@departCode || "ORL") + "&apikey=FQFMhNJmXqB34vRNk4THrnT9RiRnLiUG"
        uri = URI(@API_WAITLIST_URL)
        response = Net::HTTP.get(uri)
        json = JSON.parse(response)
        @delayTSA = json["WaitTimeResult"][0]["waitTime"]

        # we want number, not string
        case @delayTSA
        when "1-10 min"
            @delayTSA = 10
        when "11-20 min"
            @delayTSA = 20
        when "21-30 min"
            @delayTSA = 30
        when "31-45 min"
            @delayTSA = 45
        when "46-60 min"
            @delayTSA = 60
        when "61-90 min"
            @delayTSA = 90
        when "91-120 min"
            @delayTSA = 120
        else
            @delayTSA = 150
        end
        #setup and return result erb
        erb :result
    end
    # start if launching file
    run! if app_file == $0
end
