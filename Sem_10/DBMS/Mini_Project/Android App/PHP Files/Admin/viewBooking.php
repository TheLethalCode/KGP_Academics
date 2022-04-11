<?php 

	//database constants
	define('DB_HOST', 'localhost');
	define('DB_USER', 'root');
	define('DB_PASS', '');
	define('DB_NAME', 'admin');
	
	//connecting to database and getting the connection object
	$conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
	
	//Checking if any error occured while connecting
	if (mysqli_connect_errno()) {
		echo "Failed to connect to MySQL: " . mysqli_connect_error();
		die();
	}
	
	//creating a query
	$stmt = $conn->prepare("SELECT rb.event_id, rb.room_id, e.name, r.roomNo, r.building 
		FROM room_booking as rb, room as r, event as e
		WHERE rb.event_id = e.event_id AND rb.room_id = r.room_id;");
	
	//executing the query 
	$stmt->execute();
	
	//binding results to the query 
	$stmt->bind_result($eid, $rid, $ename, $rn, $bu);
	
	$products = array(); 
	
	//traversing through all the result 
	while($stmt->fetch()){
		$temp = array();
		$temp['event_id'] = $eid; 
		$temp['room_id'] = $rid; 
		$temp['name'] = $ename; 
		$temp['roomNo'] = $rn; 
		$temp['building'] = $bu; 
		array_push($products, $temp);
	}
	
	//displaying the result in json format 
	echo json_encode($products);