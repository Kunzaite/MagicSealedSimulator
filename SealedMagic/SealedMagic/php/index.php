<?php
header('Access-Control-Allow-Origin: *');



class Card {
	public $name = "";
	public $color = "";
	public $manaCost = "";
	public $typeAndClass = "";
	public $powAndTou = "";
	public $cardText = "";
	public $flavorText = "";
	public $artist = "";
	public $rarity = "";
	public $cardNr = "";
	public $foiled = false;
};

$cards = generateCardsFromTextFile();
$commonCards = array();
$uncommonCards = array();
$rareCards = array();
$mythicCards = array();
$landCards = array();

foreach($cards as $card){
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
$boosters;
if(!isset($_GET['boosters'])){
	$boosters = generateBooster($commonCards, $uncommonCards, $rareCards, $mythicCards, $landCards);
} else {
	$numberOfBoosters = $_GET['boosters'];
	$boosters = array();
	for($i = 0; $i < $numberOfBoosters; $i++){
		$boosters[] = generateBooster($commonCards, $uncommonCards, $rareCards, $mythicCards, $landCards);
	}
}

if(!isset($_GET['data'])){
	echo(json_encode($boosters));
} else {
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
	$stat = new Statistics();
	if(!isset($_GET['boosters'])){
		foreach($boosters as $card){
			addStat($card, $stat);
		}
	} else {
		foreach($boosters as $booster){
			foreach($booster as $card){
				addStat($card, $stat);
			}
		}
	}
	echo(json_encode(array("data" => $stat, "boosters" => $boosters)));
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

function merge($res, $in){
	if($in == null){
		return $res;
	} else {
		return array_merge($res, $in);
	}
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
	    if(!$card || !is_object($card)){
	    	var_dump($r);
	    	var_dump($selectedBlock);
	    	var_dump($common);
	    	var_dump($uncommon);
	    	var_dump($mythic);
	    	var_dump($card);
	    	die();
	    }
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


function generateCardsFromTextFile(){
	$stringParserIdentifier = array(
		"Card Name:" => "name",
		"Card Color:" => "color",
		"Mana Cost:" => "manaCost",
		"Type & Class:" => "typeAndClass",
		"Pow/Tou:" => "powAndTou",
		"Card Text:" => "cardText",
		"Flavor Text:"=> "flavorText" ,
		"Artist:" =>"artist" ,
		"Rarity:" => "rarity",
		"Card #:"=> "cardNr" 
	);

	$currentType = "";
	$cards = array();

	$handle = fopen("test.txt", 'r');
	if ($handle) {
		$card;
	    while (($line = fgets($handle)) !== false) {
	    	$split = explode(":", $line, 2);
	    	if(array_key_exists($split[0] . ":", $stringParserIdentifier)){
	    		$currentType = $split[0] . ":";
		    	if($currentType == "Card Name:"){
		    		if($card != null){
		    			$cards[] = $card;
		    		}
		    		$card = new Card();
		    	}
	    	}
	    	$ident = $stringParserIdentifier[$currentType];
	    	if(count($split) > 1){
	    		$card->$ident = trim($split[1]);
	    	}
	    }
	    //push the last card
	    $cards[] = $card;
	    return $cards;
	} else {
	    die("Can't read file");
	}
	return null;
}

function array_copy($arr) {
    $newArray = array();
    foreach($arr as $key => $value) {
        if(is_array($value)) $newArray[$key] = array_copy($value);
        elseif(is_object($value)) $newArray[$key] = clone $value;
        else $newArray[$key] = $value;
    }
    return $newArray;
}

?>
