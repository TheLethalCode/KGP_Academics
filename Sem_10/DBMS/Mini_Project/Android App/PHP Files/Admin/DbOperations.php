<?php 

	class DbOperations{

		private $con; 

		function __construct(){

			require_once dirname(__FILE__).'/DbConnect.php';

			$db = new DbConnect();

			$this->con = $db->connect();

		}

		public function makeRoom( $roomNo, $floor,$building)
		{
			{
				$stmt = $this->con->prepare("INSERT INTO `room` ( `room_id`, `roomNo`, `floor`, `building`) VALUES (NULL, ?, ?, ?);");
				$stmt->bind_param("sis",$roomNo, $floor, $building);

				if($stmt->execute()){
					return 1; 
				}else{
					return 2; 
				}
			}
		}
		// UPDATE `event` SET `IsActive`=[value-6] WHERE `event_id` =
		/*CRUD -> C -> CREATE */
		// FullName`, `AdminEmail`, `UserName`, `Password`
		public function createUser( $fullname, $email,$username, $pass)
		{
			if($this->isUserExist($username,$email)){
				return 0; 
			}else{
				$password = md5($pass);
				$stmt = $this->con->prepare("INSERT INTO `eve` (`id`, `FullName`, `AdminEmail`, `UserName`, `Password`) VALUES (NULL, ?, ?, ?, ?);");
				$stmt->bind_param("sss",$fullname,$email,$username,$password);

				if($stmt->execute()){
					return 1; 
				}else{
					return 2; 
				}
			}
		}
		public function authenticateEvent($event_id)
		{
			$stmt = $this->con->prepare("UPDATE `event` SET `IsActive`=1 WHERE `event_id` = ?;");
			$stmt->bind_param("i",$event_id);

			if($stmt->execute())
			{
				return 1; 
			}
			else
			{
				return 2; 
			}
		}


		public function userLogin($username, $pass)
		{
			$password = md5($pass);
			$stmt = $this->con->prepare("SELECT id FROM `admin` WHERE UserName = ? AND Password = ?");
			$stmt->bind_param("ss",$username,$password);
			$stmt->execute();
			$stmt->store_result(); 
			return $stmt->num_rows > 0; 
		}

		public function getUserByUsername($username){
			$stmt = $this->con->prepare("SELECT * FROM `admin` WHERE UserName = ?");
			$stmt->bind_param("s",$username);
			$stmt->execute();
			return $stmt->get_result()->fetch_assoc();
		}
		

		private function isUserExist($username, $email){
			$stmt = $this->con->prepare("SELECT id FROM users WHERE username = ? OR email = ?");
			$stmt->bind_param("ss", $username, $email);
			$stmt->execute(); 
			$stmt->store_result(); 
			return $stmt->num_rows > 0; 
		}

	}