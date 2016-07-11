require 'spec_helper'

feature "Mentor creates availability" do

  context "when the mentor provides valid input" do
    given(:mentor) { FactoryGirl.create :mentor }

    scenario "persists the availability to the database" do
      mentoring_time = 1.week.from_now.change(:hour => 18, :min => 45).beginning_of_minute
      visit new_availability_path

      new_availability_form(mentor, mentoring_time)

      expect(page).to have_content "#{mentor.name} on #{mentoring_time.strftime("%m/%d/%Y")} from 6:45pm"
    end
  end

  context "when displaying the availabity request" do
    given(:mentor) { FactoryGirl.create :mentor }

    scenario "displays the user's full name" do
      availability = FactoryGirl.create(:availability)
      visit "/"

      avail_panel = find_link(availability.mentor.name).find(:xpath, "ancestor::div[@class='panel']")
      within(avail_panel) do
        click_link "Sign up"
      end

      expect(page).to have_text(availability.mentor.name)
    end
  end

  context "when the mentor provides recurrence parameters" do
    given(:mentor) { FactoryGirl.create :mentor }

    scenario "persists the availabilities to the database" do
      mentoring_time = 1.week.from_now
      visit new_availability_path

      expect {
        new_availability_form_recurring(mentor, mentoring_time)
      }.to change(Availability, :count).by(2)
    end

    scenario "all availabilities are viewable by mentor" do
      mentoring_time = 1.week.from_now.change(hour: 12, min: 45).beginning_of_minute
      second_time = mentoring_time + 7.days
      visit new_availability_path

      new_availability_form_recurring(mentor, mentoring_time)

      [mentoring_time, second_time].each do |time|
        expect(page).to have_content "#{mentor.name} on #{time.strftime("%m/%d/%Y")} from 12:45pm"
      end
    end
  end
end
