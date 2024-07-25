<?php
require_once 'common.inc.php';

// Check if account is logged in
if ($account['loggedin']) {
    if (isset($gp_username)) {
        if (@$gp_redirectdone != 'http://redmoonfantasy.ddns.net:3400/redmoon/unsticker.php') {
            header("Location: http://redmoonfantasy.ddns.net:3400/redmoon/unsticker.php$gp_redirectdone");
            exit;
        } else {
            html_header('Login', '#0c0c0c', '#e74c3c'); // Apply header theme
            ?>
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <title>Login</title>
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
                        background-color: #1c1c1c;
                        padding: 20px;
                        border-radius: 10px;
                        box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
                        text-align: center;
                        width: 80%;
                        max-width: 400px;
                        margin: auto;
                    }
                    .logout-link {
                        color: #e74c3c;
                        text-decoration: none;
                        font-weight: bold;
                    }
                    .logout-link:hover {
                        text-decoration: underline;
                    }
                </style>
            </head>
            <body>
                <div class="content-box">
                    <p>You have now logged in.</p>
                    <br><a href='REBIRTHlogout.php' class='logout-link'>Go Back</a>
                </div>
            </body>
            </html>
            <?php
        }
    } else {
        html_header('Login', '#0c0c0c', '#e74c3c'); // Apply header theme
        ?>
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <title>Login</title>
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
                    background-color: #1c1c1c;
                    padding: 20px;
                    border-radius: 10px;
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
                    text-align: center;
                    width: 80%;
                    max-width: 400px;
                    margin: auto;
                }
                .logout-link {
                    color: #e74c3c;
                    text-decoration: none;
                    font-weight: bold;
                }
                .logout-link:hover {
                    text-decoration: underline;
                }
            </style>
        </head>
        <body>
            <div class="content-box">
                <p>You are already logged in.</p>
                <br><a href='https://www.redmoon-fantasy.com/'></a>
                <br><a href='unsticker.php' class='logout-link'>Click here to logout</a>
            </div>
        </body>
        </html>
        <?php
    }
} else {
    html_header('Login', '#0c0c0c', '#e74c3c'); // Apply header theme

    if (isset($gp_username)) {
        ?>
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <title>Login</title>
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
                    background-color: #1c1c1c;
                    padding: 20px;
                    border-radius: 10px;
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
                    text-align: center;
                    width: 80%;
                    max-width: 400px;
                    margin: auto;
                }
                .logout-link {
                    color: #e74c3c;
                    text-decoration: none;
                    font-weight: bold;
                }
                .logout-link:hover {
                    text-decoration: underline;
                }
            </style>
        </head>
        <body>
            <div class="content-box">
                <p>Invalid username/password.</p>
                <br><a href='javascript:history.go(-1)'>Click Here To Try Again</a>
            </div>
        </body>
        </html>
        <?php
    } else {
        login_form(); // Display login form
    }
}

html_footer(); // Ensure this is correctly implemented

function login_form() {
    global $gp_username, $gp_redirectdone;
    ?>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <title>Redmoon Login</title>
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
            input[type="text"], input[type="password"], input[type="submit"] {
                width: 100%;
                padding: 8px;
                margin-bottom: 10px;
                border-radius: 5px;
                border: none;
            }
            input[type="submit"] {
                background-color: #e74c3c;
                color: #ffffff;
                cursor: pointer;
                transition: background-color 0.3s;
            }
            input[type="submit"]:hover {
                background-color: #c0392b;
            }
            .home-button {
                padding: 10px 20px;
                font-size: 16px;
                background-color: #e74c3c;
                color: #ffffff;
                border: none;
                cursor: pointer;
                transition: background-color 0.3s;
                margin-top: 20px;
                text-decoration: none;
                display: inline-block;
            }
            .home-button:hover {
                background-color: #c0392b;
            }
            .home-button-container {
                position: absolute;
                top: 20px;
                left: 50%;
                transform: translateX(-50%);
            }
        </style>
    </head>
    <body>
        <div class="home-button-container">
            <a href="https://redmoon-fantasy.com" class="home-button">HOME</a>
        </div>
        <div class="form-container">
            <form method="post">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" maxlength="10" value="<?= htmlspecialchars(@$gp_username) ?>"><br>
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" maxlength="10"><br><br>
                <input type="submit" value="Login">
                <input type="hidden" name="redirectdone" value="<?= htmlspecialchars(@$gp_redirectdone) ?>">
            </form>
        </div>
    </body>
    </html>
    <?php
}
?>
