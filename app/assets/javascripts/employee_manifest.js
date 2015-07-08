'use strict'
$(function() {
  $(document).ready(function() {
    $("#calendar").fullCalendar({
      header: {left: 'prev next today', center: 'title', right: "month,agendaWeek,agendaDay"},
      defaultView: "month",
      height: 500,
      slotMinutes: 15,
      events: "/users/get_events",
      timeFormat: "h:mm t{ - h:mm t} ",
      dragOpacity: "0.5"
    });
  });

  $(document).on('click', '#add_employee', function(e){
    e.preventDefault();
    $('.employee_form').removeClass('hide');
  });

  $(document).on('click', '.edit_employee', function(e){
    e.preventDefault();
    $('.employee_form').removeClass('hide');
    var closest_tr = $(this).closest('tr');
    var name = closest_tr.find('td.employee_name').text().replace(/[\n\r]+/g, '').trim();
    var email = closest_tr.find('td.employee_email').text().replace(/[\n\r]+/g, '').trim();
    var role = closest_tr.find('td.employee_role').text().replace(/[\n\r]+/g, '').trim();
    $('#employee_name').val(name);
    $('#user_id').val(closest_tr.data('user_id'));
    $('#employee_email').val(email);
    $('#employee_role').val(role.toLowerCase());
  });

  $(document).on('click', '#cancel_adding_employee', hide_employee_form);

  function hide_employee_form(){
    var content = $('.employee_form');
    $('.employee_form').addClass('hide');
    content.slideToggle(500, function () {
      $('.employee_form').html(initial_employee_form_data);
    });
  }
});