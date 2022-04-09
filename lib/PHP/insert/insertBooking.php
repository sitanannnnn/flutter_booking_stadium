
<?php
	include '../connected.php';
if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}

if (isset($_GET)) {
	
	if ($_GET['isAdd'] == 'true' ) {
        $bkd_id  =$_GET['bkd_id '];
        $stu_id =$_GET['stu_id'];
        $std_id =$_GET['std_id']; 
        $substd_id =$_GET['substd_id'];
        $bkt_id =$_GET['bkt_id'];
        $bkd_date =$_GET['bkd_date'];
        $bkd_time =$_GET['bkd_time'];
        $bkd_member =$_GET['bkd_member'];
		
		

		
        $sql = "INSERT INTO booking_detail (`bkd_id`,`stu_id`,`std_id`,`substd_id`,`bkt_id`,`bkd_date`,`bkd_time`,`bkd_member`) 
		VALUES (null,'$stu_id','$std_id','$substd_id','$bkt_id','$bkd_date','$bkd_time','$bkd_member')";

		$result = mysqli_query($link,$sql);

		if ($result) {
			echo "true";
		}
		else{
			echo "false";
		}
	}else echo "Welcome ";	

}
	

	mysqli_close($link);
?>