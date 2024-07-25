<?php
require 'mssqlconfig.php';

// Function to log errors to a file
function logError($message) {
    error_log($message, 3, 'error_log.log');
}

// Function to create dynamic tables
function createDynamicTables($db_link) {
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
        $stmt = mssql_init($procedure, $db_link);

        if (!$stmt) {
            logError('Failed to initialize statement: ' . mssql_get_last_message());
            continue;
        }

        if (!mssql_execute($stmt)) {
            logError('Stored procedure execution failed: ' . mssql_get_last_message());
            mssql_free_statement($stmt);
            continue;
        }

        mssql_free_statement($stmt);
    }
}

// Function to insert data into UserLog table
function insertUserLog($db_link, $userName, $loginTime, $logoutTime, $status, $sessionID, $extra1, $extra2, $ipAddress) {
    $stmt = mssql_init('InsertUserLog', $db_link);

    if (!$stmt) {
        logError('Failed to initialize statement: ' . mssql_get_last_message());
        return;
    }

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

    mssql_bind($stmt, '@UserName', $userName, SQLVARCHAR, false, false, 50);
    mssql_bind($stmt, '@LoginTime', $loginTimeStr, SQLVARCHAR, false, false, 50);
    mssql_bind($stmt, '@LogoutTime', $logoutTimeStr, SQLVARCHAR, false, false, 50);
    mssql_bind($stmt, '@Status', $status, SQLINT4);
    mssql_bind($stmt, '@SessionID', $sessionID, SQLINT4);
    mssql_bind($stmt, '@Extra1', $extra1, SQLVARCHAR, false, false, 50);
    mssql_bind($stmt, '@Extra2', $extra2, SQLVARCHAR, false, false, 50);
    mssql_bind($stmt, '@IPAddress', $ipAddress, SQLVARCHAR, false, false, 50);

    if (!mssql_execute($stmt)) {
        logError('Stored procedure execution failed: ' . mssql_get_last_message());
    }

    mssql_free_statement($stmt);
}

// Ensure the connection is established
if ($db_link) {
    // Example usage: Create dynamic tables
    createDynamicTables($db_link);

    // Example usage: Insert data into UserLog table
    // insertUserLog($db_link, 'username', '2024-07-24 01:00:00', '2024-07-24 02:00:00', 1, 123, 'extra1', 'extra2', '127.0.0.1');

    // Close the database connection
    mssql_close($db_link);
} else {
    logError('Failed to connect to the database: ' . mssql_get_last_message());
}
?>

<script>
    // Reloads the page every 10 seconds
    setInterval(function() {
        location.reload();
    }, 10000); // 10,000 milliseconds
</script>
