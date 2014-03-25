require 'spec_helper'

describe AvailabilitiesController do
  describe "#create" do
    let(:mentor) { FactoryGirl.create(:mentor) }

    it "creates a new availability given params" do
      expect {
        post :create, email: mentor.email, availability: FactoryGirl.attributes_for(:availability)
      }.to change{Availability.count}.by(1)
    end

    it "returns mentor info with JSON" do
      availability = FactoryGirl.create(:availability)
      get :index, :format => :json
      JSON.parse(response.body).first["mentor_name"].should == availability.mentor.name
    end

    it "handles datepicker style start times" do
      availability_params = {
        :duration => 30,
        'start_time(1s)' => '2013-01-01',
        'start_time(4i)' => '00',
        'start_time(5i)' => '00',
        :timezone => 'UTC',
        :city => 'Chicago'
      }
      expect do
        post :create, email: mentor.email, availability: availability_params
      end.to change{Availability.count}.by(1)
    end
  end
end
