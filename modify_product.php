<?php
// Database credentials
$servername = "localhost";
$username = "endeersc_srn";
$password = "TrDduMGvva2ZDD9vdMH5";
$dbname = "endeersc_srn";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Check if data was posted
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Get the posted data
    $barcode = $_POST['barcode'];
    $product_name = $_POST['product_name'];
    $price = $_POST['price'];
    $brand = $_POST['brand'];
    $department = $_POST['department'];
    $measure = $_POST['measure'];

    // Ensure that barcode is provided
    if (empty($barcode)) {
        echo json_encode([
            "success" => false,
            "message" => "Barcode is required"
        ]);
        exit();
    }

    // Check if the product exists with the given barcode
    $check_sql = "SELECT * FROM products WHERE barcode = '$barcode'";
    $result = $conn->query($check_sql);

    if ($result->num_rows > 0) {
        // Update the product details
        $update_sql = "UPDATE products 
                       SET product_name = '$product_name', price = '$price', brand = '$brand', 
                           department = '$department', measure = '$measure' 
                       WHERE barcode = '$barcode'";

        if ($conn->query($update_sql) === TRUE) {
            echo json_encode([
                "success" => true,
                "message" => "Product modified successfully"
            ]);
        } else {
            echo json_encode([
                "success" => false,
                "message" => "Error updating product: " . $conn->error
            ]);
        }
    } else {
        echo json_encode([
            "success" => false,
            "message" => "Product with the given barcode not found"
        ]);
    }
} else {
    echo json_encode([
        "success" => false,
        "message" => "Invalid request"
    ]);
}

// Close the connection
$conn->close();
?>
