
<?php 

require_once 'DbOperations.php';

$response = array(); 
// `room_id`, `roomNo`, `floor`, `building`, `capacity`
if($_SERVER['REQUEST_METHOD']=='POST'){
	if(
		isset($_POST['roomNo']) and 
			isset($_POST['floor']) and 
				isset($_POST['building']) )
		{
		//operate the data further 

		$db = new DbOperations(); 
		#`id`, `FullName`, `AdminEmail`, `UserName`, `Password`
		$result = $db->makeRoom( 	$_POST['roomNo'],
									$_POST['floor'],
									$_POST['building']
								);
		if($result == 1){
			$response['error'] = false; 
			$response['message'] = "Room added successfully";
		}elseif($result == 2){
			$response['error'] = true; 
			$response['message'] = "Some error occurred please try again";			
		}elseif($result == 0){
			$response['error'] = true; 
			$response['message'] = "It seems you are already registered, please choose a different room";						
		}

	}else{
		$response['error'] = true; 
		$response['message'] = "Required fields are missing";
	}
}else{
	$response['error'] = true; 
	$response['message'] = "Invalid Request";
}

echo json_encode($response);
