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
  $brand = $_POST['brand'];
  $product = $_POST['product'];
  $price = $_POST['price'];
  $measure = $_POST['measure'];
  $suggested_qty = $_POST['suggested_qty'];

  // Insert data into the database
  $sql = "INSERT INTO trolly (barcode, brand, product, price, measure, suggested_qty) VALUES ('$barcode', '$brand', '$product', '$price', '$measure', '$suggested_qty')";

  if ($conn->query($sql) === TRUE) {
    echo json_encode(["success" => true, "message" => "Product added successfully"]);
  } else {
    echo json_encode(["success" => false, "message" => "Error: " . $conn->error]);
  }
} else {
  echo json_encode(["success" => false, "message" => "Invalid request"]);
}

// Close the connection
$conn->close();
?>
