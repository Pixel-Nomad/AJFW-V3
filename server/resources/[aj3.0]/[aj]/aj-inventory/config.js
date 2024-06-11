const Config = {
    imageResource: "nui://aj-framework-assets/data/inventory/images/",
    sixthPocketSlot: 41,
    TestDecay: true,
};

var FormatItemInfo = (itemData) => {
    if (itemData != null && itemData.info != "") {
        if (!itemData.decay) {
            itemData.metadata = {}
            itemData.metadata.len = "Metadata Not Supported"
        } else {
            itemData.metadata.len = itemData.metadata.count
        }
        if (itemData.name == "id_card") {
            var gender = "Man";
            if (itemData.info.gender == 1) {
                gender = "Woman";
            }
            $(".item-info-title").html(itemData.label);
            $("#item-description").html(itemData.description);
            $("#item-weight").html((itemData.weight / 100).toFixed(2));
            $("#item-tweight").html(
                ((itemData.weight * itemData.amount) / 100).toFixed(2)
            );
            $("#item-details").html(
                "<b class='detail-title'>Metadata:</b> " +
                itemData.metadata.len +
                ' | <b class=\'detail-title\'>Quality : </b> <span style="color:' +
                generateDamageColor(itemData.info.quality) +
                ' ">' +
                itemData.info.quality +
                "%</span>" +
                "<br>" +
                " <b class='detail-title'>CSN: </b>" +
                itemData.info.citizenid +
                " <br><b class='detail-title'>First Name: </b> " +
                itemData.info.firstname +
                " <br><b class='detail-title'>Last Name: </b> " +
                itemData.info.lastname +
                " <br><b class='detail-title'>Birth Date: </b> " +
                itemData.info.birthdate +
                " <br><b class='detail-title'>Gender: </b> " +
                gender +
                " <br><b class='detail-title'>Nationality: </b>" +
                itemData.info.nationality
            );
        } else if (itemData.name == "driver_license" || itemData.name == "driver_licenseb" || itemData.name == "driver_licensec") {
            $(".item-info-title").html(itemData.label);
            $("#item-description").html(itemData.description);
            $("#item-weight").html((itemData.weight / 100).toFixed(2));
            $("#item-tweight").html(
                ((itemData.weight * itemData.amount) / 100).toFixed(2)
            );
            $("#item-details").html(
                "<b class='detail-title'>Metadata:</b> " +
                itemData.metadata.len +
                ' | <b class=\'detail-title\'>Quality : </b> <span style="color:' +
                generateDamageColor(itemData.info.quality) +
                ' ">' +
                itemData.info.quality +
                "%</span>" +
                "<br>" +
                " <b class='detail-title'>First Name: </b> " +
                itemData.info.firstname +
                " <br><b class='detail-title'>Last Name: </b> " +
                itemData.info.lastname +
                " <br><b class='detail-title'>Birth Date: </b> " +
                itemData.info.birthdate +
                " <br><b class='detail-title'>Licenses: </b> " +
                itemData.info.type 
            );
        } else if (itemData.name == "weaponlicense") {
            $(".item-info-title").html(itemData.label);
            $("#item-description").html(itemData.description);
            $("#item-weight").html((itemData.weight / 100).toFixed(2));
            $("#item-tweight").html(
                ((itemData.weight * itemData.amount) / 100).toFixed(2)
            );
            $("#item-details").html(
                "<b class='detail-title'>Metadata:</b> " +
                itemData.metadata.len +
                ' | <b class=\'detail-title\'>Quality : </b> <span style="color:' +
                generateDamageColor(itemData.info.quality) +
                ' ">' +
                itemData.info.quality +
                "%</span>" +
                "<br>" +
                " <b class='detail-title'>First Name: </b> " +
                itemData.info.firstname +
                " <br><b class='detail-title'>Last Name: </b> " +
                itemData.info.lastname +
                " <br><b class='detail-title'>Birth Date: </b> " +
                itemData.info.birthdate
            );
        } else if (itemData.name == "lawyerpass") {
            $(".item-info-title").html(itemData.label);
            $("#item-description").html(itemData.description);
            $("#item-weight").html((itemData.weight / 100).toFixed(2));
            $("#item-tweight").html(
                ((itemData.weight * itemData.amount) / 100).toFixed(2)
            );
            $("#item-details").html(
                "<b class='detail-title'>Metadata:</b> " +
                itemData.metadata.len +
                ' | <b class=\'detail-title\'>Quality : </b> <span style="color:' +
                generateDamageColor(itemData.info.quality) +
                ' ">' +
                itemData.info.quality +
                "%</span>" +
                "<br>" +
                " <b class='detail-title'>Pass-ID: </b> " +
                itemData.info.id +
                " <br><b class='detail-title'>First Name: </b> " +
                itemData.info.firstname +
                " <br><b class='detail-title'>Last Name: </b> " +
                itemData.info.lastname +
                " <br><b class='detail-title'>CSN: </b> " +
                itemData.info.citizenid
            );
        } else if (itemData.name == "harness") {
            $(".item-info-title").html(itemData.label);
            $("#item-description").html(itemData.description);
            $("#item-weight").html((itemData.weight / 100).toFixed(2));
            $("#item-tweight").html(
                ((itemData.weight * itemData.amount) / 100).toFixed(2)
            );
            $("#item-details").html(
                "<b class='detail-title'>Metadata:</b> " +
                itemData.metadata.len +
                ' | <b class=\'detail-title\'>Quality : </b> <span style="color:' +
                generateDamageColor(itemData.info.quality) +
                ' ">' +
                itemData.info.quality +
                "%</span>" +
                "<br>" +
                " <b class='detail-title'>Uses Left: </b> " +
                itemData.info.uses 
            );
        } else if (itemData.name == "mechboard") {
            $(".item-info-title").html(itemData.label);
            $("#item-description").html(itemData.description);
            $("#item-weight").html((itemData.weight / 100).toFixed(2));
            $("#item-tweight").html(
                ((itemData.weight * itemData.amount) / 100).toFixed(2)
            );
            $("#item-details").html(
                "<b class='detail-title'>Metadata:</b> " +
                itemData.metadata.len +
                ' | <b class=\'detail-title\'>Quality : </b> <span style="color:' +
                generateDamageColor(itemData.info.quality) +
                ' ">' +
                itemData.info.quality +
                "%</span>" +
                "<br>" +
                " <b class='detail-title'>Vehicle Plate: </b> " +
                itemData.info.vehplate+ 
                " <br><b class='detail-title'>Vehicle: </b> " +
                itemData.info.veh
            );
        } else if (itemData.name == "syphoningkit" || itemData.name == "jerrycan") { // Syphoning Kit (aj-fuel or CDN-Syphoning!)
            $(".item-info-title").html(itemData.label);
            $("#item-description").html(itemData.description);
            $("#item-weight").html((itemData.weight / 100).toFixed(2));
            $("#item-tweight").html(
                ((itemData.weight * itemData.amount) / 100).toFixed(2)
            );
            $("#item-details").html(
                "<b class='detail-title'>Metadata:</b> " +
                itemData.metadata.len +
                ' | <b class=\'detail-title\'>Quality : </b> <span style="color:' +
                generateDamageColor(itemData.info.quality) +
                ' ">' +
                itemData.info.quality +
                "%</span>" +
                "<br>" +
                " <b class='detail-title'>Liters Inside: </b> " +
                itemData.info.gasamount
            );
        } else if (itemData.type == "weapon") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            if (itemData.info.ammo == undefined) {
                itemData.info.ammo = 0;
            } else {
                itemData.info.ammo != null ? itemData.info.ammo : 0;
            }
            if (itemData.info.attachments != null) {
                var attachmentString = "";
                $.each(itemData.info.attachments, function (i, attachment) {
                    if (i == itemData.info.attachments.length - 1) {
                        attachmentString += attachment.label;
                    } else {
                        attachmentString += attachment.label + ", ";
                    }
                });
                $(".item-info-title").html(itemData.label);
                $("#item-description").html(itemData.description);
                $("#item-weight").html((itemData.weight / 100).toFixed(2));
                $("#item-tweight").html(
                    ((itemData.weight * itemData.amount) / 100).toFixed(2)
                );
                $("#item-details").html(
                    "<b class='detail-title'>Metadata:</b> " +
                    itemData.metadata.len +
                    ' | <b class=\'detail-title\'>Quality : </b> <span style="color:' +
                    generateDamageColor(itemData.info.quality) +
                    ' ">' +
                    itemData.info.quality +
                    "%</span>" +
                    "<br>" +
                    " <b class='detail-title'>Serial: </b> " +
                    itemData.info.serie+
                    " <br><b class='detail-title'>Ammo: </b> " +
                    itemData.info.ammo +
                    " <br><b class='detail-title'>Attachments: </b> " +
                    attachmentString

                );
            } else {
                $(".item-info-title").html(itemData.label);
                $("#item-description").html(itemData.description);
                $("#item-weight").html((itemData.weight / 100).toFixed(2));
                $("#item-tweight").html(
                    ((itemData.weight * itemData.amount) / 100).toFixed(2)
                );
                $("#item-details").html(
                    "<b class='detail-title'>Metadata:</b> " +
                    itemData.metadata.len +
                    ' | <b class=\'detail-title\'>Quality : </b> <span style="color:' +
                    generateDamageColor(itemData.info.quality) +
                    ' ">' +
                    itemData.info.quality +
                    "%</span>" +
                    "<br>" +
                    " <b class='detail-title'>Serial: </b> " +
                    itemData.info.serie+
                    " <br><b class='detail-title'>Ammo: </b> " +
                    itemData.info.ammo

                );
            }
        } else if (itemData.name == "filled_evidence_bag") {
            if (itemData.info.type == "casing") {
                $(".item-info-title").html(itemData.label);
                $("#item-description").html(itemData.description);
                $("#item-weight").html((itemData.weight / 100).toFixed(2));
                $("#item-tweight").html(
                    ((itemData.weight * itemData.amount) / 100).toFixed(2)
                );
                $("#item-details").html(
                    "<b class='detail-title'>Metadata:</b> " +
                    itemData.metadata.len +
                    ' | <b class=\'detail-title\'>Quality : </b> <span style="color:' +
                    generateDamageColor(itemData.info.quality) +
                    ' ">' +
                    itemData.info.quality +
                    "%</span>" +
                    "<br>" +
                    " <b class='detail-title'>Evidence material: </b> " +
                    itemData.info.label +
                    " <br><b class='detail-title'>Type number: </b> " +
                    itemData.info.ammotype +
                    " <br><b class='detail-title'>Caliber: </b> " +
                    itemData.info.ammolabel +
                    " <br><b class='detail-title'>Serial: </b> " +
                    itemData.info.serie +
                    " <br><b class='detail-title'>Crime scene: </b> " +
                    itemData.info.street
                );
            } else if (itemData.info.type == "blood") {
                $(".item-info-title").html(itemData.label);
                $("#item-description").html(itemData.description);
                $("#item-weight").html((itemData.weight / 100).toFixed(2));
                $("#item-tweight").html(
                    ((itemData.weight * itemData.amount) / 100).toFixed(2)
                );
                $("#item-details").html(
                    "<b class='detail-title'>Metadata:</b> " +
                    itemData.metadata.len +
                    ' | <b class=\'detail-title\'>Quality : </b> <span style="color:' +
                    generateDamageColor(itemData.info.quality) +
                    ' ">' +
                    itemData.info.quality +
                    "%</span>" +
                    "<br>" +
                    " <b class='detail-title'>Evidence material: </b> " +
                    itemData.info.label +
                    " <br><b class='detail-title'>Blood Type: </b> " +
                    itemData.info.bloodtype +
                    " <br><b class='detail-title'>DNA Code: </b> " +
                    itemData.info.dnalabel +
                    " <br><b class='detail-title'>Crime scene: </b> " +
                    itemData.info.street
                );
            } else if (itemData.info.type == "fingerprint") {
                $(".item-info-title").html(itemData.label);
                $("#item-description").html(itemData.description);
                $("#item-weight").html((itemData.weight / 100).toFixed(2));
                $("#item-tweight").html(
                    ((itemData.weight * itemData.amount) / 100).toFixed(2)
                );
                $("#item-details").html(
                    "<b class='detail-title'>Metadata:</b> " +
                    itemData.metadata.len +
                    ' | <b class=\'detail-title\'>Quality : </b> <span style="color:' +
                    generateDamageColor(itemData.info.quality) +
                    ' ">' +
                    itemData.info.quality +
                    "%</span>" +
                    "<br>" +
                    " <b class='detail-title'>Evidence material: </b> " +
                    itemData.info.label +
                    " <br><b class='detail-title'>Fingerprint: </b> " +
                    itemData.info.fingerprint +
                    " <br><b class='detail-title'>Crime scene: </b> " +
                    itemData.info.street
                );
            } else if (itemData.info.type == "dna") {
                $(".item-info-title").html(itemData.label);
                $("#item-description").html(itemData.description);
                $("#item-weight").html((itemData.weight / 100).toFixed(2));
                $("#item-tweight").html(
                    ((itemData.weight * itemData.amount) / 100).toFixed(2)
                );
                $("#item-details").html(
                    "<b class='detail-title'>Metadata:</b> " +
                    itemData.metadata.len +
                    ' | <b class=\'detail-title\'>Quality : </b> <span style="color:' +
                    generateDamageColor(itemData.info.quality) +
                    ' ">' +
                    itemData.info.quality +
                    "%</span>" +
                    "<br>" +
                    " <b class='detail-title'>Evidence material: </b> " +
                    itemData.info.label +
                    " <br><b class='detail-title'>DNA Code: </b> " +
                    itemData.info.dnalabel
                );
            }
        } else if (
            itemData.info.costs != undefined &&
            itemData.info.costs != null
        ) {
            $(".item-info-title").html(itemData.label);
            $("#item-description").html(itemData.description);
            $("#item-weight").html((itemData.weight / 100).toFixed(2));
            $("#item-tweight").html(
                ((itemData.weight * itemData.amount) / 100).toFixed(2)
            );
            $("#item-details").html(
                "<b class='detail-title'>Metadata:</b> " +
                itemData.metadata.len +
                ' | <b class=\'detail-title\'>Quality : </b> <span style="color:' +
                generateDamageColor(itemData.info.quality) +
                ' ">' +
                itemData.info.quality +
                "%</span>" +
                "<br>" +
                " <b class='detail-title'>Cost: </b> " +
                itemData.info.costs
            );
        } else if (itemData.name == "stickynote") {
            $(".item-info-title").html(itemData.label);
            $("#item-description").html(itemData.description);
            $("#item-weight").html((itemData.weight / 100).toFixed(2));
            $("#item-tweight").html(
                ((itemData.weight * itemData.amount) / 100).toFixed(2)
            );
            $("#item-details").html(
                "<b class='detail-title'>Metadata:</b> " +
                itemData.metadata.len +
                ' | <b class=\'detail-title\'>Quality : </b> <span style="color:' +
                generateDamageColor(itemData.info.quality) +
                ' ">' +
                itemData.info.quality +
                "%</span>" +
                "<br>" +
                " <b class='detail-title'>Label: </b> " +
                itemData.info.label
            );
        } else if (itemData.name == "moneybag") {
            $(".item-info-title").html(itemData.label);
            $("#item-description").html(itemData.description);
            $("#item-weight").html((itemData.weight / 100).toFixed(2));
            $("#item-tweight").html(
                ((itemData.weight * itemData.amount) / 100).toFixed(2)
            );
            $("#item-details").html(
                "<b class='detail-title'>Metadata:</b> " +
                itemData.metadata.len +
                ' | <b class=\'detail-title\'>Quality : </b> <span style="color:' +
                generateDamageColor(itemData.info.quality) +
                ' ">' +
                itemData.info.quality +
                "%</span>" +
                "<br>" +
                " <b class='detail-title'>Amount of cash: </b> " +
                itemData.info.cash
            );
        } else if (itemData.name == "markedbills") {
            $(".item-info-title").html(itemData.label);
            $("#item-description").html(itemData.description);
            $("#item-weight").html((itemData.weight / 100).toFixed(2));
            $("#item-tweight").html(
                ((itemData.weight * itemData.amount) / 100).toFixed(2)
            );
            $("#item-details").html(
                "<b class='detail-title'>Metadata:</b> " +
                itemData.metadata.len +
                ' | <b class=\'detail-title\'>Quality : </b> <span style="color:' +
                generateDamageColor(itemData.info.quality) +
                ' ">' +
                itemData.info.quality +
                "%</span>" +
                "<br>" +
                " <b class='detail-title'>Worth: </b> " +
                itemData.info.worth
            );
        } else if (itemData.name == "visa" || itemData.name == "mastercard") {
            var str = "" + itemData.info.cardNumber + "";
            var res = str.slice(12);
            var cardNumber = "************" + res;
            $(".item-info-title").html(itemData.label);
            $("#item-description").html(itemData.description);
            $("#item-weight").html((itemData.weight / 100).toFixed(2));
            $("#item-tweight").html(
                ((itemData.weight * itemData.amount) / 100).toFixed(2)
            );
            $("#item-details").html(
                "<b class='detail-title'>Metadata:</b> " +
                itemData.metadata.len +
                ' | <b class=\'detail-title\'>Quality : </b> <span style="color:' +
                generateDamageColor(itemData.info.quality) +
                ' ">' +
                itemData.info.quality +
                "%</span>" +
                "<br>" +
                " <b class='detail-title'>Card Holder: </b> " +
                itemData.info.name+
                " <br><b class='detail-title'>Citizen ID: </b> " +
                itemData.info.citizenid +
                " <br><b class='detail-title'>Card Number: </b> " +
                cardNumber
            );
        } else if (itemData.name == "labkey") {
            $(".item-info-title").html(itemData.label);
            $("#item-description").html(itemData.description);
            $("#item-weight").html((itemData.weight / 100).toFixed(2));
            $("#item-tweight").html(
                ((itemData.weight * itemData.amount) / 100).toFixed(2)
            );
            $("#item-details").html(
                "<b class='detail-title'>Metadata:</b> " +
                itemData.metadata.len +
                ' | <b class=\'detail-title\'>Quality : </b> <span style="color:' +
                generateDamageColor(itemData.info.quality) +
                ' ">' +
                itemData.info.quality +
                "%</span>" +
                "<br>" +
                " <b class='detail-title'>Lab: </b> " +
                itemData.info.lab
            );
        } else {
            $(".item-info-title").html(itemData.label);
            $("#item-description").html(itemData.description);
            $("#item-weight").html((itemData.weight / 100).toFixed(2));
            $("#item-tweight").html(
                ((itemData.weight * itemData.amount) / 100).toFixed(2)
            );
            $("#item-details").html(
                "<b class='detail-title'>Metadata:</b> " +
                itemData.metadata.len +
                ' | <b class=\'detail-title\'>Quality : </b> <span style="color:' +
                generateDamageColor(itemData.info.quality) +
                ' ">' +
                itemData.info.quality +
                "%</span>"
            );
        }
    } else {
        $(".item-info-title").html(itemData.label);
        $("#item-description").html(itemData.description);
        $("#item-weight").html((itemData.weight / 100).toFixed(2));
        $("#item-tweight").html(
            ((itemData.weight * itemData.amount) / 100).toFixed(2)
        );
        itemData.metadata =
            itemData.metadata != undefined && itemData.metadata != null
                ? itemData.metadata.len
                : "Metadata Not Supported";
        $("#item-details").html(
            "<b class='detail-title'>Metadata:</b> " +
            itemData.metadata +
            ' | <b class=\'detail-title\'>Quality : </b> <span style="color:' +
            generateDamageColor(itemData.info.quality) +
            ' ">' +
            itemData.info.quality +
            "%</span>"
        );
    }
};