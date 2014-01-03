
var cardColorCardinality = {}
$(document).ready(function () {
    console.log("VERSION " + jQuery.fn.jquery);

    function getQueryString() {
        var ret = {};
        var dec_url = decodeURI(document.location);
        var parts = (dec_url.toString().split('?')[1]).split('&');
        for (var i = 0; i < parts.length; i++) {

            var p = parts[i].split('=');
            // so strings will be correctly parsed:
            p[1] = decodeURIComponent(p[1].replace(/\+/g, " "));

            if (p[0].search(/\[\]/) >= 0) { // then it's an array
                p[0] = p[0].replace('[]', '');

                if (typeof ret[p[0]] != 'object') ret[p[0]] = [];
                ret[p[0]].push(p[1]);
            } else {
                ret[p[0]] = p[1];
            }
        }
        return ret;
    }
    console.log(getQueryString());

    $.getJSON("http://flamingfox.se/magiccarddb/boosters.php", { sets: getQueryString().sets, verbose: true }, function (result) {
        console.log(result.data);

        $.each(result.boosters, function (index, booster){
            $.each(booster, function (index, card) {
                var cardname = card.name.replace(/\s+/g, "").replace("'", "").replace(",", "").replace("-", "").replace("(", "").replace(")", "").toLowerCase();
                var cardcolor = "";
                var cardtype = "";
                if (card.type.indexOf("Creature") != -1) {
                    cardtype = "Creature";
                }

                else if (card.type.indexOf("Basic") != -1) {
                    cardtype = "BasicLand";
                }

                else {
                    cardtype = card.type;
                }
                         
                if (card.color == "A" || card.color == "L") {
                    cardcolor = "AL";
                }

                else {
                    cardcolor = card.color;
                }

                if (!cardColorCardinality[cardcolor]) {
                    cardColorCardinality[cardcolor] = 1
                } else {
                    cardColorCardinality[cardcolor] += 1;
                }

                if (card.foiled == true) {
                    

                    $("#poolPile" + cardcolor)
                        .append($('<li></li>').addClass("card").attr("onmouseover", "javascript:return preview(this);").attr("file", encodeURI(card.image)).attr("name", card.name).attr("type", cardtype).attr("cmc", getConvertedManaCost(card.manacost)).attr("color", cardcolor).attr("rarity", card.rarity)
                            .append($('<div></div>').addClass("cardDiv")
                                .append($('<img src="/Images/foil.png" />').addClass("foilImages"))
                                .append($('<img src="' + encodeURI(card.image) + '" />').addClass("cardImages"))));
                        
                }

                else if (cardtype != "BasicLand") {
                    $("#poolPile" + cardcolor)
                        .append($('<li></li>').addClass("card").attr("onmouseover", "javascript:return preview(this);").attr("file", encodeURI(card.image)).attr("name", card.name).attr("type", cardtype).attr("cmc", getConvertedManaCost(card.manacost)).attr("color", cardcolor).attr("rarity", card.rarity)
                            .append($('<div></div>').addClass("cardDiv")
                                .append($('<img src="' + encodeURI(card.image) + '" />').addClass("cardImages"))));

                }   
                        
            });

            $.enableDrag();
            //$.enableSelect();
        });

        $('#totalCardsInPoolArea').html($('.poolStack > li').length);
        $("#poolImage").attr("title", "W: " + cardColorCardinality["W"] + "\nU: " + cardColorCardinality["U"] + "\nB: " + cardColorCardinality["B"] + "\nR: " + cardColorCardinality["R"] + "\nG: " + cardColorCardinality["G"] + "\nM: " + cardColorCardinality["M"] + "A/L: " + cardColorCardinality["AL"]);
        $("#WButton").attr("title", "White: " + cardColorCardinality["W"] + " cards.");
        $("#UButton").attr("title", "Blue: " + cardColorCardinality["U"] + " cards.");
        $("#BButton").attr("title", "Black: " + cardColorCardinality["B"] + " cards.");
        $("#RButton").attr("title", "Red: " + cardColorCardinality["R"] + " cards.");
        $("#GButton").attr("title", "Green: " + cardColorCardinality["G"] + " cards.");
        $("#MButton").attr("title", "Multicolor: " + cardColorCardinality["M"] + " cards.");
        $("#AButton").attr("title", "Colorless: " + cardColorCardinality["AL"] + " cards.");
        $("#LButton").attr("title", "Colorless: " + cardColorCardinality["AL"] + " cards.");
    });

    $(function () {
        $.contextMenu({
            selector: '#poolDiv',
            className: 'css-title',
            callback: function (key, options) {
                $("#sort" + key + "PoolButton").click();
            },
            items: {
                "Color": { name: "Color" },
                "Cost": { name: "Cost" },
                "Rarity": { name: "Rarity" },
                "Type": { name: "Type" },
            }
        });
    });

    $(function () {
        $.contextMenu({
            selector: '#deckDiv',
            className: 'css-title',
            callback: function (key, options) {
                $("#sort" + key + "DeckButton").click();
            },
            items: {
                "Color": { name: "Color" },
                "Cost": { name: "Cost" },
                "Rarity": { name: "Rarity" },
                "Type": { name: "Type" },
            }
        });
    });

    $("#draggablePreviewImage").on('dblclick', 'div',
        function () {
            $(this).hide();
    });

    $("#draggablePreviewImage").offset({ top: 400, left: 800 })

    $("#tabs").tabs();

    $("#draggablePreviewImage").draggable();

    $("#poolDiv").selectable({ filter: "li" });

    $("#deckDiv").selectable({filter:"li"});

    $('.resizable').resizable({
        aspectRatio: true,
        handles: 'sw',
        maxWidth: 250,
    });

    var countArray = [];
    var verticalSpaceBetweenListItems = 3;
    countArray.push($("#pile1div li").length);
    countArray.push($("#pile2div li").length);
    countArray.push($("#pile3div li").length);
    countArray.push($("#pile4div li").length);
    countArray.push($("#pile5div li").length);
    countArray.push($("#pile6div li").length);
    countArray.push($("#pile7div li").length);
    var largest = Math.max.apply(Math, countArray);
    var size = 30 * largest || 30 * 15;
    console.log(size);
    var elems = $("#poolDiv").find('ul');
    $(elems).each(function () {
        $(this).css('height', size + 'px');
    });


    $('.toggleButtonImages').attr("toggled", "0");
    $('.sortPoolButtonImages').attr("clicked", "0");
    $('#totalCreaturesInDeck').html("0");
    $('#totalCardsInDeck').html("0");
    $('#totalOtherInDeck').html("0");
    $('#totalLandsInDeck').html("0");

    $(".AddButtonImages").hover(function () {
        $(this).attr("src", "/Images/Hover" + $(this).attr("id") + ".png");

    }, function () {
        $(this).attr("src", "/Images/" + $(this).attr("id") + ".png");
    });

    $(".RestoreButtomImages").hover(function () {
        $(this).attr("src", "/Images/Hover" + $(this).attr("id") + ".png");

    }, function () {
        $(this).attr("src", "/Images/" + $(this).attr("id") + ".png");
    });

    $(".sortPoolButtonImages").hover(function () {
        $(this).attr("src", "/Images/HoverPool" + $(this).attr("id").substring(4) + ".png");

    }, function () {
        if ($(this).attr("clicked") == 1) {
            $(this).attr("src", "/Images/SelectedPool" + $(this).attr("id").substring(4) + ".png");
        }

        else {
            $(this).attr("src", "/Images/" + $(this).attr("id").substring(4) + ".png");
        }
    });

    $(".sortDeckButtonImages").hover(function () {
        $(this).attr("src", "/Images/HoverDeck" + $(this).attr("id").substring(4) + ".png");

    }, function () {
        if ($(this).attr("clicked") == 1) {
            $(this).attr("src", "/Images/SelectedDeck" + $(this).attr("id").substring(4) + ".png");
        }

        else {
            $(this).attr("src", "/Images/" + $(this).attr("id").substring(4) + ".png");
        }

    });

    // Hover over toggleButtons
    $(".toggleButtonImages").hover(function () {
        if ($(this).attr("toggled") == 1) {
            $(this).attr("src", "/Images/ToggledHover" + $(this).attr("id") + ".jpg");
        }

        else {
            $(this).attr("src", "/Images/Hover" + $(this).attr("id") + ".jpg");
        }

    }, function () {
        if ($(this).attr("toggled") == 1) {
            $(this).attr("src", "/Images/Toggled" + $(this).attr("id") + ".jpg");
        }

        else {
            $(this).attr("src", "/Images/" + $(this).attr("id") + ".png");
        }

    });

    $('#addLButton').click(function () {
        $('#addLandDialog').dialog('open');
    });

    $.addLandFunction = function () {
        $("#addLandDialog").dialog("close");

        // Add plains
        for (var i = 0; i < $('#addPlainsBox').val() ; i++) {
            $("#deckPileAL")
                .append($('<li></li>').addClass("card").attr("onmouseover", "javascript:return preview(this);").attr("file", encodeURI('http://flamingfox.se/magiccarddb/cardimages/THS/Plains2.full.jpg')).attr("name", "Plains (2)").attr("type", "BasicLand").attr("cmc", "0").attr("color", "AL").attr("rarity", "C")
                    .append($('<div></div>').addClass("cardDiv")
                        .append($('<img src="' + encodeURI('http://flamingfox.se/magiccarddb/cardimages/THS/Plains2.full.jpg') + '" />').addClass("cardImages"))));
        }
        
        // Add island
        for (var i = 0; i < $('#addIslandBox').val() ; i++) {
            $("#deckPileAL")
                .append($('<li></li>').addClass("card").attr("onmouseover", "javascript:return preview(this);").attr("file", encodeURI('http://flamingfox.se/magiccarddb/cardimages/THS/Island1.full.jpg')).attr("name", "Island (1)").attr("type", "BasicLand").attr("cmc", "0").attr("color", "AL").attr("rarity", "C")
                    .append($('<div></div>').addClass("cardDiv")
                        .append($('<img src="' + encodeURI('http://flamingfox.se/magiccarddb/cardimages/THS/Island1.full.jpg') + '" />').addClass("cardImages"))));
        }

        // Add swamp
        for (var i = 0; i < $('#addSwampBox').val() ; i++) {
            $("#deckPileAL")
                .append($('<li></li>').addClass("card").attr("onmouseover", "javascript:return preview(this);").attr("file", encodeURI('http://flamingfox.se/magiccarddb/cardimages/THS/Swamp3.full.jpg')).attr("name", "Swamp (3)").attr("type", "BasicLand").attr("cmc", "0").attr("color", "AL").attr("rarity", "C")
                    .append($('<div></div>').addClass("cardDiv")
                        .append($('<img src="' + encodeURI('http://flamingfox.se/magiccarddb/cardimages/THS/Swamp3.full.jpg') + '" />').addClass("cardImages"))));
        }

        // Add mountain
        for (var i = 0; i < $('#addMountainBox').val() ; i++) {
            $("#deckPileAL")
                .append($('<li></li>').addClass("card").attr("onmouseover", "javascript:return preview(this);").attr("file", encodeURI('http://flamingfox.se/magiccarddb/cardimages/THS/Mountain2.full.jpg')).attr("name", "Mountain (2)").attr("type", "BasicLand").attr("cmc", "0").attr("color", "AL").attr("rarity", "C")
                    .append($('<div></div>').addClass("cardDiv")
                        .append($('<img src="' + encodeURI('http://flamingfox.se/magiccarddb/cardimages/THS/Mountain2.full.jpg') + '" />').addClass("cardImages"))));
        }

        // Add forest
        for (var i = 0; i < $('#addForestBox').val() ; i++) {
            $("#deckPileAL")
                .append($('<li></li>').addClass("card").attr("onmouseover", "javascript:return preview(this);").attr("file", encodeURI('http://flamingfox.se/magiccarddb/cardimages/THS/Forest2.full.jpg')).attr("name", "Forest (2)").attr("type", "BasicLand").attr("cmc", "0").attr("color", "AL").attr("rarity", "C")
                    .append($('<div></div>').addClass("cardDiv")
                        .append($('<img src="' + encodeURI('http://flamingfox.se/magiccarddb/cardimages/THS/Forest2.full.jpg') + '" />').addClass("cardImages"))));
        }

        $('#totalCardsInDeck').html($('.deckStack > li').length);
        $('#totalLandsInDeck').html($('.deckStack > li[type=Land]').length + $('.deckStack > li[type=BasicLand]').length);
        $.enableDrag();
    };

    $.suggestLandFunction = function () {
        var elems = $("#deckDiv").find('ul').children('li');
        var numberOfEachColorList = [0, 0, 0, 0, 0, 0];
        var numberOfEachLandList = [];
        $(elems).each(function () {
            if ($(this).attr("color") == "W") {
                numberOfEachColorList[0] = parseInt(numberOfEachColorList[0]) + 1;
            }

            else if ($(this).attr("color") == "U") {
                numberOfEachColorList[1] = parseInt(numberOfEachColorList[1]) + 1;
            }

            else if ($(this).attr("color") == "B") {
                numberOfEachColorList[2] = parseInt(numberOfEachColorList[2]) + 1;
            }

            else if ($(this).attr("color") == "R") {
                numberOfEachColorList[3] = parseInt(numberOfEachColorList[3]) + 1;
            }

            else if ($(this).attr("color") == "G") {
                numberOfEachColorList[4] = parseInt(numberOfEachColorList[4]) + 1;
            }

            else {
                numberOfEachColorList[5] = parseInt(numberOfEachColorList[5]) + 1;
            }
        });

        var totalNonLandCards = 0;


        for (var i = 0; i < numberOfEachColorList.length; i++) {
            totalNonLandCards = totalNonLandCards + numberOfEachColorList[i];
        }

        var numberOfLands = 40 - totalNonLandCards;

        for (var i = 0; i < numberOfEachColorList.length; i++) {
            numberOfEachLandList[i] = parseInt(parseFloat(numberOfEachColorList[i] / totalNonLandCards) * numberOfLands);
        }

    };

    $('#openDecklistButton').click(function () {
        $('#decklistTextArea').text('');
        var elems = $("#deckDiv").find('ul').children('li');

        var cardNameArray = [];

        $(elems).each(function () {
            cardNameArray.push($(this).attr("name"));
        });

        var quantityList = {};
        for (var i = 0; i < cardNameArray.length; i++) {
            if (quantityList[cardNameArray[i]]) {
                quantityList[cardNameArray[i]]++;
            }
            else {
                quantityList[cardNameArray[i]] = 1;
            }
        }

        $('#decklistTextArea').append("// Deck file for Magic Workstation.<br />");
        for (var key in quantityList) {
            $('#decklistTextArea').append(quantityList[key] + " [THS] " + key + "<br />");
        }

        $('#decklistDialog').dialog('open');
        return false;
    });

    $("#decklistDialog").dialog({
        autoOpen: false,
        modal: true,
        width: 300,
        draggable: true,
        resizable: true,
        open: function (event, ui) {
            $(this).parent().children(".ui-dialog-buttonpane").css("background-color", "white");
            $(this).parent().children(".ui-dialog-buttonpane").css("border", "3px solid grey");
            $(this).parent().children().children().children(".ui-button").css("font-family", "Vani");
        },
        buttons: { "Close": function () { $("#decklistDialog").dialog("close"); } }
    });

    $("#addDeckListDialog").dialog({
        autoOpen: false,
        modal: true,
        width: 300,
        draggable: false,
        resizable: false,
        open: function (event, ui) {
            $(this).parent().children(".ui-dialog-buttonpane").css("background-color", "white");
            $(this).parent().children(".ui-dialog-buttonpane").css("border", "3px solid grey");
            $(this).parent().children().children().children(".ui-button").css("font-family", "Vani");
        },
        buttons: { "Close": function () { $("#addDeckListDialog").dialog("close"); } }

    });

    $("#addLandDialog").dialog({
        autoOpen: false,
        modal: true,
        draggable: false,
        resizable: false,
        width: 275,
        height: 160,
        open: function (event, ui) {
            // reset values to 0
            $('#addPlainsBox').val("0");
            $('#addIslandBox').val("0");
            $('#addSwampBox').val("0");
            $('#addMountainBox').val("0");
            $('#addForestBox').val("0");
            $(this).parent().children(".ui-dialog-buttonpane").css("background-color", "white");
            $(this).parent().children(".ui-dialog-buttonpane").css("border", "3px solid grey");
            $(this).parent().children().children().children(".ui-button").css("font-family", "Vani");
        },
        //"Suggest": function () { $.suggestLandFunction(); },
        buttons: { "OK": function () { $.addLandFunction(); } }
    });
    $(".ui-dialog-titlebar").hide();
});

