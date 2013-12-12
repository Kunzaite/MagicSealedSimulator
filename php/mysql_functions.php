<?php
require "mysql_settings.php";

function getCardsFromDatabase($set){
	global $pdo;
	$stm = $pdo->prepare("SELECT * FROM cards WHERE `set` = ?");
	$stm->execute(array($set));
	$data = $stm->fetchAll();
	return $data;
}
?>