<?php 

require_once 'DbOperations.php';

$response = array(); 

if($_SERVER['REQUEST_METHOD']=='POST'){
	if(isset($_POST['UserName']) and isset($_POST['Password'])){
		$db = new DbOperations(); 

		if($db->userLogin($_POST['UserName'], $_POST['Password'])){
			$user = $db->getUserByUsername($_POST['UserName']);
			$response['error'] = false; 
			#`id`, `FullName`, `AdminEmail`, `UserName`, `Password`
			$response['id'] = $user['id'];
			$response['FullName'] = $user['FullName'];
			$response['AdminEmail'] = $user['AdminEmail'];
			$response['UserName'] = $user['UserName'];
		}else{
			$response['error'] = true; 
			$response['message'] = "Invalid username or password";			
		}

	}else{
		$response['error'] = true; 
		$response['message'] = "Required fields are missing";
	}
}

echo json_encode($response);