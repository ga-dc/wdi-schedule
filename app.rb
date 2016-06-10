require 'yaml'
require 'pry'
days = YAML.load_file('schedule.yml')
days.each_with_index do |day, index|
  puts "# Day #{index + 1}"
  day["day"].each do |events|
    events.each do |time, details|
      puts "## #{time}"
      puts "### #{details["title"]}"
      puts "### #{details["url"]}"
      puts "### #{details["lead"]}"
      puts "### #{details["support"]}"
    end
  end
end
