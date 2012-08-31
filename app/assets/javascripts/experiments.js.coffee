# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  display_rest_of_proj_details = (data) ->
    $('#pid').text("Project ID: " + data["project_id"])
    $('#description').text("Description: " + data["description"])
    $('#date_created').text("Date Created: " + data["date_created"])
    $('#funded_by').text("Funded By: " + data["funded_by"])
    $('#supervisor').text("Supervisor: " + data["supervisor"])

  project_details_display = (project_id) ->
    if project_id
      callback = (response) -> display_rest_of_proj_details response
      url = '/projects/' + project_id + '/project_data'
      $.ajax url,
        type: 'GET'
        dataType: 'json'
        error: (data, text_status, error) ->
          $('body').append "AJAX Error: #{error}"
        success: (data, text_status, error) ->
          display_rest_of_proj_details (data)
    else
      $('#pid').text("Project ID: ")
      $('#description').text("Description: ")
      $('#date_created').text("Date Created: ")
      $('#funded_by').text("Funded By: ")
      $('#supervisor').text("Supervisor: ")


  # Check 'Other (Specify)' textfield enable/disable
  $('#experiment_other_text').prop('disabled', true)
  if $('#experiment_other:checked').val()
    $('#experiment_other_text').prop('disabled', false)

  # Check 'Reporter Protein (Specify)' textfield enable/disable
  $('#experiment_reporter_protein_text').prop('disabled', true)
  if $('#experiment_reporter_protein:checked').val()
    $('#experiment_reporter_protein_text').prop('disabled', false)

  # Check if any project has already been selected
  project_details_display($("#project_select").val())

  $('#project_select').change () ->
    project_id = $("#project_select").val()
    #$('.project_display').empty()
    project_details_display(project_id)
    $("#experiment_project_id").val(project_id)

  $('#experiment_other').click () ->
    is_checked = $('#experiment_other:checked').val()
    if is_checked
      $('#experiment_other_text').prop('disabled', false)
    else
      $('#experiment_other_text').prop('disabled', true)

  $('#experiment_other').click () ->
    is_checked = $('#experiment_other:checked').val()
    if is_checked
      $('#experiment_reporter_protein_text').prop('disabled', false)
    else
      $('#experiment_reporter_protein_text').prop('disabled', true)