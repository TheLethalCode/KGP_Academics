<?php
require "conn.php";
$username = $_POST["username"];
$eventname = $_POST["eventname"];

$mysql_qry1 = "select id from users WHERE username like '$username';";
$result1 = mysqli_query($conn,$mysql_qry1);
$result1 = $result1->fetch_array();
$userid = intval($result1[0]);


$mysql_qry2 = "select Event_id from event WHERE Name like '$eventname';";
$result2 = mysqli_query($conn,$mysql_qry2);
$result2 = $result2->fetch_array();
$eventid = intval($result2[0]);


$mysql_qry3 = "select * from user_event where user_id = '$userid' and event_id ='$eventid';";
$result3 = mysqli_query($conn,$mysql_qry3);
if(mysqli_num_rows($result3)>0)
{
	echo "You have already signed up for the event!";
}
else
{
	$mysql_qry = "insert into user_event (user_id,event_id) values('$userid','$eventid')";
	if($conn->query($mysql_qry) === TRUE)
	{
	echo "registration for the event success";
	}	
	else
	{
	echo "Error" . $mysql_qry . "<br>" . $conn->error;
	}
}
$conn->close();

?> 