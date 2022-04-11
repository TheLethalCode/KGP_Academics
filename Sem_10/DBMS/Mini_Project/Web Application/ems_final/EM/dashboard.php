<?php
session_start();
error_reporting(0);
include('includes/config.php');
if(strlen($_SESSION['EMsession'])==0)
{   
header('location:logout.php');
}
else{ 
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Event Management System | Dashboard</title>
    <link href="../vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="../vendor/metisMenu/metisMenu.min.css" rel="stylesheet">
    <link href="../dist/css/sb-admin-2.css" rel="stylesheet">
    <link href="../vendor/morrisjs/morris.css" rel="stylesheet">
    <link href="../vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
</head>

<body>

    <div id="wrapper">

<!-- Navigation -->
<nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
<!-- / Header -->

<!-- / Leftbar -->
<?php include_once('includes/leftbar.php');?>
</nav>

        <div id="page-wrapper">
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Dashboard</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-primary">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-3">
                                    <i class="fa fa-file fa-5x"></i>
                                </div>

<?php 
$session_id = $_SESSION['EMsession'];
$sql ="SELECT id from tblcategory";
$query = $dbh -> prepare($sql);
$query->execute();
$results=$query->fetchAll(PDO::FETCH_OBJ);
$listedcategories=$query->rowCount();
?>


                                <div class="col-xs-9 text-right">
                                    <div class="huge"><?php echo htmlentities($listedcategories);?></div>
                                    <div>Listed Categories</div>
                                </div>
                            </div>
                        </div>
                        <a href="all-categories.php">
                            <div class="panel-footer">
                                <span class="pull-left">View Details</span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-green">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-3">
                                    <i class="fa fa-tasks fa-5x"></i>
                                </div>
<?php 
$session_id = $_SESSION['EMsession'];
$sql ="SELECT id from tblsponsers where Created_id = :session_id";
$query = $dbh -> prepare($sql);
$query-> bindParam(':session_id', $session_id, PDO::PARAM_STR);
$query->execute();
$results=$query->fetchAll(PDO::FETCH_OBJ);
$listedsponsers=$query->rowCount();
?>

                                <div class="col-xs-9 text-right">
                                    <div class="huge"><?php echo htmlentities($listedsponsers);?></div>
                                    <div>Sponsers</div>
                                </div>
                            </div>
                        </div>
                        <a href="manage-sponsers.php">
                            <div class="panel-footer">
                                <span class="pull-left">View Details</span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-yellow">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-3">
                                    <i class="fa fa-table fa-fw fa-5x"></i>
                                </div>

<?php 
$session_id = $$_SESSION['EMsession'];
$sql ="SELECT room_id from Room as R where room_id not in (SELECT RB.room_id from Room_Booking as RB)";
$query = $dbh -> prepare($sql);
$query->execute();
$results=$query->fetchAll(PDO::FETCH_OBJ);
$listedrooms=$query->rowCount();
?>

                                <div class="col-xs-9 text-right">
                                    <div class="huge"><?php echo htmlentities($listedrooms);?></div>
                                    <div>Rooms/Venues</div>
                                </div>
                            </div>
                        </div>
                        <a href="available-rooms.php">
                            <div class="panel-footer">
                                <span class="pull-left">View Availability</span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-yellow">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-3">
                                    <i class="fa fa-table fa-fw fa-5x"></i>
                                </div>



<?php 
$created_id=$_SESSION['EMsession'];
$sql ="SELECT B.id from tblbookings as B, tblevents as E where B.EventId = E.id and E.Created_id = :created_id";
$query = $dbh -> prepare($sql);
$query->bindParam(':created_id',$created_id,PDO::PARAM_STR);
$query->execute();
$results=$query->fetchAll(PDO::FETCH_OBJ);
$totalbookings=$query->rowCount();
?>


                                <div class="col-xs-9 text-right">
                                    <div class="huge"><?php echo htmlentities($totalbookings);?></div>
                                    <div>Total Bookings</div>
                                </div>
                            </div>
                        </div>
                               <a href="all-booking.php">
                            <div class="panel-footer">
                                <span class="pull-left">View Details</span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-primary">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-3">
                                    <i class="fa fa-book  fa-5x"></i>
                                </div>

<?php 
$created_id=$_SESSION['EMsession'];
$status="Confirmed";
$sql ="SELECT B.id from tblbookings as B, tblevents as E where B.BookingStatus=:status and B.EventId = E.id and E.Created_id = :created_id";
$query = $dbh -> prepare($sql);
$query->bindParam(':status',$status,PDO::PARAM_STR);
$query->bindParam(':created_id',$created_id,PDO::PARAM_STR);
$query->execute();
$results=$query->fetchAll(PDO::FETCH_OBJ);
$confirmedbooking=$query->rowCount();
?>



                                <div class="col-xs-9 text-right">
                                    <div class="huge"><?php echo htmlentities($confirmedbooking);?></div>
                                    <div>Confirmed Booking</div>
                                </div>
                            </div>
                        </div>
                        <a href="confirmed-bookings.php">
                            <div class="panel-footer">
                                <span class="pull-left">View Details</span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
                    </div>
                </div>
                <div class="col-lg-3 col-md-6">
                    <div class="panel panel-red">
                        <div class="panel-heading">
                            <div class="row">
                                <div class="col-xs-3">
                                    <i class="fa fa-book fa-5x"></i>
                                </div>
<?php 
$created_id=$_SESSION['EMsession'];
$status="Cancelled";
$sql ="SELECT B.id from tblbookings as B, tblevents as E where B.BookingStatus=:status and B.EventId = E.id and E.Created_id = :created_id";
$query = $dbh -> prepare($sql);
$query->bindParam(':status',$status,PDO::PARAM_STR);
$query->bindParam(':created_id',$created_id,PDO::PARAM_STR);
$query->execute();
$results=$query->fetchAll(PDO::FETCH_OBJ);
$cancelledbooking=$query->rowCount();
?>

                                <div class="col-xs-9 text-right">
                                    <div class="huge"><?php echo htmlentities($cancelledbooking);?></div>
                                    <div>Cancelled Bookings</div>
                                </div>
                            </div>
                        </div>
                        <a href="cancelled-booking.php">
                            <div class="panel-footer">
                                <span class="pull-left">View Details</span>
                                <span class="pull-right"><i class="fa fa-arrow-circle-right"></i></span>
                                <div class="clearfix"></div>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
            <!-- /.row -->
















         
        </div>
        <!-- /#page-wrapper -->

    </div>
    <script src="../vendor/jquery/jquery.min.js"></script>
    <script src="../vendor/bootstrap/js/bootstrap.min.js"></script>
    <script src="../vendor/metisMenu/metisMenu.min.js"></script>
    <script src="../vendor/raphael/raphael.min.js"></script>
    <script src="../vendor/morrisjs/morris.min.js"></script>
    <script src="../data/morris-data.js"></script>
    <script src="../dist/js/sb-admin-2.js"></script>
</body>
</html>
<?php }?>
