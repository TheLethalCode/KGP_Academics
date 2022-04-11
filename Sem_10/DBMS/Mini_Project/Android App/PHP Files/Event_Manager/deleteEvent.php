<?php


if ($_SERVER['REQUEST_METHOD'] =='POST'){

    $event_id = (int) $_POST['event_id'];

    require_once 'connect.php';

    $sql = "DELETE FROM booking WHERE event_id = '$event_id' ";
    $sql2 = "DELETE FROM event WHERE event_id = '$event_id' ";

    if ( mysqli_query($conn, $sql) && mysqli_query($conn, $sql2) ) {
        $result["success"] = "1";
        $result["message"] = "success";

        echo json_encode($result);
        mysqli_close($conn);

    } else {

        $result["success"] = "0";
        $result["message"] = "error";

        echo json_encode($result);
        mysqli_close($conn);
    }
}

?>