<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Create Account</title>
    <style>
        body {
            background-color: #ffffff; /* White background */
            color: #00bfa5; /* Turquoise font color */
            text-align: center;
            font-family: Arial, sans-serif;
        }

        .form-container {
            background-color: #f0f0f0; /* Light grey background for form */
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
            display: inline-block;
            text-align: left;
            margin-top: 20px;
        }

        .form-container label {
            display: block;
            margin: 10px 0 5px;
        }

        .form-container input[type="text"],
        .form-container input[type="password"],
        .form-container input[type="submit"],
        .form-container input[type="checkbox"] {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            margin-bottom: 10px;
            border: 1px solid #00bfa5; /* Turquoise border color */
            background-color: #ffffff; /* White background for inputs */
            color: #00bfa5; /* Turquoise text color */
            box-sizing: border-box;
        }

        .form-container input[type="submit"] {
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .form-container input[type="submit"]:hover {
            background-color: #008f7a; /* Darker turquoise on hover */
        }

        .form-container .checkbox-container {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 10px;
        }

        .form-container .checkbox-container input {
            width: auto;
            margin-right: 10px;
        }

        .disclaimer {
            margin-top: 20px;
            color: #00bfa5; /* Turquoise text color */
            font-size: 14px;
            text-align: left; /* Ensure text alignment is consistent */
            white-space: pre-wrap; /* Preserve line breaks */
        }

        .home-button-container {
            margin-top: 20px;
        }

        .home-button-container input[type="button"] {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #00bfa5; /* Turquoise button background */
            color: #ffffff; /* White text color */
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .home-button-container input[type="button"]:hover {
            background-color: #008f7a; /* Darker turquoise on hover */
        }

        .message {
            color: #00bfa5; /* Turquoise text color */
            font-size: 18px;
            margin-bottom: 20px;
        }
    </style>
</head>

<body>
    <div class="home-button-container">
        <form>
            <input type="button" value="HOME" onclick="window.location.href='http://www.redmoon-fantasy.com'" />
        </form>
    </div>

    <?php
    include("config.php");

    $message = "";

    if (isset($_POST['CreateAccount'])) {
        if (!empty($_POST['loginID']) && !empty($_POST['Password']) && !empty($_POST['Password2']) && !empty($_POST['question']) && !empty($_POST['answer'])) {
            $loginID = $_POST['loginID'];
            $password = $_POST['Password'];
            $password2 = $_POST['Password2'];
            $question = $_POST['question'];
            $answer = $_POST['answer'];
            $is_hardcore = isset($_POST['is_hardcore']) ? 1 : 0;

            if ($password === $password2) {
                $query = "SELECT BillID FROM tblBillID WHERE BillID = ?";
                $stmt = odbc_prepare($conn, $query);
                odbc_execute($stmt, array($loginID));
                $result = odbc_fetch_array($stmt);

                if ($result) {
                    $message = "<b>Account name in use.</b>";
                } else {
                    $accquery = "INSERT INTO tblBillID (BillID, Password, FreeDate, SecurityNum1, SecurityNum2, Note1, Note2, is_hardcore) VALUES (?, ?, '1.1.2010', '5846', '101', ?, ?, ?)";
                    $accstmt = odbc_prepare($conn, $accquery);
                    $accparams = array($loginID, $password, $question, $answer, $is_hardcore);

                    if (odbc_execute($accstmt, $accparams)) {
                        $message = "<b>Account created successfully.</b>";
                    } else {
                        $message = "<b>Error creating account.</b>";
                    }
                }
            } else {
                $message = "<b>Passwords do not match.</b>";
            }
        } else {
            $message = "<b>Please fill in all fields.</b>";
        }
    }
    ?>

    <?php if (!empty($message)) : ?>
        <div class="message"><?php echo $message; ?></div>
    <?php endif; ?>

    <h1>Create Account</h1>
    <div class="form-container">
        <form method="POST" action="">
            <label for="loginID">Login ID:</label>
            <input type="text" id="loginID" name="loginID" required maxlength="16">

            <label for="Password">Password:</label>
            <input type="password" id="Password" name="Password" required maxlength="16">

            <label for="Password2">Confirm Password:</label>
            <input type="password" id="Password2" name="Password2" required maxlength="16">

            <label for="question">Secret Question:</label>
            <input type="text" id="question" name="question" required maxlength="16">

            <label for="answer">Secret Answer:</label>
            <input type="text" id="answer" name="answer" required maxlength="16">

            <div class="checkbox-container">
                <input type="checkbox" id="is_hardcore" name="is_hardcore">
                <label for="is_hardcore">Hardcore Mode</label>
            </div>

            <div class="disclaimer">
                <p>
                    By creating a hardcore account, you acknowledge that<br>
                    any character within the account who dies in-game<br>
                    will be immediately deleted. Disconnection excuses<br>
                    will not be accepted unless it is verified that my ISP<br>
                    was down at the time. I will conduct an investigation,<br>
                    but this does not guarantee the restoration of the<br>
                    hardcore character. If you have donated, you will not<br>
                    lose items. Simply create a new character with the<br>
                    same name on the same account to automatically<br>
                    receive the items.
                </p>
            </div>

            <input type="submit" name="CreateAccount" value="Create Account">
        </form>
    </div>
</body>

</html>
