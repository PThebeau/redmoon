<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Redmoon - Players Online</title>
    <style>
        body {
            background-color: #ffffff; /* White background */
            color: #00bfa5; /* Turquoise text color */
            font-family: Arial, sans-serif;
            text-align: center;
        }

        .online-section {
            background-color: #f0f0f0; /* Light grey background for the section */
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
            width: 50%; /* Narrower width */
            max-width: 400px; /* Maximum width for consistency */
            margin: 40px auto; /* Center the section */
            text-align: left;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 10px;
            text-align: center; /* Center text and images */
            border: 1px solid #00bfa5; /* Turquoise border color */
        }

        th {
            background-color: #00bfa5; /* Turquoise header background */
            color: #ffffff; /* White text */
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
    </style>
</head>

<body>
    <div class="home-button-container">
        <input type="button" value="HOME" onclick="window.location.href='https://redmoon-fantasy.com'" />
    </div>

    <div class="online-section">
        <h2>Players Currently Online</h2>
        <table>
            <tr>
                <th>Online</th>
                <th>Account Type</th>
            </tr>
            <?php
            include("config.php");
            try {
                $query = "SELECT o.GameID, b.is_hardcore 
                          FROM tblOccupiedBillID o 
                          JOIN tblBillID b ON o.BillID = b.BillID 
                          WHERE o.GameID NOT LIKE 'GM%'";
                $stmt = odbc_exec($conn, $query);

                while ($row = odbc_fetch_array($stmt)) {
                    echo '<tr>';
                    echo '<td>' . htmlspecialchars($row['GameID']) . '</td>';
                    echo '<td>';
                    if ($row['is_hardcore']) {
                        echo '<img src="http://redmoonfantasy.ddns.net:3400/redmoon/face/skull.png" style="width: 50px; height: 40px;">';
                    } else {
                        echo '<img src="http://redmoonfantasy.ddns.net:3400/redmoon/face/GreySkull.png" style="width: 50px; height: 40px;">';
                    }
                    echo '</td>';
                    echo '</tr>';
                }
                odbc_close($conn);
            } catch (Exception $e) {
                echo "Connection failed: " . $e->getMessage();
            }
            ?>
        </table>
        <p>
            <img src="http://redmoonfantasy.ddns.net:3400/redmoon/face/GreySkull.png" style="width: 30px; height: 30px;"> = Normal Account<br>
            <img src="http://redmoonfantasy.ddns.net:3400/redmoon/face/skull.png" style="width: 30px; height: 25px;"> = Hardcore Account
        </p>
    </div>

    <script>
        // Reload the page every 10 seconds
        setInterval(function() {
            location.reload();
        }, 10000);
    </script>
</body>
</html>
