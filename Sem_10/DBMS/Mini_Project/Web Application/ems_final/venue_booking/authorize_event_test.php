<?php
session_start();
error_reporting(0);

{
    // Posted Values
    $event_name='FAREWELL';
    $room_name='SDS-122';
    // get the image extension
    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "ems";
    // Establish database connection.
    $conn = new mysqli($servername, $username, $password, $dbname);
    // Check connection
    if ($conn->connect_error) 
    {
        die("Connection failed: " . $conn->connect_error);
    } 
    else
    {

        $idevent=0;
        $sql = "SELECT id , EventName FROM tblevents  
        WHERE EventName = '".$event_name."'";
        $result= $conn->query($sql); //or die(mysqli_error($conn));
        if($result->num_rows > 0)
        {
            $row=$result->fetch_assoc();
            $idevent=$row["id"];
            echo "idevent = $idevent    ";
        }
        else echo "Failed";
        echo "I am here2\n";
        
        $idroom = 0;
        $sql = "SELECT room_id , roomNo FROM room  
        WHERE roomNo = '".$room_name."'";

        $result= $conn->query($sql); //or die(mysqli_error($conn));
        if($result->num_rows > 0)
        {
            $row=$result->fetch_assoc();
            $idroom=$row["room_id"];
            echo "idroom = $idroom    ";
        }
        else echo "Failed";
        echo "I am here3\n";
    }  



}    
?>
