<?php
define('hostname','localhost');
define('user','root');
define('password','Kudzai8');
define('databaseName','Test_101');

$connect=mysqli_connect(hostname,user,password,databaseName);
if(mysqli_connect_errno())
{
	echo "Failed to MSQL database:".msqli_connect_error();
}
?>
