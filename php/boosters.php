<?php
header('Access-Control-Allow-Origin: *');
include_once 'mysql_functions.php';
include_once 'util.php';

class Card { 
	// false means that the data is filled in by hand
	// filter string means that the data will come from db but be parsed before set.
	// true means that the data is set directly from the db.
	public $foiled = false; //will be set last in generate booster process
	public $color = "color_filter"; // Turns multicolor WG into M (legacy reasons)
	public $manacost = "bracket_filter"; //removes the brackets form the manacost (legacy reasons)
	public $image = false; // will be set as IMAGE_DIR + set + name
	public $type = true;
	public $rarity = true;
	public $name = true;
	public $id = true;
    public $set = true;
    public $converted_manacost = true;
    public $power = true;
    public $toughness = true;
    public $loyalty = true;
    public $ability = true;
    public $flavor = true;
    public $variation = true;
    public $artist = true;
    public $number = true;
    public $rating = true;
    public $ruling = true;
    public $generated_mana = true;
};

class Statistics {
	public $totalSumCards = 0;
	public $common = 0;
	public $uncommon = 0;
	public $rare = 0;
	public $mythic = 0;
	public $foiled = 0;
	public $land = 0;
	public $foiledMythic = 0;
}

$cardCache = array();

$sets;
if(isset($_GET["sets"])){
	$sets = array_count_values($_GET['sets']);
} else {
	$sets = array("THS" => 6);
}


$totalBoosters = array();
foreach($sets as $set => $count){
	$cards = getCardsFromSet($set);
	$boosters = generateBoosters($cards, $count);
	$stat = new Statistics();
	foreach($stat as $key => $value){
		$stat->$key += $boosters["data"]->$key;
	}
	$totalBoosters = array_merge($totalBoosters, $boosters["boosters"]);
}
if(isset($_GET['verbose'])){
	echo(json_encode(array("data" => $stat, "boosters" => $totalBoosters)));
} else {
	echo(json_encode($totalBoosters));
}

function getCardsFromSet($set){
	if(isset($cardCache[$set])){
		return $cardCache[$set];
	} else {
		$rawCards = getCardsFromDatabase($set);
		$cards = mapToOldApiSyntax($rawCards);
		$cardCache[$set] = $cards;
		return $cards;
	}
}

function colorFilter($colorString){
	$length = strlen(utf8_decode($colorString));
	if($length > 1){
		return "M";
	} else {
		return $colorString;
	}
}

function bracketFilter($string){
	return str_replace("}", "", str_replace("{", "", $string));
}

function mapToOldApiSyntax($rawCards){
	$IMAGE_DIR = 'http://flamingfox.se/magiccarddb/cardimages';
	$DIVIDER = '/';
	$IMAGE_END = '.full.jpg';

	$cards = array();
	foreach($rawCards as $rawCard){
		$cardBluePrint = new Card();
		$card = new Card();
		foreach($cardBluePrint as $k => $v){
			$var = $card->$k;
			if($var === "color_filter"){
				$card->$k = colorFilter($rawCard[$k]);
			} elseif($var === "bracket_filter"){
				$card->$k = bracketFilter($rawCard[$k]);
			} elseif($var){
				$card->$k = $rawCard[$k];
			}
		}

		$card->image = $IMAGE_DIR . $DIVIDER . $card->set . $DIVIDER . $card->name . $IMAGE_END;
		$cards[] = $card;
	}
	return $cards;
}

