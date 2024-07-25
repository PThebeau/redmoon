<?php
session_start(); // Ensure session is started

require 'mssqlconfig.php';

// Load PayPal config
$paypalConfig = include('paypal_config.php');
$paypal_client_id = $paypalConfig['client_id'];

// Function to sanitize input data
function sanitize_input($data) {
    return htmlspecialchars(stripslashes(trim($data)));
}

// Initialize cart if not already done
if (!isset($_SESSION['cart'])) {
    $_SESSION['cart'] = array();
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    if (isset($_POST['add_to_cart'])) {
        $game_id = sanitize_input($_POST['game_id']);
        $item = sanitize_input($_POST['item']);
        $price = floatval($_POST['price']);
        $item_kind = intval($_POST['item_kind']);
        $item_index = intval($_POST['item_index']);
        $item_count = intval($_POST['item_count']);

        $_SESSION['cart'][] = array(
            'game_id' => $game_id,
            'item' => $item,
            'price' => $price,
            'item_kind' => $item_kind,
            'item_index' => $item_index,
            'item_count' => $item_count
        );
    } elseif (isset($_POST['remove_item'])) {
        $index = intval($_POST['remove_item']);
        unset($_SESSION['cart'][$index]);
        $_SESSION['cart'] = array_values($_SESSION['cart']); // Re-index array
    } elseif (isset($_POST['clear_cart'])) {
        $_SESSION['cart'] = array();
    } elseif (isset($_POST['paypal_success'])) {
        // Handle successful PayPal payment
        foreach ($_SESSION['cart'] as $cart_item) {
            $game_id = $cart_item['game_id'];
            $item = $cart_item['item'];
            $price = $cart_item['price'];
            $item_kind = $cart_item['item_kind'];
            $item_index = $cart_item['item_index'];
            $item_count = $cart_item['item_count'];
            $time = date('Y-m-d H:i:s');

            // Insert into PurchaseLog table
            $sql = "INSERT INTO PurchaseLog (GameID, Item, Price, PurchaseTime, ItemKind, ItemIndex) VALUES ('$game_id', '$item', '$price', '$time', $item_kind, $item_index)";
            if (!mssql_query($sql, $db_link)) {
                logError('Failed to insert into PurchaseLog: ' . mssql_get_last_message());
            }

            // Send item to the player
            sendItemsInBatches($game_id, array_fill(0, $item_count, $cart_item), $db_link);
        }
        $_SESSION['cart'] = array();
    }
}

function sendItemsInBatches($game_id, $items, $db_link) {
    $totalItems = count($items);
    $batchSize = 5;

    for ($i = 0; $i < $totalItems; $i += $batchSize) {
        $batch = array_slice($items, $i, $batchSize);

        foreach ($batch as $item) {
            $sql = "EXEC RMS_SENDSPECIALITEMMAIL 
                    @Sender = '[GMFantasy]', 
                    @Recipient = '$game_id', 
                    @Title = '[StorePurchase]', 
                    @Content = 'Thank you for your purchase!', 
                    @ItemKind = " . intval($item['item_kind']) . ", 
                    @ItemIndex = " . intval($item['item_index']) . ", 
                    @ItemCount = " . intval($item['item_count']);

            if (mssql_query($sql, $db_link)) {
                echo "Batch of items sent successfully to $game_id.<br>";
            } else {
                echo "Error sending batch of items to $game_id: " . mssql_get_last_message() . "<br>";
            }
        }
    }
}

