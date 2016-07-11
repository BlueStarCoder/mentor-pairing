module FormHelper
  def new_availability_form(mentor, mentoring_time)
    fill_in :first_name, with: mentor.first_name
    fill_in :last_name, with: mentor.last_name
    fill_in :email, with: mentor.email
    fill_in :twitter_handle, with: mentor.twitter_handle
    fill_in :availability_duration, with: 60
    select_datetime(mentoring_time, :availability_start_time)
    click_on :submit_availability
  end

  def new_availability_form_recurring(mentor, mentoring_time)
    fill_in :first_name, with: mentor.first_name
    fill_in :last_name, with: mentor.last_name
    fill_in :email, with: mentor.email
    fill_in :twitter_handle, with: mentor.twitter_handle
    fill_in :availability_duration, with: 60
    select_datetime(mentoring_time, :availability_start_time)
    check :availability_setup_recurring
    select("week", :from => :availability_recur_weekly)
    select("1", :from => :availability_recur_num)
    click_on :submit_availability
  end
end
