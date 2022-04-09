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
        $bkd_id =$_GET['bkd_id'];

    $result = mysqli_query($link, "SELECT * FROM booking_detail WHERE bkd_id='$bkd_id'");
    
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