$(function () {
    $("#restoreDeckButton").click(function () {
        $("ul li").each(function () {

            $('#totalCardsInPoolArea').html($('.poolStack > li').length);
            $('#totalCardsInDeck').html("0");
            $('#totalCreaturesInDeck').html("0");
            $('#totalLandsInDeck').html("0");
            $('#totalOtherInDeck').html("0");

            if ($(this).attr("type") == "BasicLand") {
                $(this).remove();
            }

            else {
                $(this).appendTo($('#poolPile' + $(this).attr("color")));
            }
                    
        });
    });
});


$(function () {
    $(".toggleButtons").click(function () {

        if ($($(this).children('img')).attr("toggled") == 0) {
            $($(this).children('img')).attr("toggled", "1");
            $($(this).children('img')).attr("src", "/Images/Toggled" + $(this).children('img').attr("id") + ".jpg");
        }

        else {
            $($(this).children('img')).attr("toggled", "0");
            $($(this).children('img')).attr("src", "/Images/" + $(this).children('img').attr("id") + ".png");
        }

        var color = $(this).children('img').attr("id");

        $("ul li").each(function () {

            if ($(this).attr("color") == color.replace('Button', '')) {
                $(this).toggle();
            }
        });
    });
});

// SORT FUNCTIONS FOR Deck AREA ---------------------------------------------------------------------------------------
// Sort by Color - DECK
$(function () {
    $("#sortColorDeckButton").click(function () {
        var elems = $("#deckDiv").find('ul').children('li').remove();
        $('.sortDeckButtonImages').attr("clicked", "0");
        $("#deckColorButton").attr("clicked", "1");
        $('.sortDeckButtonImages').each(function () {
            $(this).attr("src", "/Images/" + $(this).attr("id").substring(4) + ".png");
        });
        $("#deckColorButton").attr("src", "/Images/SelectedDeckColorButton.png");

        $(elems).each(function () {

            $(this).appendTo($("#deckPile" + $(this).attr("color")));

        });
        $.enableDrag();
    });
});

