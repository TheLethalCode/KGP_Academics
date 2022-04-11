<?php


if ($_SERVER['REQUEST_METHOD'] =='POST'){

    $name = $_POST['event_name'];
    $desc = $_POST['event_desc'];
    $date = $_POST['event_date'];
    $time = $_POST['event_time'];
    $room = $_POST['event_room'];
    $em_id = (int) $_POST['em_id'];

    require_once 'connect.php';

    $sql = "SELECT room_id  from room WHERE roomNo = '$room'";

    $response = mysqli_query($conn, $sql);
    
    if ( mysqli_num_rows($response) === 1 ) {
        
        $row = mysqli_fetch_assoc($response);

        $room_id = (int) $row['room_id'];

        $sql2 = "INSERT INTO event (Name, Description, StartDate, EndDate, `Time`, isActive, em_created) VALUES ('$name', '$desc', '$date', '$date', '$time', 0, '$em_id')";

        if ( mysqli_query($conn, $sql2) ) {

            $sql3 = "SELECT event_id from event WHERE Name = '$name'";

            $response3 = mysqli_query($conn, $sql3);

            if ( mysqli_num_rows($response3) === 1 ) {

                $row3 = mysqli_fetch_assoc($response3);
                $event_id = (int) $row3['event_id'];

                $sql4 = "INSERT INTO booking (event_id, room_id, `Date`) VALUES ('$event_id', '$room_id', '$date')";

                if ( mysqli_query($conn, $sql4) ) {
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

            else {
                $result["success"] = "0";
                $result["message"] = "error";

                echo json_encode($result);
                mysqli_close($conn);
            }



        } else {

            $result["success"] = "0";
            $result["message"] = "error";

            echo json_encode($result);
            mysqli_close($conn);
        }
        

    }

    else {
        $result['success'] = "0";
        $result['message'] = "error";
        echo json_encode($result);

        mysqli_close($conn);
    }
}

?>