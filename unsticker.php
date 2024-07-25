<?php
require_once 'common.inc.php';

html_header('Troubleshoot', '#0c0c0c', '#e74c3c');
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Redmoon Troubleshoot</title>
    <style>
        body {
            background-color: #0c0c0c;
            color: #e74c3c;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            font-family: 'Arial', sans-serif;
        }
        .form-container {
            background-color: #1c1c1c;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
            text-align: center;
            width: 80%;
            max-width: 400px;
            margin: auto;
        }
        select, input[type="button"], input[type="submit"] {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #e74c3c;
            color: #ffffff;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
            margin-bottom: 10px;
            width: 100%;
            border-radius: 5px;
        }
        select:hover, input[type="button"]:hover, input[type="submit"]:hover {
            background-color: #c0392b;
        }
        .home-button-container {
            position: absolute;
            top: 20px;
            left: 50%;
            transform: translateX(-50%);
        }
        .home-button {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #e74c3c;
            color: #ffffff;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
            border-radius: 5px;
            text-decoration: none;
        }
        .home-button:hover {
            background-color: #c0392b;
        }
    </style>
</head>

<body>
    <div class="home-button-container">
        <a href="REBIRTHlogout.php" class="home-button">CLICK HERE TO LOGOUT</a>
    </div>

    <div class="form-container">
        <?php
        if (isset($gp_name) || isset($gp_name2)) {
            $name = !empty($gp_name2) ? $gp_name2 : $gp_name;
            $db->query('UPDATE tblGameID1 SET Map = 21 WHERE GameID = ?', array($name));
            echo "<p>$name has now been moved to Street 1.</p><hr>";
        }
        ?>

        <form method="post">
            <strong>Unstick Your Character</strong><br><br>
            <?php if ($account['loggedin']) { ?>
                <select name="name">
                    <?php
                    foreach ($account['chars'] as $char => $data) {
                        echo "<option value='$char'>$char</option>";
                    }
                    ?>
                </select>
                <input type="submit" value="UnstickMe!">
            <?php } else { ?>
                <p>(log in to get a select box)</p>
            <?php } ?>
        </form>
    </div>
</body>
</html>

<?php
html_footer();
?>
