#!/usr/bin/ruby
# @Author: matt
# @Date:   2016-09-24 11:15:35
# @Last Modified by:   matt
# @Last Modified time: 2016-09-24 15:05:22
require 'sinatra/base'

class FlightServlet < Sinatra::Base
    attr_accessor :name
    get "/home" do
        @name = "matt"
        erb :index
    end
    post "/result" do
        @num = params[:flightinfo] || "unknown"
        erb :result
    end

    # start if launching file
    run! if app_file == $0
end
