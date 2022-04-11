SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


CREATE TABLE `admin` (
 `admin_id` int(10) NOT NULL AUTO_INCREMENT,
 `name` varchar(30) NOT NULL,
 `email` varchar(50) NOT NULL,
 `username` varchar(30) NOT NULL,
 `password` text NOT NULL,
 `creationDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
 PRIMARY KEY (`admin_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


CREATE TABLE `event_manager` (
 `em_id` int(10) NOT NULL AUTO_INCREMENT,
 `name` varchar(30) NOT NULL,
 `email` varchar(50) NOT NULL,
 `username` varchar(30) NOT NULL,
 `password` text NOT NULL,
 `creationDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
 PRIMARY KEY (`em_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


CREATE TABLE `room` (
 `room_id` int(10) NOT NULL AUTO_INCREMENT,
 `roomNo` varchar(15) NOT NULL,
 `floor` int(5) NOT NULL,
 `building` varchar(20) NOT NULL,
 `admin_created` int(10) NOT NULL,
 `creationDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
 PRIMARY KEY (`room_id`),
 FOREIGN KEY (`admin_created`) REFERENCES admin(`admin_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


CREATE TABLE `event` (
 `event_id` int(11) NOT NULL AUTO_INCREMENT,
 `Name` varchar(50) NOT NULL,
 `Description` text DEFAULT NULL,
 `StartDate` date NOT NULL,
 `EndDate` date NOT NULL,
 `Time` time NOT NULL,
 `isActive` int(2) NOT NULL,
 `em_created` int(10) NOT NULL,
 `creationDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
 PRIMARY KEY (`event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


CREATE TABLE `booking` (
 `event_id` int(10) NOT NULL,
 `room_id` int(10) NOT NULL,
 `Date` date NOT NULL,
 `creationDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
 PRIMARY KEY (`event_id`, `room_id`, `Date`),
 FOREIGN KEY (`event_id`) REFERENCES event(`event_id`),
 FOREIGN KEY (`room_id`) REFERENCES room(`room_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


CREATE TABLE `user` (
 `user_id` int(10) NOT NULL AUTO_INCREMENT,
 `name` varchar(30) NOT NULL,
 `email` varchar(50) NOT NULL,
 `username` varchar(30) NOT NULL,
 `password` text NOT NULL,
 `creationDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
 PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;


CREATE TABLE `user_event` (
 `user_id` int(10) NOT NULL,
 `event_id` int(10) NOT NULL,
 `Date` date NOT NULL,
 `creationDate` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
 PRIMARY KEY (`user_id`, `event_id`),
 FOREIGN KEY (`event_id`) REFERENCES event(`event_id`),
 FOREIGN KEY (`user_id`) REFERENCES user(`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


INSERT INTO `admin` (`admin_id`, `name`, `email`, `username`, `password`) VALUES
(1, 'Admin', 'admin@gmail.com', 'admin', '$2y$10$iX.Z3cvsMY3fVx9ZnH3xVukEmq6DGL4zeycvR2oZvg7/eiyr/jVzK'); -- password : password1

INSERT INTO `event_manager` (`em_id`, `name`, `email`, `username`, `password`) VALUES
(1, 'Event Manager First', 'em1@gmail.com', 'manager1', '$2y$10$iX.Z3cvsMY3fVx9ZnH3xVukEmq6DGL4zeycvR2oZvg7/eiyr/jVzK'), -- password : password1
(2, 'Event Manager Second', 'em2@gmail.com', 'manager2', '$2y$10$gO5G7gzPMknqED9etIvUwuK15G0HcJR71ZU2qOEroqNohF6DxLQz.'); -- password : password2


INSERT INTO `event` (`event_id`, `Name`, `Description`, `StartDate`, `EndDate`, `Time`, `isActive`, `em_created`) VALUES
(2, 'Hands-on-python', 'Learn python with live tutorials', '20/5/2020', '20/5/2020', '12:30', 1, 1),
(1, 'DBMS Bootcamp', 'Introduction to database management', '15/5/2020', '15/5/2020', '17:30', 1, 1),
(3, 'Deep Learning', 'Introduction to Neural Networks', '15/5/2020', '15/5/2020', '17:30', 1, 2);


INSERT INTO `room` (`room_id`, `roomNo`, `floor`, `building`, `admin_created`) VALUES
(3, 'S201', 2, 'Main Building', 1),
(1, 'NR121', 1, 'Nalanda', 1),
(2, 'V2', 1, 'Vikramshila', 1),
(4, 'CSE-109', 1, 'CSE Department', 1);


INSERT INTO `booking` (`event_id`, `room_id`, `Date`) VALUES
(1, 1, '15/5/2020'),
(2, 3, '20/5/2020'),
(3, 3, '15/5/2020');


INSERT INTO `user` (`user_id`, `name`, `email`, `username`, `password`) VALUES
(1, 'User First', 'user1@gmail.com', 'user1', '$2y$10$iX.Z3cvsMY3fVx9ZnH3xVukEmq6DGL4zeycvR2oZvg7/eiyr/jVzK'), -- password : password1
(2, 'User Second', 'user2@gmail.com', 'user2', '$2y$10$gO5G7gzPMknqED9etIvUwuK15G0HcJR71ZU2qOEroqNohF6DxLQz.'); -- password : password2


INSERT INTO `user_event` (`user_id`, `event_id`, `Date`) VALUES
(1, 1, '15/5/2020'),
(2, 1, '15/5/2020');





