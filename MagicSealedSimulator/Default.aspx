﻿<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="MagicSealedSimulator._Default" %>

<asp:Content runat="server" ID="FeaturedContent" ContentPlaceHolderID="FeaturedContent">
    <head>
	<style type="text/css">
	body{
		font-family: Trebuchet MS, Lucida Sans Unicode, Arial, sans-serif;	/* Font to use */
		background-color:#E2EBED;
	}
    

        /* menu header */
    .css-title:before {
        content: "some title";
        display: block;
        position: absolute;
        top: 0;
        right: 0;
        left: 0;
        background: #DDD;
        padding: 2px;
    
        font-family: Verdana, Arial, Helvetica, sans-serif;
        font-size: 11px;
        font-weight: bold;
    }
    .css-title :first-child {
        margin-top: 20px;
    }


    /* menu header via data attribute */
    .data-title:before {
        content: attr(data-menutitle);
        display: block;
        position: absolute;
        top: 0;
        right: 0;
        left: 0;
        background: #DDD;
        padding: 2px;
    
        font-family: Verdana, Arial, Helvetica, sans-serif;
        font-size: 11px;
        font-weight: bold;
    }
    .data-title :first-child {
        margin-top: 20px;
    }


    /* demo trigger boxes */
    .box {
        color: #EEE;
        background: #666;
        font-weight: bold;
        padding: 20px;
        text-align: center;
        font-size: 20px;
        margin: 5px 0;
    }
    .box:hover {
        background: #777;
    }
    .box > * {
        display:block;
    }
    .menu-injected { background-color: #C87958; }
    .box.context-menu-disabled { background-color: red; }

    .handler_horizontal 
	{ 
		width:100%;
		height: 10px; 
		cursor: row-resize; 
		left: 0; 
		border:1px solid grey;
		position:absolute;
        margin-bottom:50px;	
	}

    #poolDiv
	{
		overflow:auto;
		background-color: black;
        width:100%;
		height:37%;
	}



    #poolDiv div 
	{
        float:left;

        /* CSS HACK */
		width: 172px;	/* IE 5.x */
		width/* */:/**/170px;	/* Other browsers */
		width: /**/170px;
	}



	#deckDiv
	{
		overflow:auto;
		background-color: black;
	}

    #deckDiv div 
	{
        float:left;
	}
	#dhtmlgoodies_dragDropContainer{	/* Main container for this script */
		background-color:#FFF;
		-moz-user-select:none;
	}
	#dhtmlgoodies_dragDropContainer ul{	/* General rules for all <ul> */
		margin-top:0px;
		margin-left:0px;
		margin-bottom:0px;
		padding:2px;
	}

	#dhtmlgoodies_dragDropContainer li,#dragContent li,li#indicateDestination{	/* Movable items, i.e. <LI> */
		list-style-type:none;
		height:23px;
		background-color:#000000;
		cursor:pointer;
		font-size:0.9em;
	}

	li#indicateDestination{	/* Box indicating where content will be dropped - i.e. the one you use if you don't use arrow */
		background-color:#FFF;
	}


	#dhtmlgoodies_dragDropContainer .mouseover{	/* Mouse over effect DIV box in right column */
		background-color:#FFFFFF;
		border:1px solid #317082;
	}

	/* Start main container CSS */

	div#dhtmlgoodies_mainContainer{	/* Right column DIV */
        /**float:left;*/
        width:100%;
        height:100%;
        position:relative;

	}

	#dhtmlgoodies_mainContainer div{	/* Parent <div> of small boxes */
        /**float:left;*/
		margin-right:10px;
		margin-bottom:10px;
		margin-top:0px;
		border-left:1px solid #666666;

	}
	#dhtmlgoodies_mainContainer div ul{
		margin-left:10px;
	}

    span.tab {
    padding: 0 80px; 
    }

	#dhtmlgoodies_mainContainer ul{	/* Small box in right column ,i.e <ul> */
		width:150px;
		height:80px;
		border:0px;
		margin-bottom:0px;
	}

	#dragContent{	/* Drag container */
		position:absolute;
		width:150px;
		height:20px;
		display:none;
		margin:0px;
		padding:0px;
		z-index:2000;
	}

	#dragDropIndicator{	/* DIV for the small arrow */
		position:absolute;
		width:7px;
		height:10px;
		display:none;
		z-index:1000;
		margin:0px;
		padding:0px;
	}
	</style>
	<style type="text/css" media="print">
	div#dhtmlgoodies_listOfItems{
		display:none;
	}
	body{
		background-color:#FFF;
	}
	img{
		display:none;
	}
	#dhtmlgoodies_dragDropContainer{
		border:0px;
		width:100%;
	}

    .ui-drop-hover {
    border: 1px solid yellow;
    background-color:yellow;
    }

    .ui-draggable-dragging
    {
       display:none;
    }


    

	</style>


    <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js"></script>
	<script type="text/javascript">
	    /* http://jsfiddle.net/MadLittleMods/4Vfm5/ */

	    $(document).ready(function () {
	        $("#previewImage").draggable({
	            appendTo: 'body'
	        });

	        $('#resizeDiv').draggable().resizable();

	        $('#resizeDiv').resizable({
                start: function (e, ui) {
                    alert('resizing started');
                },
                resize: function (e, ui) {

                },
                stop: function (e, ui) {
                    alert('resizing stopped');
                }
            });
	        console.log("VERSION " + jQuery.fn.jquery);
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
	        var size = 30 * largest;
	        console.log(size);
	        var elems = $("#poolDiv").find('ul');
	        $(elems).each(function () {
	            $(this).css('height', size + 'px');
	        });
	        
	        $("#poolImage").attr("title", "W: " + countArray[0] + ", U: " + countArray[1] + ", B: " + countArray[2] + ", R: " + countArray[3] + ", G: " + countArray[4] + ", M: " + countArray[5] + ", A/L: " + countArray[6]);
	        $("#WhiteButton").attr("title", "White: " + countArray[0] + " cards.");
	        $("#BlueButton").attr("title", "Blue: " + countArray[1] + " cards.");
	        $("#BlackButton").attr("title", "Black: " + countArray[2] + " cards.");
	        $("#RedButton").attr("title", "Red: " + countArray[3] + " cards.");
	        $("#GreenButton").attr("title", "Green: " + countArray[4] + " cards.");
	        $("#MultiColorButton").attr("title", "Multicolor: " + countArray[5] + " cards.");
	        $("#ArtifactButton").attr("title", "Colorless: " + countArray[6] + " cards.");
	        $("#LandButton").attr("title", "Colorless: " + countArray[6] + " cards.");

	        $('.toggleButtonImages').attr("toggled", "0");
	        $('.sortPoolButtonImages').attr("clicked", "0");
	        $('#totalCreaturesInDeck').html("0");
	        $('#totalCardsInDeck').html("0");
	        $('#totalOtherInDeck').html("0");
	        $('#totalLandsInDeck').html("0");

	        $(".AddButtonImages").hover(function () {
	            $(this).attr("src", "/Images/Hover" + $(this).attr("id") + ".jpg");

	        }, function () {
	                $(this).attr("src", "/Images/" + $(this).attr("id") + ".jpg");
	        });

	        $(".sortPoolButtonImages").hover(function () {
	           $(this).attr("src", "/Images/Hover" + $(this).attr("id").substring(4) + ".jpg");

	        }, function () {
	            if ($(this).attr("clicked") == 1) {
	                $(this).attr("src", "/Images/Selected" + $(this).attr("id").substring(4) + ".jpg");
	            }

	            else {
	                $(this).attr("src", "/Images/" + $(this).attr("id").substring(4) + ".jpg");
	            }
	        });

	        $(".sortDeckButtonImages").hover(function () {
	            $(this).attr("src", "/Images/Hover" + $(this).attr("id").substring(4) + ".jpg");

	        }, function () {
	            if ($(this).attr("clicked") == 1) {
	                $(this).attr("src", "/Images/Selected" + $(this).attr("id").substring(4) + ".jpg");
	            }

	            else {
	                $(this).attr("src", "/Images/" + $(this).attr("id").substring(4) + ".jpg");
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
	            if ($(this).attr("toggled") == 1)
	            {
	                $(this).attr("src", "/Images/Toggled" + $(this).attr("id") + ".jpg");
	            }

	            else
	            {
	                $(this).attr("src", "/Images/" + $(this).attr("id") + ".jpg");
	            }

	        });

	        $('#addLandButton').click(function () {
	            $('#addLandDialog').dialog('open');
	        });


	        $.addLandFunction = function() {
	            $("#addLandDialog").dialog("close");
	            var numberOfLands = parseInt($('#addPlainsBox').val()) + parseInt($('#addIslandBox').val()) + parseInt($('#addSwampBox').val()) + parseInt($('#addMountainBox').val()) + parseInt($('#addForestBox').val());
	            var totalNumberOfCardsInDeck = parseInt($('#totalCardsInDeck').html());

                // Add plains
	            for (var i = 0; i < $('#addPlainsBox').val(); i++)
	            {
	                $("#deckPile7").append($('<li></li>').append($("<img src='/TherosPictures/plains2.jpg'/>").css({ width: 150 })).attr("onmouseover", "javascript:return preview(this);").attr("file", "/TherosPictures/plains2.jpg").attr("name", "Plains (2)").attr("type", "Land").attr("cmc", "0").attr("color", "Colorless").attr("rarity", "common"));
	            }

	            // Add island
	            for (var i = 0; i < $('#addIslandBox').val() ; i++) {
	                $("#deckPile7").append($('<li></li>').append($("<img src='/TherosPictures/island4.jpg'/>").css({ width: 150 })).attr("onmouseover", "javascript:return preview(this);").attr("file", "/TherosPictures/island4.jpg").attr("name", "Island (4)").attr("type", "Land").attr("cmc", "0").attr("color", "Colorless").attr("rarity", "common"));
	            }

	            // Add swamp
	            for (var i = 0; i < $('#addSwampBox').val() ; i++) {
	                $("#deckPile7").append($('<li></li>').append($("<img src='/TherosPictures/swamp4.jpg'/>").css({ width: 150 })).attr("onmouseover", "javascript:return preview(this);").attr("file", "/TherosPictures/swamp4.jpg").attr("name", "Swamp (4)").attr("type", "Land").attr("cmc", "0").attr("color", "Colorless").attr("rarity", "common"));
	            }

	            // Add mountain
	            for (var i = 0; i < $('#addMountainBox').val() ; i++) {
	                $("#deckPile7").append($('<li></li>').append($("<img src='/TherosPictures/mountain4.jpg'/>").css({ width: 150 })).attr("onmouseover", "javascript:return preview(this);").attr("file", "/TherosPictures/mountain4.jpg").attr("name", "Mountain (4)").attr("type", "Land").attr("cmc", "0").attr("color", "Colorless").attr("rarity", "common"));
	            }

	            // Add forest
	            for (var i = 0; i < $('#addForestBox').val() ; i++) {
	                $("#deckPile7").append($('<li></li>').append($("<img src='/TherosPictures/forest3.jpg'/>").css({ width: 150 })).attr("onmouseover", "javascript:return preview(this);").attr("file", "/TherosPictures/forest3.jpg").attr("name", "Forest (3)").attr("type", "Land").attr("cmc", "0").attr("color", "Colorless").attr("rarity", "common"));
	            }

	            
	            $('#totalLandsInDeck').html((numberOfLands + parseInt($('#totalLandsInDeck').html())).toString());
	            $('#totalCardsInDeck').html((numberOfLands + totalNumberOfCardsInDeck).toString());
	            $.enableDrag();
	        };

	        $.suggestLandFunction = function () {
	            var elems = $("#deckDiv").find('ul').children('li');
	            var numberOfEachColorList = [0, 0, 0, 0, 0, 0];
	            var numberOfEachLandList = [];
	            $(elems).each(function () {
	                if ($(this).attr("color") == "White") {
	                    numberOfEachColorList[0] = parseInt(numberOfEachColorList[0]) + 1;
	                }

	                else if ($(this).attr("color") == "Blue") {
	                    numberOfEachColorList[1] = parseInt(numberOfEachColorList[1]) + 1;
	                }

	                else if ($(this).attr("color") == "Black") {
	                    numberOfEachColorList[2] = parseInt(numberOfEachColorList[2]) + 1;
	                }

	                else if ($(this).attr("color") == "Red") {
	                    numberOfEachColorList[3] = parseInt(numberOfEachColorList[3]) + 1;
	                }

	                else if ($(this).attr("color") == "Green") {
	                    numberOfEachColorList[4] = parseInt(numberOfEachColorList[4]) + 1;
	                }

	                else {
	                    numberOfEachColorList[5] = parseInt(numberOfEachColorList[5]) + 1;
	                }
	            });

	            var totalNonLandCards = 0;
	            

	            for (var i = 0; i < numberOfEachColorList.length; i++)
	            {
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
	            for (var i = 0; i < cardNameArray.length; i++)
	            {
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
	            buttons: { "OK": function () { $.addLandFunction(); }, "Suggest": function () { $.suggestLandFunction(); }, }
	        });
	        $(".ui-dialog-titlebar").hide();
	    });

	    $(function () {
	        $("#restoreDeckButton").click(function () {
	            $("ul li").each(function () {
	                if ($(this).attr("color") == "White") {
	                    $(this).appendTo($('#<%=poolPile1.ClientID %>'));
	                }

	                else if ($(this).attr("color") == "Blue") {
	                    $(this).appendTo($('#<%=poolPile2.ClientID %>'));
	                }

	                else if ($(this).attr("color") == "Black") {
	                    $(this).appendTo($('#<%=poolPile3.ClientID %>'));
	                }

	                else if ($(this).attr("color") == "Red") {
	                    $(this).appendTo($('#<%=poolPile4.ClientID %>'));
	                }

	                else if ($(this).attr("color") == "Green") {
	                    $(this).appendTo($('#<%=poolPile5.ClientID %>'));
	                }

	                else if ($(this).attr("color") == "MultiColor") {
	                    $(this).appendTo($('#<%=poolPile6.ClientID %>'));
	                }

	                else {
	                    $(this).appendTo($('#<%=poolPile7.ClientID %>'));
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

	            else
	            {
	                $($(this).children('img')).attr("toggled", "0");
	                $($(this).children('img')).attr("src", "/Images/" + $(this).children('img').attr("id") + ".jpg");
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
	                $(this).attr("src", "/Images/" + $(this).attr("id").substring(4) + ".jpg");
	            });
	            $("#deckColorButton").attr("src", "/Images/SelectedColorButton.jpg");

	            $(elems).each(function () {
	                if ($(this).attr("color") == "White") {
	                    $(this).appendTo($("#deckPile1"));
	                }

	                else if ($(this).attr("color") == "Blue") {
	                    $(this).appendTo($("#deckPile2"));
	                }

	                else if ($(this).attr("color") == "Black") {
	                    $(this).appendTo($("#deckPile3"));
	                }

	                else if ($(this).attr("color") == "Red") {
	                    $(this).appendTo($('#deckPile4'));
	                }

	                else if ($(this).attr("color") == "Green") {
	                    $(this).appendTo($('#deckPile5'));
	                }

	                else if ($(this).attr("color") == "MultiColor") {
	                    $(this).appendTo($('#deckPile6'));
	                }

	                else {
	                    $(this).appendTo($('#deckPile7'));
	                }
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
                $(this).attr("src", "/Images/" + $(this).attr("id").substring(4) + ".jpg");
            });
            $("#deckCostButton").attr("src", "/Images/SelectedCostButton.jpg");

            elems.sort(function (a, b) {
                return parseInt($(a).attr("cmc")) < parseInt($(b).attr("cmc")) ? 1 : -1;
            });

            $(elems).each(function () {
                if ($(this).attr("cmc") == "1") {
                    $(this).appendTo('#deckPile1');
	                    }

	                    else if ($(this).attr("cmc") == "2") {
	                        $(this).appendTo('#deckPile2');
	                    }

	                    else if ($(this).attr("cmc") == "3") {
	                        $(this).appendTo('#deckPile3');
	                    }

	                    else if ($(this).attr("cmc") == "4") {
	                        $(this).appendTo('#deckPile4');
	                    }

	                    else if ($(this).attr("cmc") == "5") {
	                        $(this).appendTo('#deckPile5');
	                    }

	                    else if ($(this).attr("cmc") == "6") {
	                        $(this).appendTo('#deckPile6');
	                    }

	                    else {
	                        $(this).appendTo('#deckPile7');
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
                $(this).attr("src", "/Images/" + $(this).attr("id").substring(4) + ".jpg");
            });
            $("#deckRarityButton").attr("src", "/Images/SelectedRarityButton.jpg");

            $(elems).each(function () {
                if ($(this).attr("rarity") == "R" || $(this).attr("rarity") == "M")
                {
                    $(this).appendTo('#deckPile1');
	            }

	            else if ($(this).attr("rarity") == "U") {
	                $(this).appendTo('#deckPile2');
	            }

	            else
	            {
	                if ($("#pile3Deckdiv li").length < 20) {
	                    $(this).appendTo('#deckPile3');
	                }

	                else if ($("#pile4Deckdiv li").length < 20) {
	                    $(this).appendTo('#deckPile4');
	                }

	                else {
	                    $(this).appendTo('#deckPile5');
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
                $(this).attr("src", "/Images/" + $(this).attr("id").substring(4) + ".jpg");
            });
            $("#deckTypeButton").attr("src", "/Images/SelectedTypeButton.jpg");

            $(elems).each(function () {
                if ($(this).attr("type") == "Creature")
                {
                    $(this).appendTo('#deckPile1');
	            }

	            else if ($(this).attr("type") == "Enchantment") {
	                $(this).appendTo('#deckPile2');
	            }

	            else if ($(this).attr("type") == "Artifact") {
	                $(this).appendTo('#deckPile3');
	            }

	            else if ($(this).attr("type") == "Instant") {
	                $(this).appendTo('#deckPile4');
	            }

	            else if ($(this).attr("type") == "Sorcery") {
	                $(this).appendTo('#deckPile5');
	            }

	            else if ($(this).attr("type") == "Land") {
	                $(this).appendTo('#deckPile6');
	            }

	            else {
	                $(this).appendTo('#deckPile7');
	            }

	            });
	            $.enableDrag();
	            });
	        });

    // SORT FUNCTIONS FOR POOL AREA ---------------------------------------------------------------------------------------
	    
    $(function () {

        // Sort by Color - POOL
	    $("#sortColorPoolButton").click(function () {
	        var elems = $("#poolDiv").find('ul').children('li').remove();
	        $('.sortPoolButtonImages').attr("clicked", "0");
	        $("#poolColorButton").attr("clicked", "1");
	        $('.sortPoolButtonImages').each(function () {
	            $(this).attr("src", "/Images/" + $(this).attr("id").substring(4) + ".jpg");
	        });
	        $("#poolColorButton").attr("src", "/Images/SelectedColorButton.jpg");

	        $(elems).each(function () {
	            if ($(this).attr("color") == "White")
	            {
	                $(this).appendTo('#<%=poolPile1.ClientID %>');
	            }

	            else if ($(this).attr("color") == "Blue") {
	                $(this).appendTo('#<%=poolPile2.ClientID %>');
	            }

	            else if ($(this).attr("color") == "Black") {
	                $(this).appendTo('#<%=poolPile3.ClientID %>');
	            }

	            else if ($(this).attr("color") == "Red") {
	                $(this).appendTo('#<%=poolPile4.ClientID %>');
	            }

	            else if ($(this).attr("color") == "Green") {
	                $(this).appendTo('#<%=poolPile5.ClientID %>');
	            }

	            else if ($(this).attr("color") == "MultiColor") {
	                $(this).appendTo('#<%=poolPile6.ClientID %>');
	            }

	            else {
	                $(this).appendTo('#<%=poolPile7.ClientID %>');
	            }
	        });
	        $.enableDrag();
	    });

        // Sort by CMC - POOL
        $("#sortCostPoolButton").click(function () {
            var elems = $("#poolDiv").find('ul').children('li').remove();
            $('.sortPoolButtonImages').attr("clicked", "0");
            $("#poolCostButton").attr("clicked", "1");
            $('.sortPoolButtonImages').each(function () {
                $(this).attr("src", "/Images/" + $(this).attr("id").substring(4) + ".jpg");
            });
            $("#poolCostButton").attr("src", "/Images/SelectedCostButton.jpg");

            elems.sort(function (a, b) {
                return parseInt($(a).attr("cmc")) < parseInt($(b).attr("cmc")) ? 1 : -1;
            });

            $(elems).each(function () {
                if ($(this).attr("cmc") == "1") {
                    $(this).appendTo('#<%=poolPile1.ClientID %>');
	                }

	                else if ($(this).attr("cmc") == "2") {
	                    $(this).appendTo('#<%=poolPile2.ClientID %>');
	                }

	                else if ($(this).attr("cmc") == "3") {
	                    $(this).appendTo('#<%=poolPile3.ClientID %>');
	                }

	                else if ($(this).attr("cmc") == "4") {
	                    $(this).appendTo('#<%=poolPile4.ClientID %>');
	                }

	                else if ($(this).attr("cmc") == "5") {
	                    $(this).appendTo('#<%=poolPile5.ClientID %>');
	                }

	                else if ($(this).attr("cmc") == "6") {
	                    $(this).appendTo('#<%=poolPile6.ClientID %>');
	                }

	                else {
	                    $(this).appendTo('#<%=poolPile7.ClientID %>');
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
                $(this).attr("src", "/Images/" + $(this).attr("id").substring(4) + ".jpg");
            });
            $("#poolRarityButton").attr("src", "/Images/SelectedRarityButton.jpg");

            $(elems).each(function () {
                if ($(this).attr("rarity") == "R" || $(this).attr("rarity") == "M") {
                    $(this).appendTo('#<%=poolPile1.ClientID %>');
	                }

	                else if ($(this).attr("rarity") == "U") {
	                    $(this).appendTo('#<%=poolPile2.ClientID %>');
	                }

	                else {
	                    console.log($('#<%=poolPile3.ClientID %>').size());
	                    if ($("#pile3div li").length < 20) {
	                        $(this).appendTo('#<%=poolPile3.ClientID %>');
	                    }

	                    else if ($("#pile4div li").length < 20) {
	                        $(this).appendTo('#<%=poolPile4.ClientID %>');
	                    }

	                    else {
	                        $(this).appendTo('#<%=poolPile5.ClientID %>');
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
                $(this).attr("src", "/Images/" + $(this).attr("id").substring(4) + ".jpg");
            });
            $("#poolTypeButton").attr("src", "/Images/SelectedTypeButton.jpg");

            $(elems).each(function () {
                if ($(this).attr("type") == "Creature") {
                    $(this).appendTo('#<%=poolPile1.ClientID %>');
	                }

	                else if ($(this).attr("type") == "Enchantment") {
	                    $(this).appendTo('#<%=poolPile2.ClientID %>');
	                }

	                else if ($(this).attr("type") == "Artifact") {
	                    $(this).appendTo('#<%=poolPile3.ClientID %>');
	                }

	                else if ($(this).attr("type") == "Instant") {
	                    $(this).appendTo('#<%=poolPile4.ClientID %>');
	                }

	                else if ($(this).attr("type") == "Sorcery") {
	                    $(this).appendTo('#<%=poolPile5.ClientID %>');
	                }

	                else if ($(this).attr("type") == "Land") {
	                    $(this).appendTo('#<%=poolPile6.ClientID %>');
	                }

	                else {
	                    $(this).appendTo('#<%=poolPile7.ClientID %>');
	                }
	            });
	            $.enableDrag();
        });

	    });

	    $(function () {
	        $("#draggable").draggable({
	            containment: [9, 50, 9, 700],
	            drag: function () {
	                var position = $("#draggable").position();
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

	    $(function () {
	        var sourceElement;
	        $.enableDrag = function() {
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
	        };
	        $.enableDrag();
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
	                    console.log(sourceElement);
	                },
	                scroll: false,
	                helper: 'clone',
	                appendTo: 'body'
	            });
	        });

            // Set every ul to droppable in POOL
	        $(".poolStack").droppable({
	            activeClass: "ui-state-hover",
	            hoverClass: "ui-drop-hover",
	            accept: ":not(.ui-sortable-helper)",
	            drop: function (event, ui) {
	                $('#totalCardsInDeck').html(function (i, val) { return val * 1 - 1 });
	                if ($(ui.draggable).attr("type") == 'Creature') {
	                    $('#totalCreaturesInDeck').html(function (i, val) { return val * 1 - 1 });
	                }
	                else {
	                    $('#totalOtherInDeck').html(function (i, val) { return val * 1 - 1 });
	                }
	                $(this).addClass("ui-state-highlight");
	                $(ui.draggable).appendTo(this);
	            }
	        });

	        // Set every ul to droppable in DECK
	        $(".deckStack").droppable({
	            activeClass: "ui-state-hover",
	            hoverClass: "ui-drop-hover",
	            accept: ":not(.ui-sortable-helper)",
	            drop: function (event, ui) {

	                if (sourceElement == "poolDiv") {
	                    $('#totalCardsInDeck').html(function (i, val) { return val * 1 + 1 });
	                    if ($(ui.draggable).attr("type") == 'Creature') {
	                        $('#totalCreaturesInDeck').html(function (i, val) { return val * 1 + 1 });
	                    }
	                    else {
	                        $('#totalOtherInDeck').html(function (i, val) { return val * 1 + 1 });
	                    }
	                }
	                $(this).addClass("ui-state-highlight");
	                $(ui.draggable).appendTo(this);
	            }
	        });

	        // Send a card from Pool to Deck (first column)
	        $('#<%=poolPile1.ClientID %>').on('dblclick', 'li', function () {
	            $(this).appendTo($('#deckPile1'));
	            $('#totalCardsInDeck').html(function (i, val) { return val * 1 + 1 });
	            if ($(this).attr("type") == 'Creature') {
	                $('#totalCreaturesInDeck').html(function (i, val) { return val * 1 + 1 });
	            }
	            else {
	                $('#totalOtherInDeck').html(function (i, val) { return val * 1 + 1 });
	            }
	        });

	        $('#<%=poolPile2.ClientID %>').on('dblclick', 'li', function () {
	            $(this).appendTo($('#deckPile1'));
	            $('#totalCardsInDeck').html(function (i, val) { return val * 1 + 1 });
	            if ($(this).attr("type") == 'Creature') {
	                $('#totalCreaturesInDeck').html(function (i, val) { return val * 1 + 1 });
	            }
	            else {
	                $('#totalOtherInDeck').html(function (i, val) { return val * 1 + 1 });
	            }
	        });

	        $('#<%=poolPile3.ClientID %>').on('dblclick', 'li', function () {
	            $(this).appendTo($('#deckPile1'));
	            $('#totalCardsInDeck').html(function (i, val) { return val * 1 + 1 });
	            if ($(this).attr("type") == 'Creature') {
	                $('#totalCreaturesInDeck').html(function (i, val) { return val * 1 + 1 });
	            }
	            else {
	                $('#totalOtherInDeck').html(function (i, val) { return val * 1 + 1 });
	            }
	        });

	        $('#<%=poolPile4.ClientID %>').on('dblclick', 'li', function () {
	            $(this).appendTo($('#deckPile1'));
	            $('#totalCardsInDeck').html(function (i, val) { return val * 1 + 1 });
	            if ($(this).attr("type") == 'Creature') {
	                $('#totalCreaturesInDeck').html(function (i, val) { return val * 1 + 1 });
	            }
	            else {
	                $('#totalOtherInDeck').html(function (i, val) { return val * 1 + 1 });
	            }
	        });

	        $('#<%=poolPile5.ClientID %>').on('dblclick', 'li', function () {
	            $(this).appendTo($('#deckPile1'));
	            $('#totalCardsInDeck').html(function (i, val) { return val * 1 + 1 });
	            if ($(this).attr("type") == 'Creature') {
	                $('#totalCreaturesInDeck').html(function (i, val) { return val * 1 + 1 });
	            }
	            else {
	                $('#totalOtherInDeck').html(function (i, val) { return val * 1 + 1 });
	            }
	        });

	        $('#<%=poolPile6.ClientID %>').on('dblclick', 'li', function () {
	            $(this).appendTo($('#deckPile1'));
	            $('#totalCardsInDeck').html(function (i, val) { return val * 1 + 1 });
	            if ($(this).attr("type") == 'Creature') {
	                $('#totalCreaturesInDeck').html(function (i, val) { return val * 1 + 1 });
	            }
	            else {
	                $('#totalOtherInDeck').html(function (i, val) { return val * 1 + 1 });
	            }
	        });

	        $('#<%=poolPile7.ClientID %>').on('dblclick', 'li', function () {
	            $(this).appendTo($('#deckPile1'));
	            $('#totalCardsInDeck').html(function (i, val) { return val * 1 + 1 });
	            if ($(this).attr("type") == 'Creature') {
	                $('#totalCreaturesInDeck').html(function (i, val) { return val * 1 + 1 });
	            }
	            else {
	                $('#totalOtherInDeck').html(function (i, val) { return val * 1 + 1 });
	            }
	        });

            // Send a card back to POOL
	        $(".deckStack").on('dblclick', 'li', function () {
	            $('#totalCardsInDeck').html(function (i, val) { return val * 1 - 1 });
	            if ($(this).attr("type") == 'Creature') {
	                $('#totalCreaturesInDeck').html(function (i, val) { return val * 1 - 1 });
	            }
	            else {
	                $('#totalOtherInDeck').html(function (i, val) { return val * 1 - 1 });
	            }
	            if ($(this).attr("color") == 'White')
	            {
	                $(this).appendTo('#<%=poolPile1.ClientID %>');
	            }
	            else if ($(this).attr("color") == 'Blue') {
	                $(this).appendTo('#<%=poolPile2.ClientID %>');
	            }
	            else if ($(this).attr("color") == 'Black') {
	                $(this).appendTo('#<%=poolPile3.ClientID %>');
	            }
	            else if ($(this).attr("color") == 'Red') {
	                $(this).appendTo('#<%=poolPile4.ClientID %>');
	            }
	            else if ($(this).attr("color") == 'Green') {
	                $(this).appendTo('#<%=poolPile5.ClientID %>');
	            }

	            else if ($(this).attr("color") == 'MultiColor') {
	                $(this).appendTo('#<%=poolPile6.ClientID %>');
	            }

	            else  {
	                $(this).appendTo('#<%=poolPile7.ClientID %>');
	            }
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


	</script>


    </head>

    <section class="featured">
            <asp:Panel runat="server" ID="defaultPanel">
                </asp:Panel>
    <!--<div class="context-menu-one box menu-1">
        <strong>without title</strong>
    </div>-->
    <div id="decklistDialog" style="background-color:white">
            <p id="decklistTextArea">
            </p>
    </div>
    <div id="addLandDialog" style="background-color:white; border: 3px solid grey;">
        <table border="1" style="border-collapse:collapse; border-color:white">
            <tr>
                <td style="background-color:black"><img src="/Images/WhiteImage.jpg" width="50" alt="submit" /></td>
                <td style="background-color:black"><img src="/Images/BlueImage.jpg" width="50" alt="submit" /></td>
                <td style="background-color:black"><img src="/Images/BlackImage.jpg" width="50" alt="submit" /></td>
                <td style="background-color:black"><img src="/Images/RedImage.jpg" width="50" alt="submit" /></td>
                <td style="background-color:black"><img src="/Images/GreenImage.jpg" width="50" alt="submit" /></td>
            </tr>
            <tr>
                <td><input type="number" id="addPlainsBox" onkeypress='validate(event)' value="0" min="0" max="99" style="background-color:#f6f3be; font-family:Vani; width:45px; font-size: 24px;"></td>
                <td><input type="number" id="addIslandBox" onkeypress='validate(event)' value="0" min="0" max="99" style="background-color:#2842fb; font-family:Vani; width:45px; font-size: 24px;"></td>
                <td><input type="number" id="addSwampBox" onkeypress='validate(event)' value="0" min="0" max="99" style="background-color:#6a6a6a; font-family:Vani; width:45px; font-size: 24px;"></td>
                <td><input type="number" id="addMountainBox" onkeypress='validate(event)' value="0" min="0" max="99" style="background-color:#fc020e; font-family:Vani; width:45px; font-size: 24px;"></td>
                <td><input type="number" id="addForestBox" onkeypress='validate(event)' value="0" min="0" max="99" style="background-color:#30e528; font-family:Vani; width:45px; font-size: 24px;"></td>
            </tr>
        </table>
    </div>
    <div style="background-color:darkgreen; border: 3px solid black; width:100%">
        <table>
            <tr>
                <td><img src="/Images/Pool.jpg" id="poolImage" width="120" alt="submit" /></td>    
                <td>
                    <table border="1" style="border-collapse:collapse; border-color:black">
                        <tr>
                            <td style="background-color:black"><img src="/Images/SortByImage.jpg" id="Img4" width="120" alt="submit" /></td>
                            <td style="background-color:white"><button id="sortColorPoolButton" style="margin: 0px; width:70px; height:32px; padding: 0; vertical-align:middle; background-color: transparent; border: none;" onclick="return false;"><img src="/Images/ColorButton.jpg" id="poolColorButton" width="70" class="sortPoolButtonImages" alt="submit" /></button></td>
                            <td style="background-color:white"><button id="sortCostPoolButton" style="margin: 0px; width:70px; height:32px; padding: 0; vertical-align:middle; background-color: transparent; border: none;" onclick="return false;"><img src="/Images/CostButton.jpg" id="poolCostButton" width="70" class="sortPoolButtonImages" alt="submit" /></button></td>
                            <td style="background-color:white;"><button id="sortRarityPoolButton" style="margin: 0px; height:32px; padding: 0; vertical-align:middle; background-color: transparent; border: none;"  onclick="return false;"><img src="/Images/RarityButton.jpg" id="poolRarityButton" width="70" class="sortPoolButtonImages" alt="submit" /></button></td>
                            <td style="background-color:white"><button id="sortTypePoolButton" style="margin: 0px; height:32px; padding: 0; vertical-align:middle; background-color: transparent; border: none;" onclick="return false;"><img src="/Images/TypeButton.jpg" id="poolTypeButton" width="70" class="sortPoolButtonImages" alt="submit" /></button></td>
                        </tr>
                    </table>
                </td>  
                <td><span class="tab"></span></td>
                <td>
                    <table border="1" style="border-collapse:collapse; border-color:black">
                        <tr>
                            <td style="background-color:black"><img src="/Images/ToggleImage.jpg" id="Img5" width="120" alt="submit" /></td>
                            <td style="background-color:white"><button style="margin: 0px; padding: 0; vertical-align:middle; background-color: transparent; border: none;" id="whiteShowHideButton" class="toggleButtons" onclick="return false;"><img src="/Images/WhiteButton.jpg" class="toggleButtonImages" id="WhiteButton" width="30" alt="submit" /></button></td>
                            <td style="background-color:white"><button style="margin: 0px; padding: 0; vertical-align:middle; background-color: transparent; border: none;" id="blueShowHideButton" class="toggleButtons" onclick="return false;"><img src="/Images/BlueButton.jpg" class="toggleButtonImages" id="BlueButton" width="30" alt="submit" /></button></td>
                            <td style="background-color:white"><button style="margin: 0px; padding: 0; vertical-align:middle; background-color: transparent; border: none;" id="blackShowHideButton" class="toggleButtons" onclick="return false;"><img src="/Images/BlackButton.jpg" class="toggleButtonImages" id="BlackButton" width="30" alt="submit" /></button></td>
                            <td style="background-color:white"><button style="margin: 0px; padding: 0; vertical-align:middle; background-color: transparent; border: none;" id="redShowHideButton" class="toggleButtons" onclick="return false;"><img src="/Images/RedButton.jpg" class="toggleButtonImages" id="RedButton" width="30" alt="submit" /></button></td>
                            <td style="background-color:white"><button style="margin: 0px; padding: 0; vertical-align:middle; background-color: transparent; border: none;" id="greenShowHideButton" class="toggleButtons" onclick="return false;"><img src="/Images/GreenButton.jpg" class="toggleButtonImages" id="GreenButton" width="30" alt="submit" /></button></td>
                            <td style="background-color:white"><button style="margin: 0px; padding: 0; vertical-align:middle; background-color: transparent; border: none;" id="multicolorShowHideButton" class="toggleButtons" onclick="return false;"><img src="/Images/MultiColorButton.jpg" class="toggleButtonImages" id="MultiColorButton" width="30" alt="submit" /></button></td>
                            <td style="background-color:white"><button style="margin: 0px; padding: 0; vertical-align:middle; background-color: transparent; border: none;" id="artifactShowHideButton" class="toggleButtons" onclick="return false;"><img src="/Images/ArtifactButton.jpg" class="toggleButtonImages" id="ArtifactButton" width="30" alt="submit" /></button></td>
                            <td style="background-color:white"><button style="margin: 0px; padding: 0; vertical-align:middle; background-color: transparent; border: none;" id="landShowHideButton" class="toggleButtons" onclick="return false;"><img src="/Images/LandButton.jpg" class="toggleButtonImages" id="LandButton" width="30" alt="submit" /></button></td>
                        </tr>
                    </table>
                </td>
                <td><span class="tab"></span></td>
                <td><td style="background-color:white"><button style="margin: 0px; width:70px; height:32px; padding: 0; vertical-align:middle; background-color: transparent; border: none;" id="restoreDeckButton" onclick="return false;"><img src="/Images/RestoreButton.jpg" id="Img6" width="70" alt="submit" /></button></td></td>
            </tr>
        </table>
    </div>
<div id="dhtmlgoodies_dragDropContainer">
<div id="dhtmlgoodies_mainContainer">
    <div id="poolDiv">
	    <div id="pile1div" class="column_n">
            <ul id="poolPile1" runat="server" class="poolStack" style=" list-style-type:none">
		    </ul>
	    </div>
	    <div id="pile2div" class="column_n">
		    <ul id="poolPile2" runat="server" class="poolStack" style=" list-style-type:none">
		    </ul>
	    </div>
	    <div id="pile3div" class="column_n" >
		    <ul id="poolPile3" runat="server" class="poolStack" style=" list-style-type:none">
		    </ul>
	    </div>
	    <div id="pile4div" class="column_n">
		    <ul id="poolPile4" runat="server" class="poolStack">
		    </ul>
	    </div>
	    <div id="pile5div" class="column_n">
		    <ul id="poolPile5" runat="server" class="poolStack">
		    </ul>
	    </div>
	    <div id="pile6div" class="column_n">
		    <ul id="poolPile6" runat="server" class="poolStack">
		    </ul>
	    </div>
	    <div id="pile7div" class="column_n">
		    <ul id="poolPile7" runat="server" class="poolStack">
		    </ul>
	    </div>
	    <div id="previewDiv" runat="server">
            <img id="previewImage" src="/Images/mtgBack.jpg" width="200px">
	    </div>
    </div>
    <div style="background-color:white; width:100%" id="draggable" class="handler_horizontal">
    </div>
    <div style="background-color:darkgreen; border: 3px solid black; width:100%" >
    <table>
        <tr>
            <td><img src="/Images/Deck.jpg" id="Img2" width="120" alt="submit" /></td>

            <td>
                <table border="1" style="border-collapse:collapse; border-color:black">
                    <tr>
                        <td style="background-color:black"><img src="/Images/SortByImage.jpg" id="Img3" width="120" alt="submit" /></td>
                        <td style="background-color:white"><button style="margin: 0px; width:70px; height:32px; padding: 0; vertical-align:middle; background-color: transparent; border: none;" id="sortColorDeckButton" onclick="return false;"><img src="/Images/ColorButton.jpg" id="deckColorButton" width="70" class="sortDeckButtonImages" alt="submit" /></button></td>
                        <td style="background-color:white"><button style="margin: 0px; width:70px; height:32px; padding: 0; vertical-align:middle; background-color: transparent; border: none;" id="sortCostDeckButton" onclick="return false;"><img src="/Images/CostButton.jpg" id="deckCostButton" width="70" class="sortDeckButtonImages" alt="submit" /></button></td>
                        <td style="background-color:white"><button style="margin: 0px; width:70px; height:32px; padding: 0; vertical-align:middle; background-color: transparent; border: none;" id="sortRarityDeckButton" onclick="return false;"><img src="/Images/RarityButton.jpg" id="deckRarityButton" width="70" class="sortDeckButtonImages" alt="submit" /></button></td>
                        <td style="background-color:white"><button style="margin: 0px; width:70px; height:32px; padding: 0; vertical-align:middle; background-color: transparent; border: none;" id="sortTypeDeckButton" onclick="return false;"><img src="/Images/TypeButton.jpg" id="deckTypeButton" width="70" class="sortDeckButtonImages" alt="submit" /></button></td>
                    </tr>
                </table>

            </td>
            <td><span class="tab"></span></td>
            <td>
                <table border="1" style="border-collapse:collapse; border-color:black">
                    <tr>
                        <td style="background-color:black"><img src="/Images/AddImage.jpg" id="Img1" width="120" alt="submit" /></td>
                        <td style="background-color:white"><button style="margin: 0px; padding: 0; vertical-align:middle; background-color: transparent; border: none;" id="addLandsButton" onclick="return false;"><img src="/Images/AddLandButton.jpg" id="addLandButton" width="70" class="AddButtonImages" alt="submit" /></button></td>
                        <td style="background-color:white"><button style="margin: 0px; padding: 0; vertical-align:middle; background-color: transparent; border: none;" id="openDecklistButton" onclick="return false;"><img src="/Images/DecklistButton.jpg" id="decklistButton" width="70" class="AddButtonImages" alt="submit" /></button></td>
                    </tr>
                </table>
            </td>
            <td><span class="tab"></span></td>
            <td><label style="color:white">Total:</label><label id="totalCardsInDeck" style="color:white"></label></td>
            <td><label style="color:white">Creatures: </label><label id="totalCreaturesInDeck" style="color:white"></label></td>
            <td><label style="color:white">Other: </label><label id="totalOtherInDeck" style="color:white"></label></td>
            <td><label style="color:white">Lands: </label><label id="totalLandsInDeck" style="color:white"></label></td>
        </tr>
    </table>
    
    </div>
    <div id="deckDiv">
	    <div id="pile1Deckdiv">
		    <ul id="deckPile1" class="deckStack" style="height:500px; list-style-type:none">
		    </ul>
	    </div>
	    <div id="pile2Deckdiv">
		    <ul id="deckPile2" class="deckStack" style="height:500px; list-style-type:none">
		    </ul>
	    </div>
	    <div id="pile3Deckdiv">
		    <ul id="deckPile3" class="deckStack" style="height:500px; list-style-type:none">
		    </ul>
	    </div>
	    <div id="pile4Deckdiv"">
		    <ul id="deckPile4" class="deckStack" style="height:500px; list-style-type:none">
		    </ul>
	    </div>
	    <div id="pile5Deckdiv">
		    <ul id="deckPile5" class="deckStack" style="height:500px; list-style-type:none">
		    </ul>
	    </div>
	    <div id="pile6Deckdiv">
		    <ul id="deckPile6" class="deckStack" style="height:500px; list-style-type:none">
		    </ul>
	    </div>
	    <div id="pile7Deckdiv">
		    <ul id="deckPile7" class="deckStack" style="height:500px; list-style-type:none">
		    </ul>
	    </div>

    </div>
</div>

</div>
<ul id="dragContent"></ul>
<div id="dragDropIndicator"><img src="images/insert.gif"></div>
    </section>
</asp:Content>
<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
</asp:Content>
