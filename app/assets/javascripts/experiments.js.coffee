# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  display_rest_of_proj_details = (data) ->
    $('div', '#display_project_id').text(data["project_id"])
    $('div', '#display_description').text(data["description"])
    $('div', '#display_date_created').text(data["date_created"])
    $('div', '#display_funded_by').text(data["funded_by"])
    $('div', '#display_supervisor').text(data["supervisor"])

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
      $('div', '#display_project_id').text("")
      $('div', '#display_description').text("")
      $('div', '#display_date_created').text("")
      $('div', '#display_funded_by').text("")
      $('div', '#display_supervisor').text("")

  enable_submit_button = (project_id) ->
    if project_id
      $('#experiment_submit').prop('disabled', false)
    else
      $('#experiment_submit').prop('disabled', true)

  # Check project selected to enable/disable submit button
  $('#experiment_submit').prop('disabled', true)
  if $("#project_select").val()
    $('#experiment_submit').prop('disabled', false)

  # Check 'Other (Specify)' textfield enable/disable
  $('#experiment_other_text').prop('disabled', true)
  if $('#experiment_other:checked').val()
    $('#experiment_other_text').prop('disabled', false)

  # Check 'Fluorescent protein (Specify)' textfield enable/disable
  $('#experiment_fluorescent_protein_ids').select2('disable')
  if $('#experiment_has_fluorescent_proteins:checked').val()
    $('#experiment_fluorescent_protein_ids').select2('enable')

  $('#experiment_immunofluorescence_ids').select2('disable')
  if $('#experiment_has_immunofluorescence:checked').val()
    $('#experiment_immunofluorescence_ids').select2('enable')

  $('#experiment_specific_dye_ids').select2('disable')
  if $('#experiment_has_specific_dyes:checked').val()
    $('#experiment_specific_dye_ids').select2('enable')

  # Check if any project has already been selected

  if $("#project_select").size() > 0
    project_id = $("#project_select").val()
    enable_submit_button($("#project_select").val())
    project_details_display($("#project_select").val())
    $("#experiment_project_id").val($("#project_select").val())


  $('#project_select').change () ->
    project_id = $("#project_select").val()
    enable_submit_button(project_id)
    project_details_display(project_id)
    $("#experiment_project_id").val(project_id)

  $('#experiment_other').click () ->
    is_checked = $('#experiment_other:checked').val()
    if is_checked
      $('#experiment_other_text').prop('disabled', false)
    else
      $('#experiment_other_text').val('')
      $('#experiment_other_text').prop('disabled', true)

  $('#experiment_has_fluorescent_proteins').click () ->
    is_checked = $('#experiment_has_fluorescent_proteins:checked').val()
    if is_checked
      $('#experiment_fluorescent_protein_ids').select2('enable')
    else
      $('#experiment_fluorescent_protein_ids').val('')
      $('#experiment_fluorescent_protein_ids').select2('disable')

  $('#experiment_has_specific_dyes').click () ->
    is_checked = $('#experiment_has_specific_dyes:checked').val()
    if is_checked
      $('#experiment_specific_dye_ids').select2('enable')
    else
      $('#experiment_specific_dye_ids').val('')
      $('#experiment_specific_dye_ids').select2('disable')

  $('#experiment_has_immunofluorescence').click () ->
    is_checked = $('#experiment_has_immunofluorescence:checked').val()
    if is_checked
      $('#experiment_immunofluorescence_ids').select2('enable')
    else
      $('#experiment_immunofluorescence_ids').val('')
      $('#experiment_immunofluorescence_ids').select2('disable')