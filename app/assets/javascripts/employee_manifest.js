'use strict'
$(function() {
  $(document).ready(function() {
    $("#calendar").fullCalendar({
      events: '/users/get_events.json'
    });
  });

  $(document).on('click', '.show_form', function(e){
    e.preventDefault();
    $('.hidden_new_form').removeClass('hide');
  });

  $(document).on('click', '.edit_employee', function(e){
    e.preventDefault();
    $('.hidden_new_form').removeClass('hide');
    var closest_tr = $(this).closest('tr');
    var name = closest_tr.find('td.employee_name').text().replace(/[\n\r]+/g, '').trim();
    var email = closest_tr.find('td.employee_email').text().replace(/[\n\r]+/g, '').trim();
    var role = closest_tr.find('td.employee_role').text().replace(/[\n\r]+/g, '').trim();
    $('#employee_name').val(name);
    $('#user_id').val(closest_tr.data('user_id'));
    $('#employee_email').val(email);
    $('#employee_role').val(role.toLowerCase());
  });

  $(document).on('click', '.cancel_form', function(e){
    e.preventDefault();
    var form_id = $(this).closest('form').attr('id');
    document.getElementById(form_id).reset();
    var div = $('#' + form_id).closest('div');
    if (div.hasClass('hidden_new_form')) $('.hidden_new_form').addClass('hide') ;
  });
  
});