// Sort by CMC - DECK
$(function () {
    $("#sortCostDeckButton").click(function () {
        var elems = $("#deckDiv").find('ul').children('li').remove();
        $('.sortDeckButtonImages').attr("clicked", "0");
        $("#deckCostButton").attr("clicked", "1");
        $('.sortDeckButtonImages').each(function () {
            $(this).attr("src", "/Images/" + $(this).attr("id").substring(4) + ".png");
        });
        $("#deckCostButton").attr("src", "/Images/SelectedDeckCostButton.png");

        elems.sort(function (a, b) {
            return parseInt($(a).attr("cmc")) < parseInt($(b).attr("cmc")) ? 1 : -1;
        });

        var deckList = ["deckPileW", "deckPileU", "deckPileB", "deckPileR", "deckPileG", "deckPileM", "deckPileAL"];
        $(elems).each(function () {
            if (parseInt($(this).attr("cmc")) == 0 || parseInt($(this).attr("cmc")) > 6) {
                $(this).appendTo('#deckPileAL');
            }

            else {
                $(this).appendTo('#' + deckList[$(this).attr("cmc")-1]);
            }

            
        });
        $.enableDrag();
    });
});

// Sort by Rarity - DECK
$(function () {
    $("#sortRarityDeckButton").click(function () {
        var elems = $("#deckDiv").find('ul').children('li').remove();
        $('.sortDeckButtonImages').attr("clicked", "0");
        $("#deckRarityButton").attr("clicked", "1");
        $('.sortDeckButtonImages').each(function () {
            $(this).attr("src", "/Images/" + $(this).attr("id").substring(4) + ".png");
        });
        $("#deckRarityButton").attr("src", "/Images/SelectedDeckRarityButton.png");

        $(elems).each(function () {
            if ($(this).attr("rarity") == "R" || $(this).attr("rarity") == "M") {
                $(this).appendTo('#deckPileW');
            }

            else if ($(this).attr("rarity") == "U") {
                $(this).appendTo('#deckPileU');
            }

            else {
                if ($("#pile3Deckdiv li").length < 20) {
                    $(this).appendTo('#deckPileB');
                }

                else if ($("#pile4Deckdiv li").length < 20) {
                    $(this).appendTo('#deckPileR');
                }

                else {
                    $(this).appendTo('#deckPileG');
                }
            }
        });
        $.enableDrag();
    });
});

