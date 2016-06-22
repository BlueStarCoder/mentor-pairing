require 'spec_helper'

describe AppointmentRequestsController do
  describe "#new" do
    render_views

    it "warns you if someone else has requested this availability" do
      mentee = FactoryGirl.create(:mentee, activated: true)
      availability = FactoryGirl.create(:availability)

      get :new, availability_id: availability.id
      expect(response).not_to render_template(partial: "_existing_request")

      availability.appointment_requests.create!(mentee: mentee)
      get :new, availability_id: availability.id
      expect(response).to render_template(partial: "_existing_request")
    end
  end

  describe "#create" do
    it "creates a record of the appointment request" do
      availability = FactoryGirl.create(:availability)
      mentee = FactoryGirl.create(:mentee, activated: true)

      expect {
        post :create, availability_id: availability.id, email: mentee.email
      }.to change{mentee.appointment_requests.count}.by(1)
    end

    it "creates a new user if user doesn't exist and given params" do
      expect {
        post :create, email: "erik@example.com", :first_name => "Erik", :last_name => "Allar", :twitter_handle => "erik"
      }.to change{User.count}.by(1)
    end

    it "does not create a new user if user is exists but is unactivated" do
      user = FactoryGirl.create(:mentor, :activated => false)
      expect {
        post :create, email: user.email, :first_name => "Erik", :last_name => "Allar", :twitter_handle => "erik"
      }.not_to change{User.count}.by(1)
    end
  end
end
