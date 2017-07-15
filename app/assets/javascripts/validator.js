function toggleErrors(fields) {
  var noErrors = true;

  for(var i = 0; i < fields.length; i++) {

    if(fields[i].val()) {
      fields[i].removeClass("field_error");
    } else {
      noErrors = false;
      fields[i].addClass("field_error");
    }

  }

  return noErrors;
}

function checkStartTime() {
  var noErrors = true;

  var date = $("#availability_start_time_1s").val();
  var hour = $("#availability_start_time_4i_ option:selected").val();
  var minute = $("#availability_start_time_5i_ option:selected").val();
  var ampm = $("#availability_start_time_6i_ option:selected").val();

  var trueHour = hour;
  if (ampm == 'PM' && hour < 12) { trueHour = String(Number(hour) + 12) }
  if (ampm == 'AM' && hour == 12) { trueHour = 0 }

  var militaryDate = new Date(date + " " + trueHour + ":" + minute);

  if(militaryDate.getDay() != 0 && militaryDate.getDay() != 6 && trueHour < 18) {
    noErrors = false;

    $("#availability_start_time_1s").addClass("field_error");
    $("#availability_start_time_4i_").addClass("field_error");
    $("#availability_start_time_5i_").addClass("field_error");
    $("#availability_start_time_6i_").addClass("field_error");
    $("#core_hours_error").show();
  } else {
    $("#availability_start_time_1s").removeClass("field_error");
    $("#availability_start_time_4i_").removeClass("field_error");
    $("#availability_start_time_5i_").removeClass("field_error");
    $("#availability_start_time_6i_").removeClass("field_error");
    $("#core_hours_error").hide();
  }

  return noErrors;
}
