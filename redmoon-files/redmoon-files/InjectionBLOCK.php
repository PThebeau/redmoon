<?php
// Include your database connection file
include("config.php");

// Function to sanitize inputs
function sanitizeInput($input) {
    return htmlspecialchars(stripslashes(trim($input)));
}

// Function to detect SQL injection patterns
function isSuspiciousInput($input) {
    $patterns = [
        '/\bSELECT\b/i',
        '/\bUNION\b/i',
        '/\bINSERT\b/i',
        '/\bUPDATE\b/i',
        '/\bDELETE\b/i',
        '/\bDROP\b/i',
        '/\bTABLE\b/i',
        '/--/',
        '/\bOR\b.*=/i',
    ];

    foreach ($patterns as $pattern) {
        if (preg_match($pattern, $input)) {
            return true;
        }
    }
    return false;
}

// Function to log and block suspicious IP
function logAndBlockIP($ip, $details, $userID = null) {
    global $conn;

    // Log the suspicious activity
    $stmt = odbc_prepare($conn, "INSERT INTO SuspiciousActivityLog (ip_address, details, timestamp) VALUES (?, ?, GETDATE())");
    $params = array($ip, $details);
    odbc_execute($stmt, $params);

    // Check if the IP should be blocked (e.g., more than 5 attempts in the last hour)
    $stmt = odbc_prepare($conn, "SELECT COUNT(*) FROM SuspiciousActivityLog WHERE ip_address = ? AND timestamp > DATEADD(HOUR, -1, GETDATE())");
    odbc_execute($stmt, array($ip));
    $attempts = odbc_result($stmt, 1);

    if ($attempts > 5) {
        // Block IP (add to a blocklist)
        $stmt = odbc_prepare($conn, "INSERT INTO BlockedIPs (ip_address, blocked_until) VALUES (?, DATEADD(HOUR, 1, GETDATE()))");
        odbc_execute($stmt, array($ip));
    }

    // Disconnect the player by setting KillBillID to True if userID is provided
    if ($userID) {
        $stmt = odbc_prepare($conn, "UPDATE tblOccupiedBillID SET KillBillID = 1 WHERE BillID = ?");
        odbc_execute($stmt, array($userID));

        // Block the IP associated with the userID
        $stmt = odbc_prepare($conn, "SELECT IPAddress FROM tblUserLog1_202407 WHERE UserName = ?");
        odbc_execute($stmt, array($userID));
        while (odbc_fetch_row($stmt)) {
            $userIP = odbc_result($stmt, "IPAddress");
            $blockStmt = odbc_prepare($conn, "INSERT INTO BlockedIPs (ip_address, blocked_until) VALUES (?, DATEADD(HOUR, 1, GETDATE()))");
            odbc_execute($blockStmt, array($userIP));
        }
    }
}

// Function to check if IP is blocked
function isIPBlocked($ip) {
    global $conn;
    $stmt = odbc_prepare($conn, "SELECT COUNT(*) FROM BlockedIPs WHERE ip_address = ? AND blocked_until > GETDATE()");
    odbc_execute($stmt, array($ip));
    $isBlocked = odbc_result($stmt, 1);

    return $isBlocked > 0;
}

// Get user IP address
$userIP = $_SERVER['REMOTE_ADDR'];

// Check if IP is blocked
if (isIPBlocked($userIP)) {
    die("Your IP has been blocked due to suspicious activities.");
}

// Function to log actions
function logAction($userID, $actionType, $details) {
    global $conn;
    global $userIP;

    // Detect suspicious input
    if (isSuspiciousInput($userID) || isSuspiciousInput($actionType) || isSuspiciousInput($details)) {
        logAndBlockIP($userIP, "Suspicious input detected: userID=$userID, actionType=$actionType, details=$details", $userID);
        die("Suspicious activity detected. Your IP has been logged and may be blocked.");
    }

    $stmt = odbc_prepare($conn, "CALL LogAction(?, ?, ?)");
    $params = array($userID, $actionType, $details);
    odbc_execute($stmt, $params);
}

// Start session and implement rate limiting
session_start();
if (!isset($_SESSION['last_action_time'])) {
    $_SESSION['last_action_time'] = time();
} else {
    if (time() - $_SESSION['last_action_time'] < 1) {
        die("You are making requests too quickly.");
    }
    $_SESSION['last_action_time'] = time();
}

// Check if required parameters are set
if (isset($_POST['userID']) && isset($_POST['actionType']) && isset($_POST['details'])) {
    $userID = sanitizeInput($_POST['userID']);
    $actionType = sanitizeInput($_POST['actionType']);
    $details = sanitizeInput($_POST['details']);
    
    // Log the action
    logAction($userID, $actionType, $details);

    echo "Action logged successfully.";
} else {
    // Debugging: Output which parameters are missing
    $missingParams = [];
    if (!isset($_POST['userID'])) $missingParams[] = 'userID';
    if (!isset($_POST['actionType'])) $missingParams[] = 'actionType';
    if (!isset($_POST['details'])) $missingParams[] = 'details';

    $missingParamsList = implode(', ', $missingParams);
    die("Missing required parameters: $missingParamsList.");
}
