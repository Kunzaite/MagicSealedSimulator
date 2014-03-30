<?php
require "mysql_settings.php";

abstract class CARD_INFO_SIZE
{
    const MINIMAL_CARD = 0;
    const SMALL_CARD = 1;
    const SMALL_SELECTABLE_CARD = 2;
    const FULL_CARD = 3;
}

function getCardsFromDatabase($set, $size) {
    global $pdo;
    if($size == CARD_INFO_SIZE::MINIMAL_CARD){
        $stm = $pdo->prepare("SELECT id, name, `set` FROM cards WHERE `set` = ?");
    } elseif($size == CARD_INFO_SIZE::SMALL_CARD || $size == CARD_INFO_SIZE::SMALL_SELECTABLE_CARD) {
        $stm = $pdo->prepare("SELECT id, name, `set`, color, manacost, type, rarity, name, id, converted_manacost, power, toughness FROM cards WHERE `set` = ?");
    } else {
        $stm = $pdo->prepare("SELECT * FROM cards WHERE `set` = ?");
    }
    
    $stm->execute(array($set));
    $data = $stm->fetchAll();
    return $data;
}

function getAllCardsFromDatabase($size) {
    global $pdo;
    if($size == CARD_INFO_SIZE::MINIMAL_CARD){
        $stm = $pdo->prepare("SELECT id, name, `set` FROM cards");
    } elseif($size == CARD_INFO_SIZE::SMALL_CARD || $size == CARD_INFO_SIZE::SMALL_SELECTABLE_CARD) {
        $stm = $pdo->prepare("SELECT id, name, `set`, color, manacost, type, rarity, name, id, converted_manacost, power, toughness FROM cards");
    } else {
        $stm = $pdo->prepare("SELECT * FROM cards");
    }
    
    $stm->execute();
    $data = $stm->fetchAll();
    return $data;
}

function getLatestSet() {
    global $pdo;
    $stm = $pdo->prepare("SELECT code FROM sets ORDER BY STR_TO_DATE(`date`, '%m/%Y') DESC LIMIT 1");
    $stm->execute();
    $data = $stm->fetchAll();
    return $data[0]["code"];
}

function getMasterSet($set) {
    global $pdo;
    $stm = $pdo->prepare("SELECT  `set` FROM  `cards` JOIN (SELECT DATE FROM  `sets` WHERE `code` =  ? ) AS compare LEFT JOIN  `sets` ON  `sets`.code =  `cards`.set WHERE STR_TO_DATE( compare.date,  '%m/%Y' ) > STR_TO_DATE(  `sets`.date,  '%m/%Y' ) ORDER BY STR_TO_DATE(  `sets`.date,  '%m/%Y' ) DESC LIMIT 1");
    $stm->execute(array($set));
    $data = $stm->fetchAll();
    return $data[0]["set"];
}

function getLandCards($set) {
    global $pdo;
    $SQL = "SELECT * FROM  `cards` WHERE `set` = ? AND `type` LIKE '%basic land%'";
    $stm = $pdo->prepare($SQL);
    $stm->execute(array($set));
    $data = $stm->fetchAll();
    return $data;
}

function getSavedPool($id) {
    global $pdo;
    $SQL = "SELECT pool FROM `saved_pools` WHERE `id` = ?";
    $stm = $pdo->prepare($SQL);
    $stm->execute(array($id));
    $data = $stm->fetchAll();
    return json_decode($data[0]["pool"]);
}

function getSavedDeck($id, $poolid) {
    global $pdo;
    $SQL = "SELECT cards FROM  `saved_decks` WHERE `id` = ? AND `poolid` = ?";
    $stm = $pdo->prepare($SQL);
    $stm->execute(array($id, $poolid));
    $data = $stm->fetchAll();
    return json_decode($data[0]["cards"]);
}


function setSavedPool($pool) {
    global $pdo;
    $SQL = "INSERT INTO `saved_pools` (pool) VALUES (?)";
    $stm = $pdo->prepare($SQL);
    $stm->execute(array(json_encode($pool)));
    return $pdo->lastInsertId();
}


function setSavedDeck($deck, $poolid) {
    global $pdo;
    $SQL = "INSERT INTO `saved_decks` (cards, poolid) VALUES (?, ?)";
    $stm = $pdo->prepare($SQL);
    $stm->execute(array(json_encode($deck), $poolid));
    return $pdo->lastInsertId();
}

function getCardFromDatabase($id, $size) {
    global $pdo;
    if($size == CARD_INFO_SIZE::MINIMAL_CARD){
        $stm = $pdo->prepare("SELECT id, name, `set` FROM cards WHERE `id` = ?");
    } elseif($size == CARD_INFO_SIZE::SMALL_CARD || $size == CARD_INFO_SIZE::SMALL_SELECTABLE_CARD) {
        $stm = $pdo->prepare("SELECT id, name, `set`, color, manacost, type, rarity, name, id, converted_manacost, power, toughness FROM cards WHERE `id` = ?");
    } else {
        $stm = $pdo->prepare("SELECT * FROM cards WHERE `id` = ?");
    }
    
    $stm->execute(array($id));
    $data = $stm->fetchAll();
    return $data[0];
}
