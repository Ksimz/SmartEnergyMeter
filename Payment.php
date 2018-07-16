<?php
$servername = "localhost";
$username = "root";
$password = "Kudzai8";
$dbname = "Test_101";

if($_SERVER["REQUEST_METHOD"]=="POST")
{
    $userNumber=$_POST["CustomerNumber"];
    $Amount=$_POST["Amount"];
    // Create connection
    $conn = mysqli_connect($servername, $username, $password, $dbname);
    // Check connection
    if (!$conn) {
         die("Connection failed: " . mysqli_connect_error())."<br>";
       }

      $sql = "SELECT  balance FROM Customers WHERE CustomerNumber='$userNumber'";


      $result = mysqli_query($conn, $sql);

    if (mysqli_num_rows($result) > 0) {
         // output data of each row
         while($row = mysqli_fetch_assoc($result)) {
               $balance=$row["balance"];
               $balance=$balance+$Amount;
               $sql="UPDATE Customers Set balance='$balance' WHERE CustomerNumber='$userNumber'";
               if(mysqli_query($conn,$sql))
               {
                $row1=array("balance"=>$balance);
                echo json_encode($row1);
               }
                  
             }
        } 
    else {
         echo "0 results<br>";
         }

     mysqli_close($conn);
}
else
{
	die("Wrong Request Method");
}


 ?>
