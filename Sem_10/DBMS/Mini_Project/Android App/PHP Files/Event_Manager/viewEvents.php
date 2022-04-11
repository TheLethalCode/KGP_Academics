<?php

	if ($_SERVER['REQUEST_METHOD']=='POST') {

		$em_id = (int) $_POST['em_id'];

		require_once 'connect.php';

		$sql = "SELECT E.event_id as eventID, E.Name as eventName, E.Description as eventDesc, E.StartDate as eventDate, E.Time as eventTime, E.isActive as eventStatus, R.roomNo as eventRoom  FROM event as E, booking as B, room as R WHERE E.em_created = '$em_id' AND E.event_id = B.event_id AND B.room_id = R.room_id ;";

		$response = mysqli_query($conn, $sql);

		$result = array();
		$result['events'] = array();

		if ( mysqli_num_rows($response) >= 1 ) {

			while($row = mysqli_fetch_assoc($response)){

				$index['event_id'] = $row['eventID'];
				$index['event_status'] = $row['eventStatus'];
				$index['event_name'] = $row['eventName'];
				$index['event_desc'] = $row['eventDesc'];
				$index['event_room'] = $row['eventRoom'];
				$index['event_date'] = $row['eventDate'];
				$index['event_time'] = $row['eventTime'];

				array_push($result['events'], $index);
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