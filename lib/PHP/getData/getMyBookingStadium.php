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
	

    $result = mysqli_query($link, "SELECT * FROM `booking_detail`
    LEFT JOIN stadium 
    ON booking_detail.std_id=stadium.std_id 
    LEFT JOIN sub_stadium 
    on booking_detail.substd_id=sub_stadium.substd_id 
    WHERE stu_id='$stu_id'
    AND bkd_date='$bkd_date'");
    
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