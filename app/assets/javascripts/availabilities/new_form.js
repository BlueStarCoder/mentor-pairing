var TimeZoneHelper = {
  setTz: function () {
    var city = $(this).val();
    var tz = TimeZoneHelper.cityTimezones[city];
    if (tz) {
      $("#availability_timezone")
        .find("option[value='"+tz+"']")
        .prop("selected",true);
    }
  },
  cityTimezones: {
    'Chicago':"Central Time (US & Canada)",
    'San Francisco':"Pacific Time (US & Canada)",
    'New York':"Eastern Time (US & Canada)",
    'San Diego':"Pacific Time (US & Canada)",
    'Seattle':"Pacific Time (US & Canada)",
    'Austin':"Central Time (US & Canada)"
  }
};

var FindByEmail = {
  find: function() {
    var userEmail = {email: $('#email').val()};

    $.ajax({
      url: '/users/findmentor',
      type: 'POST',
      data: userEmail,
      dataType: "JSON"
    }).done(FindByEmail.populate);
  },
  populate: function(response) {
    if (!response.no_user) {
      $('#first_name').val(response.first_name);
      $('#last_name').val(response.last_name);
      $('#twitter_handle').val(response.twitter_handle);
      $('#bio').val(response.bio);
      $('#interests').val(response.interests)
    }
  }
}

var TabHelper = {
  toggle:function(){
    $('.tab').on("click", function(e){
      $('.tabs').children().removeClass('active')
      $(this).addClass('active')
      var clickedID = $(this).attr('id')
      TabHelper.showFields(clickedID)
    })
  },
  showFields:function(selector){
    if (selector === "basics"){
      $("#optional_fields").hide();
    }
    else if (selector === "more"){
      $("#optional_fields").show();
    }
  }
}

$(document).ready(function() {

  TabHelper.toggle()

  $('#email').on('blur', FindByEmail.find)

  AvailabilityRecurrence.init("#availability_recurrence")

  $("#availability_city").on("change", TimeZoneHelper.setTz);
});
