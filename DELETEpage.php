<?php
require 'common.inc.php';

html_header('Character Deletion', '#e74c3c', '#000000'); // Red background, black text

echo "<p style='color: #e74c3c;'></p><hr>";

if (isset($gp_name) || isset($gp_name2)) {
    $name = isset($gp_name2) && !empty($gp_name2) ? $gp_name2 : $gp_name;
    $db->query('DELETE FROM tblGameID1 WHERE GameID = ?', array($name));

    echo "<p style='color: #e74c3c;'>$name has been deleted</p><hr>";
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Character Deletion</title>
    <style>
        body {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            font-family: 'Arial', sans-serif;
            background-color: #0c0c0c; /* Dark background color */
            color: #ffffff; /* Light text color */
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
            background-color: #e74c3c; /* Redmoon Fantasy theme color for button background */
            color: #ffffff; /* White text color */
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
            text-decoration: none;
            display: inline-block;
        }

        .home-button:hover {
            background-color: #c0392b; /* Darker shade on hover */
        }

        .form-container {
            background-color: #1c1c1c; /* Gray background for content box */
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
            text-align: center;
            margin-top: 20px;
        }

        select, input[type="submit"] {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #e74c3c; /* Redmoon Fantasy theme color for button background */
            color: #ffffff; /* White text color */
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
            margin-bottom: 10px;
        }

        select:hover, input[type="submit"]:hover {
            background-color: #c0392b; /* Darker shade on hover */
        }

        .delete-button {
            margin-top: 20px; /* Space the delete button further down */
            font-weight: bold;
        }
    </style>
    <script>
        function confirmDeletion() {
            return confirm("Are you sure you want to delete this character? This action cannot be undone.");
        }
    </script>
</head>
<body>

<div class="home-button-container">
    <a href="https://redmoon-fantasy.com" class="home-button">HOME</a>
</div>

<div class="form-container">
    <form method="post" onsubmit="return confirmDeletion()">
        <strong>Delete Character</strong><br><br>
        <?php if ($account['loggedin']) { ?>
            <select name="name">
                <?php
                foreach ($account['chars'] as $char => $data) {
                    echo "<option value='$char'>$char</option>";
                }
                ?>
            </select>
        <?php } ?>
        <?php if (!$account['loggedin']) echo "<span style='color: #e74c3c;'> (log in to get a select box)</span>"; ?><br>
        <input type="submit" class="delete-button" value="> CLICK HERE TO DELETE <">
    </form>
</div>

</body>
</html>
