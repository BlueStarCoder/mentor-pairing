class UserMailer < ActionMailer::Base
  default from: "no-reply@devbootcamp.com"
  add_template_helper(ApplicationHelper)

  def user_activation(user)
    @user = user

    @url = "http://mentoring.devbootcamp.com/activations/" + user.activation_code + "/user"

    mail(:to => user.email, :subject => "Please confirm that you're an actual person")
  end

  def appointment_request(availability, mentee)
    @availability = availability
    @mentor = availability.mentor
    @mentee = mentee

    @url = "http://mentoring.devbootcamp.com/appointments/" + @mentor.activation_code + "/create?mentee_id=#{@mentee.id}&availability_id=#{@availability.id}"

    mail(:to => @mentor.email, :subject => "#{@mentee.name} has requested to learn with you")
  end

  def appointment_confirmation(appointment)
    @appointment = appointment
    @mentor = appointment.mentor
    @mentee = appointment.mentee

    mail(:to => @mentee.email, :subject => "#{@mentor.name} has agreed to learn with you!")
  end

  def appointment_rejection(availability, mentee)
    @availability = availability
    @mentor = availability.mentor
    @mentee = mentee

    mail(:to => @mentee.email, :subject => "#{@mentor.name} isn't available at the time you requested")
  end

  def appointment_deletion(appointment)
    @appointment = appointment
    @mentor = appointment.mentor
    @mentee = appointment.mentee

    mail(:to => [@mentee.email,@mentor.email], :subject => "Mentoring appointment canceled")
  end

  def feedback_request(appointment, giver, receiver)
    @appointment = appointment
    @giver = giver
    @receiver = receiver

    mail(:to => giver.email, :subject => "#{@receiver.name} would like feedback about your session")
  end

  def new_feedback_notification(feedback)
    @feedback = feedback
    mail(:to => feedback.feedback_receiver.email, :subject => "You have new feedback from a pairing session")
  end

  def management_link(user)
    @user = user
    mail(:to => user.email, :subject => "Your Pairing is Caring Managment Link")
  end
end
