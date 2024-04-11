require "http"
require "json"

pp "Where are you?"
user_location = gets.chomp

gmaps_key = ENV.fetch("GMAPS_KEY")

gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{user_location}&key=#{gmaps_key}"

raw_gmaps_data = HTTP.get(gmaps_url)
#pp raw_gmaps_data

parsed_response = JSON.parse(raw_gmaps_data)
#pp parsed_response

results_array = parsed_response.fetch("results")
#pp results_array

results_array = results_array.at(0)
#pp results_array

geometry_hash = results_array.fetch("geometry")
#pp geometry_hash

location_hash = geometry_hash.fetch("location")
#pp location_hash

latitude = location_hash.fetch("lat")
longitude = location_hash.fetch("lng")

puts "Your coordinates are #{latitude}, #{longitude}."

pirate_weather_key = ENV.fetch("PIRATE_WEATHER_KEY")

pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_key}/#{latitude},#{longitude}"
#pp pirate_weather_url

raw_pirate_weather_response = HTTP.get(pirate_weather_url)

pirate_weather_parsed_response = JSON.parse(raw_pirate_weather_response)
#pp pirate_weather_parsed_response

currently_hash = pirate_weather_parsed_response.fetch("currently")
#pp currently_hash

current_temp = currently_hash.fetch("temperature")
puts "It is currently #{current_temp}°F."

precipitation = currently_hash.fetch("precipProbability").to_f*100

precip_prob_threshold = 10
any_precipitation = false

if precipitation > precip_prob_threshold
  any_precipitation = true
end

if any_precipitation == true
  puts "You might want to take an umbrella! The rain probability is #{precipitation}%."
else
  puts "You probably won't need an umbrella. The rain probability is #{precipitation}%."
end
