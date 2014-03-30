<?php
$mysql_username = 'flamingf';
$mysql_password = '7ud92zF3h';
$mysql_host   	= 'localhost';
$mysql_database = 'flamingf_magic';

$dsn = "mysql:host=$mysql_host;dbname=$mysql_database;charset=utf8";
$opt = array(
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
);
$pdo = new PDO($dsn, $mysql_username, $mysql_password, $opt);

?>