// Sort by Type - Deck
$(function () {
    $("#sortTypeDeckButton").click(function () {
        var elems = $("#deckDiv").find('ul').children('li').remove();
        $('.sortDeckButtonImages').attr("clicked", "0");
        $("#deckTypeButton").attr("clicked", "1");
        $('.sortDeckButtonImages').each(function () {
            $(this).attr("src", "/Images/" + $(this).attr("id").substring(4) + ".png");
        });
        $("#deckTypeButton").attr("src", "/Images/SelectedDeckTypeButton.png");

        $(elems).each(function () {
            if ($(this).attr("type") == "Creature") {
                $(this).appendTo('#deckPileW');
            }

            else if ($(this).attr("type") == "Enchantment") {
                $(this).appendTo('#deckPileU');
            }

            else if ($(this).attr("type") == "Artifact") {
                $(this).appendTo('#deckPileB');
            }

            else if ($(this).attr("type") == "Instant") {
                $(this).appendTo('#deckPileR');
            }

            else if ($(this).attr("type") == "Sorcery") {
                $(this).appendTo('#deckPileG');
            }

            else if ($(this).attr("type") == "Land") {
                $(this).appendTo('#deckPileM');
            }

            else {
                $(this).appendTo('#deckPileAL');
            }

        });
        $.enableDrag();
    });
});

