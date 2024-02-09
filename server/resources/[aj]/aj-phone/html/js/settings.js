AJ.Phone.Settings = {};
AJ.Phone.Settings.Background = "default-ajfw";
AJ.Phone.Settings.OpenedTab = null;
AJ.Phone.Settings.Backgrounds = {
    'default-ajfw': {
        label: "Standard AJFW"
    }
};

var PressedBackground = null;
var PressedBackgroundObject = null;
var OldBackground = null;
var IsChecked = null;

$(document).on('click', '.settings-app-tab', function(e){
    e.preventDefault();
    var PressedTab = $(this).data("settingstab");

    if (PressedTab == "background") {
        AJ.Phone.Animations.TopSlideDown(".settings-"+PressedTab+"-tab", 200, 0);
        AJ.Phone.Settings.OpenedTab = PressedTab;
    } else if (PressedTab == "profilepicture") {
        AJ.Phone.Animations.TopSlideDown(".settings-"+PressedTab+"-tab", 200, 0);
        AJ.Phone.Settings.OpenedTab = PressedTab;
    } else if (PressedTab == "numberrecognition") {
        var checkBoxes = $(".numberrec-box");
        AJ.Phone.Data.AnonymousCall = !checkBoxes.prop("checked");
        checkBoxes.prop("checked", AJ.Phone.Data.AnonymousCall);

        if (!AJ.Phone.Data.AnonymousCall) {
            $("#numberrecognition > p").html('Off');
        } else {
            $("#numberrecognition > p").html('On');
        }
    }
});

