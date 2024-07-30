<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Redmoon Fantasy</title>
    <style>
        /* Your existing CSS styles */
        body {
            height: 100%;
            width: 100%;
            margin: 0;
            font-family: 'Arial', sans-serif;
            background-color: #ffffff; /* White background color */
            color: #00bfa5; /* Turquoise text color */
        }
        .main-content {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh; /* Ensure it covers the full viewport height */
        }
        .home-button-container {
            margin-top: 20px;
            text-align: center; /* Center the home button container */
        }
        .home-button {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #00bfa5; /* Turquoise background color */
            color: #ffffff; /* White text color */
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
        }
        .home-button:hover {
            background-color: #008f7a; /* Darker turquoise on hover */
        }
        .section {
            margin: 20px auto;
            width: 90%; /* Adjust width for responsiveness */
            max-width: 1200px; /* Maximum width for larger screens */
            background-color: #f0f0f0; /* Light grey background for sections */
            padding: 20px;
            border-radius: 10px;
            text-align: center; /* Center content inside section */
            box-sizing: border-box; /* Ensure padding is included in width */
        }
        table {
            width: 100%; /* Make table width 100% of its container */
            border-collapse: collapse;
            margin: 0 auto;
        }
        th, td {
            padding: 15px;
            text-align: center;
            border: 2px solid #00bfa5; /* Turquoise border color */
            word-wrap: break-word; /* Ensure long text wraps within cells */
        }
        th {
            background-color: #00bfa5; /* Turquoise background for headers */
            color: #ffffff; /* White text color */
        }
        td img {
            width: 40px;
            height: 40px;
        }
    </style>
</head>

<body>
    <div class="home-button-container">
        <a href="https://redmoon-fantasy.com" class="home-button">HOME</a>
    </div>

    <div class="main-content">
        <div class="section">
            <h2>Redmoon Fantasy Army</h2>
            <table>
                <tr>
                    <th>Army Names</th>
                    <th>Commander</th>
                    <th>Camp</th>
                </tr>
                <?php
                include("config.php"); // Ensure this file sets up the $conn variable correctly
                if (isset($conn)) {
                    $query = "SELECT TOP 500 Name, Commander, Camp FROM tblArmyList1";
                    $result = odbc_exec($conn, $query);
                    if (!$result) {
                        echo "Error in query execution: " . odbc_errormsg($conn);
                    } else {
                        while ($row = odbc_fetch_array($result)) {
                            echo '<tr>';
                            echo '<td>' . htmlspecialchars($row['Name']) . '</td>';
                            echo '<td>' . htmlspecialchars($row['Commander']) . '</td>';
                            echo '<td>' . htmlspecialchars($row['Camp']) . '</td>';
                            echo '</tr>';
                        }
                    }
                    odbc_free_result($result);
                } else {
                    echo "<tr><td colspan='3'>Error: Database connection not established.</td></tr>";
                }
                ?>
            </table>
        </div>

        <div class="section">
            <h2>Redmoon Fantasy Characters</h2>
            <p>
                <img src="face/GreySkull.png" style="width: 20px; height: 20px;"> = Normal Account<br>
                <img src="face/skull.png" style="width: 30px; height: 30px;"> = Hardcore Account
            </p>
            <?php
            if (isset($conn)) {
                $query = "SELECT TOP 3000 GameID, Lvl, Face, SubQuestGiftFame, STotalBonus, BillID 
                          FROM tblGameid1 
                          WHERE GameID NOT LIKE 'GM%' AND GameID NOT LIKE 'Wow123' AND Lvl >= 1
                          ORDER BY SubQuestGiftFame DESC, STotalBonus DESC, Lvl DESC";
                $result = odbc_exec($conn, $query);
                if (!$result) {
                    echo "Error in query execution: " . odbc_errormsg($conn);
                } else {
                    echo '<table>';
                    echo '<tr>';
                    echo '<th>Name</th>';
                    echo '<th>Level</th>';
                    echo '<th>Character</th>';
                    echo '<th>Rebirth Count</th>';
                    echo '<th>Bonus Points</th>';
                    echo '<th>Hardcore</th>';
                    echo '<th>Last Login</th>';
                    echo '</tr>';

                    while ($row = odbc_fetch_array($result)) {
                        $accountQuery = "SELECT is_hardcore, LastLogin FROM tblBillID WHERE BillID = ?";
                        $accountStmt = odbc_prepare($conn, $accountQuery);
                        odbc_execute($accountStmt, array($row['BillID']));
                        $accountRow = odbc_fetch_array($accountStmt);
                        $isHardcore = ($accountRow['is_hardcore'] == '1');
                        $lastLogin = isset($accountRow['LastLogin']) ? $accountRow['LastLogin'] : 'N/A';

                        $displayedLevel = ($row['Lvl'] >= 1000) ? 1000 : $row['Lvl'];

                        echo '<tr>';
                        echo '<td>' . htmlspecialchars($row['GameID']) . '</td>';
                        echo '<td>' . htmlspecialchars($displayedLevel) . '</td>';
                        echo '<td><img src="face/' . htmlspecialchars($row['Face']) . '.jpg"></td>';
                        echo '<td>' . htmlspecialchars($row['SubQuestGiftFame']) . '</td>';
                        echo '<td>' . htmlspecialchars($row['STotalBonus']) . '</td>';
                        echo '<td>';
                        if ($isHardcore) {
                            echo '<img src="face/skull.png">';
                        } else {
                            echo '<img src="face/GreySkull.png">';
                        }
                        echo '</td>';
                        echo '<td>' . htmlspecialchars($lastLogin) . '</td>';
                        echo '</tr>';
                    }
                    odbc_free_result($result);
                }
            } else {
                echo "<tr><td colspan='7'>Error: Database connection not established.</td></tr>";
            }
            ?>
        </div>
    </div>
</body>
</html>
