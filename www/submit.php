<html>
  <head>
    <title>UMW ACM Bi-Weekly Programming Competition</title>
    <link rel='stylesheet' type='text/css' href='style.css'>
    <style>
      html, body {
        background: white;
      }
    </style>
  </head>
  <body>
    <form action='/submit.php' method='post' enctype='multipart/form-data'>
      <p>Team Name: <input type='text' name='TeamName'></p>
      <p>Contact Emails: <input type='text' name='ContactEmails'></p>
      <p>Problem ID: <input type='text' name='ProblemID'></p>
      <p>Language: <select name='Language'>
        <option value="c">C</option>
        <option value="java">Java</option>
        <option value="python">Python</option>
      </select></p>
      <p>Solution File: <input type='file' name='SolutionCode'></p>
      <p>I want hints: <input type='checkbox' name='HintsUsed'></p>
      <input type='submit' value='Submit Your Code'>
    </form>
<?php

require 'leaderboard_db.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  
  $tmp_dir = sys_get_temp_dir()."/acm_weekly_challenge_tmp_".dechex(rand(0, PHP_INT_MAX))."/";
  // World executable on directories means that if you know the EXACT name of a file in it, you may access it.
  // It disallows listing files.
  mkdir($tmp_dir, 0771);
  
  $tmp_src = $tmp_dir.basename($_FILES["SolutionCode"]["name"]);
  move_uploaded_file($_FILES['SolutionCode']['tmp_name'], $tmp_src);
  // We actually need the solution to be world-readable so we may copy it to our protected tmp dir & compile/execute
  chmod($tmp_src, 0774);
  
  $hints = "no";
  if (isset($_POST['HintsUsed'])) {
    $hints = "yes ";
  }
  
  $lang=$_POST["Language"];
  // verify lang is OK, lowercase & trim it
  
  $difficulty="diff_goes_here";
  
  // execute stuff
  $percent_passed=10;
  
  $source_code="public static void main";
  
  // todo prevent against injections
  $l_db->exec(sprintf("INSERT INTO '$l_table' ".
    "('TimeStamp','TeamName','ContactEmails','ProblemID','Difficulty','Language','SourceCode','PercentPassed','HintsUsed')".
    " VALUES ".
    "(%d,          '%s',      '%s',           '%s',        '%s',       '%s',      '%s',         %d,             %d)",
    time(),
    /*mysqli_real_escape_string*/($_POST["TeamName"]),
    /*mysqli_real_escape_string*/($_POST["ContactEmails"]),
    /*mysqli_real_escape_string*/($_POST["ProblemID"]),
    $difficulty,
    $lang,
    /*mysqli_real_escape_string*/($source_code),
    /*mysqli_real_escape_string*/($percent_passed),
    /*mysqli_real_escape_string*/($hints)));
  
  echo "<hr><h3><u>Proctor Output:</u></h3>";
  //echo "<pre>$output</pre><br>";
  echo "<a href='http://cs.umw.edu/~jmcateer/leaderboard.php'>Take a look at the leaderboard!</a>";
  
  chmod($tmp_src, 0000);
  unlink($tmp_src);
  unlink($tmp_dir);
  
}
?>
  </body>
</body>