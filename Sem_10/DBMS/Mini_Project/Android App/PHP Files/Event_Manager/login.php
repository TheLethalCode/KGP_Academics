<?php

if ($_SERVER['REQUEST_METHOD']=='POST') {

    $username = $_POST['username'];
    $password = $_POST['password'];

    require_once 'connect.php';

    $sql = "SELECT * FROM event_manager WHERE username='$username' ";

    $response = mysqli_query($conn, $sql);

    $result = array();
    $result['login'] = array();
    
    if ( mysqli_num_rows($response) === 1 ) {
        
        $row = mysqli_fetch_assoc($response);

        if ( password_verify($password, $row['password']) ) {
            
            $index['name'] = $row['name'];
            $index['username'] = $row['username'];
            $index['email'] = $row['email'];
            $index['em_id'] = $row['em_id'];

            array_push($result['login'], $index);

            $result['success'] = "1";
            $result['message'] = "success";
            echo json_encode($result);

            mysqli_close($conn);

        } else {

            $result['success'] = "0";
            $result['message'] = "error";
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