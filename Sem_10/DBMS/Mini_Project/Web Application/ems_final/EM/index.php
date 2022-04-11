<?php
session_start();
include('includes/config.php');
if(isset($_POST['login']))
{

// getting post values
$username=$_POST['username'];
$password=md5($_POST['password']);
// Sql Query for checking login details
$sql ="SELECT EMid,UserName,Password FROM event_manager WHERE UserName=:username and Password=:password";
$query= $dbh -> prepare($sql);
// binding post values
$query-> bindParam(':username', $username, PDO::PARAM_STR);
$query-> bindParam(':password', $password, PDO::PARAM_STR);
$query-> execute();
$results=$query->fetchAll(PDO::FETCH_OBJ);
//if login details verified
if($query->rowCount() > 0)
{
// fetching id for session
foreach($results as $result)
{
$_SESSION['EMsession']=$result->EMid;

}
echo "<script type='text/javascript'> document.location ='dashboard.php'; </script>";
} else{
    // For invalid details
echo "<script>alert('Invalid Details');</script>";
}

}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Event Management System | Event Manager login </title>
    <link href="../vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="../vendor/metisMenu/metisMenu.min.css" rel="stylesheet">
    <link href="../dist/css/sb-admin-2.css" rel="stylesheet">
    <link href="../vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
</head>
<body>

    <div class="container">
<div class="row"> 
<div class="col-md-12" align="center">
<h3>Event Management System  | Event Manager</h3>
</div>


    </div>
        <div class="row">
            <div class="col-md-4 col-md-offset-4">
                <div class="login-panel panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title">Please Sign In</h3>
                    </div>
                    <div class="panel-body">
                        <form role="form" method="post">
                           
                            <fieldset>
<!--Username -->
<div class="form-group"> 
<input class="form-control" placeholder="User name" name="username" type="text" autofocus required="true">
</div>

<!--Password -->
<div class="form-group">
<input class="form-control" placeholder="Password" name="password" type="password"  required="true" autofocus>
</div>

<!--Submit Button -->                           
<input type="submit" name="login"  class="btn btn-lg btn-success btn-block"  value="submit"> 

<div class="col-xs-12 mt30">
 <div class="input-box post-comment" style="color:green;"> 
    <br>Not Registered Yet ?  <br><a href="signup.php">Signup here</a>
</div>
</div>
                           </fieldset>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- jQuery -->
    <script src="../vendor/jquery/jquery.min.js"></script>
    <script src="../vendor/bootstrap/js/bootstrap.min.js"></script>
    <script src="../vendor/metisMenu/metisMenu.min.js"></script>
    <script src="../dist/js/sb-admin-2.js"></script>
</body>
</html>
