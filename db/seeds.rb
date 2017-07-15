# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def random_token
  foo = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
  foo.sample(5).join
end

def create_availability_data
  possibilities = [
    { timezone: "Central Time (US & Canada)", city: "Chicago"},
    { timezone: "Pacific Time (US & Canada)", city: "San Francisco"},
    { timezone: "Eastern Time (US & Canada)", city: "New York"},
    { timezone: "Pacific Time (US & Canada)", city: "Seattle"},
    { timezone: "Central Time (US & Canada)", city: "Austin"},
  ]

  {start_time: 1.week.from_now, duration: 30, location: "Dev Bootcamp"}.merge(possibilities.sample)

end

15.times do
  random = random_token
  u = User.create!(
  email: "mentor-#{random}@example.com",
  first_name: "Ima",
  last_name: "Mentor-#{random}",
  activated: true,
  twitter_handle: "mentor_#{random}")

  u.availabilities.create!(create_availability_data)
end

mentee = User.create!(
email: "mentee@example.com",
first_name: "Ima",
last_name: "Mentee",
activated: true,
twitter_handle: "mentee"
)

availabilities = Availability.order("random()")
a = availabilities[0]
b = availabilities[1]
c = availabilities[2]

Appointment.create!(mentee: mentee, mentor: a.mentor, availability: a)
Appointment.create!(mentee: mentee, mentor: b.mentor, availability: b)
Appointment.create!(mentee: mentee, mentor: c.mentor, availability: c)
