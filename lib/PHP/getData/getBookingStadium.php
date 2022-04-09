<?php
include '../connected.php';
header("Access-ontrol-Allow-Origin: *");
    if(!$link){
        echo "Error : Unable to connect to MySQL." .PHP_EOL;
        echo "Debugging errno" .mysqli_connect_errno().PHP_EOL;
        echo "Debugging error" .mysqli_connect_error().PHP_EOL;
        exit;
    }
    if (!$link -> set_charset("utf8")) {
        print("error loading character set utf8 : %s\n".$link->error);
        exit();
    }
    if (isset($_GET)) {
    if($_GET['isAdd']=='true'){
        $stu_id =$_GET['stu_id'];
        $bkd_date =$_GET['bkd_date'];
	$bkd_time =$_GET['bkd_time'];

    $result = mysqli_query($link, "SELECT booking_detail.bkd_id,booking_detail.stu_id,booking_detail.std_id,booking_detail.substd_id,booking_detail.bkt_id,booking_detail.bkd_date,booking_detail.bkd_time,booking_detail.bkd_member,stadium.std_name,stadium.std_number_of_player,stadium.std_url_picture,stadium.std_descrip_location,stadium.std_procedure,sub_stadium.substd_name,sub_stadium.substd_url_picture FROM `booking_detail`
    LEFT JOIN stadium 
    ON booking_detail.std_id=stadium.std_id 
    LEFT JOIN sub_stadium 
    on booking_detail.substd_id=sub_stadium.substd_id 
    WHERE booking_detail.stu_id='$stu_id'
    AND booking_detail.bkd_date='$bkd_date'
    AND booking_detail.bkd_time='$bkd_time'");
    
    if($result){
      while ($row=mysqli_fetch_assoc($result)) {
          $output[]=$row;
          # code...
      }
        echo json_encode($output);
       
    }
        }else echo "Welcome student";
    } mysqli_close($link);
   
?>