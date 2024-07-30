<?php
session_start();
session_destroy();

require 'common.inc.php';

html_header('Logout');
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Redmoon Logout</title>
    <style>
        body {
            background-color: #f0f0f0;
            color: #e74c3c;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            font-family: 'Arial', sans-serif;
        }

        .content-box {
            text-align: center;
            background-color: #ffffff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5);
            width: 300px;
        }

        .content-box p,
        .content-box a {
            margin-bottom: 10px;
            color: #00bfa5;
            text-decoration: none;
        }

        .content-box a {
            color: #00bfa5;
            transition: color 0.3s;
        }

        .content-box a:hover {
            color: #008f7a;
        }
    </style>
</head>

<body>
    <div class="content-box">
        <p>You have been logged out.</p>
        <br>
        <a href='https://www.redmoon-fantasy.com/'>RETURN HOME</a>
    </div>
</body>
</html>

<?php
html_footer();
?>