// SORT FUNCTIONS FOR POOL AREA ---------------------------------------------------------------------------------------

$(function () {

    // Sort by Color - POOL
    $("#sortColorPoolButton").click(function sortColorPool () {
        var elems = $("#poolDiv").find('ul').children('li').remove();
        $('.sortPoolButtonImages').attr("clicked", "0");
        $("#poolColorButton").attr("clicked", "1");
        $('.sortPoolButtonImages').each(function () {
            $(this).attr("src", "/Images/" + $(this).attr("id").substring(4) + ".png");
        });
        $("#poolColorButton").attr("src", "/Images/SelectedPoolColorButton.png");

        $(elems).each(function () {
            $(this).appendTo('#poolPile' + $(this).attr("color"));

        });
        $.enableDrag();
    });

    // Sort by CMC - POOL
    $("#sortCostPoolButton").click(function () {
        var elems = $("#poolDiv").find('ul').children('li').remove();
        $('.sortPoolButtonImages').attr("clicked", "0");
        $("#poolCostButton").attr("clicked", "1");
        $('.sortPoolButtonImages').each(function () {
            $(this).attr("src", "/Images/" + $(this).attr("id").substring(4) + ".png");
        });
        $("#poolCostButton").attr("src", "/Images/SelectedPoolCostButton.png");

        elems.sort(function (a, b) {
            return parseInt($(a).attr("cmc")) < parseInt($(b).attr("cmc")) ? 1 : -1;
        });

        var poolList = ["poolPileW", "poolPileU", "poolPileB", "poolPileR", "poolPileG", "poolPileM", "poolPileAL"];
        $(elems).each(function () {
            if (parseInt($(this).attr("cmc")) == 0 || parseInt($(this).attr("cmc")) > 6) {
                $(this).appendTo('#poolPileAL');
            }

            else {
                $(this).appendTo('#' + poolList[$(this).attr("cmc")-1]);
            }

        });
        $.enableDrag();
    });

    // Sort by Rarity - POOL
    $("#sortRarityPoolButton").click(function () {
        var elems = $("#poolDiv").find('ul').children('li').remove();
        $('.sortPoolButtonImages').attr("clicked", "0");
        $("#poolRarityButton").attr("clicked", "1");
        $('.sortPoolButtonImages').each(function () {
            $(this).attr("src", "/Images/" + $(this).attr("id").substring(4) + ".png");
        });
        $("#poolRarityButton").attr("src", "/Images/SelectedPoolRarityButton.png");

        $(elems).each(function () {
            if ($(this).attr("rarity") == "R" || $(this).attr("rarity") == "M") {
                $(this).appendTo('#poolPileW');
            }

            else if ($(this).attr("rarity") == "U") {
                $(this).appendTo('#poolPileU');
            }

            else {
                if ($("#pile3div li").length < 20) {
                    $(this).appendTo('#poolPileB');
                }

                else if ($("#pile4div li").length < 20) {
                    $(this).appendTo('#poolPileR');
                }

                else {
                    $(this).appendTo('#poolPileG');
                }

            }
        });
        $.enableDrag();
    });

    // Sort by Type - POOL
    $("#sortTypePoolButton").click(function () {
        var elems = $("#poolDiv").find('ul').children('li').remove();
        $('.sortPoolButtonImages').attr("clicked", "0");
        $("#poolTypeButton").attr("clicked", "1");
        $('.sortPoolButtonImages').each(function () {
            $(this).attr("src", "/Images/" + $(this).attr("id").substring(4) + ".png");
        });
        $("#poolTypeButton").attr("src", "/Images/SelectedPoolTypeButton.png");

        $(elems).each(function () {
            if ($(this).attr("type") == "Creature") {
                $(this).appendTo('#poolPileW');
            }

            else if ($(this).attr("type") == "Enchantment") {
                $(this).appendTo('#poolPileU');
            }

            else if ($(this).attr("type") == "Artifact") {
                $(this).appendTo('#poolPileB');
            }

            else if ($(this).attr("type") == "Instant") {
                $(this).appendTo('#poolPileR');
            }

            else if ($(this).attr("type") == "Sorcery") {
                $(this).appendTo('#poolPileG');
            }

            else {
                $(this).appendTo('#poolPileM');
            }
        });
        $.enableDrag();
    });

});

