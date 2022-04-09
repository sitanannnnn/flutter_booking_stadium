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
    $dateTime =$_GET['dateTime'];
    $result = mysqli_query($link, "SELECT stadium.std_id,
    stadium.std_name,
    stadium.std_number_of_player,
    stadium.std_url_picture,
    stadium.std_descrip_location,
    stadium.std_procedure,
    stadium_closed.stdclosed_id,
    stadium_closed.stdclosed_date,
    stadium_closed.stdclosed_note 
FROM stadium
LEFT OUTER JOIN stadium_closed 
ON stadium.std_id = stadium_closed.std_id 
AND stadium_closed.stdclosed_date = '$dateTime'");
    
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