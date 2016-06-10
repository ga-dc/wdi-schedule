require 'pry'
events = []
real_events = []
temp = {}

def strftime str
  str.split("T")[1][0...4]
end

File.open("./wdi_cal.ics") do |file|
  file.each do |line|
    if line.match(/BEGIN:VEVENT/)
      temp = {}
    end
    key = line.match(/^[A-Z\-]+/)[0]
    value = line.split(key + ":")[1]
    value = value.gsub("\n", "").gsub("\r", "") if value
    temp[key] = value
    if line.match("END:VEVENT")
      events << temp
      temp = {}
    end
  end
end

events.each do |event|
  if event["BEGIN"] == "VEVENT" && event["DTSTART"]
    real_events << event
  end
end

real_events.each do |event|
  start = strftime(event["DTSTART"])
  endd = strftime(event["DTEND"])
  puts "- day:"
  puts " - #{start} - #{endd}:"
end



binding.pry
puts "puts fixes"