// Draggable div in middle
$(function () {
    $("#draggableMiddleDiv").draggable({
        containment: [9, 50, 9, 700],
        drag: function () {
            var position = $("#draggableMiddleDiv").position();
            var topPos = position.top;
            var divHeight = $(window).height();

            var poolDiv = topPos;
            var deckDiv = divHeight - topPos;

            $('#poolDiv').height(poolDiv);
            $('#deckDiv').height(deckDiv);

        },
        //axis: "y",
        //containment: "#divAll"

        stop: function () {
        }

    });

});


// Draggable-funktion för korten
$(function () {
    var sourceElement;
   
    $.enableDrag = function () {
        $(".card").each(function () {
            var selected = $([]), offset = { top: 0, left: 0 };
            $(this).draggable({
                revert: 'invalid',
                create: function (event, ui) {
                    $(this).css('list-style-type', 'none');
                },
                stop: function () {
                    $(this).draggable('option', 'revert', 'invalid');
                    $("li.ui-selected").css({ opacity: 1 });
                    var totalCountInDeck = $('.deckStack > li').length;
                    var totalCountInPool = $('.poolStack > li').length;
                    var creatureCount = $('.deckStack > li[type=Land]').length + $('.deckStack > li[type=Creature]').length;
                    var landCount = $('.deckStack > li[type=Land]').length + $('.deckStack > li[type=BasicLand]').length;

                    $('#totalCardsInPoolArea').html(totalCountInPool);
                    $('#totalCardsInDeck').html(totalCountInDeck);
                    $('#totalCreaturesInDeck').html(creatureCount);
                    $('#totalLandsInDeck').html(landCount);
                    $('#totalOtherInDeck').html(totalCountInDeck - creatureCount - landCount);
                    
                    $(this).parent().children().each(function () {
                        $(this).removeClass("last");
                    });

                    $(this).addClass("last");
                    $("li.ui-selected").removeClass("ui-selected");

                },
                start: function () {
                    $("ul li.ui-selected").css({ opacity: 0 });
                    $(this).addClass("ui-selected");
                    $(this).css('list-style-type', 'none');
                },

                scroll: false,
                helper: function () {
                    var selected = $("li.ui-selected");
                    selected.addClass("helperList");
                    var container = $('<div/>');
                    selected.clone().appendTo(container);
                    return container;
                },
                appendTo: 'body'
            });
        });

        $(".card").each(function () {
            $(this).mousedown(function () {
                $(this).addClass("ui-selected");    
            });

            $(this).mouseup(function () {
                $(this).removeClass("ui-selected");
            });
        });
    };

    $.enableDrag();

    /*$.enableSelect = function () {
        $(".card").each(function () {
            $($(this)).click(function (e) {

                if (e.metaKey == false) {
                    // if command key is pressed don't deselect existing elements
                    $("#selectable > div").removeClass("ui-selected");
                    $(this).find('.cardImages').addClass("ui-selecting");
                }
                else {
                    if ($(this).hasClass("ui-selected")) {
                        // remove selected class from element if already selected
                        $(this).removeClass("ui-selected");
                    }
                    else {
                        // add selecting class if not
                        //$(this).find('.cardImages').addClass("ui-selecting");
                        $(this).addClass("ui-selected");
                    }
                }

                //$("#selectable").data("selectable")._mouseStop(null);
            });

        });
    };
    $.enableSelect();*/
});

