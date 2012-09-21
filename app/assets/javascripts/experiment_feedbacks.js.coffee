jQuery ->

  # Check project selected to enable/disable instrument failed reason textarea
  $('#experiment_feedback_instrument_failed_reason').prop('disabled', true)
  if $('#experiment_feedback_instrument_failed:checked').val()
    $('#experiment_feedback_instrument_failed_reason').prop('disabled', false)

  $('#experiment_feedback_instrument_failed').click () ->
    is_checked = $('#experiment_feedback_instrument_failed:checked').val()
    if is_checked
      $('#experiment_feedback_instrument_failed_reason').prop('disabled', false)
    else
      $('#experiment_feedback_instrument_failed_reason').val('')
      $('#experiment_feedback_instrument_failed_reason').prop('disabled', true)