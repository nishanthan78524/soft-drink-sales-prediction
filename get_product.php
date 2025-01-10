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

// Get the barcode from the request
$barcode = $_GET['barcode'];

// SQL query to fetch product details
$sql = "SELECT * FROM products WHERE barcode = '$barcode'";
$result = $conn->query($sql);

// Check if any rows returned
if ($result->num_rows > 0) {
    // Fetch associative array and convert it to JSON
    $row = $result->fetch_assoc();
    echo json_encode($row);
} else {
    // No product found
    echo json_encode(["error" => "No product found for the given barcode"]);
}

$conn->close();
?>
