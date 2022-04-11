<?php
require "conn.php";
$mysql_qry = "select u.username, u.email, r.event_name from registration as r,users as u where r.user_id=u.user_id and r.event_id=1;
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