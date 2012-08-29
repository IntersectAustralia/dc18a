# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $("#project_select").change (e) ->
    project_id = $("#project_select").val()
    $('.project_display').empty()
    if project_id
      project = $("#project_select option:selected").val()
      project_name = $("#project_select option:selected").text()
      $('.project_display').append(
        '<br/><span>Project ID:   ' + project_id + '</span>
         <br/><span>Project Name: ' + project_name + '</span><br/>
         <br/>'
       )

      $("#experiment_project_id").val(project_id)
      #TODO: Include other project details - this may require querying the server..?
