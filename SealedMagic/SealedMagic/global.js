$(document).ready(function () {
    console.log(location.href);
    var hreflist = location.href.toString().replace(".", "/").split('/');
    console.log("x" + hreflist[4]);
    $('#menu_' + hreflist[4]).addClass("chosen_menu");

    $('#yourStartButton').click(function () {
       
        $.getJSON("http://xn--smst-loa.se/magiccarddb/card_handler.php?get_all_cards=true" , function (cards) {

            var lines = $('#yourPoolTextArea').val().split('\n');

                var poolArray = [];
                var cardsNotFound = [];

                for (var i = 0; i < lines.length; i++) {
                    if (lines[i].trim() == "")
                    {
                        lines.splice(i, 1);
                    }
                }
                
                // Each line in the poolList
                for (var i = 0; i < lines.length; i++) {
                    numberOfCopies = parseInt(lines[i].charAt(0));
                    console.log("n " + numberOfCopies.toString());
                    var cardname = lines[i].toString().replace(/\d+/g, '');
                    var cardFound = false;
                    $.each(cards, function (index, card) {
                        if (card.name.toLowerCase().replace(/\s+/g, '') == cardname.toLowerCase().replace(/\s+/g, '')) {
                            for (var j = 0; j < numberOfCopies; j++)
                            {
                                poolArray.push(card.id);
                            }
                            cardFound = true;
                            return false;
                        }

                        return true;
                    });

                    if (!cardFound) {
                        cardsNotFound.push(cardname);
                    }

                }

                if (!cardsNotFound.length) {
                    $.getJSON("http://sämst.se/magiccarddb/decksaver.php", { pool: poolArray }).done(
                        function (result) {
                            console.log("pool" + result.poolId);
                            window.open('magicSealedSite.html?poolid=' + result.poolId);
                        });
                }

                else {
                    $('#errorMessage').text("Wrong: " + cardsNotFound.join(", "));
                }
            
        });


    });
});

$(document).ready(function () {
    $("#StartButton").hover(function () {
        $(this).attr("src", "Images/HoverStartButton.jpg");
    }, function () {
        $(this).attr("src", "Images/StartButton.jpg");
    });

    // default options
    var deffunction = function () {
        $(".THSButton").addClass('ButtonClicked');
        $("#options1").val("THS");
        $("#options2").val("THS");
        $("#options3").val("THS");
        $("#options4").val("BNG");
        $("#options5").val("BNG");
        $("#options6").val("BNG");
    };

    $('.SetButton').on('click', function () {
        $(".SetButton").each(function () {
            $(this).removeClass('ButtonClicked');
        });
        $(this).addClass('ButtonClicked');
    });

    $.getJSON("http://xn--smst-loa.se/magiccarddb/sets.php", function (sets) {
        var setList = [];

        for (var i = 0; i < 6; i++) {
            var paragraph = $('<p class="info"></p>');
            var x = $('<label class="custom-select"></label>');
            var $select = $('<select class="boosterSelect" id=options' + (i + 1).toString() + '></select>');
            $.each(sets, function (index, set) {

                $select.append($("<option></option>").text(set.name).val(set.code));
            })

            $('.content_right div').append(paragraph.append(x.append($select)));
        }

        deffunction();
    });

    $('#startButton').click(function () {
        var boosterList = [];
        $('.content_right').find('.boosterSelect').each(function (index, booster) {
            boosterList.push($(booster).val());
        });
        window.open('magicSealedSite.html' + '?' + $.param({ sets: boosterList }));
    });

    $("#m14Button").click(function () {
        $(".boosterSelect").val("M14");
    });

    $("#therosButton").click(function () {
        $("#options1").val("THS");
        $("#options2").val("THS");
        $("#options3").val("THS");
        $("#options4").val("BNG");
        $("#options5").val("BNG");
        $("#options6").val("BNG");
    });

    $("#ravnicaButton").click(function () {
        $("#options1").val("RTR");
        $("#options2").val("RTR");
        $("#options3").val("GTC");
        $("#options4").val("GTC");
        $("#options5").val("DGM");
        $("#options6").val("DGM");
    });



});