<?php
require "conn.php";
$mysql_qry = "select username ,event_name from registration where event_id=1;";
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