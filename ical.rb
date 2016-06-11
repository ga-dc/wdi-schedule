require 'pry'
events = []
wdi_events = []
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
    wdi_events << event
  end
end

# given an event's summary as a string
# returns array with event's title, lead, and support
# NOTE assumes most events are following naming convention: "(Adrian / Jesse) Git Branching"
def parse_summary str
  info = []
  if str.include?("/") # lesson
    opi = str.index(/\(/)
    cpi = str.index(/\)/)
    fsi = str.index(/\//) # convention: lead before slash, support after
    info << str[cpi + 2, str.length - 1] # title
    info << str[opi + 1, fsi - 1] # lead
    info << str[fsi + 1..cpi-1] # support
  elsif str.include?(")") # no support scheduled
    # TODO deal with non-conventional parens in event title
    info << str[str.index(/\)/) +2, str.length - 1]
    info << str[/\((.*?)\)/, 1] # grab anything between parens
    info << ""
  else # no support or lead
    info = [str, "", ""]
  end
  info
end

wdi_events.each do |event|
  start = strftime(event["DTSTART"])
  endd = strftime(event["DTEND"])
  info = parse_summary(event["SUMMARY"])
  url = event["DESCRIPTION"][/\"(.*?)\"/, 1] if event["DESCRIPTION"].include?("\<a") # TODO deal with multiple urls
  puts "- day:"
  puts " - #{start} - #{endd}:"
  puts "   title: #{info[0]}"
  puts "   url: #{url}"
  puts "   lead: #{info[1]}"
  puts "   support: #{info[2]}"
end



binding.pry
puts "puts fixes"
