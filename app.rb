require 'yaml'
thing = YAML.load_file('schedule.yml')
thing.each do |t|
p t
p "===="
end
