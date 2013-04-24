#!ruby

require 'json'
require 'uri'
require 'net/http'
require 'logger'

ip = ARGV[0]

class Location
  attr_accessor :ip
  def initialize(ip)
    @ip = ip
  end

  def city
    data['city']
  end

  def region_code
    data['region_code']
  end

  def country_code
    data['country_code']
  end

  def temp
    weather['main']['temp']
  end

  def condition
    weather['weather'].first['description']
  end

  private
  def data
    @data ||= begin
      JSON.load(Net::HTTP.get(URI.parse("http://freegeoip.net/json/#{ip}"))).tap do |d|
        logger.debug "City data: #{d}"
      end
    end
  end

  def weather
    @weather ||= begin
      JSON.load(Net::HTTP.get(URI.parse("http://api.openweathermap.org/data/2.1/find/name?units=imperial&q=#{city},#{region_code},#{country_code}")))['list'].first
    end
  end

  def logger
    @logger ||= Logger.new(STDOUT).tap {|l| l.level = Logger::DEBUG }
  end
end

location = Location.new(ip)

begin
  puts "It's currently #{location.temp} and '#{location.condition}' in #{location.city}"
rescue
  puts "It's currently nothing."
end
