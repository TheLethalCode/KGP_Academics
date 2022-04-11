
<?php
session_start();
error_reporting(0);
include('includes/config.php');
// Signup Process
if(isset($_POST['book']))
{

$bokkingid = mt_rand(100000000, 999999999);
$userid=$_SESSION['usrid'];
$eid=intval($_GET['evntid']);
// Getting Post values
$noofmembers=$_POST['noofmembers'];
$usrremark=$_POST['userremark'];



// query for data insertion
$sql="INSERT INTO tblbookings(BookingId,UserId,EventId,NumberOfMembers,UserRemark) VALUES(:bokkingid,:userid,:eid,:noofmembers,:usrremark)";
//preparing the query
$query = $dbh->prepare($sql);
//Binding the values
$query->bindParam(':bokkingid',$bokkingid,PDO::PARAM_STR);
$query->bindParam(':userid',$userid,PDO::PARAM_STR);
$query->bindParam(':eid',$eid,PDO::PARAM_STR);
$query->bindParam(':noofmembers',$noofmembers,PDO::PARAM_STR);
$query->bindParam(':usrremark',$usrremark,PDO::PARAM_STR);
//Execute the query
$query->execute();
//Check that the insertion really worked
$lastInsertId = $dbh->lastInsertId();
if($lastInsertId)
{
echo '<script>alert("Event booked successfully. Booking number is "+"'.$bokkingid.'")</script>';
echo "<script>window.location.href='my-bookings.php'</script>";  
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
        <title>Event Details </title>
		<!-- all css here -->
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
    </head>
    <body>
        <!--body-wraper-are-start-->
         <div id="home" class="wrapper event-details">
         
           <!--slider header area are start-->
           <div id="home" class="header-slider-area">
                <!--header start-->
           <?php include_once('includes/header.php');?>
                <!-- header End-->
            </div>
           <!--slider header area are end-->

            <!--  breadcumb-area start-->
            <div class="breadcumb-area bg-overlay">
                <div class="container">
                    <ol class="breadcrumb">
                        <li><a href="index.php">Home</a></li>
                        <li class="active">Event-details</li>
                    </ol>
                </div>
            </div> 
            <!--  breadcumb-area end--> 
<?php
// Event Details
$eid=intval($_GET['evntid']);
$isactive=1;
$sql = "SELECT tblcategory.CategoryName,tblevents.EventName,tblevents.EventLocation,tblevents.EventStartDate,tblevents.EventEndDate,tblevents.EventImage,tblevents.id,tblevents.EventDescription,tblevents.PostingDate,tblsponsers.sponserName,tblsponsers.sponserLogo,tblevents.EventImage from tblevents left join tblcategory on tblcategory.id=tblevents.CategoryId left join tblsponsers on tblsponsers.id=tblevents.SponserId where tblevents.id=:eid and tblevents.IsActive=:isactive";
$query = $dbh -> prepare($sql);
$query->bindParam(':isactive',$isactive,PDO::PARAM_STR);
$query->bindParam(':eid',$eid,PDO::PARAM_STR);
$query->execute();
$results=$query->fetchAll(PDO::FETCH_OBJ);
$cnt=1;
if($query->rowCount() > 0)
{
foreach($results as $row)
{ 
    ?>           


            <!--about area are start-->
            <div class="about-area ptb100 fix" id="about-event">
                <div class="container">
                    <div class="row">
                        <div class="col-md-6 col-sm-6 col-xs-12">
                            <div class="about-left">
                                <div class="about-top">
                                    <h1 class="section-title"> <?php echo htmlentities($row->EventName);?> Details</h1>
                                    <div class="total-step">
                                        <div class="descp">
                                            <p><?php echo htmlentities($row->EventDescription);?></p>
                                        </div>
                                     </div>
                                </div>
    <h3>Sponser</h3>
                                <div class="total-step">
                                    <div class="about-step">
                                        <h2 class="sub-title"><?php echo htmlentities($row->sponserName);?></h2>
                                        <div class="descp">
 <p><img src="admin/sponsers/<?php echo htmlentities($row->sponserLogo);?>" width="270" style="border:solid 1px #000"></p>
                                        </div>
                                    </div>
                                </div>
                            </div>  
<p style="margin-top:4%"><b>Posting Date:</b> <?php echo htmlentities($row->PostingDate);?></p>                         
                        </div>

                        <div class="col-md-6 col-sm-6 col-xs-12">

                             <p align="center"><img src="admin/eventimages/<?php echo htmlentities($row->EventImage);?>" width="350" style="border:solid 1px #000"  ></p>
                            <div class="about-right">
                                <ul>

                                      <li><i class="zmdi zmdi-palette"></i><?php echo htmlentities($row->CategoryName);?> (Category)</li>
                                    <li><i class="zmdi zmdi-calendar-note"></i>
                                        <?php echo htmlentities($row->EventStartDate);?> To
                                        <?php echo htmlentities($evntenddate=$row->EventEndDate);?></li>
                                    <li><i class="zmdi zmdi-pin"></i><?php echo htmlentities($row->EventLocation);?> </li>             
                                </ul>
                                <?php 
$cadte=date('Y-m-d');
if($cadte<=$evntenddate){
if(strlen($_SESSION['usrid'])=='0'){
    ?>
<div class="about-btn"> <a href="signin.php" class="btn-def bnt-2">Book Now</a> </div>  
<?php } else{?>

<div class="about-btn"> 
<button type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="#myModal">Book Now</button></div> 

<?php }} else { ?>
  <div class="about-btn"> <a href="#" class="btn-def bnt-2">Event Expired</a> </div>  
<?php } ?>     
 </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--about area are end-->
        <?php }} else {?>
     <h3 align="center" style="color:red; margin-top: 4%">No record found</h3>
 <?php }?>

<!-- Modal -->
<div id="myModal" class="modal fade" role="dialog" style="margin-top:10%">
  <div class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Book event</h4>
      </div>
      <div class="modal-body">
        <form name="bookevent" method="post">
        <p><input type="text" placeholder="Number of members" class="info" name="noofmembers" required="true"></p>
          <p><textarea  placeholder="User remark" class="info" name="userremark" required="true"></textarea></p>
          <p><button type="submit" class="btn btn-info btn-lg" name="book">Submit</button></p>
    </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
      </div>
    </div>

  </div>
</div>
            <!--information area are start-->
        <?php include_once('includes/footer.php');?>
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
