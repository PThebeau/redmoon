<?php
// Include your database connection file
require 'mssqlconfig.php';

// Function to sanitize inputs
function sanitizeInput($input) {
    return htmlspecialchars(stripslashes(trim($input)));
}

// Function to detect SQL injection patterns
function isSuspiciousInput($input) {
    // Add your SQL injection patterns here
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
    $stmt = $conn->prepare("INSERT INTO SuspiciousActivityLog (ip_address, details, timestamp) VALUES (?, ?, GETDATE())");
    if ($stmt) {
        $stmt->bind_param("ss", $ip, $details);
        $stmt->execute();
        $stmt->close();

        // Check if the IP should be blocked (e.g., more than 5 attempts in the last hour)
        $stmt = $conn->prepare("SELECT COUNT(*) FROM SuspiciousActivityLog WHERE ip_address = ? AND timestamp > DATEADD(HOUR, -1, GETDATE())");
        if ($stmt) {
            $stmt->bind_param("s", $ip);
            $stmt->execute();
            $stmt->bind_result($attempts);
            $stmt->fetch();
            $stmt->close();

            if ($attempts > 5) {
                // Block IP (add to a blocklist)
                $stmt = $conn->prepare("INSERT INTO BlockedIPs (ip_address, blocked_until) VALUES (?, DATEADD(HOUR, 1, GETDATE()))");
                if ($stmt) {
                    $stmt->bind_param("s", $ip);
                    $stmt->execute();
                    $stmt->close();
                }
            }
        }
    } else {
        die("Failed to prepare statement: " . $conn->error);
    }

    // Disconnect the player by setting KillBillID to True if userID is provided
    if ($userID) {
        $stmt = $conn->prepare("UPDATE tblOccupiedBillID SET KillBillID = 1 WHERE BillID = ?");
        if ($stmt) {
            $stmt->bind_param("s", $userID);
            $stmt->execute();
            $stmt->close();
        } else {
            die("Failed to prepare statement: " . $conn->error);
        }

        // Block the IP associated with the userID
        $stmt = $conn->prepare("SELECT IPAddress FROM tblUserLog1_202407 WHERE UserName = ?");
        if ($stmt) {
            $stmt->bind_param("s", $userID);
            $stmt->execute();
            $stmt->bind_result($userIP);
            while ($stmt->fetch()) {
                $blockStmt = $conn->prepare("INSERT INTO BlockedIPs (ip_address, blocked_until) VALUES (?, DATEADD(HOUR, 1, GETDATE()))");
                if ($blockStmt) {
                    $blockStmt->bind_param("s", $userIP);
                    $blockStmt->execute();
                    $blockStmt->close();
                }
            }
            $stmt->close();
        } else {
            die("Failed to prepare statement: " . $conn->error);
        }
    }
}

// Function to check if IP is blocked
function isIPBlocked($ip) {
    global $conn;
    $stmt = $conn->prepare("SELECT COUNT(*) FROM BlockedIPs WHERE ip_address = ? AND blocked_until > GETDATE()");
    if ($stmt) {
        $stmt->bind_param("s", $ip);
        $stmt->execute();
        $stmt->bind_result($isBlocked);
        $stmt->fetch();
        $stmt->close();

        return $isBlocked > 0;
    } else {
        die("Failed to prepare statement: " . $conn->error);
    }
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

    $stmt = $conn->prepare("CALL LogAction(?, ?, ?)");
    if ($stmt) {
        $stmt->bind_param("sss", $userID, $actionType, $details);
        $stmt->execute();
        if ($stmt->error) {
            die("Execute failed: " . $stmt->error);
        }
        $stmt->close();
    } else {
        die("Failed to prepare statement: " . $conn->error);
    }
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
    logAction($userID, $actionType, $details);

    echo "Action logged successfully.";
} else {
    die("Missing required parameters.");
}
?>
