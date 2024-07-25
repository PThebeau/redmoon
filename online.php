<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Redmoon</title>
    <style>
        body {
            height: 100%;
            width: 100%;
            margin: 0;
            font-family: 'Arial', sans-serif;
            background-color: #0c0c0c; /* Dark background color */
            color: #ffffff; /* Light text color */
        }

        center {
            margin-top: 20px;
        }

        form {
            margin-top: 20px;
        }

        input[type="button"] {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #e74c3c; /* Redmoon Fantasy theme color for button background */
            color: #ffffff; /* White text color */
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        input[type="button"]:hover {
            background-color: #c0392b; /* Darker shade on hover */
        }

        p {
            font-size: 18px;
            margin-top: 20px;
        }

        .character-section, .online-section {
            margin: 20px auto;
            width: 50%;
            background-color: #1c1c1c; /* Darker background for sections */
            padding: 20px;
            border-radius: 10px;
        }

        table {
            width: 50%;
            border-collapse: collapse;
            margin-top: 30px;
        }

        th, td {
            padding: 15px;
            text-align: center;
            border: 2px solid #e74c3c; /* Redmoon Fantasy theme color for the border */
        }

        th {
            background-color: #e74c3c; /* Redmoon Fantasy theme color for the header background */
            color: #ffffff;
        }
    </style>
</head>

<body>

    <center>
        <form>
            <input type="button" value="Home" onclick="window.location.href='https://redmoon-fantasy.com'" />
        </form>
        <form>
            <input type="button" value="Helpful Tools" onclick="window.location.href='http://redmoonfantasy.ddns.net:3400/redmoon/HelpfulLinks2.php'" />
        </form>
    </center>

    <div class="online-section">
        <center>
            <h2>Players Currently Online</h2>
            <table>
                <tr>
                    <th>Online</th>
                    <th>Account Type</th>
                </tr>
                <?php
                include("mssqlconfig.php");
                $query = "SELECT o.GameID, b.is_hardcore 
                          FROM tblOccupiedBillID o 
                          JOIN tblBillID b ON o.BillID = b.BillID 
                          WHERE o.GameID NOT LIKE 'GM%'";
                $names = mssql_query($query);
                while ($row = mssql_fetch_array($names)) {
                    $isHardcore = $row['is_hardcore'];
                    echo '<tr>';
                    echo '<td>' . htmlspecialchars($row['GameID']) . '</td>';
                    echo '<td>';
                    if ($isHardcore) {
                        echo '<img src="http://redmoonfantasy.ddns.net:3400/redmoon/face/skull.png" style="width: 60px; height: 50px;">';
                    } else {
                        echo '<img src="http://redmoonfantasy.ddns.net:3400/redmoon/face/GreySkull.png" style="width: 50px; height: 50px;">';
                    }
                    echo '</td>';
                    echo '</tr>';
                }
                ?>
            </table>
            <p>
                <img src="http://redmoonfantasy.ddns.net:3400/redmoon/face/GreySkull.png" style="width: 30px; height: 30px;"> = Normal Account<br>
                <img src="http://redmoonfantasy.ddns.net:3400/redmoon/face/skull.png" style="width: 40px; height: 30px;"> = Hardcore Account
            </p>
        </center>
    </div>



    <script>
        // Reload the page every 10 seconds
        setInterval(function() {
            location.reload();
        }, 10000);
    </script>

</body>

</html>
