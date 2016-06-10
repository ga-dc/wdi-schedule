require 'yaml'
require 'pry'

days = YAML.load_file('schedule.yml')
days.each_with_index do |day, index|
  puts "<div class='day'>"
  puts "<h2> Day #{index + 1}</h2>"
  day["day"].each do |events|
    events.each do |time, details|
      title = details["title"]
      url = details["url"]
      lead = details["lead"]
      support = details["support"]
      puts "
      <div class='event'>
	<h2><a href='#{url}'>#{time}: #{title}</a></h2>
	<ul>
	  <li>#{lead}</li>
	  <li>#{support}</li>
	</ul>
      </div>"
    end
  end
  puts "</div>"
end


