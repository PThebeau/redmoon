<!DOCTYPE html>
<html lang="en">
<head>
    <title>Redmoon Login</title>
    <style>
        body {
            background-color: #000000;
            color: #e74c3c;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            font-family: 'Arial', sans-serif;
        }

        .form-container {
            text-align: center;
            background-color: #1c1c1c;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5);
            width: 300px;
        }

        form input[type="text"],
        form input[type="password"],
        input[type="button"],
        input[type="submit"] {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            box-sizing: border-box;
            border-radius: 5px;
            border: none;
        }

        input[type="button"], input[type="submit"] {
            font-size: 16px;
            background-color: #e74c3c;
            color: #ffffff;
            cursor: pointer;
            transition: background-color 0.3s;
            border-radius: 5px;
        }

        input[type="button"]:hover, input[type="submit"]:hover {
            background-color: #c0392b;
        }

        .centered {
            margin-top: 20px;
            font-size: 18px;
            max-width: 80%;
            margin: 20px 0;
        }
    </style>
</head>

<body>
    <form>
        <input type="button" value="HOME" onclick="window.location.href='https://redmoon-fantasy.com'" />
    </form>

    <div class="form-container">
        <form method="post" action="DELETEpage.php">
            <div>
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" maxlength="10" value="">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" maxlength="10">
            </div>
            <input type="submit" value="Login">
            <input type="hidden" name="redirectdone" value="">
        </form>
    </div>
</body>
</html>
