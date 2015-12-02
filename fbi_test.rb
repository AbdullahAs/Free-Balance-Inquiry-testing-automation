#!/usr/bin/env ruby

require 'rest-client'
require 'nokogiri'

# main call
def start
  loop_msisdns
  puts "Done with #{@number_of_successful_MSISDNs} result"
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

# loop list of MSISDNs then call SF service for each
def loop_msisdns
  array = read_msisdns_files
  unless array.empty?
    array.each do |msisdn|
      url = "http://10.64.239.220:8888/sqi/fbi?msisdn=#{msisdn.to_i}&reqId=12465451465465&reqUser=Hammam&reqChannel=Hammam&resFormat=XML&msgVersion=1&functionId=ALL&sType=PRE&mode=ALL&reqFunction=FBI"
      parse_xml(url)
    end
  end
end

# Parse the XML response
def parse_xml(url)
  response = RestClient.get url
  doc = Nokogiri::XML(response.to_str)
  check_if_resorces_available(doc)
end

# if the number doesn't have a resources? ignore it
def check_if_resorces_available(doc)
  resourceType = doc.xpath('//resourceType')

  unless resourceType.length == 0
    subscriberId = doc.at_xpath('///subscriberId').content
    balance = doc.at_xpath('///balance').content
    write_to_file(doc)
    resources = find_resources_of_msisdn(doc, subscriberId, balance)
    puts "#{subscriberId} has been added"
    @number_of_successful_MSISDNs += 1
  end
end

# Write XML response to a file
def write_to_file(doc)
  subscriberId = doc.at_xpath('///subscriberId').content

  f = File.open('POT/' + File.basename(subscriberId, File.extname(subscriberId)) + '.txt', 'w')
  f.write('MSISDN: ' + subscriberId + "\n")
  f.write(doc)
  f.close
end

# find the FBI resources and return them in an array
def find_resources_of_msisdn(doc, subscriberId, balance)
  resources = Hash.new{|hash, key| hash[key] = Hash.new }
  doc.css('resource').each do |r|
    source = r.css('source')[0].text
    resources[source]['type'] = r.css('type')[0].text
    resources[source]['specialUse'] = r.css('specialUse')[0].text
    resources[source]['remaining'] = r.css('remaining')[0].text
    resources[source]['consumed'] = r.css('consumed')[0].text
    resources[source]['original'] = r.css('original')[0].text
  end
  write_to_summary_file(resources, subscriberId, balance)
end

# print MSISDN + the resources it has into the summary file, in the following format
# MSISDN: 966561055043
# ---
# Source 1: Prime Package - VOICE-OnNet: c[362] r[1638] t[2000]
# ....
def write_to_summary_file(resources, subscriberId, balance)
  source = 1
  @summary_file.write('MSISDN: ' + subscriberId + " - Balance: " + balance + "\n")
  @summary_file.write("--- \n")
  resources.each do |r|
    @summary_file.write("Source #{source}: " + r.to_s + "\n")
    source += 1
  end
  @summary_file.write("================== \n\n")
end

@summary_file = File.open('summary.txt', 'w')
@number_of_successful_MSISDNs = 1
start
@summary_file.close