$(function () {
    var sourceElement;
    $("ul li").each(function () {
        $(this).draggable({
            revert: 'invalid',
            create: function (event, ui) {
                $(this).css('list-style-type', 'none');
            },
            stop: function () {
                $(this).draggable('option', 'revert', 'invalid');
                $(this).css({ opacity: 1 });
            },
            start: function () {
                $(this).css({ opacity: 0 });
                $(this).css('list-style-type', 'none');
                sourceElement = $(this).parent().parent().parent().attr("id");
            },
            scroll: false,
            helper: 'clone',
            appendTo: 'body'
        });
    });

    // Set every ul to droppable in POOL
    $(".poolStack").droppable({
        accept: function (d) {
            if (d.hasClass("card")) {
                return true;
            }
        },
        drop: function (event, ui) {
            var totalCount = $('.deckStack > li').length;
            var creatureCount = $('.deckStack > li[type=Land]').length + $('.deckStack > li[type=Creature]').length;
            var landCount = $('.deckStack > li[type=Land]').length + $('.deckStack > li[type=BasicLand]').length;
            var totalCountInPool = $('.poolStack > li').length;

            $('#totalCardsInPoolArea').html(totalCountInPool);
            $('#totalCardsInDeck').html(totalCount);
            $('#totalCreaturesInDeck').html(creatureCount);
            $('#totalLandsInDeck').html(landCount);
            $('#totalOtherInDeck').html(totalCount - creatureCount - landCount);
            $("li.helperList").removeClass("helperList");
            $("ul li.ui-selected").appendTo(this);
        }
    });

    // Set every ul to droppable in DECK
    $(".deckStack").droppable({
        accept: ":not(.resizable)",
        drop: function (event, ui) {
            var totalCount = $('.deckStack > li').length;
            var creatureCount = $('.deckStack > li[type=Land]').length + $('.deckStack > li[type=Creature]').length;
            var landCount = $('.deckStack > li[type=Land]').length + $('.deckStack > li[type=BasicLand]').length;
            var totalCountInPool = $('.poolStack > li').length;

            $('#totalCardsInPoolArea').html(totalCountInPool);
            $('#totalCardsInDeck').html(totalCount);
            $('#totalCreaturesInDeck').html(creatureCount);
            $('#totalLandsInDeck').html(landCount);
            $('#totalOtherInDeck').html(totalCount - creatureCount - landCount);
            $("li.helperList").removeClass("helperList");
            $("ul li.ui-selected").appendTo(this);
        }
    });

    // Send a card from Pool to Deck (first column)
    $('.poolStack').on('dblclick', 'li', function () {
        $(this).appendTo($('#deckPileW'));
        var totalCount = $('.deckStack > li').length;
        var creatureCount = $('.deckStack > li[type=Land]').length + $('.deckStack > li[type=Creature]').length;
        var landCount = $('.deckStack > li[type=Land]').length + $('.deckStack > li[type=BasicLand]').length;
        var totalCountInPool = $('.poolStack > li').length;

        $('#totalCardsInPoolArea').html(totalCountInPool);
        $('#totalCardsInDeck').html(totalCount);
        $('#totalCreaturesInDeck').html(creatureCount);
        $('#totalLandsInDeck').html(landCount);
        $('#totalOtherInDeck').html(totalCount - creatureCount - landCount);
    });

    // Send a card back to POOL
    $(".deckStack").on('dblclick', 'li', function () {
        $(this).appendTo('#poolPile' + $(this).attr("color"));
        var totalCount = $('.deckStack > li').length;
        var creatureCount = $('.deckStack > li[type=Land]').length + $('.deckStack > li[type=Creature]').length;
        var landCount = $('.deckStack > li[type=Land]').length + $('.deckStack > li[type=BasicLand]').length;
        var totalCountInPool = $('.poolStack > li').length;

        $('#totalCardsInPoolArea').html(totalCountInPool);
        $('#totalCardsInDeck').html(totalCount);
        $('#totalCreaturesInDeck').html(creatureCount);
        $('#totalLandsInDeck').html(landCount);
        $('#totalOtherInDeck').html(totalCount - creatureCount - landCount);
    })
});


