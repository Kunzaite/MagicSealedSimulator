

// Randomize x cards raritywise
function randomizeCardNumbers(randomSize, quantity)
{
    var generatedCardNumbers = [];

    for (var i = 0; i < randomSize; i++)
    {
        var cardNumber = Math.floor((Math.random() * randomSize) + 1);

        if ($.inArray(cardNumber, generatedCardNumbers))
        {
            cardNumber = Math.floor((Math.random() * randomSize) + 1);
        }

        else
        {

        }

        generatedCardNumbers.push(cardNumber);
    }

    return generatedCardNumbers;
}

function checkMythic()
{
    var isItMythic = false;
    var r = Math.floor((Math.random() * 8) + 1);

    // 8 gives mythic
    if (r == 8)
    {
        isItMythic = true;
    }

    return isItMythic;
}

function checkFoil()
{
    var isItFoil = false;
    // 15/63 gives foil
    var r = Math.floor((Math.random() * 63) + 1);
    if (r >= 1 && r <= 15)
    {
        isItFoil = true;
    }
    return isItFoil;
}

function getFoil(foilcard)
{
    // 15/63 gives foil
    /* 
    11/16 -> common
    3/16 -> uncommon
    1/16 -> 7/8 -> R AND 1/8 -> M
    1/16 -> L
    */

    var r = Math.floor((Math.random() * 16) + 1);

    // C
    if (r >= 1 && r <= 11)
    {
        // Get common
        //foilcard = cardCommonList[randomizeRarity(cardCommonList.Count)];
    }

    // Unc
    else if (r >= 12 && r <= 14)
    {
        // Get uncommon
        //foilcard = cardUncommonList[randomizeRarity(cardUncommonList.Count)];
    }

    // R
    else if (r == 15)
    {
        // M
        if (checkMythic() == true)
        {
            // Get mythic
            //foilcard = cardMythicList[randomizeRarity(cardMythicList.Count)];
        }

        else
        {
            // Get rare
            //foilcard = cardRareList[randomizeRarity(cardRareList.Count)];
        }

    }

    // L
    else
    {
        // get land
        //foilcard = cardBasicLandList[randomizeRarity(cardBasicLandList.Count)];
    }

    //return foilcard;
}

function createAndAddCardToStack(name, color, type, cmc, rarity)
{
    // create image
    var n = name.Replace(" ", "").Replace("'", "").Replace(",", "").Replace("-", "").Replace("(", "").Replace(")", "");

    var image = $("<img src='" + "~/TherosPictures/" + n + ".jpg" + " width=150></img>");

    var listItem = $("<li></li>");
    listItem.attr("file", "/TherosPictures/" + n + ".jpg");
    listItem.attr("name", name);
    listItem.attr("color", color);
    listItem.attr("type", type);
    listItem.attr("cmc", cmc);
    listItem.attr("rarity", rarity);
    listItem.attr("onmouseover", "javascript:return preview(this);");

    listItem.append(image);
     
    if (color == "White")
    {
        $("#deckPile1").append(listItem);
    }

    else if (color == "Blue")
    {
        $("#deckPile2").append(listItem);
    }

    else if (color == "Black")
    {
        $("#deckPile3").append(listItem);
    }

    else if (color == "Red")
    {
        poolPile4.Controls.Add(li);
    }

    else if (color == "Green")
    {
        poolPile5.Controls.Add(li);
    }

    else if (color == "MultiColor")
    {
        poolPile6.Controls.Add(li);
    }

    else
    {
        poolPile7.Controls.Add(li);
    }
}