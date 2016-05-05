module ApplicationHelper
  def display_availability(a)
    a.local_start_time.strftime("%m/%d/%Y") +
    " from " + a.local_start_time.strftime("%l:%M%P").strip +
    " to " + a.local_end_time.strftime("%l:%M%P ") + a.timezone +
    " at " + (a.location.blank? ? "Dev Bootcamp" : a.location) +
    (a.city.nil? ? "" : " in #{a.city}.")
  end

  def href_to_twitters_user(m)
    "https://twitter.com/" + m.twitter_handle
  end

  def display_twitter_handle(handle)
    handle && ("@" + handle.sub(/^@/, ''))
  end

  def month_link(symbol, month)
    link_to symbol, :month => month.strftime("%Y-%m-01")
  end

  def appointment_time_in_words(appointment)
    words = distance_of_time_in_words(Time.now, appointment.start_time)
    words + (appointment.start_time > Time.now ? " from now" : " ago")
  end

  def future_or_past_tense(start_time)
    Time.now < start_time ? "is mentoring" : "mentored"
  end
end
