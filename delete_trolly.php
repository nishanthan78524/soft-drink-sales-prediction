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

// Check if 'barcode' is passed as a query parameter in the URL
if ($_SERVER['REQUEST_METHOD'] == 'GET' && isset($_GET['barcode'])) {
  // Get the barcode of the product to delete
  $barcode = $_GET['barcode'];

  // Prepare the SQL query to delete the product
  $sql = "DELETE FROM trolly WHERE barcode = '$barcode'";

  if ($conn->query($sql) === TRUE) {
    echo json_encode(["success" => true, "message" => "Product deleted successfully"]);
  } else {
    echo json_encode(["success" => false, "message" => "Error: " . $conn->error]);
  }
} else {
  echo json_encode(["success" => false, "message" => "Invalid request. Barcode is missing."]);
}

// Close the connection
$conn->close();
?>
