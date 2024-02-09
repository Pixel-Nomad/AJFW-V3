RegisterCommand('record', function()
    StartRecording(1)
    TriggerEvent('AJFW:Notify', Lang:t('editor.started'), 'success')
end, false)

RegisterCommand('clip', function()
    StartRecording(0)
end, false)

RegisterCommand('saveclip', function()
    StopRecordingAndSaveClip()
    TriggerEvent('AJFW:Notify', Lang:t('editor.save'), 'success')
end, false)

RegisterCommand('delclip', function()
    StopRecordingAndDiscardClip()
    TriggerEvent('AJFW:Notify', Lang:t('editor.delete'), 'error')
end, false)

RegisterCommand('editor', function()
    NetworkSessionLeaveSinglePlayer()
    ActivateRockstarEditor()
    TriggerEvent('AJFW:Notify', Lang:t('editor.editor'), 'error')
end, false)
