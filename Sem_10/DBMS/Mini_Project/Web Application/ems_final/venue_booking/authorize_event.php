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
    $event_name=$_POST['Event-Name'];
    $room_name=$_POST['room-id'];
    
    // Posted Values
    $event_name='FAREWELL';
    $room_name='SDS-122';
    // get the image extension
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "ems";
    // Establish database connection.
    $conn = new mysqli($servername, $username, $password, $dbname);
    // Check connection
    if ($conn->connect_error) 
    {
        die("Connection failed: " . $conn->connect_error);
    } 
    else
    {

        $idevent=0;
        $sql = "SELECT id , EventName FROM tblevents  
        WHERE EventName = '".$event_name."'";
        $result= $conn->query($sql); //or die(mysqli_error($conn));
        if($result->num_rows > 0)
        {
            $row=$result->fetch_assoc();
            $idevent=$row["id"];
        }
        else echo "Failed";
        
        $idroom = 0;
        $sql = "SELECT room_id , roomNo FROM room  
        WHERE roomNo = '".$room_name."'";

        $result= $conn->query($sql); //or die(mysqli_error($conn));
        if($result->num_rows > 0)
        {
            $row=$result->fetch_assoc();
            $idroom=$row["room_id"];
        }
        else echo "Failed";

        $conn = mysqli_connect($servername, $username, $password, $dbname);
        // Check connection
        if (!$conn) {
            die("Connection failed: " . mysqli_connect_error());
        }
        else
        {

            $isActive= 1;
            $authorized_by = 77;
            mysqli_query($conn,"INSERT INTO `room_booking` (`booking_id`, `room_id`, `isActive`, `authorized_by`,`LastUpdationDate`) VALUES ('$idevent', '$idroom', '$isActive', '$authorized_by', 'DEFAULT NULL ON UPDATE current_timestamp()')"
            )  or die(mysqli_error($conn));

             $conn = new mysqli($servername, $username, $password, $dbname);
             $sql = "UPDATE venue_booking SET Available = 0 WHERE Room_No = '".$idroom."'";
                if ($conn->query($sql) === TRUE) 
                {
                        echo "Record updated successfully";
                } 
                else
                {
                        echo "Error updating record: " . $conn->error;
                }


            echo '<script>alert("Room alloted successfully")</script>';
            echo "<script>window.location.href='authorize_event.php</script>";  
        } 
    }  



}    
?>
<!DOCTYPE html>
<html lang="en">

<head>

    <title>EMS | Allot Room</title>

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
<?php //include_once('includes/header.php');?>
<?php include_once('includes/leftbar.php');?>
<!-- / Leftbar -->
</nav>

        <div id="page-wrapper">
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header"> Allot Room</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                           Add Event
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
<label>Event-Name</label>
<select class="form-control"  name="Event-Name" autocomplete="off" required >
<option>Select</option>
<?php
$sql = "SELECT tblevents.id ,tblevents.EventName from tblevents";
$query = $dbh -> prepare($sql);
$query->execute();
$results=$query->fetchAll(PDO::FETCH_OBJ);
$cnt=1;
if($query->rowCount() > 0)
{
foreach($results as $row)
{ ?>  
<option value="<?php echo htmlentities($row->id);?>"><?php echo htmlentities($row->EventName);?></option>
<?php }} ?>
</select>
</div>


<!--room-id logo -->
<div class="form-group">
<label>Available-Rooms : </label>

<select class="form-control"  name="room-id" autocomplete="off" required >
<option>Select</option>
<?php
$sql = "SELECT Room_No from venue_booking WHERE Available!=0";
$query = $dbh -> prepare($sql);
$query->execute();
$results=$query->fetchAll(PDO::FETCH_OBJ);
$cnt=1;
if($query->rowCount() > 0)
{
foreach($results as $row)
{ ?>  
<option value="<?php echo htmlentities($row->Room_No);?>"><?php echo htmlentities($row->Room_No);?></option>
<?php }} ?>
</select>

</div>


<!--Button -->                       
<button type="submit" class="btn btn-default" name="add">Allot Room</button>
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
