<?php

$dir = 'sqlite://var/lib/acm_challenge_proctor/leaderboard.db';
$dbh  = new PDO($dir) or die("cannot open the database");
$query =  "SELECT * FROM combo_calcs WHERE options='easy'";
foreach ($dbh->query($query) as $row) {
  echo $row[0];
}

?>