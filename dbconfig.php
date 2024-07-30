<?php


$hostname = "";
$dbuser = "";
$dbpassword = "";
$dbname = "";

try {
    $dsn = "odbc:Driver={SQL Server};Server=$hostname;Database=$dbname;";
    $pdo = new PDO($dsn, $dbuser, $dbpassword);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Unable to connect to the database: " . $e->getMessage());
}
