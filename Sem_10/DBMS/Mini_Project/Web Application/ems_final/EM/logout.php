<?php
session_start(); 
unset($_SESSION['EMsession']);
session_destroy(); // destroy session
header("location:index.php"); 
?>
