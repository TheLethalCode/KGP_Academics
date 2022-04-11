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
// Code for updation
if(isset($_POST['cancellbooking']))
    {
$uid=$_SESSION['usrid'];
$bkngid=intval($_GET['bkid']);
$cancelremark=$_POST['cancelltionremark'];
$status="Cancelled";
$sql="update tblbookings set UserCancelRemark=:cancelremark,BookingStatus=:status where UserId=:uid and id=:bkngid";
$query = $dbh->prepare($sql);
$query-> bindParam(':uid', $uid, PDO::PARAM_STR);
$query-> bindParam(':bkngid', $bkngid, PDO::PARAM_STR);
$query-> bindParam(':cancelremark', $cancelremark, PDO::PARAM_STR);
$query-> bindParam(':status', $status, PDO::PARAM_STR);
$query->execute();
echo "<script>alert('Success :Booking Cancelled.');</script>";
echo "<script>window.location.href='my-bookings.php'</script>"; 
}


    ?>

<!doctype html>
<html class="no-js" lang="en">
    <head>

        <title>Event Management System | Booking Details </title>
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
<?php
// Fetching Booking Details
$uid=$_SESSION['usrid'];
$bkngid=intval($_GET['bkid']);
$sql = "SELECT tblbookings.BookingId,tblbookings.BookingDate,tblbookings.BookingStatus,tblevents.EventName,tblevents.id as evtid,tblbookings.UserRemark,tblbookings.NumberOfMembers,tblbookings.AdminRemark,tblbookings.LastUpdationDate,tblbookings.UserCancelRemark,tblevents.EventStartDate,tblevents.EventEndDate,tblevents.EventLocation from tblbookings left join tblevents on tblevents.id=tblbookings.EventId where tblbookings.UserId=:uid and  tblbookings.id=:bkngid";
$query = $dbh -> prepare($sql);
$query->bindParam(':uid',$uid,PDO::PARAM_STR);
$query->bindParam(':bkngid',$bkngid,PDO::PARAM_STR);
$query->execute();
$results=$query->fetchAll(PDO::FETCH_OBJ);
$cnt=1;
if($query->rowCount() > 0)
{
foreach($results as $row)
{ ?>
                        
<div class="Leave-your-thought mt50" id="exampl">
<h3 class="aside-title uppercase"><a href="event-details.php?evntid=<?php echo htmlentities($row->evtid);?>"><?php echo htmlentities($row->EventName);?></a> Booking Details</h3>
<div class="row">
<div class="col-md-12 col-sm-6 col-xs-12 lyt-left">
<div class="input-box leave-ib">
<div class="table-responsive">
<table border="2" class="table">



<tr>
<th>Booking Number</th>   
<td><?php echo htmlentities($row->BookingId);?></td>  

<th>Booking Date</th>    
<td><?php echo htmlentities($row->BookingDate);?></td>

<tr>
<th>Number of members</th>
 <td><?php echo htmlentities($row->NumberOfMembers);?></td>  
<th>User Remark</th>
 <td><?php echo htmlentities($row->UserRemark);?></td>     
</tr>
<tr>
<th>Event Name</th>   
<td><a href="event-details.php?evntid=<?php echo htmlentities($row->evtid);?>"><?php echo htmlentities($row->EventName);?></a></td>     
 <th>Event Date</th>
 <td><?php echo htmlentities($esdate=$row->EventStartDate);?> To <?php echo htmlentities($row->EventEndDate);?></td>    
</tr>

 <tr>
<th>Event Location</th>
 <td><?php echo htmlentities($row->EventLocation);?></td> 
<th>Booking Status</th>
<td ><?php $bstatus=$row->BookingStatus;
if($bstatus==""){
echo htmlentities("Not confirmed Yet");
} else {
echo htmlentities($bstatus);
}?></td>  
</tr>
<?php if($row->AdminRemark!=""){ ?>
<tr>
<th>Admin Remark</th> 
<td colspan="3"><?php echo htmlentities($row->AdminRemark);?></td>   
</tr>
<?php } ?>

<?php if($row->UserCancelRemark!=""){ ?>
<tr>
<th>User Cancellation Remark</th> 
<td colspan="3"><?php echo htmlentities($row->UserCancelRemark);?></td>   
</tr>
<?php } ?>

<?php if($row->LastUpdationDate!=""){ ?>
<tr>
<th>Last Updation Date</th> 
<td colspan="2"><?php echo htmlentities($row->LastUpdationDate);?></td>  
<td></td> 
</tr>
<?php } ?> 
<tr>
 <td colspan="2" align="center"><button type="button" class="btn btn-info btn-lg" data-toggle="modal" data-target="#myModal">Cancel this Booking</button></td>   
<td colspan="2" align="center"><i class="fa fa-print fa-2x" aria-hidden="true" OnClick="CallPrint(this.value)" ></i></td>
</tr>
</table>
</div>
</div>
</div>
    <?php $cnt++;}} ?>                                   



                                        </form>
                                    </div>

                                </div>
                           </div>
                       </div>
                        <!--sidebar-->
                     
               </div>
           </div></div>
            <!--main blog area start-->

<!-- Modal -->
<div id="myModal" class="modal fade" role="dialog" style="margin-top:10%">
  <div class="modal-dialog">

    <!-- Modal content-->
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h4 class="modal-title">Book Event Cancellation</h4>
      </div>
      <?php
 $cadte=date('Y-m-d');
if(($cadte<$esdate) && ($bstatus=="")){
    ?>


      <div class="modal-body">
        <form name="cancelbooking" method="post">
    
          <p><textarea  placeholder="Cancellation Reason" class="info" name="cancelltionremark" required="true"></textarea></p>
          <p><button type="submit" class="btn btn-info btn-lg" name="cancellbooking">Submit</button></p>
    </form>
      </div>
<?php  } if(($bstatus=='Confirmed' || $bstatus=='Cancelled') && ($esdate<$cadte)) {?>
  <div class="modal-body">
<p>Booking can't cancell now.You can only cancel not confirmed  bookings. </p>
      </div>
<?php }  if(($esdate<$cadte) && ($bstatus=="")){ ?>

 <div class="modal-body">
<p>Booking can't cancel now.You can only cancel booking before event start date . </p>
      </div>
 <?php } if(($bstatus=='Confirmed' || $bstatus=='Cancelled') && ($esdate>$cadte)) {?>
  <div class="modal-body">
<p>Booking can't cancell now.You can only cancel not confirmed  bookings. </p>
      </div>
<?php } ?>

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
<script>
function CallPrint(strid) {
var prtContent = document.getElementById("exampl");
var WinPrint = window.open('', '', 'left=0,top=0,width=800,height=900,toolbar=0,scrollbars=0,status=0');
WinPrint.document.write(prtContent.innerHTML);
WinPrint.document.close();
WinPrint.focus();
WinPrint.print();
WinPrint.close();
}
</script>        

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
