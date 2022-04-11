<?php
require "conn.php";
$username = $_POST["username"];

$mysql_qry1 = "select id from users WHERE username like '$username';";
$result1 = mysqli_query($conn,$mysql_qry1);
$result1 = $result1->fetch_array();
$userid = intval($result1[0]);

$mysql_qry = "select e.Name from event as e,user_event as ue where ue.user_id='$userid' and ue.event_id=e.Event_id;";
$result = mysqli_query($conn,$mysql_qry);
if($result)
{

while($row=mysqli_fetch_array($result))
	{
	$flag[]=$row;		
	}
print(json_encode($flag));
}
mysqli_close($conn);
?>