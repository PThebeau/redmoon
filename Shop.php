<?php
session_start();

require 'dbconfig.php'; // Load the database configuration

try {
    $dsn = "odbc:Driver={SQL Server};Server=$hostname;Database=$dbname;";
    $pdo = new PDO($dsn, $dbuser, $dbpassword);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Unable to connect to the database: " . $e->getMessage());
}

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
        $_SESSION['cart'] = array_values($_SESSION['cart']);
    } elseif (isset($_POST['clear_cart'])) {
        $_SESSION['cart'] = array();
    } elseif (isset($_POST['paypal_success'])) {
        foreach ($_SESSION['cart'] as $cart_item) {
            $game_id = $cart_item['game_id'];
            $item = $cart_item['item'];
            $price = $cart_item['price'];
            $item_kind = $cart_item['item_kind'];
            $item_index = $cart_item['item_index'];
            $item_count = $cart_item['item_count'];
            $time = date('Y-m-d H:i:s');

            // Insert into PurchaseLog table
            $sql = "INSERT INTO PurchaseLog (GameID, Item, Price, PurchaseTime, ItemKind, ItemIndex) 
                    VALUES (?, ?, ?, ?, ?, ?)";
            $stmt = $pdo->prepare($sql);
            $stmt->execute([$game_id, $item, $price, $time, $item_kind, $item_index]);

            // Send items to the player
            sendItemsInBatches($game_id, array_fill(0, $item_count, $cart_item), $pdo);
        }
        $_SESSION['cart'] = array();
    }
}

