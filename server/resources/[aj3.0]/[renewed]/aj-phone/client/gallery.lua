-- NUI Callback

RegisterNUICallback('GetGalleryData', function(_, cb)
    local data = PhoneData.Images
    cb(data)
end)

RegisterNUICallback('DeleteImage', function(image,cb)
    TriggerServerEvent('aj-phone:server:RemoveImageFromGallery',image)
    Wait(400)
    TriggerServerEvent('aj-phone:server:getImageFromGallery')
    cb(true)
end)

-- Events

RegisterNetEvent('aj-phone:refreshImages', function(images)
    PhoneData.Images = images
end)