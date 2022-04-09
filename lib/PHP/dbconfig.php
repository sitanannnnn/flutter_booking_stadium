<?php
   
   try{
   	header("content-type:text/javascript;charset=utf-8");
      $link = new PDO('mysql:host=localhost;dbname=std_booking_db','root','12345aomam');
      $link -> setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_EXCEPTION);
      // echo "Yes Connected";
   }catch (PDOException $exc){
      echo $exc -> getMessage();
      die("could not connect");
   }

   ?>
