<?php
require "mysql_settings.php";
$stm = $pdo->prepare("SELECT * FROM sets");
$stm->execute();
$data = $stm->fetchAll();
echo(json_encode($data));
?>