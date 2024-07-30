<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

include("config.php");

$activePlayers = array();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (isset($_POST['GameID'])) {
        $gameId = $_POST['GameID'];
        $currentTime = date('Y-m-d H:i:s');

        // Update only LastActivity without DeviceInfo
        $updateQuery = "UPDATE tblUserLog1_202407 SET LastActivity = ? WHERE BillID = ?";
        $stmt = odbc_prepare($conn, $updateQuery);
        $params = array($currentTime, $gameId);
        if ($stmt) {
            odbc_execute($stmt, $params);
            odbc_free_result($stmt);
        } else {
            error_log('Error updating LastActivity for GameID: ' . odbc_errormsg($conn));
        }
    }
    odbc_close($conn);
    exit;
} else {
    $tableSuffix = date('Ym');
    $logTable = "tblUserLog1_" . $tableSuffix;

    $query = "SELECT GameID, BillID FROM tblOccupiedBillID";
    $result = odbc_exec($conn, $query);
    if ($result) {
        $gameIDs = array();
        while ($row = odbc_fetch_array($result)) {
            $gameIDs[$row['BillID']] = $row['GameID'];
        }

        if (!empty($gameIDs)) {
            $billIDList = "'" . implode("','", array_keys($gameIDs)) . "'";
            $dataQuery = "SELECT BillID, IPAddress FROM $logTable WHERE BillID IN ($billIDList)";
            $dataResult = odbc_exec($conn, $dataQuery);

            if ($dataResult) {
                while ($dataRow = odbc_fetch_array($dataResult)) {
                    $billID = $dataRow['BillID'];
                    if (isset($gameIDs[$billID])) {
                        $activePlayers[$billID] = array(
                            'GameID' => $gameIDs[$billID],
                            'IPAddress' => $dataRow['IPAddress']
                        );
                    } else {
                        error_log("GameID not found for BillID: $billID");
                    }
                }
            } else {
                error_log('Error fetching player data: ' . odbc_errormsg($conn));
            }
        }
    } else {
        error_log('Error fetching GameIDs: ' . odbc_errormsg($conn));
    }
    odbc_close($conn);
}

function jsonEncodeManually($array) {
    $items = array();
    foreach ($array as $item) {
        $encodedItem = array();
        foreach ($item as $key => $value) {
            $encodedItem[] = '"' . addslashes($key) . '":"' . addslashes($value) . '"';
        }
        $items[] = '{' . implode(',', $encodedItem) . '}';
    }
    return '[' . implode(',', $items) . ']';
}

function getGeoLocation($ip) {
    $geoData = @file_get_contents("http://ip-api.com/json/$ip");
    if ($geoData) {
        $geoData = json_decode($geoData, true);
        if (isset($geoData['city']) && isset($geoData['country'])) {
            return $geoData['city'] . ', ' . $geoData['country'];
        }
    }
    return 'Unknown';
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Player Monitoring</title>
    <style>
        body {
            background-color: #0c0c0c;
            color: #e74c3c;
            font-family: Arial, sans-serif;
        }
        .container {
            margin: 0 auto;
            width: 80%;
            padding: 20px;
            background-color: #1c1c1c;
            border-radius: 10px;
            text-align: center;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid #444;
        }
        th, td {
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #333;
        }
    </style>
    <script>
        var activePlayers = <?php echo jsonEncodeManually($activePlayers); ?>;

        console.log("Active Players:", activePlayers);

        setInterval(function() {
            if (activePlayers.length > 0) {
                activePlayers.forEach(function(player, index) {
                    sendHeartbeat(player.GameID);
                    updateGeoLocation(player, index);
                });
            } else {
                console.log("No active players found.");
            }
        }, 5000);

        function sendHeartbeat(gameId) {
            var xhr = new XMLHttpRequest();
            xhr.open("POST", "monitor.php", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.send("GameID=" + encodeURIComponent(gameId));
        }

        function updateGeoLocation(player, index) {
            var xhr = new XMLHttpRequest();
            xhr.open('GET', 'http://ip-api.com/json/' + player.IPAddress, true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        var response = JSON.parse(xhr.responseText);
                        if (response.status === 'success') {
                            document.getElementById('geo-' + index).textContent = response.city + ', ' + response.country;
                        } else {
                            document.getElementById('geo-' + index).textContent = 'Unknown';
                        }
                    }
                }
            };
            xhr.send(null);
        }
    </script>
</head>
<body>
    <div class="container">
        <h1>Player Monitoring</h1>
        <p>Tracking player activity and geographical location.</p>
        <table>
            <tr>
                <th>GameID</th>
                <th>IP Address</th>
                <th>Geographical Location</th>
            </tr>
            <?php if (!empty($activePlayers)): ?>
                <?php $index = 0; foreach($activePlayers as $player): ?>
                <tr>
                    <td><?php echo htmlspecialchars($player['GameID']); ?></td>
                    <td><?php echo htmlspecialchars($player['IPAddress']); ?></td>
                    <td id="geo-<?php echo $index; ?>">Loading...</td>
                </tr>
                <?php $index++; endforeach; ?>
            <?php else: ?>
                <tr>
                    <td colspan="3">No active players found.</td>
                </tr>
            <?php endif; ?>
        </table>
    </div>
</body>
</html>
