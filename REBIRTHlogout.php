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
            background-color: #0c0c0c;
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
            background-color: #1c1c1c;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5);
            width: 300px;
        }

        .content-box p,
        .content-box a {
            margin-bottom: 10px;
            color: #ffffff;
            text-decoration: none;
        }

        .content-box a {
            color: #e74c3c;
            transition: color 0.3s;
        }

        .content-box a:hover {
            color: #c0392b;
        }
    </style>
</head>

<body>
    <div class="content-box">
        <p>You have been logged out.</p>
        <br>
        <a href='javascript:history.go(-1)'></a>
        <br><br>
        <a href='https://www.redmoon-fantasy.com/'>RETURN HOME</a>
    </div>
</body>
</html>

<?php
html_footer();
?>
