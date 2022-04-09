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
        $std_id =$_GET['std_id'];
    $result = mysqli_query($link, "SELECT  stadium.std_id,
              stadium.std_name,
              booking_time.bkt_id,
              booking_time.bkt_start_time,
              booking_time.bkt_end_time,
              booking_detail.bkd_id,
              booking_detail.bkd_member,
              booking_detail.bkd_date,
              booking_detail.bkd_time
      FROM stadium
      CROSS JOIN  booking_time 
        ON booking_time.std_id= '$std_id'
        AND stadium.std_id= '$std_id'
      LEFT OUTER JOIN booking_detail 
        ON booking_detail.std_id = stadium.std_id 
        AND booking_detail.bkt_id = booking_time.bkt_id 
        AND booking_detail.bkd_date = CURRENT_DATE
      ORDER BY stadium.std_id,booking_time.bkt_id;
         ");
    
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