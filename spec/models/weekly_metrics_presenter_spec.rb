require "spec_helper"

describe WeeklyMetricsPresenter do
  def availability_for(start_time, options={})
    availability = FactoryGirl.create(:availability, {:start_time => start_time, :duration => 60}.merge(options))
  end

  def appointment_for(start_time, options={})
    availability = availability_for(start_time, options)
    FactoryGirl.create(:appointment, :availability => availability)
  end

  context "#for_week_of" do
    it "is the current time if when not initialized with a value" do
      now = Time.now
      Time.stub(:now).and_return(now)

      wm_presenter = WeeklyMetricsPresenter.new
      expect(wm_presenter.for_week_of).to eq(now)
    end

    it "is the parsed time of the value presenter was initialized with" do
      wm_presenter = WeeklyMetricsPresenter.new("20130224")
      expect(wm_presenter.for_week_of).to eq(Time.parse("20130224"))
    end
  end

  context "#starting" do
    it "starts at the beginning of the week from the for week of value" do
      wm_presenter = WeeklyMetricsPresenter.new
      expect(wm_presenter.starting).to eq(Time.now.beginning_of_week(:sunday))
    end
  end

  context "#ending" do
    it "starts at the beginning of the week from the for week of value" do
      wm_presenter = WeeklyMetricsPresenter.new
      expect(wm_presenter.ending).to eq(Time.now.end_of_week(:sunday))
    end
  end

  context "#total_appointments" do
    it "returns the count of appointments from the database" do
      future_appointment = appointment_for(2.weeks.from_now)
      this_week = (Time.now.beginning_of_week(:sunday)...Time.now.end_of_week(:sunday))
      expected_count = rand(0..5)+1
      expected_count.times { appointment_for(rand(this_week)) }

      wm_presenter = WeeklyMetricsPresenter.new
      expect(wm_presenter.total_appointments).to eq(expected_count)
    end
  end

  context '#appointments_for' do
    it "returns the count of appointments from the database" do
      future_appointment = appointment_for(2.weeks.from_now)
      this_week = (Time.now.beginning_of_week(:sunday)...Time.now.end_of_week(:sunday))
      2.times { appointment_for(rand(this_week), city: 'Chicago') }
      1.times { appointment_for(rand(this_week), city: 'New York') }
      1.times { appointment_for(rand(this_week), city: 'Seattle') }

      wm_presenter = WeeklyMetricsPresenter.new
      expect(wm_presenter.appointments_for('Chicago')).to eq(2)
      expect(wm_presenter.appointments_for('New York')).to eq(1)
      expect(wm_presenter.appointments_for('San Francisco')).to eq(0)
      expect(wm_presenter.appointments_for('Seattle')).to eq(1)
    end
  end

  context "#include_date" do
    it "returns true if the the date is greater than the start and less than the end" do
      wm_presenter = WeeklyMetricsPresenter.new
      this_week = (wm_presenter.starting..wm_presenter.ending)

      expect(wm_presenter).to have_included_date(rand(this_week))
    end
  end

  context "when calculating abandoned availabilities" do
    it "returns the count of abandoned availabilities from the db" do
      arbitrary_date = Time.new(2014, 3, 19)
      expected_count = rand(0..5)+1
      expected_count.times do
        FactoryGirl.create(:availability,
                           :start_time => 1.day.ago(arbitrary_date),
                           :duration => 60
        )
      end

      wm_presenter = WeeklyMetricsPresenter.new("20140319")
      expect(wm_presenter.total_abandoned_availabilties).to eq(expected_count)
    end

    context 'for a city' do
      it "returns the count of abandoned availabilities from the db" do
        this_week = (Time.now.beginning_of_week(:sunday)...Time.now)
        2.times { availability_for(rand(this_week), city: 'Chicago') }
        1.times { availability_for(rand(this_week), city: 'New York') }

        wm_presenter = WeeklyMetricsPresenter.new
        expect(wm_presenter.abandoned_availabilities_for('Chicago')).to eq(2)
        expect(wm_presenter.abandoned_availabilities_for('New York')).to eq(1)
        expect(wm_presenter.abandoned_availabilities_for('San Francisco')).to eq(0)
      end
    end
  end
end
