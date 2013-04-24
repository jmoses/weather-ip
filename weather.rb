#!ruby

require 'json'
require 'uri'
require 'net/http'

ip = ARGV[0]

ip_details = JSON.load(Net::HTTP.get(URI.parse("http://www.geobytes.com/IpLocator.htm?GetLocation&template=json.txt&IpAddress=#{ip}")))

country_code = ip_details['geobytes']['ISO2']
state = ip_details['geobytes']['code']
city_name = ip_details['geobytes']['city']


weather = JSON.load(Net::HTTP.get(URI.parse("http://api.openweathermap.org/data/2.1/find/name?units=imperial&q=#{city_name},#{state},#{country_code}")))

city = weather['list'].first
temp = city['main']['temp']
condition = city['weather'].first['description']

puts "It's currently #{temp} and '#{condition}' in #{city_name}"
