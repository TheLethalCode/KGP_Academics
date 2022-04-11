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
$websitename=$_POST['Websitename'];
$pnumber=$_POST['phonenumber'];
$email=$_POST['emailid'];
$address=$_POST['address'];
$ftext=$_POST['footertext'];
$sql="update  tblgenralsettings set SiteName=:websitename,PhoneNumber=:pnumber,EmailId=:email,address=:address,footercontent=:ftext";
$query = $dbh->prepare($sql);
$query->bindParam(':websitename',$websitename,PDO::PARAM_STR);
$query->bindParam(':pnumber',$pnumber,PDO::PARAM_STR);
$query->bindParam(':email',$email,PDO::PARAM_STR);
$query->bindParam(':address',$address,PDO::PARAM_STR);
$query->bindParam(':ftext',$ftext,PDO::PARAM_STR);
$query->execute();
echo "<script>alert('Success : Data updated successfully');</script>";
echo "<script>window.location.href='website-setting.php'</script>";
}    
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <title>EMS | General Setting</title>
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
<form method="post" name="generalsetting">
        <div id="page-wrapper">
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header"> General Setting</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <?php
$sql = "SELECT * from tblgenralsettings";
$query = $dbh -> prepare($sql);
$query->execute();
$results=$query->fetchAll(PDO::FETCH_OBJ);
$cnt=1;
if($query->rowCount() > 0)
{
foreach($results as $row)
{ 
?>

            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                           Header Setting
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-6">

<!--Websitename Name -->
<div class="form-group">
<label>Website name</label>
<input class="form-control" type="text" name="Websitename" value="<?php echo htmlentities($row->SiteName);?>" autocomplete="off" required >
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




          <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                           Other Settings
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-6">

<!--Phone number -->
<div class="form-group">
<label>Phone Number</label>
<input class="form-control" type="text" name="phonenumber" value="<?php echo htmlentities($row->PhoneNumber);?>" autocomplete="off" required>
</div>

<!--Email -->
<div class="form-group">
<label>Email Id</label>
<input class="form-control" type="email" name="emailid" value="<?php echo htmlentities($row->EmailId);?>" autocomplete="off" required>
</div>

<!--Address -->
<div class="form-group">
<label>Address</label>
<textarea class="form-control" name="address"  required><?php echo htmlentities($row->address);?></textarea>
</div>

<!--Footer Text -->
<div class="form-group">
<label>Footer Text</label>
<textarea class="form-control" name="footertext"  required><?php echo htmlentities($row->footercontent);?></textarea>
</div>


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
<?php }} ?>

</form>
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
