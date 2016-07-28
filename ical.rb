require 'pry'
events = []
wdi_events = []
temp = {}

def civil_to_est str
  # 20160524T120000
  #http://ruby-doc.org/stdlib-2.3.1/libdoc/date/rdoc/DateTime.html#method-c-civil
  # need to convert a string in civil format to standard EST
  # TODO: account for DST
  hour = str[-7,2].to_i
  min = str[-5,2].to_i
  year = str[0,4].to_i
  month = str[4,2].to_i
  day = str[6,2].to_i
  offset = "-4" # EST
  dt = DateTime.new(year, month, day, hour, min).new_offset(offset)
  time = dt.strftime("%I:%M%p")
end

File.open("wdi_cal.ics") do |file|
  p file
  file.each do |line|
    if line.match(/BEGIN:VEVENT/)
      temp = {}
    end
    begin
    key = line.match(/^[A-Z\-]+/)[0]
    value = line.split(key + ":")[1]
    rescue
      key, value = nil
    end
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
  str = str.gsub("\\", "")
  info = []
  if str.include?("/") # lesson
    opi = str.index(/\(/)
    cpi = str.index(/\)/)
    fsi = str.index(/\//) # convention: lead before slash, support after
    begin
      info << str[cpi + 2, str.length - 1] # title
      info << str[opi + 1, fsi - 1] # lead
      info << str[fsi + 1..cpi-1] # support
    rescue
      info << ""
      info << ""
      info << ""
    end
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

new_day = true

wdi_events = wdi_events.sort_by{|event| Date.parse(event["DTSTART"])}
wdi_events.each do |event|
  current_day = Date.parse(event["DTSTART"]).strftime("%F")
  start = civil_to_est(event["DTSTART"])
  endd = civil_to_est(event["DTEND"])
  info = parse_summary(event["SUMMARY"])
  urls = event["DESCRIPTION"].scan(/"(.*?)"/) if event["DESCRIPTION"].include?("\<a")
  urls && urls.length > 1 ? url = urls.flatten.uniq.join(", ") : url = urls.flatten.uniq[0] if urls
  if new_day != current_day
    puts "- day:"
    new_day = current_day
  end
  puts "  - \"#{start} - #{endd}\":"
  puts "     title: \"#{info[0]}\""
  puts "     url: \"#{url}\""
  puts "     lead: \"#{info[1]}\""
  puts "     support: \"#{info[2]}\""
end