function sendItemsInBatches($game_id, $items, $pdo) {
    $totalItems = count($items);
    $batchSize = 5;

    for ($i = 0; $i < $totalItems; $i += $batchSize) {
        $batch = array_slice($items, $i, $batchSize);

        foreach ($batch as $item) {
            $sql = "EXEC RMS_SENDSPECIALITEMMAIL 
                    @Sender = '[GMFantasy]', 
                    @Recipient = :game_id, 
                    @Title = '[StorePurchase]', 
                    @Content = 'Thank you for your purchase!', 
                    @ItemKind = :itemKind, 
                    @ItemIndex = :itemIndex, 
                    @ItemCount = :itemCount";

            $stmt = $pdo->prepare($sql);
            $stmt->bindParam(':game_id', $game_id, PDO::PARAM_STR);
            $stmt->bindParam(':itemKind', $item['item_kind'], PDO::PARAM_INT);
            $stmt->bindParam(':itemIndex', $item['item_index'], PDO::PARAM_INT);
            $stmt->bindParam(':itemCount', $item['item_count'], PDO::PARAM_INT);

            if ($stmt->execute()) {
                echo "Item (Kind: {$item['item_kind']}, Index: {$item['item_index']}, Count: {$item['item_count']}) sent successfully to $game_id.<br>";
            } else {
                echo "Error sending item to $game_id: " . implode(", ", $stmt->errorInfo()) . "<br>";
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
            background-color: #ffffff; /* White background */
            color: #00bfa5; /* Turquoise text */
        }

        .centered {
            text-align: center;
            margin-top: 20px;
        }

        h2 {
            color: #00bfa5; /* Turquoise text */
        }

        form {
            margin-top: 20px;
        }

        input[type="button"], input[type="submit"], button {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #00bfa5; /* Turquoise background */
            color: #ffffff;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        input[type="button"]:hover, input[type="submit"]:hover, button:hover {
            background-color: #008f7a; /* Darker shade on hover */
        }

        .major {
            margin-top: 40px;
        }

        .paypal-button {
            margin-top: 20px;
        }

        b {
            color: #000000; /* Black text */
        }

        hr {
            margin-top: 40px;
            border: 1px solid #008f7a; /* Turquoise border */
        }

        .item-list {
            margin-top: 20px;
            margin-bottom: 40px;
        }

        .item-list p {
            margin: 5px 0;
        }

        a {
            color: #00bfa5; /* Turquoise text */
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
            border: 1px solid #00bfa5; /* Turquoise border */
            padding: 10px;
            width: 300px;
            text-align: center;
            background-color: #f0f0f0; /* Light grey background */
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
            <label for="game_id" style="color: #00bfa5;">Game ID:</label>
            <input type="text" id="game_id" name="game_id" maxlength="14" required style="padding: 10px; width: 200px; margin-top: 10px;"><br><br>
        </form>
    </div>

    <div class="item-container">
        <!-- Clear Stage 0 Weapons -->
        <div class="item-box">
            <h3>Clear Stage 0 Weapons - $15.00 USD Each</h3>
            <select id="clear-stage-0-weapon">
                <option value="Manus Blade" data-price="15.00" data-item-kind="6" data-item-index="110" data-item-count="1">Manus Blade</option>
                <option value="Measure" data-price="15.00" data-item-kind="6" data-item-index="111" data-item-count="1">Measure</option>
                <option value="Destruction" data-price="15.00" data-item-kind="6" data-item-index="112" data-item-count="1">Destruction</option>
                <option value="Creationer" data-price="15.00" data-item-kind="6" data-item-index="113" data-item-count="1">Creationer</option>
                <option value="Sauvagine" data-price="15.00" data-item-kind="6" data-item-index="114" data-item-count="1">Sauvagine</option>
            </select>
            <button class="paypal-button" type="button" onclick="addToCartFromSelect('clear-stage-0-weapon')">Add to Cart</button>
        </div>

        <!-- Sunset Armor -->
        <div class="item-box">
            <h3>Sunset Armor - $12.00 USD Each</h3>
            <select id="sunset-armor">
                <option value="Nauthiz Helmet" data-price="12.00" data-item-kind="6" data-item-index="100" data-item-count="1">Nauthiz Helmet</option>
                <option value="Nauthiz Armor" data-price="12.00" data-item-kind="6" data-item-index="101" data-item-count="1">Nauthiz Armor</option>
                <option value="Nauthiz Pants" data-price="12.00" data-item-kind="6" data-item-index="102" data-item-count="1">Nauthiz Pants</option>
                <option value="Nauthiz Boots" data-price="12.00" data-item-kind="6" data-item-index="103" data-item-count="1">Nauthiz Boots</option>
                <option value="Nauthiz Shield" data-price="12.00" data-item-kind="6" data-item-index="104" data-item-count="1">Nauthiz Shield</option>
                <option value="Nauthiz Gloves" data-price="12.00" data-item-kind="6" data-item-index="105" data-item-count="1">Nauthiz Gloves</option>
                <option value="Nauthiz Belt" data-price="12.00" data-item-kind="6" data-item-index="106" data-item-count="1">Nauthiz Belt</option>
                <option value="Majestic Necklace" data-price="12.00" data-item-kind="6" data-item-index="108" data-item-count="1">Majestic Necklace</option>
            </select>
            <button class="paypal-button" type="button" onclick="addToCartFromSelect('sunset-armor')">Add to Cart</button>
        </div>

        <!-- Majestic Ring -->
        <div class="item-box">
            <h3>Majestic Ring - $7.00 USD Each</h3>
            <button class="paypal-button" type="button" onclick="addToCart('Majestic Ring', 7.00, 6, 107, 1)">Add to Cart</button>
        </div>

        <!-- Miscellaneous Uniques -->
        <div class="item-box">
            <h3>Miscellaneous Uniques - $5.00 USD Each</h3>
            <select id="misc-uniques">
                <option value="Selion" data-price="5.00" data-item-kind="6" data-item-index="1" data-item-count="1">Selion</option>
                <option value="Tamas" data-price="5.00" data-item-kind="6" data-item-index="2" data-item-count="1">Tamas</option>
                <option value="God of War" data-price="5.00" data-item-kind="6" data-item-index="10" data-item-count="1">God of War</option>
                <option value="Noas" data-price="5.00" data-item-kind="6" data-item-index="11" data-item-count="1">Noas</option>
                <option value="Tears of Heliades" data-price="5.00" data-item-kind="6" data-item-index="12" data-item-count="1">Tears of Heliades</option>
                <option value="Infrascope" data-price="5.00" data-item-kind="6" data-item-index="14" data-item-count="1">Infrascope</option>
                <option value="rajas" data-price="5.00" data-item-kind="6" data-item-index="15" data-item-count="1">rajas</option>
                <option value="Nagrepar" data-price="5.00" data-item-kind="6" data-item-index="18" data-item-count="1">Nagrepar</option>
                <option value="Largesse" data-price="5.00" data-item-kind="6" data-item-index="24" data-item-count="1">Largesse</option>
                <option value="Silpheed" data-price="5.00" data-item-kind="6" data-item-index="26" data-item-count="1">Silpheed</option>
                <option value="Elein" data-price="5.00" data-item-kind="6" data-item-index="28" data-item-count="1">Elein</option>
                <option value="Minerva's Robe" data-price="5.00" data-item-kind="6" data-item-index="91" data-item-count="1">Minerva's Robe</option>
                <option value="Minerva's Blessing" data-price="5.00" data-item-kind="6" data-item-index="92" data-item-count="1">Minerva's Blessing</option>
                <option value="Parcae's Plate" data-price="5.00" data-item-kind="6" data-item-index="93" data-item-count="1">Parcae's Plate</option>
                <option value="Parcae's Buckle" data-price="5.00" data-item-kind="6" data-item-index="94" data-item-count="1">Parcae's Buckle</option>
                <option value="Erinyes" data-price="5.00" data-item-kind="6" data-item-index="95" data-item-count="1">Erinyes</option>
                <option value="Rage of Erinyes" data-price="5.00" data-item-kind="6" data-item-index="96" data-item-count="1">Rage of Erinyes</option>
                <option value="Will of Erinyes" data-price="5.00" data-item-kind="6" data-item-index="97" data-item-count="1">Will of Erinyes</option>
            </select>
            <button class="paypal-button" type="button" onclick="addToCartFromSelect('misc-uniques')">Add to Cart</button>
        </div>

        <!-- Ring Set -->
        <div class="item-box">
            <h3>Ring Set - $15.00 USD (Set)</h3>
            <p>Graupnel</p>
            <p>Topaz</p>
            <p>Aquarine</p>
            <button class="paypal-button" type="button" onclick="addToCart('Ring Set', 15.00, 6, 0, 1)">Add to Cart</button>
        </div>

        <!-- Minerva's Tears -->
        <div class="item-box">
            <h3>Minerva's Tears - $5.00 USD Each</h3>
            <button class="paypal-button" type="button" onclick="addToCart('Minerva\'s Tears', 5.00, 6, 90, 1)">Add to Cart</button>
        </div>

        <!-- Lottery Ticket -->
        <div class="item-box">
            <h3>Lottery Ticket - $5.00 USD Each</h3>
            <button class="paypal-button" type="button" onclick="addToCart('Lottery Ticket', 5.00, 6, 197, 1)">Add to Cart</button>
        </div>

        <!-- Mysterious Rune -->
        <div class="item-box">
            <h3>Mysterious Rune (Level 1 Mage Weapon) - $10.00 USD</h3>
            <button class="paypal-button" type="button" onclick="addToCart('Mysterious Rune', 10.00, 6, 212, 1)">Add to Cart</button>
        </div>

        <!-- Fallen Star -->
        <div class="item-box">
            <h3>Fallen Star (Level 1 All Char Orb Slot) - $10.00 USD</h3>
            <button class="paypal-button" type="button" onclick="addToCart('Fallen Star', 10.00, 6, 219, 1)">Add to Cart</button>
        </div>

        <!-- Runes of Death -->
        <div class="item-box">
            <h3>Runes of Death (High Level Mage Weapon) - $25.00 USD</h3>
            <button class="paypal-button" type="button" onclick="addToCart('Runes of Death', 25.00, 6, 216, 1)">Add to Cart</button>
        </div>

        <!-- Protection -->
        <div class="item-box">
            <h3>Protection - $2.00 USD Each</h3>
            <button class="paypal-button" type="button" onclick="addToCart('Protection', 2.00, 6, 196, 1)">Add to Cart</button>
        </div>

        <!-- Pain Blaster -->
        <div class="item-box">
            <h3>Pain Blaster - $25.00 USD</h3>
            <button class="paypal-button" type="button" onclick="addToCart('Pain Blaster', 25.00, 1, 71, 1)">Add to Cart</button>
        </div>

        <!-- Slayer Blaster -->
        <div class="item-box">
            <h3>Slayer Blaster - $50.00 USD</h3>
            <button class="paypal-button" type="button" onclick="addToCart('Slayer Blaster', 50.00, 1, 72, 1)">Add to Cart</button>
        </div>
    </div>

    <div class="centered">
        <h2>Your Cart</h2>
        <?php
        if (!empty($_SESSION['cart'])) {
            echo '<form method="post" action="">';
            echo '<table border="1" style="width: 50%; margin: 0 auto; color: #000000;">';
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
