<?php
session_start();
//error_reporting(0);
include('includes/config.php');
if(strlen($_SESSION['adminsession'])==0)
{   
header('location:logout.php');
}
else{ 
if(isset($_POST['update']))
{
//Getting Values
$eventid=intval($_GET['sid']);    
// Posted Values
$catid=$_POST['category'];
$spnserid=$_POST['sponser'];
$ename=$_POST['eventname'];
$ediscription=$_POST['evetndescription'];
$esdate=$_POST['eventstartdate'];
$eedate=$_POST['eventenddate'];
$elocation=$_POST['eventlocation'];

// Query for updation  data into database
$sql="UPDATE  tblevents set CategoryId=:catid,SponserId=:spnserid,EventName=:ename,EventDescription=:ediscription,EventStartDate=:esdate,EventEndDate=:eedate,EventLocation=:elocation where id=:eid";
$query = $dbh->prepare($sql);
$query->bindParam(':catid',$catid,PDO::PARAM_STR);
$query->bindParam(':spnserid',$spnserid,PDO::PARAM_STR);
$query->bindParam(':ename',$ename,PDO::PARAM_STR);
$query->bindParam(':ediscription',$ediscription,PDO::PARAM_STR);
$query->bindParam(':esdate',$esdate,PDO::PARAM_STR);
$query->bindParam(':eedate',$eedate,PDO::PARAM_STR);
$query->bindParam(':elocation',$elocation,PDO::PARAM_STR);
$query->bindParam(':eid',$eventid,PDO::PARAM_STR);
$query->execute();

echo "<script>alert('Success : Event details updated successfully ');</script>";
echo "<script>window.location.href='manage-events.php'</script>";
}
   
?>
<!DOCTYPE html>
<html lang="en">

<head>

    <title>EMS | Add Event</title>

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
                    <h1 class="page-header"> Edit Event</h1>
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


<form role="form" method="post" enctype="multipart/form-data">
<?php
$eventid=intval($_GET['sid']);
$sql = "SELECT  tblevents.id as eid,tblevents.EventName,tblevents.EventStartDate,tblevents.EventEndDate,tblcategory.CategoryName as catname,tblcategory.id as catid,tblsponsers.sponserName as spnrname,tblsponsers.id as spnserid,tblevents.EventDescription,tblevents.EventLocation,tblevents.EventImage from tblevents left join tblcategory on tblcategory.id=tblevents.CategoryId left join tblsponsers on tblsponsers.id=tblevents.SponserId where tblevents.id=:eid";
$query = $dbh -> prepare($sql);
$query->bindParam(':eid',$eventid,PDO::PARAM_STR);
$query->execute();
$results=$query->fetchAll(PDO::FETCH_OBJ);
$cnt=1;
if($query->rowCount() > 0)
{
foreach($results as $result)
{ 
    ?>
<!--categrory Name -->
<div class="form-group">
<label>Category</label>
<select class="form-control"  name="category" autocomplete="off" required >
<option value="<?php echo htmlentities($result->catid);?>"><?php echo htmlentities($ctname=$result->catname);?></option>
<?php
$sql = "SELECT id,CategoryName,CategoryDescription,CreationDate,IsActive from tblcategory";
$query = $dbh -> prepare($sql);
$query->execute();
$results=$query->fetchAll(PDO::FETCH_OBJ);
$cnt=1;
if($query->rowCount() > 0)
{
foreach($results as $row)
{ 
if($ctname==$row->CategoryName){
continue;
}
else{
?>  
<option value="<?php echo htmlentities($row->id);?>"><?php echo htmlentities($row->CategoryName);?></option>
<?php }} }?>
</select>
</div>


<!--Sponser logo -->
<div class="form-group">
<label>Event Sponsors : </label>

<select class="form-control"  name="sponser" autocomplete="off" required >
<option value="<?php echo htmlentities($result->spnserid);?>"><?php echo htmlentities($spnname=$result->spnrname);?></option>
<?php
$sql = "SELECT id,sponserName from tblsponsers";
$query = $dbh -> prepare($sql);
$query->execute();
$results=$query->fetchAll(PDO::FETCH_OBJ);
$cnt=1;
if($query->rowCount() > 0)
{
foreach($results as $row)
{ 
if($spnname==$row->sponserName){
continue;
}
else{
    ?>  
<option value="<?php echo htmlentities($row->id);?>"><?php echo htmlentities($row->sponserName);?></option>
<?php }}} ?>
</select>

</div>

<!--Event name -->
<div class="form-group">
<label>Event Name</label>
<input class="form-control" type="text" name="eventname" autocomplete="off" value="<?php echo htmlentities($result->EventName);?>" required >
</div>

<!--Event Description -->
<div class="form-group">
<label>Event Description</label>
<textarea class="form-control" type="text" name="evetndescription" rows="5" autocomplete="off" required ><?php echo htmlentities($result->EventDescription);?></textarea>
</div>

<!--Event Start date -->
<div class="form-group">
<label>Event Start Date</label> 
<input  class="form-control" type="date" name="eventstartdate" value="<?php echo htmlentities($result->EventStartDate);?>" autocomplete="off" required  />
</div>

<!--Event End Date -->
<div class="form-group">
<label>Event End Date</label>
<input  class="form-control" type="date" name="eventenddate" autocomplete="off" value="<?php echo htmlentities($result->EventEndDate);?>" required  />
</div>

<!--Event Location -->
<div class="form-group">
<label>Event location</label>
<input  class="form-control" type="text" name="eventlocation" autocomplete="off" value="<?php echo htmlentities($result->EventLocation);?>" required  />
</div>

<!--Event Featured Image -->
<div class="form-group">
<label>Event Featured Image : </label>
<img src="eventimages/<?php echo htmlentities($result->EventImage);?>" style="border:solid #000 1px" width="300"><a href="change-event-image.php?evntid=<?php echo htmlentities($result->eid);?>"> Change Event Imgae </a>
</div>
<?php }} ?>
<!--Button -->  
<div class="form-group" align="center">                     
<button type="submit" class="btn btn-primary" name="update">Update Event</button>
</div>
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
