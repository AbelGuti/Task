<?php
//54.165.37.138 its my ip address, you must changed it by yours
$output = shell_exec('curl -L  http://54.165.37.138:5001/v2/keys/name');
$data=json_decode($output);
$node=$data->node;
$name=$node->value;
echo "<pre>The docker name is $name</pre>";
//54.165.37.138 its my ip address, you must changed it by yours
$output = shell_exec('curl -L  http://54.165.37.138:5001/v2/keys/port');
$data=json_decode($output);
$node=$data->node;
$port=$node->value;
echo "<pre>The port is $port</pre>";
//54.165.37.138 its my ip address, you must changed it by yours
$output = shell_exec('curl -L  http://54.165.37.138:5001/v2/keys/psswd');
$data=json_decode($output);
$node=$data->node;
$password=$node->value;
echo "<pre>The password is $password</pre>";


echo"NOTE: if you dont se a table, its because you dont load the ~/script.sql <br><br><br>";

$servername = "127.0.0.1:".$port;
$username = "root";
$dbname = "Guatemala";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT * FROM places";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
        echo "id: " . $row["id"]. " - Name: " . $row["name"]."<br>";
    }
} else {
    echo "0 results";
}
$conn->close();
?>
