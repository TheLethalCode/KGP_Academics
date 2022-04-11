  
<?php
$ret = "Select  SiteName from tblgenralsettings ";
$querys = $dbh -> prepare($ret);
$querys->execute();
$resultss=$querys->fetchAll(PDO::FETCH_OBJ);
$cnt=1;
if($querys->rowCount() > 0)
{
foreach($resultss as $rows)
{ ?>
   <div id="home" class="header-slider-area">
                <!--header start-->
                <div class="header-area header-2">
                    <!--logo menu area start-->
                    <div id="sticker" class="logo-menu-area header-area-2">
                        <div class="container hidden-xs">
                            <div class="row">
                                <div class="col-md-2 col-sm-3">
                                    <div class="logo">
                                        <a href="index.php" style="font-size:42px; color:#fff"><?php echo htmlentities($rows->SiteName);?></a>
                                    </div>
                                </div>
                                <div class="col-md-8 col-sm-9">
                                    <div class="main-menu text-right">
                                        <nav>
                                            <ul id="nav">
                                                <li><a class="smooth-scroll" href="index.php">Home</a></li>
                                                <li><a class="smooth-scroll" href="about-us.php">About Us</a></li>                                           
                                                <li><a class="smooth-scroll" href="all-events.php">Events</a></li>
                                                <li><a class="smooth-scroll" href="news.php">News</a></li>

                                                <?php if(strlen($_SESSION['usrid']==0)){?>
                                                <li><a class="smooth-scroll" href="signup.php">Signup</a></li>
                                                 <li><a class="smooth-scroll" href="signin.php">Login</a></li>
                                             <?php } else {?>
<li><a class="smooth-scroll" href="profile.php">My Account</a></li>
                                             <?php } ?>
                                            </ul>
                                        </nav>
                                    </div>
                                </div>
                            
                                </div>
                            </div><!--logo menu area end-->
                                <!-- mobile-menu-area start -->
                                <div class="mobile-menu-area">
                                    <div class="container">
                                        <div class="logo-02">
                                           <a href="index.php" style="font-size:42px; color:#fff"><?php echo htmlentities($rows->SiteName);?></a>
                                        </div>
                                        <div class="row">
                                            <div class="col-xs-12">
                                                <nav id="dropdown">
                                                    <ul>
                                            <li><a class="smooth-scroll" href="#home">Home</a></li>
                                                <li><a class="smooth-scroll" href="about-us.php">About Us</a></li>                                           
                                                <li><a class="smooth-scroll" href="all-events.php">Events</a></li>
                                                <li><a class="smooth-scroll" href="news.php">News</a></li>
                                                <li><a class="smooth-scroll" href="signup.php">Signup</a></li>
                                                 <li><a class="smooth-scroll" href="#contact">Login</a></li>
                                                    </ul>
                                                </nav>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!--mobile menu area end-->
                        </div> 
                    </div>
                    <?php }} ?>