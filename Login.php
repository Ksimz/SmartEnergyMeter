<?php
header('Content-Type:application/json');
//echo "executing";

if($_SERVER["REQUEST_METHOD"]=="POST"){
     require 'connection.php';
     Login();
   }
function Login()
{
  global $connect;
  $CustomerNumber=$_POST["customerNumber"];
  $Password=$_POST["password"];
  $query=" SELECT password FROM Customers WHERE CustomerNumber='$CustomerNumber' ";
  //, password='$Password'";
  $result=mysqli_query($connect,$query);
  if(mysqli_num_rows($result)>0){
	  //echo json_encode($result);
     $json['success']='Welcome';
     echo json_encode($json);
     //GetBalance()
     mysqli_close($connect);
  }
  else
   {
     $json['error']='wrong password';
     echo json_encode($json);
     mysqli_close($connect);
     }
   
}
?>
