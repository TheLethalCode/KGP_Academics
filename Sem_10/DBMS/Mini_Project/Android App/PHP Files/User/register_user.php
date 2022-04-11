<?php
require "conn.php";
$name = $_POST["name"];
$username = $_POST["username"];
$email = $_POST["email"];
$password = $_POST["password"];
$mysql_qry = "insert into users (name,username,email,password) values('$name','$username','$email','$password')";
if($conn->query($mysql_qry) === TRUE)
{
echo "registration success";
}
else
{
echo "Error" . $mysql_qry . "<br>" . $conn->error;
}
$conn->close();
?> 