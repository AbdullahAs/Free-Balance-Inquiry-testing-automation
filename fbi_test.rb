#!/usr/bin/env ruby

require 'rest-client'

MSISDNs = ['966544447651', '966565902163', '966548889924']

MSISDNs.each do |m|
  url = "http://10.64.239.220:8888/sqi/fbi?msisdn=#{m}&reqId=12465451465465&reqUser=Hammam&reqChannel=Hammam&resFormat=XML&msgVersion=1&functionId=ALL&sType=PRE&mode=ALL&reqFunction=FBI"
  response = RestClient.get url
  puts response.to_str
end