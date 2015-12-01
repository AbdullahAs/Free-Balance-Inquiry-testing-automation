#!/usr/bin/env ruby

require 'rest-client'
require 'nokogiri'

# main call
def start
  loop_msisdns
  puts 'Done'
end

# loop list of MSISDNs then call SF service for each
def loop_msisdns
  array = read_msisdns_files
  unless array.empty?
    array.each do |msisdn|
      url = "http://10.64.239.220:8888/sqi/fbi?msisdn=#{msisdn.to_i}&reqId=12465451465465&reqUser=Hammam&reqChannel=Hammam&resFormat=XML&msgVersion=1&functionId=ALL&sType=PRE&mode=ALL&reqFunction=FBI"
      # puts url
      parse_xml(url)
    end
  end
end

# Parse the XML response
def parse_xml(url)
  response = RestClient.get url
  doc = Nokogiri::XML(response.to_str)
  # print_details(doc)
  write_to_file(doc)
end

# if the number doesn't have a resources? ignore it
def check_if_resorces_available

end

# Write XML response to a file
def write_to_file(doc)
  subscriberId = doc.at_xpath('///subscriberId')
  File.open('tests/' + File.basename(subscriberId, File.extname(subscriberId)) + '.xml', 'w') {|f| f.write(doc)}
end

# Print XML response details
def print_details(doc)
  summary = doc.at_xpath('//summary')
  custInfo = doc.at_xpath('//custInfo')
  subscriberId = doc.at_xpath('///subscriberId')
  puts subscriberId.content
end

# read MSISDNs from file into an array
def read_msisdns_files
  array = []
  File.open('MSISDNs.txt') do |f|
    f.each_line.each do |line|
      array << line
    end
  end
  array
end

# start running the script
start
