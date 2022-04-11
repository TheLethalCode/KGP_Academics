<?php
//datbase connection file
include('includes/config.php');
error_reporting(0);
// Signup Process
if(isset($_POST['signup']))
{

// Getting Post values
$fname=$_POST['name'];
$uname=$_POST['username'];
$emailid=$_POST['email'];   
$pnumber=$_POST['phonenumber']; 
$gender=$_POST['gender']; 
$password=md5($_POST['pass']);  
$status=1;
// query for data insertion
$sql="INSERT INTO event_manager(FullName,UserName,Emailid,PhoneNumber,Gender,Password,IsActive) VALUES(:fname,:uname,:emailid,:pnumber,:gender,:password,:status)";
//preparing the query
$query = $dbh->prepare($sql);
//Binding the values
$query->bindParam(':fname',$fname,PDO::PARAM_STR);
$query->bindParam(':uname',$uname,PDO::PARAM_STR);
$query->bindParam(':emailid',$emailid,PDO::PARAM_STR);
$query->bindParam(':pnumber',$pnumber,PDO::PARAM_STR);
$query->bindParam(':gender',$gender,PDO::PARAM_STR);
$query->bindParam(':password',$password,PDO::PARAM_STR);
$query->bindParam(':status',$status,PDO::PARAM_STR);
//Execute the query
$query->execute();
//Check that the insertion really worked
$lastInsertId = $dbh->lastInsertId();
if($lastInsertId)
{
echo "<script>alert('Success : Event Manager signup successfull. Now you can signin');</script>";
echo "<script>window.location.href='index.php'</script>";	
}
else 
{
echo "<script>alert('Error : Something went wrong. Please try again');</script>";	
}

}

    ?>

<!doctype html>
<html class="no-js" lang="en">
    <head>

        <title>Event Management System | Event Manager signup </title>
		<!-- bootstrap v3.3.6 css -->
        <link rel="stylesheet" href="css/bootstrap.min.css">
		<!-- animate css -->
        <link rel="stylesheet" href="css/animate.css">
		<!-- meanmenu css -->
        <link rel="stylesheet" href="css/meanmenu.min.css">
		<!-- owl.carousel css -->
        <link rel="stylesheet" href="css/owl.carousel.css">
		<!-- icofont css -->
        <link rel="stylesheet" href="css/icofont.css">
		<!-- Nivo css -->
        <link rel="stylesheet" href="css/nivo-slider.css">
		<!-- animaton text css -->
        <link rel="stylesheet" href="css/animate-text.css">
		<!-- Metrial iconic fonts css -->
        <link rel="stylesheet" href="css/material-design-iconic-font.min.css">
		<!-- style css -->
		<link rel="stylesheet" href="style.css">
		<!-- responsive css -->
        <link rel="stylesheet" href="css/responsive.css">
        <!-- color css -->
		<link href="css/color/skin-default.css" rel="stylesheet">
        
		<!-- modernizr css -->
        <script src="js/vendor/modernizr-2.8.3.min.js"></script>
<script>
function checkusernameAvailability() {
$("#loaderIcon").show();
jQuery.ajax({  
url: "check_availability.php", 
data:'uname='+$("#username").val(), 
type: "POST",
success:function(data){
$("#username-availabilty-status").html(data);
$("#loaderIcon").hide();
},
error:function (){}
});
}
</script>

    </head>
    <body>
        <!--body-wraper-are-start-->
         <div class="wrapper single-blog">
           <!--slider header area are end-->
            
            <!--  breadcumb-area start-->
            <div class="breadcumb-area bg-overlay">
                <div class="container">
                    <ol class="breadcrumb">
                        <li><a href="index.html">Event Manager</a></li>
                        <li class="active"> Signup </li>
                    </ol>
                </div>
            </div> 

            <div class="single-blog-area ptb100 fix">
               <div class="container">
                   <div class="row">
                       <div class="col-md-8 col-sm-7">
                           <div class="single-blog-body">


                        
                                <div class="Leave-your-thought mt50">
                                    <h3 class="aside-title uppercase">EM Signup</h3>
                                    <div class="row">
                                        <form name="signup" method="post">
                                            <div class="col-md-12 col-sm-6 col-xs-12 lyt-left">
                                                <div class="input-box leave-ib">
<input type="text" placeholder="Name" class="info" name="name" required="true">
<input type="text" placeholder="Username" class="info" name="username" id="username" required="true" onBlur="checkusernameAvailability()">
<span id="username-availabilty-status" style="font-size:14px;"></span> 
<input type="email" placeholder="Email Id" class="info" name="email" required="true">
<input type="tel" placeholder="Phone Number" pattern="[0-9]{10}" title="10 numeric characters only" class="info" name="phonenumber" maxlength="10" required="true">
<select class="info" name="gender" required="true">
<option value="">Select Gender</option>	
<option value="Male">Male</option>
<option value="Female">Female</option>
<option value="Transgender">Transgender</option>
</select>
<input type="password" name="pass" placeholder="Password" class="info" required /> 
</div>
                                            </div>
                                       
                                            <div class="col-xs-12">
                                                <div class="input-box post-comment">
                                                    <input type="submit" value="Submit" id="signup" name="signup" class="submit uppercase"> 
                                                </div>
                                            </div>
 <div class="col-xs-12 mt30">
 <div class="input-box post-comment" style="color:blue;"> 
 	Already Registered  <a href="index.php"> Signin here</a>
</div>
</div>


                                        </form>
                                    </div>
                                </div>
                           </div>
                       </div>
                        <!--sidebar-->
                       
               </div>
           </div></div>
            <!--main blog area start-->

            <!--information area are start-->
            <!--footer area are start-->
         </div>   
        <!--body-wraper-are-end-->
		
		<!--==== all js here====-->
		<!-- jquery latest version -->
        <script src="js/vendor/jquery-3.1.1.min.js"></script>
		<!-- bootstrap js -->
        <script src="js/bootstrap.min.js"></script>
		<!-- owl.carousel js -->
        <script src="js/owl.carousel.min.js"></script>
		<!-- meanmenu js -->
        <script src="js/jquery.meanmenu.js"></script>
		<!-- Nivo js -->
        <script src="js/nivo-slider/jquery.nivo.slider.pack.js"></script>
        <script src="js/nivo-slider/nivo-active.js"></script>
		<!-- wow js -->
        <script src="js/wow.min.js"></script>
        <!-- Youtube Background JS -->
        <script src="js/jquery.mb.YTPlayer.min.js"></script>
		<!-- datepicker js -->
        <script src="js/bootstrap-datepicker.js"></script>
		<!-- waypoint js -->
        <script src="js/waypoints.min.js"></script>
		<!-- onepage nav js -->
        <script src="js/jquery.nav.js"></script>
        <!-- animate text JS -->
        <script src="js/animate-text.js"></script>
		<!-- plugins js -->
        <script src="js/plugins.js"></script>
        <!-- main js -->
        <script src="js/main.js"></script>
    </body>
</html>
