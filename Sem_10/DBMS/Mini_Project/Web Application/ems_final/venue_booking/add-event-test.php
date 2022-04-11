<?php 
// DB credentials.
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "ems";
// Establish database connection.
$conn = mysqli_connect($servername, $username, $password, $dbname);
// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}
else
{
$building_id=1;
$building_name='NALANDA';
$floor=2;
$Room_no='NR322';
$Capacity=100;
$Availability=1;
$EVENT_ID=2;
	mysqli_query($conn,"INSERT INTO `venue_booking` (`Building_ID`, `Building_Name`, `Floor`, `Room_No`, `Capacity`, `Available`, `Event_Alloted(ID)`) VALUES ('$building_id', '$building_name', '$floor', '$Room_no', '$Capacity', '$Availability', '$EVENT_ID')"
	)  or die(mysqli_error($conn));
}

?>