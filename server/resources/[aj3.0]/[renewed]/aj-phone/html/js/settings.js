AJ.Phone.Settings = {};
AJ.Phone.Settings.Background = "default-QBCore";

// Functions

AJ.Phone.Functions.LoadMetaData = function(MetaData) {
    if (MetaData.background !== null && MetaData.background !== undefined) {
        AJ.Phone.Settings.Background = MetaData.background;
    } else {
        AJ.Phone.Settings.Background = "default-QBCore";
    }

    var hasCustomBackground = AJ.Phone.Functions.IsBackgroundCustom();

    if (!hasCustomBackground) {
        $(".phone-background").css({"background-image":"url('/html/img/backgrounds/"+AJ.Phone.Settings.Background+".png')"})
    } else {
        $(".phone-background").css({"background-image":"url('"+AJ.Phone.Settings.Background+"')"});
    }
}
AJ.Phone.Functions.IsBackgroundCustom = function() {
    var retval = true;
    if (AJ.Phone.Settings.Background == 'default-QBCore'){
        retval = false;
    }
    return retval
}

// Clicks

$(document).on("click", ".settings-app-toggle", function(){
    ClearInputNew()
    $('#settings-app-menu').fadeIn(350);
})

$(document).on('click', '#settings-app-submit', function(e){
    e.preventDefault();

    var checkbox = document.getElementById("checkbox").checked;
    var customurl = $('.settings-customurl').val()

    if (checkbox != false && customurl != ''){
        AJ.Phone.Notifications.Add("fas fa-cog", "SETTINGS", "You can only pick one option!")
        return
    }

    if (checkbox){
        AJ.Phone.Notifications.Add("fas fa-paint-brush", "SETTINGS", "Default background set!")
        $(".phone-background").css({"background-image":"url('/html/img/backgrounds/default-QBCore.png')"})
        $.post('https://aj-phone/SetBackground', JSON.stringify({
            background: '/html/img/backgrounds/default-QBCore.png',
        }))
    }else if (customurl){
        AJ.Phone.Notifications.Add("fas fa-paint-brush", "SETTINGS", "Personal background set!")
        $(".phone-background").css({"background-image":"url('"+customurl+"')"});
        $.post('https://aj-phone/SetBackground', JSON.stringify({
            background: customurl,
        }))
    }
    $('.settings-customurl').val("")
    $('#settings-app-menu').fadeOut(350);
});