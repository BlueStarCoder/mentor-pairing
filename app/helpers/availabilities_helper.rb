module AvailabilitiesHelper

  def hour_select
    hour = select_tag('availability[start_time(4i)]',options_for_select([1,2,3,4,5,6,7,8,9,10,11,12], 6))
  end

  def minute_select
    minute = select_tag('availability[start_time(5i)]',options_for_select(['00','15','30','45'], '00'))
  end

  def ampm_select
      ampm = select_tag('availability[start_time(6i)]', options_for_select(['PM', 'AM'], 'PM'))
  end
end