$(document).on('click', '#accept-background', function(e){
    e.preventDefault();
    var hasCustomBackground = AJ.Phone.Functions.IsBackgroundCustom();

    if (hasCustomBackground === false) {
        AJ.Phone.Notifications.Add("fas fa-paint-brush", "Settings", AJ.Phone.Settings.Backgrounds[AJ.Phone.Settings.Background].label+" is set!")
        AJ.Phone.Animations.TopSlideUp(".settings-"+AJ.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $(".phone-background").css({"background-image":"url('/html/img/backgrounds/"+AJ.Phone.Settings.Background+".png')"})
    } else {
        AJ.Phone.Notifications.Add("fas fa-paint-brush", "Settings", "Personal background set!")
        AJ.Phone.Animations.TopSlideUp(".settings-"+AJ.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $(".phone-background").css({"background-image":"url('"+AJ.Phone.Settings.Background+"')"});
    }

    $.post('https://aj-phone/SetBackground', JSON.stringify({
        background: AJ.Phone.Settings.Background,
    }))
});

AJ.Phone.Functions.LoadMetaData = function(MetaData) {
    if (MetaData.background !== null && MetaData.background !== undefined) {
        AJ.Phone.Settings.Background = MetaData.background;
    } else {
        AJ.Phone.Settings.Background = "default-ajfw";
    }

    var hasCustomBackground = AJ.Phone.Functions.IsBackgroundCustom();

    if (!hasCustomBackground) {
        $(".phone-background").css({"background-image":"url('/html/img/backgrounds/"+AJ.Phone.Settings.Background+".png')"})
    } else {
        $(".phone-background").css({"background-image":"url('"+AJ.Phone.Settings.Background+"')"});
    }

    if (MetaData.profilepicture == "default") {
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="./img/default.png">');
    } else {
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="'+MetaData.profilepicture+'">');
    }
}

$(document).on('click', '#cancel-background', function(e){
    e.preventDefault();
    AJ.Phone.Animations.TopSlideUp(".settings-"+AJ.Phone.Settings.OpenedTab+"-tab", 200, -100);
});

AJ.Phone.Functions.IsBackgroundCustom = function() {
    var retval = true;
    $.each(AJ.Phone.Settings.Backgrounds, function(i, background){
        if (AJ.Phone.Settings.Background == i) {
            retval = false;
        }
    });
    return retval
}

$(document).on('click', '.background-option', function(e){
    e.preventDefault();
    PressedBackground = $(this).data('background');
    PressedBackgroundObject = this;
    OldBackground = $(this).parent().find('.background-option-current');
    IsChecked = $(this).find('.background-option-current');

    if (IsChecked.length === 0) {
        if (PressedBackground != "custom-background") {
            AJ.Phone.Settings.Background = PressedBackground;
            $(OldBackground).fadeOut(50, function(){
                $(OldBackground).remove();
            });
            $(PressedBackgroundObject).append('<div class="background-option-current"><i class="fas fa-check-circle"></i></div>');
        } else {
            AJ.Phone.Animations.TopSlideDown(".background-custom", 200, 13);
        }
    }
});

$(document).on('click', '#accept-custom-background', function(e){
    e.preventDefault();

    AJ.Phone.Settings.Background = $(".custom-background-input").val();
    $(OldBackground).fadeOut(50, function(){
        $(OldBackground).remove();
    });
    $(PressedBackgroundObject).append('<div class="background-option-current"><i class="fas fa-check-circle"></i></div>');
    AJ.Phone.Animations.TopSlideUp(".background-custom", 200, -23);
});

$(document).on('click', '#cancel-custom-background', function(e){
    e.preventDefault();

    AJ.Phone.Animations.TopSlideUp(".background-custom", 200, -23);
});

// Profile Picture

var PressedProfilePicture = null;
var PressedProfilePictureObject = null;
var OldProfilePicture = null;
var ProfilePictureIsChecked = null;

$(document).on('click', '#accept-profilepicture', function(e){
    e.preventDefault();
    var ProfilePicture = AJ.Phone.Data.MetaData.profilepicture;
    if (ProfilePicture === "default") {
        AJ.Phone.Notifications.Add("fas fa-paint-brush", "Settings", "Standard avatar set!")
        AJ.Phone.Animations.TopSlideUp(".settings-"+AJ.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="./img/default.png">');
    } else {
        AJ.Phone.Notifications.Add("fas fa-paint-brush", "Settings", "Personal avatar set!")
        AJ.Phone.Animations.TopSlideUp(".settings-"+AJ.Phone.Settings.OpenedTab+"-tab", 200, -100);
        $("[data-settingstab='profilepicture']").find('.settings-tab-icon').html('<img src="'+ProfilePicture+'">');
    }
    $.post('https://aj-phone/UpdateProfilePicture', JSON.stringify({
        profilepicture: ProfilePicture,
    }));
});

$(document).on('click', '#accept-custom-profilepicture', function(e){
    e.preventDefault();
    AJ.Phone.Data.MetaData.profilepicture = $(".custom-profilepicture-input").val();
    $(OldProfilePicture).fadeOut(50, function(){
        $(OldProfilePicture).remove();
    });
    $(PressedProfilePictureObject).append('<div class="profilepicture-option-current"><i class="fas fa-check-circle"></i></div>');
    AJ.Phone.Animations.TopSlideUp(".profilepicture-custom", 200, -23);
});

$(document).on('click', '.profilepicture-option', function(e){
    e.preventDefault();
    PressedProfilePicture = $(this).data('profilepicture');
    PressedProfilePictureObject = this;
    OldProfilePicture = $(this).parent().find('.profilepicture-option-current');
    ProfilePictureIsChecked = $(this).find('.profilepicture-option-current');
    if (ProfilePictureIsChecked.length === 0) {
        if (PressedProfilePicture != "custom-profilepicture") {
            AJ.Phone.Data.MetaData.profilepicture = PressedProfilePicture
            $(OldProfilePicture).fadeOut(50, function(){
                $(OldProfilePicture).remove();
            });
            $(PressedProfilePictureObject).append('<div class="profilepicture-option-current"><i class="fas fa-check-circle"></i></div>');
        } else {
            AJ.Phone.Animations.TopSlideDown(".profilepicture-custom", 200, 13);
        }
    }
});

$(document).on('click', '#cancel-profilepicture', function(e){
    e.preventDefault();
    AJ.Phone.Animations.TopSlideUp(".settings-"+AJ.Phone.Settings.OpenedTab+"-tab", 200, -100);
});


$(document).on('click', '#cancel-custom-profilepicture', function(e){
    e.preventDefault();
    AJ.Phone.Animations.TopSlideUp(".profilepicture-custom", 200, -23);
});
