<?php
header('Access-Control-Allow-Origin: *');
include_once 'mysql_functions.php';
include_once 'util.php';

class FullCard { 
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
	public $generated_mana = "null_filter";
};

class SmallCard { 
	public $color = "color_filter";
	public $manacost = "bracket_filter";
	public $image = false;
	public $type = true;
	public $rarity = true;
	public $name = true;
	public $id = true;
	public $set = true;
	public $converted_manacost = true;
	public $power = true;
	public $toughness = true;
};

class SmallSelectableCard { 
	public $color = "color_filter";
	public $manacost = "bracket_filter";
	public $image = false;
	public $type = true;
	public $rarity = true;
	public $name = true;
	public $id = true;
	public $set = true;
	public $converted_manacost = true;
	public $power = true;
	public $toughness = true;
	public $selected = false;
};

class MinimalCard { 
	public $image = false;
	public $name = true;
	public $id = true;
	public $set = true;
};

$cardCache = array();

if(isset($_GET['all_cards']) || isset($_GET['get_all_cards'])){
	echo(json_encode(getAllCards(CARD_INFO_SIZE::MINIMAL_CARD)));
}

if(isset($_GET['cards'])){
	echo(json_encode(getCardByIdArray($_GET['cards'], CARD_INFO_SIZE::SMALL_CARD)));
}

function getCardsFromSet($set, $size){
	if(isset($cardCache[$set])){
		return $cardCache[$set];
	} else {
		$rawCards = getCardsFromDatabase($set, $size);
		$cards = mapCardArrayClass($rawCards, $size);
		if(!hasLandCards($cards)){
			$rawLandCards = getLandCards(getMasterSet($set));
			$landCards = mapCardArrayClass($rawLandCards, $size);
			$cards = merge($cards, $landCards);
		}
		$cardCache[$set] = $cards;
		return $cards;
	}
}

function getAllCards($size){
	$rawCards = getAllCardsFromDatabase($size);
	$cards = mapCardArrayClass($rawCards, $size);
	return $cards;
}

function getCardById($id, $size){
	if(isset($cardCache[$id])){
		return $cardCache[$id];
	} else {
		$rawCard = getCardFromDatabase($id, $size);
		$card = mapCardClass($rawCard, $size);
		$cardCache[$id] = $card;
		return $card;
	}
}

function getCardByIdArray($idArray, $size){
	$cards = array();
	foreach($idArray as $id){
		$card = getCardById($id, $size);
		$cards[] = $card;
	}
	return $cards;
}


function hasLandCards($cards){
	$landFound = false;
	foreach($cards as $card){
		if($card->rarity == "Basic Land"){
			$landFound = true;
			break;
		}
	}
	return $landFound;
}

/* special card type filters */
function colorFilter($colorString){
	$length = strlen(utf8_decode($colorString));
	if($length > 1){
		if($colorString[0] != "A"){
			return "M";
		} else {
			return colorFilter(substr($colorString, 1));
		}
	} else {
		return $colorString;
	}
}

function bracketFilter($string){
	return str_replace("}", "", str_replace("{", "", $string));
}

function null_filter($string){
	if(is_null($string)) return ""; else return $string;
}


/* Mapping cards, so that the raw data from the database can be cleaned up a bit */
function mapCardClass($rawCard, $type){
	$IMAGE_DIR = 'http://xn--smst-loa.se/magiccarddb/cardimages';
	$DIVIDER = '/';
	$IMAGE_END = '.full.jpg';

	if($type == CARD_INFO_SIZE::FULL_CARD){
		$card = new FullCard();
	} elseif($type == CARD_INFO_SIZE::SMALL_CARD) {
		$card = new SmallCard();
	} elseif($type == CARD_INFO_SIZE::SMALL_SELECTABLE_CARD){
		$card = new SmallSelectableCard();
	} elseif($type == CARD_INFO_SIZE::MINIMAL_CARD) {
		$card = new MinimalCard();
	}
	foreach($card as $k => &$v){
		if($v === "color_filter"){
			$v = colorFilter($rawCard[$k]);
		} elseif($v === "bracket_filter"){
			$v = bracketFilter($rawCard[$k]);
		} elseif($v === "null_filter"){
			$v = null_filter($rawCard[$k]);
		} elseif($card->$k){
			$v = $rawCard[$k];
		}
	}
	$extraEnding = "";
	if(isset($card->type)){
		if(strpos($card->type, 'Basic Land') !== false){
			$extraEnding = rand(1, 4); //basic land cards have 4 variations.
			$card->rarity = "Basic Land";
		}
	}
	if(isset($card->image)){
		$card->image = $IMAGE_DIR . $DIVIDER . $card->set . $DIVIDER . $card->name . $extraEnding . $IMAGE_END;
	}
	return $card;
}


function mapCardArrayClass($rawCards, $type){
	$cards = array();
	foreach($rawCards as $rawCard){
		$card = mapCardClass($rawCard, $type);
		$cards[] = $card;
	}
	return $cards;
}
?>