// Function to log errors to a file
function logError($message) {
    error_log($message, 3, 'error_log.log');
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Redmoon Fantasy Store</title>
    <style>
        body {
            height: 100%;
            width: 100%;
            margin: 0;
            font-family: 'Arial', sans-serif;
            background-color: #0c0c0c; /* Dark background color */
            color: #ffffff; /* Light text color */
        }

        .centered {
            text-align: center;
            margin-top: 20px;
        }

        h2 {
            color: #e74c3c; /* Redmoon Fantasy theme color for headings */
        }

        form {
            margin-top: 20px;
        }

        input[type="button"], input[type="submit"], button {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #e74c3c; /* Redmoon Fantasy theme color for buttons */
            color: #ffffff;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        input[type="button"]:hover, input[type="submit"]:hover, button:hover {
            background-color: #c0392b; /* Darker shade on hover */
        }

        .major {
            margin-top: 40px;
        }

        .paypal-button {
            margin-top: 20px;
        }

        b {
            color: #e74c3c; /* Redmoon Fantasy theme color for bold text */
        }

        hr {
            margin-top: 40px;
            border: 1px solid #e74c3c; /* Redmoon Fantasy theme color for horizontal rules */
        }

        .item-list {
            margin-top: 20px;
            margin-bottom: 40px;
        }

        .item-list p {
            margin: 5px 0;
        }

        a {
            color: #e74c3c; /* Redmoon Fantasy theme color for links */
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        .item-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
        }

        .item-box {
            margin: 10px;
            border: 1px solid #e74c3c; /* Redmoon Fantasy theme color for borders */
            padding: 10px;
            width: 300px;
            text-align: center;
            background-color: #1c1c1c; /* Slightly lighter background for item boxes */
            border-radius: 10px;
        }
    </style>
    <script src="https://www.paypal.com/sdk/js?client-id=<?php echo $paypal_client_id; ?>&currency=USD"></script>
</head>
<body>
    <div class="centered">
        <form>
            <input type="button" value="HOME" onclick="window.location.href='https://redmoon-fantasy.com'" />
        </form>
    </div>
    <div class="centered major">
        <h2>Redmoon Fantasy Store</h2>
    </div>
    <div class="centered">
        <p>Please enter your Game ID to proceed with purchases.</p>
        <form id="checkout-form" action="" method="post">
            <label for="game_id" style="color: #e74c3c;">Game ID:</label>
            <input type="text" id="game_id" name="game_id" maxlength="14" required style="padding: 10px; width: 200px; margin-top: 10px;"><br><br>
        </form>
    </div>

    <div class="item-container">
        <!-- Beginner Weapon -->
        <div class="item-box">
            <h3>Beginner Weapon - $10.00 USD</h3>
            <select id="beginner-weapon">
                <option value="Sword of Aelous" data-price="10.00" data-item-kind="6" data-item-index="80" data-item-count="1">Sword of Aelous</option>
                <option value="Wand of Gaia" data-price="10.00" data-item-kind="6" data-item-index="81" data-item-count="1">Wand of Gaia</option>
                <option value="Spear of Ares" data-price="10.00" data-item-kind="6" data-item-index="82" data-item-count="1">Spear of Ares</option>
                <option value="Nemesis Bow" data-price="10.00" data-item-kind="6" data-item-index="83" data-item-count="1">Nemesis Bow</option>
                <option value="Madness Gun" data-price="10.00" data-item-kind="6" data-item-index="84" data-item-count="1">Madness Gun</option>
            </select>
            <button class="paypal-button" type="button" onclick="addToCartFromSelect('beginner-weapon')">Add to Cart</button>
        </div>

        <!-- Beginner Gear Set -->
        <div class="item-box">
            <h3>Beginner Gear Set - $50.00 USD</h3>
            <p>Fresh Breeze</p>
            <p>Erinyes Shield</p>
            <p>Jupiter Chest Piece</p>
            <p>Jupiter Leggings</p>
            <p>5x Protections</p>
            <button class="paypal-button" type="button" onclick="addToCart('Beginner Gear Set', 50.00, 0, 0, 1)">Add to Cart</button>
        </div>

        <!-- Clear Stage 3 Weapon x5 -->
        <div class="item-box">
            <h3>Clear Stage 3 Weapon x5 - $50.00 USD</h3>
            <select id="clear-stage-3-weapon">
                <option value="Augmented Manus Blade" data-price="50.00" data-item-kind="6" data-item-index="170" data-item-count="5">Augmented Manus Blade</option>
                <option value="Augmented Measure" data-price="50.00" data-item-kind="6" data-item-index="171" data-item-count="5">Augmented Measure</option>
                <option value="Augmented Destruction" data-price="50.00" data-item-kind="6" data-item-index="172" data-item-count="5">Augmented Destruction</option>
                <option value="Augmented Creationer" data-price="50.00" data-item-kind="6" data-item-index="173" data-item-count="5">Augmented Creationer</option>
                <option value="Augmented Sauvagine" data-price="50.00" data-item-kind="6" data-item-index="174" data-item-count="5">Augmented Sauvagine</option>
            </select>
            <button class="paypal-button" type="button" onclick="addToCartFromSelect('clear-stage-3-weapon')">Add to Cart</button>
        </div>

        <!-- Liquid of Your Choice -->
        <div class="item-box">
            <h3>Liquid of Your Choice - $20.00 USD</h3>
            <select id="liquid-choice">
                <option value="Orb of Strength" data-price="20.00" data-item-kind="6" data-item-index="204" data-item-count="1">Orb of Strength</option>
                <option value="Orb of Power" data-price="20.00" data-item-kind="6" data-item-index="205" data-item-count="1">Orb of Power</option>
                <option value="Orb of Dexterity" data-price="20.00" data-item-kind="6" data-item-index="206" data-item-count="1">Orb of Dexterity</option>
                <option value="Orb of Spirit" data-price="20.00" data-item-kind="6" data-item-index="207" data-item-count="1">Orb of Spirit</option>
            </select>
            <button class="paypal-button" type="button" onclick="addToCartFromSelect('liquid-choice')">Add to Cart</button>
        </div>

        <!-- Moderate Gear Set -->
        <div class="item-box">
            <h3>Moderate Gear Set - $100.00 USD</h3>
            <p>Ancient Coin</p>
            <p>Legendary Necklace</p>
            <p>Fallen Star (orb slot for all characters)</p>
            <p>5x Lotto Tickets</p>
            <p>8x Protections</p>
            <button class="paypal-button" type="button" onclick="addToCart('Moderate Gear Set', 100.00, 0, 0, 1)">Add to Cart</button>
        </div>

        <!-- Clear Stage 4 Weapon x5 -->
        <div class="item-box">
            <h3>Clear Stage 4 Weapon x5 - $50.00 USD</h3>
            <select id="clear-stage-4-weapon">
                <option value="Superior Manus Blade" data-price="50.00" data-item-kind="6" data-item-index="190" data-item-count="5">Superior Manus Blade</option>
                <option value="Superior Measure" data-price="50.00" data-item-kind="6" data-item-index="191" data-item-count="5">Superior Measure</option>
                <option value="Superior Destruction" data-price="50.00" data-item-kind="6" data-item-index="192" data-item-count="5">Superior Destruction</option>
                <option value="Superior Creationer" data-price="50.00" data-item-kind="6" data-item-index="193" data-item-count="5">Superior Creationer</option>
                <option value="Superior Sauvagine" data-price="50.00" data-item-kind="6" data-item-index="194" data-item-count="5">Superior Sauvagine</option>
            </select>
            <button class="paypal-button" type="button" onclick="addToCartFromSelect('clear-stage-4-weapon')">Add to Cart</button>
        </div>

        <!-- Advanced Gear Set -->
        <div class="item-box">
            <h3>Advanced Gear Set - $150.00 USD</h3>
            <p>Fantasy Necklace</p>
            <p>Fantasy Diamond</p>
            <p>8x Lotto Tickets</p>
            <p>8x Protections</p>
            <p>Heart of Redmoon x3 (ring slot)</p>
            <button class="paypal-button" type="button" onclick="addToCart('Advanced Gear Set', 150.00, 0, 0, 1)">Add to Cart</button>
        </div>

        <!-- Server Files + Guide -->
        <div class="item-box">
            <h3>Server Files + Guide - $1000.00 USD</h3>
            <button class="paypal-button" type="button" onclick="addToCart('Server Files + Guide', 1000.00, 0, 0, 1)">Add to Cart</button>
        </div>
    </div>

    <div class="centered">
        <h2>Your Cart</h2>
        <?php
        if (!empty($_SESSION['cart'])) {
            echo '<form method="post" action="">';
            echo '<table border="1" style="width: 50%; margin: 0 auto; color: #ffffff;">';
            echo '<tr><th>Game ID</th><th>Item</th><th>Price</th><th>Action</th></tr>';
            $total = 0;
            foreach ($_SESSION['cart'] as $index => $cart_item) {
                echo '<tr>';
                echo '<td>' . htmlspecialchars($cart_item['game_id']) . '</td>';
                echo '<td>' . htmlspecialchars($cart_item['item']) . '</td>';
                echo '<td>$' . number_format($cart_item['price'], 2) . '</td>';
                echo '<td><button type="submit" name="remove_item" value="' . $index . '">Remove</button></td>';
                echo '</tr>';
                $total += $cart_item['price'];
            }
            echo '<tr><td colspan="2"><b>Total</b></td><td colspan="2">$' . number_format($total, 2) . '</td></tr>';
            echo '</table>';
            echo '<br>';
            echo '<button type="submit" name="clear_cart">Clear Cart</button>';
            echo '</form>';
        } else {
            echo '<p>Your cart is empty.</p>';
        }
        ?>
    </div>
    <div class="centered">
        <div id="paypal-button-container" style="display: flex; justify-content: center;">
            <div style="transform: scale(1.2);">
                <!-- PayPal button will be rendered here -->
            </div>
        </div>
    </div>

    <script>
        function addToCartFromSelect(selectId) {
            var selectElement = document.getElementById(selectId);
            var selectedItem = selectElement.options[selectElement.selectedIndex];
            addToCart(
                selectedItem.value,
                parseFloat(selectedItem.getAttribute('data-price')),
                parseInt(selectedItem.getAttribute('data-item-kind')),
                parseInt(selectedItem.getAttribute('data-item-index')),
                parseInt(selectedItem.getAttribute('data-item-count'))
            );
        }

        function addToCart(itemName, price, itemKind, itemIndex, itemCount) {
            var gameID = document.getElementById('game_id').value;
            if (!gameID) {
                alert('Please enter your Game ID.');
                return;
            }
            var form = document.createElement('form');
            form.method = 'post';
            form.action = '';

            var gameIDInput = document.createElement('input');
            gameIDInput.type = 'hidden';
            gameIDInput.name = 'game_id';
            gameIDInput.value = gameID;

            var itemInput = document.createElement('input');
            itemInput.type = 'hidden';
            itemInput.name = 'item';
            itemInput.value = itemName;

            var priceInput = document.createElement('input');
            priceInput.type = 'hidden';
            priceInput.name = 'price';
            priceInput.value = price;

            var itemKindInput = document.createElement('input');
            itemKindInput.type = 'hidden';
            itemKindInput.name = 'item_kind';
            itemKindInput.value = itemKind;

            var itemIndexInput = document.createElement('input');
            itemIndexInput.type = 'hidden';
            itemIndexInput.name = 'item_index';
            itemIndexInput.value = itemIndex;

            var itemCountInput = document.createElement('input');
            itemCountInput.type = 'hidden';
            itemCountInput.name = 'item_count';
            itemCountInput.value = itemCount;

            var addToCartInput = document.createElement('input');
            addToCartInput.type = 'hidden';
            addToCartInput.name = 'add_to_cart';
            addToCartInput.value = '1';

            form.appendChild(gameIDInput);
            form.appendChild(itemInput);
            form.appendChild(priceInput);
            form.appendChild(itemKindInput);
            form.appendChild(itemIndexInput);
            form.appendChild(itemCountInput);
            form.appendChild(addToCartInput);

            document.body.appendChild(form);
            form.submit();
        }

        paypal.Buttons({
            createOrder: function(data, actions) {
                return actions.order.create({
                    purchase_units: [{
                        amount: {
                            value: '<?php echo isset($total) ? number_format($total, 2) : '0.00'; ?>'
                        }
                    }]
                });
            },
            onApprove: function(data, actions) {
                return actions.order.capture().then(function(details) {
                    alert('Transaction completed by ' + details.payer.name.given_name);
                    var form = document.createElement('form');
                    form.method = 'post';
                    form.action = '';
                    
                    var paypalSuccessInput = document.createElement('input');
                    paypalSuccessInput.type = 'hidden';
                    paypalSuccessInput.name = 'paypal_success';
                    paypalSuccessInput.value = '1';
                    
                    form.appendChild(paypalSuccessInput);
                    document.body.appendChild(form);
                    form.submit();
                });
            }
        }).render('#paypal-button-container > div');
    </script>
</body>
</html>
