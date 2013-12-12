<?php
	header('Access-Control-Allow-Origin: *');
	require "mysql_settings.php";
	$stm = $pdo->prepare("SELECT * FROM sets ORDER BY STR_TO_DATE(`date`, '%m/%Y') DESC");
	$stm->execute();
	$data = $stm->fetchAll();
	echo(json_encode($data));
?>