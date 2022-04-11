<?php
require "conn.php";
$user_name = $_POST["user_name"];
$user_pass = $_POST["password"];
$mysql_qry = "select * from users where username like '$user_name' and password like '$user_pass';";
$result = mysqli_query($conn,$mysql_qry);
if(mysqli_num_rows($result)>0)
{
echo "login success";
}
else
{
echo "login not success.";
}
?>