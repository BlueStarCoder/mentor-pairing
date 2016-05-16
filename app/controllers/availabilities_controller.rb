class AvailabilitiesController < ApplicationController

  def new
    @availability = Availability.new
  end

  def create
    mentor = find_or_activate_by_email
    MakesRecurringAvailabilities.new(mentor, format_start_time(availability_params)).make_availabilities
    redirect_to availabilities_path
  end

  def index
    @availabilities = Availability.visible.order(:start_time)
    @appointments = Appointment.visible.order(:start_time)
    @featured = User.featured_mentors

    respond_to do |format|
      format.html
      format.json { render :json => build_json(@availabilities) }
    end
  end

  def destroy
    Availability.destroy(params[:id])
    redirect_to :back
  end

  def remaining
    @cities = Location.all.select(&:physical?)
    render :layout => 'empty'
  end

  def remaining_in_city
    city = Location.find_by_slug(params[:city])

    @availabilities = Availability
      .visible
      .today(city.tz)
      .in_city(city.name)
      .without_appointment_requests

    if request.xhr?
      if stale?(etag: "xhr:#{@availabilities.pluck(:id).join(',')}")
        render :layout => false
      end
    else
      if stale?(etag: "html:#{@availabilities.pluck(:id).join(',')}")
        render :layout => 'empty'
      end
    end
  end


  private

  def availability_params
    params.require(:availability).permit('start_time(1s)', 'start_time(2i)',
                                         'start_time(3i)',
                                         :start_time,
                                         :duration, :timezone, :location,
                                         :setup_recurring, :recur_weekly,
                                         :recur_num, :city)
  end

  def format_start_time(time_params)
    return time_params unless time_params['start_time(1s)']
    tp = time_params.clone
    date = tp.delete('start_time(1s)')
    hour = tp.delete('start_time(4i)')
    minute = tp.delete('start_time(5i)')
    meridian = tp.delete('start_time(6i)')
    tp[:start_time] = DateTime.parse("#{date} #{hour}:#{minute}#{meridian}")
    tp
  end

  def build_json(availabilities)
    public_data = availabilities.map do |a|
      list = [:start_time, :end_time, :timezone, :location, :city].map {|attr| [attr, a[attr]]}
      hash = Hash[list]
      hash[:mentor_name] = a.mentor.name
      hash[:mentor_url] = a.mentor.twitter_handle
      hash
    end

    json = public_data.to_json
    json = params[:callback] + "(" + json + ")" if params[:callback].present?
    json
  end
end
