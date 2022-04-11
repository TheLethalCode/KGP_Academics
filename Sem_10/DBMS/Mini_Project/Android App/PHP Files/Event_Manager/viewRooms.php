<?php

	if ($_SERVER['REQUEST_METHOD']=='GET') {

		require_once 'connect.php';

		$sql = "SELECT room_id, roomNo, floor, building FROM room ;";

		$response = mysqli_query($conn, $sql);

		$result = array();
		$result['rooms'] = array();

		if ( mysqli_num_rows($response) >= 1 ) {

			while($row = mysqli_fetch_assoc($response)){

				$index['room_id'] = $row['room_id'];
				$index['room_no'] = $row['roomNo'];
				$index['floor'] = $row['floor'];
				$index['building'] = $row['building'];

				array_push($result['rooms'], $index);
			}

			$result['success'] = "1";
            $result['message'] = "success";
            echo json_encode($result);

            mysqli_close($conn);

		} 

		else {

			$result['success'] = "0";
            $result['message'] = "error";
            echo json_encode($result);

            mysqli_close($conn);

		}
	}

?>