function generateBoosters($cards, $numberOfBoosters){

	$commonCards = array();
	$uncommonCards = array();
	$rareCards = array();
	$mythicCards = array();
	$landCards = array();

	foreach($cards as $card){
		if(strpos($card->type, 'Basic Land') !== false){
			$card->rarity = "Basic Land";
		}
		switch($card->rarity){
			case "C":
				$commonCards[] = $card;
				break;
			case "R":
				$rareCards[] = $card;
				break;
			case "U":
				$uncommonCards[] = $card;
				break;
			case "M":
				$mythicCards[] = $card;
				break;
			case "Basic Land":
				$landCards[] = $card;
				break;
		}
	}

	$boosters = array();
	for($i = 0; $i < $numberOfBoosters; $i++){
		$boosters[] = generateBooster($commonCards, $uncommonCards, $rareCards, $mythicCards, $landCards);
	}

	$stat = new Statistics();
	
	foreach($boosters as $booster){
		foreach($booster as $card){
			addStat($card, $stat);
		}
	}

	return array("data" => $stat, "boosters" => $boosters);
}


function addStat($card, $stat){
	$stat->totalSumCards++;
	if(!$card->foiled){
		switch($card->rarity){
			case "C":
				$stat->common++;
				break;
			case "R":
				$stat->rare++;
				break;
			case "U":
				$stat->uncommon++;
				break;
			case "M":
				$stat->mythic++;
				break;
			case "Basic Land":
				$stat->land++;
				break;
			default:
				echo $card->rarity;
				break;
		}
	} elseif($card->rarity == "M") {
		$stat->foiledMythic++;
	} else {
		$stat->foiled++;
	}
}

function generateBooster($common, $uncommon, $rare, $mythic, $land){
	//15 of 63 is foiled.

	$res = array();

	$hasFoiled = rand(1, 63) <= 15;
	$foiled = generateFoiledCard($common, $uncommon, $rare, $mythic, $land, $hasFoiled);
	$commonCards = generateCommonBlock($common, $hasFoiled);
	$uncommonCards = generateUncommonBlock($uncommon);
	$rareCards = generateRareBlock($rare, $mythic);
	$landCards = generateLandBlock($land);

	$res = merge($res, $foiled);
	$res = merge($res, $commonCards);
	$res = merge($res, $uncommonCards);
	$res = merge($res, $rareCards);
	$res = merge($res, $landCards);

	return $res;
}

function generateFoiledCard($common, $uncommon, $rare, $mythic, $land, $hasFoiled){
	$foiled = array();
	if($hasFoiled){
	    // 15/63 gives foil
	    /* 
	    11/16 -> common, 3/16 -> uncommon, 1/16 -> 7/8 -> R AND 1/8 -> M, 1/16 -> L
	    */
	   	$r = rand(1, 16);
	   	$selectedBlock;
	    if ($r <= 11){ 
	    	// Common
	        $selectedBlock = $common;
	    } else if ($r <= 14){ 
	    	// Uncommon
	        $selectedBlock = $uncommon;
	    } else if ($r == 15){ 
	    	// Rare or Mythic Rare
	        if (rand(1, 8) == 8){
	           	$selectedBlock = $mythic;
	        } else {
	            $selectedBlock = $rare;
	        }
	    } else { 
	    	// Land
	        $selectedBlock = $land;
	    }
	    $card = $selectedBlock[rand(0, count($selectedBlock) -1)];
    	$foiledCard = clone $card;
	    $foiledCard->foiled = true;

		$foiled[] = $foiledCard;
	}
	return $foiled;
}

function generateCommonBlock($common, $hasFoiled){
	$cards = array();
	$numberOfCards = $hasFoiled ? 9 : 10;
	return takeCards($numberOfCards, $common);
}

function generateUncommonBlock($uncommon){
	return takeCards(3, $uncommon);
}

function generateRareBlock($rares, $mythic){
    // Rare or Mythic Rare
    if (rand(1, 8) == 8){
       	return takeCards(1, $mythic);
    } else {
        return takeCards(1, $rares);
    }
}

function generateLandBlock($land){
	return takeCards(1, $land);
}

function takeCards($numberOfCards, $originalPile){
	$pile = array_copy($originalPile);
	$cards = array();
	for($i = 0; $i < $numberOfCards; $i++){
		$c = rand(0, count($pile) - 1);
		$card = $pile[$c];
		$cards[] = $card;
		unset($pile[$c]);
		$pile = array_values($pile);
	}
	return $cards;
}

?>
