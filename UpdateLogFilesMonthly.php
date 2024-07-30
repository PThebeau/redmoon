<?php
// Include your database connection file
  include("config.php");

// Function to log errors to a file
function logError($message) {
    error_log($message, 3, 'error_log.log');
}

// Function to create dynamic tables
function createDynamicTables($conn) {
    // List of procedures to create tables
    $createTableProcedures = array(
        'CreateDeathLogTable',
        'CreateItemLogTable',
        'CreateLevelLogTable',
        'CreateUserCountLogTable',
        'CreateUserLogTable',
        'CreateMailLogTable'
    );

    foreach ($createTableProcedures as $procedure) {
        $stmt = odbc_exec($conn, "EXEC $procedure");

        if (!$stmt) {
            logError('Failed to execute procedure: ' . $procedure . ' - ' . odbc_errormsg($conn));
            continue;
        }
    }
}

// Function to insert data into UserLog table
function insertUserLog($conn, $BillID, $loginTime, $logoutTime, $status, $UseTime, $extra1, $extra2, $ipAddress) {
    // Provide default values for columns that cannot be null
    if (is_null($extra1)) {
        $extra1 = '';
    }
    if (is_null($extra2)) {
        $extra2 = '';
    }

    // Convert dates to strings if necessary
    $loginTimeStr = date('Y-m-d H:i:s', strtotime($loginTime));
    $logoutTimeStr = date('Y-m-d H:i:s', strtotime($logoutTime));

    $stmt = odbc_exec($conn, "EXEC InsertUserLog 
        @BillID = '$BillID', 
        @LoginTime = '$loginTimeStr', 
        @LogoutTime = '$logoutTimeStr', 
        @Status = $status, 
        @UseTime = $UseTime, 
        @Extra1 = '$extra1', 
        @Extra2 = '$extra2', 
        @IPAddress = '$ipAddress'");

    if (!$stmt) {
        logError('Stored procedure execution failed: ' . odbc_errormsg($conn));
    }
}

// Ensure the connection is established
if ($conn) {
    // Example usage: Create dynamic tables
    createDynamicTables($conn);

    // Example usage: Insert data into UserLog table
    // insertUserLog($conn, 'username', '2024-07-24 01:00:00', '2024-07-24 02:00:00', 1, 123, 'extra1', 'extra2', '127.0.0.1');

    // Close the database connection
    odbc_close($conn);
} else {
    logError('Failed to connect to the database: ' . odbc_errormsg());
}
?>

<script>
    // Reloads the page every 10 seconds
    setInterval(function() {
        location.reload();
    }, 10000); // 10,000 milliseconds
</script>
