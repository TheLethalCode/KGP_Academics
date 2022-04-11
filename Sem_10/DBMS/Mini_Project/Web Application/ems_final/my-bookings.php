<?php
session_start();
//datbase connection file
include('includes/config.php');
error_reporting(0);
if(strlen($_SESSION['usrid'])==0)
    {   
header('location:logout.php');
}
else{


?>

<!doctype html>
<html class="no-js" lang="en">
    <head>

        <title>Event Management System | My Bookings </title>
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
        <link rel="stylesheet" href="css/faicons.css">
        <!-- color css -->
        <link href="css/color/skin-default.css" rel="stylesheet">   
        <!-- modernizr css -->
<script src="js/vendor/modernizr-2.8.3.min.js"></script>

    </head>
    <body>
        <!--body-wraper-are-start-->
         <div class="wrapper single-blog">
         
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
                        <li><a href="index.html">Home</a></li>
                        <li class="active">My Bookings</li>
                    </ol>
                </div>
            </div> 
            <!--  breadcumb-area end-->    

            <!-- main blog area start-->
            <div class="single-blog-area ptb100 fix">
               <div class="container">
                   <div class="row">
<?php include_once('includes/myaccountbar.php');?>
                       <div class="col-md-8 col-sm-7">
                           <div class="single-blog-body">

                        
                                <div class="Leave-your-thought mt50">
                                    <h3 class="aside-title uppercase">My Bookings</h3>

                                    <div class="row">
                                            <div class="col-md-12 col-sm-6 col-xs-12 lyt-left">
                                                <div class="input-box leave-ib">
<div class="table-responsive">
<table border="2" class="table">
    <tr>
      <th>#</th>  
      <th>Booking Id</th> 
      <th>Event Name</th> 
      <th>Booking Date</th> 
      <th>Booking Status</th> 
      <th>Action</th> 
    </tr>
<?php
// Fetching Booking Details
$uid=$_SESSION['usrid'];
$sql = "SELECT tblbookings.id as bid,tblbookings.BookingId,tblbookings.BookingDate,tblbookings.BookingStatus,tblevents.EventName,tblevents.id as evtid from tblbookings left join tblevents on tblevents.id=tblbookings.EventId where tblbookings.UserId=:uid";
$query = $dbh -> prepare($sql);
$query->bindParam(':uid',$uid,PDO::PARAM_STR);
$query->execute();
$results=$query->fetchAll(PDO::FETCH_OBJ);
$cnt=1;
if($query->rowCount() > 0)
{
foreach($results as $row)
{ ?>

<tr>
<td><?php echo htmlentities($cnt);?></td>   
<td><?php echo htmlentities($row->BookingId);?></td>  
<td><a href="event-details.php?evntid=<?php echo htmlentities($row->evtid);?>"><?php echo htmlentities($row->EventName);?></a></td>  
<td><?php echo htmlentities($row->BookingDate);?></td>  
<td><?php $bstatus=$row->BookingStatus;
if($bstatus==""){
echo htmlentities("Not confirmed Yet");
} else {
echo htmlentities($bstatus);
}?></td>  
<td>
<a href="booking-details.php?bkid=<?php echo htmlentities($row->bid);?>">
<i class="fa fa-file-text"></i></a></td>   
</tr>
<?php $cnt++;}} ?>
</table>
</div>
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
<?php } ?>
