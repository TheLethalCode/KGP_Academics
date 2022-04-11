<?php
session_start();
error_reporting(0);
include('includes/config.php');
if(strlen($_SESSION['adminsession'])==0)
{   
header('location:logout.php');
}
else{ 
// update Process
if(isset($_POST['update']))
{

//Getting User id  
$uid=intval($_GET['uid']);
// Getting Post values
$fname=$_POST['name'];
$emailid=$_POST['email'];   
$pnumber=$_POST['phonenumber']; 
$gender=$_POST['gender']; 
$status=$_POST['status'];
// query for data updation
$sql="update  tblusers set FullName=:fname,Emailid=:emailid,PhoneNumber=:pnumber,UserGender=:gender,IsActive=:status where Userid=:uid ";
//preparing the query
$query = $dbh->prepare($sql);
//Binding the values
$query->bindParam(':fname',$fname,PDO::PARAM_STR);
$query->bindParam(':emailid',$emailid,PDO::PARAM_STR);
$query->bindParam(':pnumber',$pnumber,PDO::PARAM_STR);
$query->bindParam(':gender',$gender,PDO::PARAM_STR);
$query->bindParam(':status',$status,PDO::PARAM_STR);
$query->bindParam(':uid',$uid,PDO::PARAM_STR);
$query->execute();

echo "<script>alert('Success : Profile updated Successfully.');</script>";
echo "<script>window.location.href='manage-users.php'</script>"; 

}    
?>
<!DOCTYPE html>
<html lang="en">

<head>

    <title>EMS | Edit Category</title>

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
                    <h1 class="page-header"> Edit User Profile</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                           Edit User Profile
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-6">
<form role="form" method="post" onSubmit="return valid();" name="chngpwd">
<!-- Success / Error Message -->
 <?php if($error){?><div class="errorWrap"><strong>ERROR</strong> : <?php echo htmlentities($error); ?> </div><?php } 
else if($msg){?><div class="succWrap"><strong>SUCCESS</strong> : <?php echo htmlentities($msg); ?> </div><?php }?> 



<?php
$usrid=intval($_GET['uid']);
$sql = "SELECT Userid,FullName,UserName,Emailid,PhoneNumber,UserGender,IsActive,RegDate,LastUpdationDate,UserGender from tblusers where Userid=:usrid";
$query = $dbh -> prepare($sql);
$query->bindParam(':usrid',$usrid,PDO::PARAM_STR);
$query->execute();
$results=$query->fetchAll(PDO::FETCH_OBJ);
$cnt=1;
if($query->rowCount() > 0)
{
foreach($results as $row)
{ 
    ?>
<h3 align="center"><?php echo htmlentities($row->FullName);?>'s Profile</h3>
<hr />
<!--Registration Date -->
<p><strong>Reg Date : </strong><?php echo htmlentities($row->RegDate);?></p>

<!--Last Updation Date -->
<?php if($row->LastUpdationDate!=""){?>    
<p><strong>Last Updated at : </strong><?php echo htmlentities($row->LastUpdationDate);?></p>
<?php } ?>
<!--username -->
<div class="form-group">
<label>Username</label>
<input class="form-control" type="text" name="username" value="<?php echo htmlentities($row->UserName);?>" readonly>
</div>

<!--Fullanme -->
<div class="form-group">
<label>Fullname</label>
<input class="form-control" type="text" name="name" value="<?php echo htmlentities($row->FullName);?>" required>
</div>


<!--Email id -->
<div class="form-group">
<label>Email id</label>
<input class="form-control" type="email" name="email" value="<?php echo htmlentities($row->Emailid);?>" required>
</div>


<!--Phone Number -->
<div class="form-group">
<label>Phone Number</label>
<input class="form-control" type="test" name="phonenumber" pattern="[0-9]{10}" title="10 numeric characters only" value="<?php echo htmlentities($row->PhoneNumber);?>" required>
</div>


<!--Gender -->
<div class="form-group">
<label>Gender</label>
<select class="form-control" name="gender" required="true">
<option value="<?php echo htmlentities($row->UserGender);?>"><?php echo htmlentities($row->UserGender);?></option>    
<option value="Male">Male</option>
<option value="Female">Female</option>
<option value="Transgender">Transgender</option>
</select>
</div>



<!--status -->
<div class="form-group">
<label>Status</label>
<select class="form-control" name="status" required >
<?php
$status=$row->IsActive;
if($status==1):
?>
<option value="1">Active</option>   
<option value="0">Blocked</option>   
<?php else: ?>
 <option value="0">Blocked</option> 
      <option value="1">Active</option>  
<?php endif; ?>
</select>
</div>

<?php }} ?>

<!--Button -->   
<div class="form-group" align="center">                 
<button type="submit" class="btn btn-primary" name="update">Update</button>
 </div>                                   </form>
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
