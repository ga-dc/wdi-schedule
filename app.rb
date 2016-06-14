require 'yaml'
require 'pry'

puts "<link rel='stylesheet' type='text/css' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css'>"
puts "<style>h2 a{color:inherit;}</style>"
days = YAML.load_file('schedule.yml')
counter = 0
days.each_with_index do |day, index|
  puts "<div class='day container'>"
  is_saturday = (Date.today + counter).wday == 6
  counter += 2 if is_saturday
  today = (Date.today + counter).strftime("%A, %m/%d")
  puts "<h2 id='#{index}'><a href='##{index}'>#{today}</a></h2>"
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
  counter += 1
end
