<?php
session_start();
//datbase connection file
include('includes/config.php');
error_reporting(0);
// Code for Email Subscription
if(isset($_POST['subscribe']))
{

// Getting Post values
$emailid=$_POST['email'];   
// query for data insertion
$sql="INSERT INTO tblsubscriber(UserEmail) VALUES(:emailid)";
//preparing the query
$query = $dbh->prepare($sql);
//Binding the values
$query->bindParam(':emailid',$emailid,PDO::PARAM_STR);
//Execute the query
$query->execute();
//Check that the insertion really worked
$lastInsertId = $dbh->lastInsertId();
if($lastInsertId)
{
echo "<script>alert('Success : Successfully subscribed');</script>";
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
        <title>Event Management System | Home Page </title>
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
         <div class="wrapper home-02">
         
            <!--slider header area are start-->
         <?php include_once('includes/header.php');?>
                <!-- header End-->
                <!--slider area are start-->
                <div class="slider-container slider-02 bg-overlay">
                    <!-- Slider Image -->
                    <div id="mainSlider" class="nivoSlider slider-image"> 
                        <img src="img/event-management-system.png" alt="event-management-system" title="#htmlcaption1" height="200" /> 
                    </div>
                </div>
                <!--slider area are End-->
                <div class="down-arrow"> <a class="see-demo-btn" href="#about-event"><i class="zmdi zmdi-long-arrow-down"></i></a> </div>
            </div>
            <!--slider header area are end-->
       <!-- Slider Caption 1 -->
                    <div id="htmlcaption1" class="nivo-html-caption slider-caption-1" >
                        <div class="container">
                            <div class="slide1-text">
                                <div class="middle-text slide-def">
                            <div class="cap-dec wow fadeInDown" data-wow-duration=".9s" data-wow-delay="0.2s" style="margin-top:-100px">
                                        <h1 align="center">Event Management System</h1>
                                    </div>
                                  
                                 
                                  
                                </div>
                            </div>
                        </div>
                    </div>
                 <!--up comming events area-->
            <div class="upcomming-events-area off-white ptb100">
                  <div class="container">
                      <div class="row">
                          <div class="col-xs-12">
                           <h1 class="section-title">Up Comming Events</h1>
                        </div>
                          <div class="total-upcomming-event col-md-12 col-sm-12 col-xs-12">

<?php
// Fetching Upcomong events
$isactive=1;
$sql = "SELECT EventName,EventLocation,EventStartDate,EventEndDate,EventImage,id from tblevents where IsActive=:isactive order by id desc limit 5";
$query = $dbh -> prepare($sql);
$query->bindParam(':isactive',$isactive,PDO::PARAM_STR);
$query->execute();
$results=$query->fetchAll(PDO::FETCH_OBJ);
$cnt=1;
if($query->rowCount() > 0)
{
foreach($results as $row)
{ 
    ?>

                              <div class="single-upcomming shadow-box">
                                 <div class="col-md-4 hidden-sm col-xs-12">
                                     <div class="sue-pic">
                                        <img src="admin/eventimages/<?php echo htmlentities($row->EventImage);?>" alt="<?php echo htmlentities($row->EventName);?>" style="border:#000 1px solid"> 
                                     </div>
                                     <div class="sue-date-time text-center">
                                         <span><?php echo htmlentities($row->EventStartDate);?></span>To
                                         <span><?php echo htmlentities($row->EventEndDate);?></span>
                                     </div>
                                 </div>
                                 <div class="col-md-3 col-sm-5 col-xs-12">
                                    <div class="uc-event-title">
                                        <div class="uc-icon"><i class="zmdi zmdi-globe-alt"></i></div>
                                        <a href="#"><?php echo htmlentities($row->EventName);?></a>
                                    </div> 
                                 </div> 
                                 <div class="col-md-2 col-sm-3 col-xs-12">
                                     <div class="venu-no">
                                         <p>Location : <?php echo htmlentities($row->EventLocation);?></p>
                                     </div>
                                 </div>
                                 <div class="col-md-3 col-sm-4 col-xs-12">
                                     <div class="upcomming-ticket text-center">
 <a href="event-details.php?evntid=<?php echo htmlentities($row->id);?>" class="btn-def bnt-2 small">View Details</a>
                                     </div>
                                 </div>
                              </div>
 <?php } } ?>                        
                             
                            
                          </div>
                      </div>
                  </div>
              </div>               
            <!--up comming events area--> 

            
            <!--Counter area start-->
            <div class="counter-area pb150">
                <div class="container">
                    <div class="row">
                        <div class="col-md-2 col-sm-4 col-xs-12">
                            <div class="single-count text-center uppercase">
                               <div class="count-icon">
                                   <img src="img/icon/count-01.png" alt="">
                               </div>
                                <h3><span class="counter2">50</span></h3>
                                <p>+ Events</p>
                            </div>
                        </div>
                        <div class="col-md-2 col-sm-4 col-xs-12">
                            <div class="single-count text-center uppercase">
                               <div class="count-icon">
                                   <img src="img/icon/count-02.png" alt="">
                               </div>
                                <h3><span class="counter2">19</span></h3>
                                <p>+ Location</p>
                            </div>
                        </div>
                        <div class="col-md-2 col-sm-4 col-xs-12">
                            <div class="single-count text-center uppercase">
                               <div class="count-icon">
                                   <img src="img/icon/count-03.png" alt="">
                               </div>
                                <h3><span class="counter2">12</span></h3>
                                <p>+ Newtwork</p>
                            </div>
                        </div>
                        <div class="col-md-2 col-sm-4 col-xs-12">
                            <div class="single-count text-center uppercase">
                               <div class="count-icon">
                                   <img src="img/icon/count-04.png" alt="">
                               </div>
                                <h3><span class="counter2">90</span></h3>
                                <p>+ Countries</p>
                            </div>
                        </div>
                        <div class="col-md-2 col-sm-4 col-xs-12">
                            <div class="single-count text-center uppercase">
                               <div class="count-icon">
                                   <img src="img/icon/count-05.png" alt="">
                               </div>
                                <h3><span class="counter2">5</span></h3>
                                <p>Live Telecast</p>
                            </div>
                        </div>
                        <div class="col-md-2 col-sm-4 col-xs-12">
                            <div class="single-count text-center uppercase">
                               <div class="count-icon">
                                   <img src="img/icon/count-06.png" alt="">
                               </div>
                                <h3><span class="counter2">200</span></h3>
                                <p>+Idea</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--Counter area end-->
            
   

        
           
            <!--call to action area start-->
            <div class="call-to-action bg-overlay white-overlay pb100 pt85">
                <div class="container">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="cal-to-wrap">
                                <h1 class="section-title">Enter Your Email Address For Events & News</h1>
                                <form method="post" name="subscribe">
                                    <div class="input-box">
                                        <input type="email" placeholder="Enter your E-mail Address" class="info" name="email" required="true"> 
                                        <button type="submit" name="subscribe" class="send-btn"><i class="zmdi zmdi-mail-send"></i></button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--call to action area End--> 

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
        <!-- Vedio js -->
        <script src="js/video.js"></script>
        <!-- Youtube Background JS -->
        <script src="js/jquery.mb.YTPlayer.min.js"></script>
        <!-- datepicker js -->
        <script src="js/bootstrap-datepicker.js"></script>
        <!-- waypoint js -->
        <script src="js/waypoints.min.js"></script>
        <!-- onepage nav js -->
        <script src="js/jquery.nav.js"></script>
        <!-- Google Map js -->
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBuU_0_uLMnFM-2oWod_fzC0atPZj7dHlU"></script>
        <script src="js/google-map.js"></script>
        <!-- animate text JS -->
        <script src="js/animate-text.js"></script>
        <!-- plugins js -->
        <script src="js/plugins.js"></script>
        <!-- main js -->
        <script src="js/main.js"></script>
    </body>
</html>