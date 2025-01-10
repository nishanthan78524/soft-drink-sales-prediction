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

// SQL query to get all items from the trolly table
$sql = "SELECT barcode, brand, product, price, measure, suggested_qty FROM trolly";
$result = $conn->query($sql);

$response = array();

if ($result->num_rows > 0) {
    // Output data of each row into an associative array
    while($row = $result->fetch_assoc()) {
        $response[] = $row;
    }
} else {
    $response = array("error" => "No items found in the trolly");
}

// Return response in JSON format
echo json_encode($response);

// Close connection
$conn->close();
?>
