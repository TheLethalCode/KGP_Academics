
<?php 

require_once 'DbOperations.php';

$response = array(); 

if($_SERVER['REQUEST_METHOD']=='POST'){
	if(
		isset($_POST['FullName']) and 
			isset($_POST['AdminEmail']) and 
				isset($_POST['UserName']) and isset($_POST['Password']) )
		{
		//operate the data further 

		$db = new DbOperations(); 
		#`id`, `FullName`, `AdminEmail`, `UserName`, `Password`
		$result = $db->createUser( 	$_POST['FullName'],
									$_POST['AdminEmail'],
									$_POST['UserName'],
									$_POST['Password']
								);
		if($result == 1){
			$response['error'] = false; 
			$response['message'] = "User registered successfully";
		}elseif($result == 2){
			$response['error'] = true; 
			$response['message'] = "Some error occurred please try again";			
		}elseif($result == 0){
			$response['error'] = true; 
			$response['message'] = "It seems you are already registered, please choose a different email and username";						
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
