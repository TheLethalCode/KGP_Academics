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
$fname=$_POST['fullname'];
$admemail=$_POST['adminemail'];
$aid=$_SESSION['adminsession'];

$con="update admin set FullName=:fname,AdminEmail=:admemail where id=:aid";
$query = $dbh->prepare($con);
$query-> bindParam(':aid', $aid, PDO::PARAM_STR);
$query-> bindParam(':fname', $fname, PDO::PARAM_STR);
$query-> bindParam(':admemail', $admemail, PDO::PARAM_STR);
$query->execute();
$msg="Your profile updated.";
}
  
?>
<!DOCTYPE html>
<html lang="en">

<head>

    <title>EMS | Admin Profile</title>

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
                    <h1 class="page-header">Admin Profile</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                        Admin Profile
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-6">
<form role="form" method="post" onSubmit="return valid();" name="chngpwd">
<!-- Success  Message -->
 <?php if($msg){?><div class="succWrap"><strong>SUCCESS</strong> : <?php echo htmlentities($msg); ?> </div><?php }?> 

<?php
$aid=$_SESSION['adminsession'];
$sql ="SELECT FullName,AdminEmail,UserName,updationDate FROM admin where id=:aid";
$query= $dbh -> prepare($sql);
$query-> bindParam(':aid', $aid, PDO::PARAM_STR);
$query-> execute();
$results = $query -> fetchAll(PDO::FETCH_OBJ);
if($query -> rowCount() > 0)
{
foreach ($results as $row) {
 ?>

<!--Current Pasword -->
<div class="form-group">
<label>Full Name </label>
<input class="form-control" type="text" value="<?php echo htmlentities($row->FullName);?>" name="fullname" autocomplete="off" required autofocus>
</div>
<!--New Pasword -->
<div class="form-group">
<label>Admin Email-Id</label>
<input class="form-control" type="email" value="<?php echo htmlentities($row->AdminEmail);?>"  name="adminemail" autocomplete="off" required autofocus />
</div>
<!--Confirm Pasword -->
<div class="form-group">
<label>UserName</label>
<input class="form-control" value="<?php echo htmlentities($row->UserName);?>"   type="text" name="username" autocomplete="off" readonly  />
</div>

<?php }} ?>
<!--Button -->                       
<button type="submit" class="btn btn-default" name="update">Update</button>
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
