<?php
header('Access-Control-Allow-Origin: *');

include_once 'mysql_functions.php';
include_once 'card_handler.php';
include_once 'util.php';

if (isset($_GET['poolid'])) {
    $pool = getSavedPool($_GET['poolid']);
    $cards = getCardByIdArray($pool, CARD_INFO_SIZE::SMALL_SELECTABLE_CARD);
    if (isset($_GET['deckid'])) {
        $deck = getSavedDeck($_GET['deckid'], $_GET['poolid']);
        foreach($deck as $deckId) {
            foreach($cards as $card) {
                if ($card->id == $deckId) {
                    $card->selected = true;
                }
            }
        }
    }
    echo(json_encode($cards));
} else {
    if (isset($_GET['pool'])) {
        if (isset($_GET['deck'])) {
            $poolId = setSavedPool(array_merge($_GET['pool'], $_GET['deck']));
            $deckId = setSavedDeck($_GET['deck'], $_GET['pool']);
            echo("{ \"poolId\": " . $poolId .", \"deckId\": " . $deckId . " }");
        } else {
            $poolId = setSavedPool($_GET['pool']);
            echo("{\"poolId\": " . $poolId ."}");
        }
    } else {
        throw new Exception("Could not save or fetch pool");
    }
}