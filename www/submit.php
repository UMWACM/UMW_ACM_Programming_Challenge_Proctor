<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  
  $tmp_dir = sys_get_temp_dir()."/acm_weekly_challenge_tmp_".dechex(rand(0, PHP_INT_MAX))."/";
  // World executable on directories means that if you know the EXACT name of a file in it, you may access it.
  // It disallows listing files.
  mkdir($tmp_dir, 0771);
  
  $tmp_src = $tmp_dir.basename($_FILES["SolutionCode"]["name"]);
  move_uploaded_file($_FILES['SolutionCode']['tmp_name'], $tmp_src);
  // We actually need the solution to be world-readable so we may copy it to our protected tmp dir & compile/execute
  chmod($tmp_src, 0774);
  
  $hints = "";
  if (isset($_POST['Hints'])) {
    $hints = "--hints ";
  }
  
  $output = shell_exec("/opt/acm_challenge_proctor/proctor/run.sh ".escapeshellcmd(escapeshellarg($_POST["TeamName"]))." ".escapeshellcmd(escapeshellarg($_POST["ContactEmail"]))." ".escapeshellcmd(escapeshellarg($_POST["ProblemID"]))." ".escapeshellcmd(escapeshellarg($tmp_src))." ".$hints."--web");
  
  echo "<h3><u>Proctor Output:</u></h3>";
  echo "<pre>$output</pre><br>";
  echo "<a href='http://cs.umw.edu/~jmcateer/leaderboard.php'>Take a look at the leaderboard!</a>"
  
  chmod($tmp_src, 0000);
  unlink($tmp_src);
  unlink($tmp_dir);
  
}
?>