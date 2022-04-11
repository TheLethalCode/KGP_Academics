<?php 
require_once("includes/config.php");
// code for username availablity
if(!empty($_POST["uname"])) {
	$usrname=$_POST["uname"];
	
$sql ="SELECT UserName FROM tblusers WHERE UserName=:usrname";
$query= $dbh->prepare($sql);
$query-> bindParam(':usrname',$usrname, PDO::PARAM_STR);
$query-> execute();
$results = $query -> fetchAll(PDO::FETCH_OBJ);
if($query->rowCount() > 0)
{
echo "<span style='color:red'> Username already associated another account .</span>";
 echo "<script>$('#signup').prop('disabled',true);</script>";
} else{
	
echo "<span style='color:green'> Username available for registration .</span>";
echo "<script>$('#signup').prop('disabled',false);</script>";
}
}




?>
