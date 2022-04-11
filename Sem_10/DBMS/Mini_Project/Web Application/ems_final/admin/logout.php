<?php
session_start(); 
unset($_SESSION['adminsession']);
session_destroy(); // destroy session
header("location:index.php"); 
?>

