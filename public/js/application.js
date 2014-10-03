$('#member_button_id').on("click", function() {
  $(this).addClass("hide");
  $('.signin_form_area').removeClass("hide")
})

$('.accept_button').on("click", function() {
  var button = $(this)
  var route = button.attr("id");
  $.ajax({
    type: "get",
    url: route
  }).success(function() {
    console.log("yay")
    var id = button.parent().parent().attr("id")
    button.next().removeAttr("class");
    button.attr("id","/send/"+id );
    button.attr("class","send_button");
    button.text("Send to");
    var card = button.parent().parent();
    $('.your_cards').append(card)
  }).fail(function() {
    console.log("boo")
  }).done(function() {
    console.log()
    button.unbind()
    bindEvents(button)
  });

});

$('.delete_button').on("click", function() {

  var button = $(this)
  var route = button.attr("id");
  console.log(route)
  $.ajax({
    type: "get",
    url: route
  }).success(function() {
    console.log("yay")
    button.parent().remove()
  }).fail(function() {
    console.log("boo")
  }).done(function() {
  });

});

$('.send_button').on("click", function() {
  var button = $(this)
  var form_data = button.parent().serialize()
  var route = button.attr("id");
  $.ajax({
    type: "post",
    url: route,
    data: form_data
  }).success(function() {
    console.log("yay")
    button.parent().parent().remove();
  }).fail(function() {
    console.log("boo")
  }).done(function() {
  });
});

var bindEvents = function(element) {

  element.on("click", function() {
  var button = $(this)
  var form_data = button.parent().serialize()
  var route = button.attr("id");
  $.ajax({
    type: "post",
    url: route,
    data: form_data
  }).success(function() {
    console.log("yay")
    button.parent().parent().remove();
  }).fail(function() {
    console.log("boo")
  }).done(function() {
  });
});
};


