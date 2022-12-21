require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def histogram(list)
  list.reduce(Hash.new(0)) do |acc, value|
    acc[value.to_s] += 1
    acc
  end
end

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,'0')[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyB-5ZX4ksrhoMIMGy9HLXmvq479hw21pk0'

  begin
    legislators = civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    )

    legislators = legislators.officials

    legislators.map(&:name).join(", ")
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exists? 'output'

  filename = "output/thanks_#{id}.html"
  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def save_days_of_week(days)
  weekdays = {
    "0" => 'Monday',
    "1" => 'Tuesday',
    "2" => 'Wednesday',
    "3" => 'Thursday',
    "4" => 'Friday',
    "5" => 'Saturday',
    "6" => 'Sunday',
  }
  Dir.mkdir('output') unless Dir.exists? 'output'
  filename = 'output/week_days.txt'

  File.open(filename, 'w') do |file|
    days.sort.each do |key, value|
      day = weekdays[key]
      file.puts "#{day} - #{value}"
    end
  end
end

puts 'Event Manager Initialized!'

filename = 'event_attendees.csv'

contents = CSV.open(
  filename, headers: true, 
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

registration_times = []

# Save Thank You Letters
contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)

  registration_times << row[:regdate] unless row[:regdate].nil?

  form_letter = erb_template.result binding

  save_thank_you_letter(id, form_letter)
end

# Get Registration hours data
hours = registration_times.map do |date|
  (date_string, time) = date.split()
  (m,d,y) = date_string.split('/')
  (hour,min) = time.split(":")

  time = Time.new(y,m,d,hour,min)
  time.hour
end

# Get Registration week days data
week_days = registration_times.map do |date|
  (date_string, time) = date.split()
  (m,d,y) = date_string.split('/')
  Date.strptime(date_string, "%m/%d/%y").wday
end

date_distribution = histogram week_days
save_days_of_week date_distribution

# Save Registration hours data to file
hours_distribution = histogram hours

Dir.mkdir('output') unless Dir.exists? 'output'
filename = 'output/hours.txt'

File.open(filename, 'w') do |file|
  hours_distribution.sort.each do |key, value|
    hour = key.to_s.rjust(2,'0')
    file.puts "#{hour}:00 - #{value}"
  end
end