<?php
session_start();
error_reporting(0);
include('includes/config.php');
if(strlen($_SESSION['adminsession'])==0)
{   
header('location:logout.php');
}
else{ 
if(isset($_POST['update']))
{
// Posted Values
$sponser=$_POST['sponser'];
$sponserid=intval($_GET['sid']);
// Query for insertion data into database
$sql="update tblsponsers set sponserName=:sponser where id=:sponserid";
$query = $dbh->prepare($sql);
$query->bindParam(':sponser',$sponser,PDO::PARAM_STR);
$query->bindParam(':sponserid',$sponserid,PDO::PARAM_STR);
$query->execute();
$msg="Sponser info updated";
}  
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <title>EMS | Edit Sponer</title>
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
                    <h1 class="page-header"> Edit Sponser</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                           Edit Sponser
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-6">

<!-- Success / Error Message -->
 <?php if($error){?><div class="errorWrap"><strong>ERROR</strong> : <?php echo htmlentities($error); ?> </div><?php } 
else if($msg){?><div class="succWrap"><strong>SUCCESS</strong> : <?php echo htmlentities($msg); ?> </div><?php }?> 

<form role="form" method="post">
<?php
$sponserid=intval($_GET['sid']);
$sql = "SELECT id,sponserName,sponserLogo,postingDate from tblsponsers where id=:sponserid";
$query = $dbh -> prepare($sql);
$query->bindParam(':sponserid',$sponserid,PDO::PARAM_STR);
$query->execute();
$results=$query->fetchAll(PDO::FETCH_OBJ);
$cnt=1;
if($query->rowCount() > 0)
{
foreach($results as $row)
{ 
    ?>

<!--Sponser Name -->
<div class="form-group">
<label>Sponser</label>
<input class="form-control" type="text" name="sponser" value="<?php echo htmlentities($row->sponserName);?>" autocomplete="off" required autofocus>
</div>
<!--Sponser Logo -->
<div class="form-group">
<label>Sponser Logo :</label>
<img src="sponsers/<?php echo htmlentities($row->sponserLogo);?>" width="250" height="200" />
<a href="update-sponserlogo.php?sid=<?php echo htmlentities($row->id);?>">Update Logo</a>
</div>
<?php  }}?>

<!--Button --> 
<div class="form-group" align="center">                      
<button type="submit" class="btn btn-primary" name="update">Update</button>
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
