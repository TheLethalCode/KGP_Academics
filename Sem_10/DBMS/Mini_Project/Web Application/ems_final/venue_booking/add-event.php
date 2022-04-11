<?php
session_start();
error_reporting(0);
include('includes/config.php');
if(strlen($_SESSION['adminsession'])==0)
{   
header('location:logout.php');
}
else{ 
if(isset($_POST['add']))
{
// Posted Values
$building_id=$_POST['category'];
$building_name=$_POST['sponser'];
$floor=$_POST['eventname'];
$Room_no=$_POST['evetndescription'];
$Capacity=$_POST['eventstartdate'];
$Availability=1;
$EVENT_ID=NULL;
//echo $building_id;
//$e4ntimage=$_FILES["eventimage"]["name"];
//$status=1;
// get the image extension
//$extension = substr($entimage,strlen($entimage)-4,strlen($entimage));
// allowed extensions
//$allowed_extensions = array(".jpg","jpeg",".png",".gif");
// Validation for allowed extensions .in_array() function searches an array for a specific value.

//rfloor the image file
//$eventimage=md5($entimage).$extension;
// Code for move image into directory
//move_uploaded_file($_FILES["eventimage"]["tmp_name"],"eventimages/".$eventimage);
// Query for insertion data into database
$sql="INSERT INTO  venue_booking(Building_Id,Building_Name,Floor,Room_No,Capacity,Available,Event_Alloted(ID)) VALUES(:building_id,:building_name,:floor,:Room_no,:Capacity,:Availability,:EVENT_ID)";
$query = $dbh->prepare($sql);
$query->bindParam(':building_id',$building_id,PDO::PARAM_INT);
$query->bindParam(':building_name',$building_name,PDO::PARAM_STR);
$query->bindParam(':floor',$floor,PDO::PARAM_INT);
$query->bindParam(':Room_no',$Room_no,PDO::PARAM_STR);
$query->bindParam(':Capacity',$Capacity,PDO::PARAM_INT);
$query->bindParam(':Availability',$Availability,PDO::PARAM_INT);
$query->bindParam(':EVENT_ID',$EVENT_ID,PDO::PARAM_INT);
$query->execute();
$lastInsertId = $dbh->lastInsertId();
if($lastInsertId)
{
	echo '<script>alert("Event created successfully")</script>';
    echo "<script>window.location.href='add-event.php</script>";  
}
else 
{
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

	mysqli_query($conn,"INSERT INTO `venue_booking` (`Building_ID`, `Building_Name`, `Floor`, `Room_No`, `Capacity`, `Available`, `Event_Alloted(ID)`) VALUES ('$building_id', '$building_name', '$floor', '$Room_no', '$Capacity', '$Availability', '$EVENT_ID')"
	)  or die(mysqli_error($conn));

	mysqli_query($conn,"INSERT INTO `room` (`room_id`,`roomNo`,`floor`,`building`,`capacity`,`LastUpdationDate`) VALUES ('$building_id','$Room_no','$floor','$Building_Name','$Capacity','DEFAULT NULL ON UPDATE current_timestamp()')") or die(mysqli_error($conn));

	echo '<script>alert("Room added successfully")</script>';
    echo "<script>window.location.href='add-event.php</script>";  
}  
}


}    
?>
<!DOCTYPE html>
<html lang="en">

<head>

    <title>EMS | Add Room</title>

    <!-- Bootstrap Core CSS -->
    <link href="../vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="../vendor/metisMenu/metisMenu.min.css" rel="stylesheet">
    <link href="../dist/css/sb-admin-2.css" rel="stylesheet">
    <link href="../vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
 <style>
    .errorWrap {
    padding: 10px;
    margin: 0 0 20px 0;
    background: #fff;
    border-left: 4px solid #dd3d36;
    -webkit-box-shadow: 0 1px 1px 0 rgba(0,0,0,.1);
    box-shadow: 0 1px 1px 0 rgba(0,0,0,.1);
}
.succWrap{
    padding: 10px;
    margin: 0 0 20px 0;
    background: #fff;
    border-left: 4px solid #5cb85c;
    -webkit-box-shadow: 0 1px 1px 0 rgba(0,0,0,.1);
    box-shadow: 0 1px 1px 0 rgba(0,0,0,.1);
}
</style>
</head>
<body>
<div id="wrapper">
<!-- Navigation -->
<nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
<!-- / Header -->
<?php include_once('includes/header.php');?>
<!-- / Leftbar -->
<?php include_once('includes/leftbar.php');?>
</nav>

        <div id="page-wrapper">
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header"> Add Room</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                           Add Room
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-12">

<!-- Success / Error Message -->
 <?php if($error){?><div class="errorWrap"><strong>ERROR</strong> : <?php echo htmlentities($error); ?> </div><?php } 
else if($msg){?><div class="succWrap"><strong>SUCCESS</strong> : <?php echo htmlentities($msg); ?> </div><?php }?> 

<form role="form" method="post" enctype="multipart/form-data">


<!--categrory Name -->
<div class="form-group">
<label>Building_ID</label>
<input class="form-control" type="number" name="category" autocomplete="off" required autofocus>
</div>


<!--Sponser logo -->
<div class="form-group">
<label>Building_Name</label>
<input class="form-control" type="text" name="sponser" autocomplete="off" required autofocus>
</div>

<!--Event name -->
<div class="form-group">
<label>Floor</label>
<input class="form-control" type="number" name="eventname" autocomplete="off" required autofocus>
</div>

<!--Event Start date -->
<div class="form-group">
<label>Room_No</label> 
<input  class="form-control" type="text" name="evetndescription" autocomplete="off" required autofocus />
</div>

<!--Event End Date -->
<div class="form-group">
<label>Capacity</label>
<input  class="form-control" type="number" name="eventstartdate" autocomplete="off" required autofocus />
</div>


<!--Button -->                       
<button type="submit" class="btn btn-default" name="add">Add Room</button>
                                    </form>
                                </div>

                            </div>
                            <!-- /.row (nested) -->
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
        </div>
        <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->

    <!-- jQuery -->
    <script src="../vendor/jquery/jquery.min.js"></script>
    <script src="../vendor/bootstrap/js/bootstrap.min.js"></script>
    <script src="../vendor/metisMenu/metisMenu.min.js"></script>
    <script src="../dist/js/sb-admin-2.js"></script>
</body>
</html>
<?php } ?>
