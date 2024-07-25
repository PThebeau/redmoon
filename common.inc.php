<?php
$starttime = getmicrotime();
$numqueries = 0;

error_reporting(E_ALL);

session_cache_expire(60 * 24 * 31);
session_set_cookie_params(60 * 60 * 24 * 31);
session_start();
if (get_magic_quotes_gpc()) {
    function stripslashes_deep($value) {
        return is_array($value) ? array_map('stripslashes_deep', $value) : stripslashes($value);
    }

    $_POST = array_map('stripslashes_deep', $_POST);
    $_GET = array_map('stripslashes_deep', $_GET);
    $_COOKIE = array_map('stripslashes_deep', $_COOKIE);
}
extract($_GET, EXTR_PREFIX_ALL, "gp");
extract($_POST, EXTR_PREFIX_ALL, "gp");

require_once 'config.inc.php';
require_once 'DB.class.php';
require_once 'Result.class.php';

$db = new DB;
$types = array('Philar', 'Azlar', 'Sadad', 'Destino', 'Jarexx', 'Canon', 'Kitara', 'Luna', 'Lavita');

if (!isset($noinit)) {
    init();
}

function init() {
    global $db, $account, $gp_username, $gp_password;

    $account = array(
        'loggedin' => false,
        'chars' => array(),
        'username' => '',
        'password' => '',
        'data' => array(),
    );

    if (isset($_SESSION['username']) && isset($_SESSION['password'])) {
        $result = $db->query('SELECT * FROM tblBillID WHERE BillID = ? AND Password = ?', array($_SESSION['username'], $_SESSION['password']));
        if ($row = $result->fetch()) {
            $account['loggedin'] = true;
            $account['username'] = $row['BillID'];
            $account['password'] = $row['Password'];
            $account['data'] = $row;
        }
    } elseif (isset($gp_username) && isset($gp_password)) {
        $result = $db->query('SELECT * FROM tblBillID WHERE BillID = ? AND Password = ?', array($gp_username, $gp_password));
        if ($row = $result->fetch()) {
            $account['loggedin'] = true;
            $account['username'] = $row['BillID'];
            $account['password'] = $row['Password'];
            $account['data'] = $row;
        }
    }

    if ($account['loggedin']) {
        $_SESSION['username'] = $account['username'];
        $_SESSION['password'] = $account['password'];

        $chars = $db->query('SELECT * FROM tblGameID1 WHERE BillID = ?', array($account['username']));
        while ($char = $chars->fetch()) {
            $account['chars'][$char['GameID']] = $char;
        }
    }
}

function gdie($error) {
    ?>
    <div class="content-box">
        <p>An error has occurred!</p>
        <pre><?= htmlspecialchars($error) ?></pre>
    </div>
    <?php
    die();
}

function character_type($type) {
    global $types;

    if (isset($types[$type])) {
        return $types[$type];
    }

    return 'Unknown';
}

function honor_color($honor) {
    if ($honor == 0)        { return '#ffffff'; }
    else if ($honor > 800)  { return '#00049c'; }
    else if ($honor > 600)  { return '#1343ad'; }
    else if ($honor > 400)  { return '#6b69c6'; }
    else if ($honor > 200)  { return '#9c9ad6'; }
    else if ($honor > 0)    { return '#cecfef'; }
    else if ($honor < -800) { return '#9c0400'; }
    else if ($honor < -600) { return '#ad3431'; }
    else if ($honor < -400) { return '#c6696b'; }
    else if ($honor < -200) { return '#d69a9c'; }
    else if ($honor < 0)    { return '#efcfce'; }
}

function honor_color_simple($honor) {
    if ($honor > 700)       { return '#6b69c6'; }
    else if ($honor > 400)  { return '#9c9ad6'; }
    else if ($honor > 0)    { return '#cecfef'; }
    else if ($honor < -700) { return '#c6696b'; }
    else if ($honor < -400) { return '#efcfce'; }
    else if ($honor < 0)    { return '#d69a9c'; }

    return '#ffffff';
}

function sunset_stage_color($stage) {
    if ($stage == 0)      { return '#ffefcc'; }
    else if ($stage == 1) { return '#ffdf99'; }
    else if ($stage == 2) { return '#ffd066'; }
    else if ($stage == 3) { return '#ffc032'; }
    else if ($stage == 4) { return '#ffb000'; }
}

function unsigned_int($x) {
    $x = (float) $x;

    if ($x < 0) {
        $x = 2147483648 + (2147483648 - abs($x));
    }

    return $x;
}

function debugvar($var, $return = false) {
    if (!$return) {
        echo '<pre class="debug">' . print_r($var, 1) . '</pre>';
    } else {
        return "<pre class='debug'>" . print_r($var, 1) . '</pre>';
    }
}

function calc_bps($level, $bonus = 0) {
    return $level * 2 + floor($level / 100) + $bonus;
}

function nice_number($num) {
    if ($num < 1000) {
        return $num;
    } else if ($num < 100000) {
        return round($num / 1000, 1) . 'k';
    } else if ($num < 100000000) {
        return round($num / 1000000, 1) . ' mil';
    }

    return round($num / 1000000000, 1) . ' bil';
}

function item_location($kind) {
    if ($kind == 1) {
        return 'I';
    } else if ($kind == 2) {
        return 'E';
    } else if ($kind == 3) {
        return 'Q';
    } else if ($kind == 50) {
        return 'B';
    } else if ($kind == 51) {
        return 'S';
    } else if ($kind == 100) {
        return 'M';
    } else {
        return $kind;
    }
}

function goto_login() {
    header("Location: login.php?redirectdone=" . urlencode($_SERVER['REQUEST_URI']));
    exit;
}

function getmicrotime() {
    list($usec, $sec) = explode(' ', microtime());
    return $usec + $sec;
}

function html_header($title) {
    global $account;
    // Output any header-related content here
}

function html_footer() {
    global $db, $account, $starttime, $numqueries;

    echo '<div  style="text-align: center;">';
    $result = $db->query('SELECT COUNT(*) AS count FROM tblOccupiedBillID');
    if ($row = $result->fetch()) {
        echo "";
    }
    echo '</div>';
}
?>
