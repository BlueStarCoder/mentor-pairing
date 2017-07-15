$(function () {
  $('#availability_start_time_1s').datepicker({
    dateFormat: 'yy-mm-dd',
    showOtherMonths: true,
    selectOtherMonths: true});

  $("#availability").on("submit", function(event){
    var fields = [$("#first_name"), $("#last_name"), $("#email"), $("#availability_duration"), $("#availability_location")];
    return checkStartTime() && toggleErrors(fields);
  });
});
