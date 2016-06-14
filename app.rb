require 'yaml'
require 'pry'

days = YAML.load_file('schedule.yml')
days.each_with_index do |day, index|
  puts "<div class='day'>"
  puts "<h2> Day #{index + 1}</h2>"
  day["day"].each do |events|
    events.each do |time, details|
      title = details["title"]
      urls = details["url"].split(",")
      lead = details["lead"]
      support = details["support"]
      puts "<div class='event'>"
      puts "<h3>"
      if urls[0] != ""
	puts "<a href='#{urls[0]}'>#{title}</a>"
      else
        puts "#{title}"
      end
      puts "</h3><small>#{time}</small>"
      if urls.length > 1
        puts "<ul>"
        urls.each do |url|
	  puts "<li><a href='#{url}'>#{url}</a></li>"
	end
        puts "</ul>"
      end
      if lead != "" && support != ""
	puts "<ul>
	  <li>#{lead}</li>
	  <li>#{support}</li>
	</ul>
	"
      end
      puts "</div>"
    end
  end
  puts "</div><hr>"
end
