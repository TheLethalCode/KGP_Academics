<?php
require "conn.php";
$mysql_qry = "select Event_id,Name,Description,Startdate,Time from event where isActive=1;";
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