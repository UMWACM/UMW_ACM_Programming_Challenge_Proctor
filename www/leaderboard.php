<html>
  <head>
    <title>UMW ACM Programming Competition Leaderboard</title>
    <link rel='stylesheet' type='text/css' href='style.css'>
    <meta http-equiv='refresh' content='60'>
    <style>
      html, body {
        background: white;
      }
    </style>
  </head>
  <body>
    <h1><u>ACM Bi-Weekly Challenge Leaderboard</u></h1>
<?php

require_once 'leaderboard_db.php';

$query = $l_db->query("SELECT * FROM '$l_table'");

echo "<table>";
echo "<tr> <th>Timestamp</th><th>Team Name</th><th>Difficulty</th><th>Percent Passed</th><th>Hints Used</th><th>Number of Submissions</th> </tr>";

while ($row = $query->fetchArray()) {
  echo sprintf("<tr> <td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td> </tr>",
    date('Y-m-d H:i', $row['TimeStamp']),
    $row['TeamName'],
    $row['Difficulty']." - ".$row['ProblemID'],
    $row['PercentPassed'],
    $row['HintsUsed'],
    $row['SubmissionCount']); 
}

echo "</table>";

?>
<footer>
<hr><p>
<?php
echo "Generated at ".shell_exec("/bin/date");
?>
</p>
</footer>
  </body>
</html>