function preview(card) {
    document.getElementById('previewImage').src = card.getAttribute("file");
}

function validate(evt) {
    var theEvent = evt || window.event;
    var key = theEvent.keyCode || theEvent.which;
    key = String.fromCharCode(key);
    var regex = /[0-9]|\./;
    if (!regex.test(key)) {
        theEvent.returnValue = false;
        if (theEvent.preventDefault) theEvent.preventDefault();
    }
}

function getConvertedManaCost(color)
{
    var colorSymbols = [];
    colorSymbols = color.split('');
    var cost = 0;
    var cmc = 0;

    colorSymbols.forEach(function(cost) {
        if (parseInt(cost))
        {
            cmc = cost;
        }

        else
        {
            cmc++;
        }
    });

    return cmc;
}

/*
$(document).ready(function () {

    Highcharts.setOptions({
        colors: ['#fffae5', '#83a2fb', '#363638', '#e93737', '#6bcb49']
    });

    RenderPieChart('container', [
              ['White', 45.0],
              ['Blue', 26.8],
              ['Black', 12.8],
              ['Red', 8.5],
              ['Green', 6.2]
    ]);

    $('#btnPieChart').live('click', function () {
        var data = [
                     ['Firefox', 42.0],
                     ['IE', 26.8],
                     {
                         name: 'Chrome',
                         y: 14.8,
                         sliced: true,
                         selected: true
                     },
                     ['Safari', 6.5],
                     ['Opera', 8.2],
        ];

        RenderPieChart('container', data);
    });

    function RenderPieChart(elementId, dataList) {
        new Highcharts.Chart({
            chart: {
                renderTo: elementId,
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false
            }, title: {
                text: 'Browser market shares at a specific website, 2010'
            },
            tooltip: {
                formatter: function () {
                    return '<b>' + this.point.name + '</b>: ' + this.percentage + ' %';
                }
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        color: '#000000',
                        connectorColor: '#000000',
                        formatter: function () {
                            return '<b>' + this.point.name + '</b>: ' + this.percentage + ' %';
                        }
                    }
                }
            },
            series: [{
                type: 'pie',
                name: 'Browser share',
                data: dataList
            }]
        });
    };
});
*/