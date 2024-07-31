<?php

require 'common.inc.php';

html_header('Character Rebirth', '#00bfa5', '#ffffff'); // Turquoise background, white text

if (isset($_POST['name'])) {
    $name = $_POST['name'];
    $db->query('UPDATE tblGameID1 SET 
        Lvl = 1, 
        STotalBonus = STotalBonus + 2000,
        SBonus = SBonus + 2000,
        Bonus = 2, 
        Bonus2 = 0, 
        Strength = 10,
        Spirit = 10,
        Dexterity = 10,
        Power = 10,
        HP = 50,
        MP = 50,
        SP = 0,
        DP = 0,
        Money = 0,
        BankMoney = 0,
        SETimer = 0,
        PKTimer = 0,
        Map = 22,
        X = 9,
        Y = 15
        WHERE GameID = ?', array($name));

    echo "<p>$name has now been reborn and moved to the starting location.</p><hr>";
}

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Redmoon - Rebirth Character</title>
    <style>
        body {
            background-color: #ffffff;
            color: #00bfa5;
            font-family: Arial, sans-serif;
            text-align: center;
        }

        .form-container {
            background-color: #f0f0f0;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
            display: inline-block;
            text-align: left;
            margin-top: 20px;
        }

        .form-container select,
        .form-container input[type="submit"] {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            margin-bottom: 10px;
            border: 1px solid #00bfa5;
            background-color: #ffffff;
            color: #00bfa5;
            box-sizing: border-box;
            border-radius: 5px;
        }

        .form-container input[type="submit"] {
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .form-container input[type="submit"]:hover {
            background-color: #008f7a;
        }

        .home-button-container {
            margin-top: 20px;
        }

        .home-button-container input[type="button"] {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #00bfa5;
            color: #ffffff;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .home-button-container input[type="button"]:hover {
            background-color: #008f7a;
        }
    </style>
</head>
<body>
    <div class="home-button-container">
        <input type="button" value="LOGOUT" onclick="window.location.href='/redmoon/REBIRTHlogout.php'" />
    </div>

    <div class="form-container">
        <form method="post">
            <strong>Rebirth Your Character</strong><br><br>
<?php
if (isset($account) && isset($account['loggedin']) && $account['loggedin']) {
    echo '<form method="post">';
    echo '<select name="name">';
    foreach ($account['chars'] as $char) {
        if ($char['Lvl'] >= 1000) {
            echo "<option value='{$char['GameID']}'>{$char['GameID']}</option>";
        }
    }
    echo '</select>';
    echo '<input type="submit" value="Rebirth Now">';
    echo '</form>';
} else {
    echo "<p>(log in to get a select box)</p>";
}
?>

        </form>
    </div>
</body>
</html>


