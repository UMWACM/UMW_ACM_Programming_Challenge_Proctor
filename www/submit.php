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
      <h1><u>Submit</u></h1>
      <p>Team Name: <input type='text' name='TeamName'></p>
      <p>Contact Emails: <input type='text' name='ContactEmails'></p>
      <p>Problem ID: <input type='text' name='ProblemID'></p>
      <p>Language: <select name='Language'>
        <option value="c">C</option>
        <option value="java">Java</option>
        <option value="python2">Python 2</option>
        <option value="python3">Python 3</option>
      </select></p>
      <p>Solution File: <input type='file' name='SolutionCode'></p>
      <p>I want hints: <input type='checkbox' name='HintsUsed'></p>
      <input type='submit' value='Submit Your Code'>
    </form>
<?php
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
  die("");
}
require_once 'leaderboard_db.php';
require_once 'util.php';
echo "<h2><u>Proctor Output:</u></h2> <pre>";

$testid = dechex(rand(0, PHP_INT_MAX));
$tmp_dir = sys_get_temp_dir()."/chal_sub_".$testid."/";
mkdir($tmp_dir);
$tmp_src = $tmp_dir.basename($_FILES["SolutionCode"]["name"]);

move_uploaded_file($_FILES['SolutionCode']['tmp_name'], $tmp_src);

$source_code = file_get_contents($tmp_src);

$hints = "no";
if (isset($_POST['HintsUsed'])) {
  $hints = "yes ";
  echo "[ Using Hints ]\n";
}

$lang=strtolower(trim( $_POST["Language"] ));

$id=strtolower(trim( $_POST["ProblemID"] ));
echo "[ ID $id ]\n";

$chal_dir = getChalDir($id, 0);
$difficulty = explode("/", $chal_dir)[3];
echo "[ Difficulty $difficulty ]\n";
$chal_dir = getChalDir($id, 0);

$docker_run_cmd = "docker run ".
                  "--name ".$testid." ". # allow us to kill container after timeout
                  "--net=none ". # Disable internet access
                  "--volumes-from acm_proctor ".
                  "jeffreypmcateer/acm-programming-challenge-sandbox ".
                  escapeshellarg($lang)." ".escapeshellarg(basename($tmp_src)).
                  " ".escapeshellarg($tmp_dir)." ".escapeshellarg($chal_dir."/in/").
                  " 2>&1";

// Actually run the code (inside a container, of course)
passthru($docker_run_cmd);
// echo $docker_run_cmd; // Development

// Loop through and compare their out files with our out files
$out_dir = $chal_dir."/out";
$total_tests = 0;
$correct_tests = 0;
$i = -1;
while ($i < 1000) {
  $i++;
  $total_tests++;
  $correct_out_file = $out_dir."/".$i.".txt";
  $their_out_file = $tmp_dir.$i.".txt";
  if (!file_exists($correct_out_file)) {
    break;
  }
  if (!file_exists($their_out_file)) {
    continue;
  }
  $correct_out = strtolower(trim( file_get_contents($correct_out_file) ));
  
  $their_out = strtolower(trim( file_get_contents($their_out_file) ));
  
  exec("diff --ignore-space-change --ignore-blank-lines --ignore-case '".$correct_out_file."' '".$their_out_file."'", $diff_output, $diff_exit_code);
  
  
  $diff_output = implode($diff_output, ""); // Join array with ""
  echo "\$diff_output=$diff_output\n";
  echo "\$diff_exit_code=$diff_exit_code\n";
  // Use 2 methods as PHP's string comparison is flaky.
  if ($their_out === $correct_out || ($diff_exit_code == 0 && $diff_output === "")) {
    $correct_tests++;
  }
}
$total_tests--;

$percent_passed = round(100 * ($correct_tests/$total_tests));
echo "Passed $correct_tests out of $total_tests\n";
echo "Percent passed: $percent_passed\n";

if ($correct_tests > 0) {
  
  $submission_num = 1;
  $sql_statement = "";
  $query = $l_db->query("SELECT * FROM '$l_table' WHERE TeamName='".sql_kinda_escaped($_POST["TeamName"])."' AND Difficulty='".$difficulty."'");
  $row = $query->fetchArray();
  if ($row && $row['TeamName'] == sql_kinda_escaped($_POST["TeamName"])) {
    echo "Updating previous solution...\n";
    $submission_num += intval($row['SubmissionCount'], 10);
    $sql_statement = sprintf("UPDATE '$l_table' SET ".
      "'TimeStamp'=%d,'TeamName'='%s','ContactEmails'='%s','ProblemID'='%s','Difficulty'='%s','Language'='%s','SourceCode'='%s','PercentPassed'=%d,'HintsUsed'=%d,'SubmissionCount'=%d".
      " WHERE ".
      " TeamName='%s' AND Difficulty='%s'",
      time(),
      sql_kinda_escaped($_POST["TeamName"]),
      sql_kinda_escaped($_POST["ContactEmails"]),
      sql_kinda_escaped($_POST["ProblemID"]),
      $difficulty,
      $lang,
      sql_kinda_escaped($source_code),
      $percent_passed,
      $hints,
      $submission_num,
      sql_kinda_escaped($_POST["TeamName"]),
      $difficulty);
  }
  else {
    echo "Adding entry to database of solvers...\n";
    $sql_statement = sprintf("INSERT INTO '$l_table' ".
      "('TimeStamp','TeamName','ContactEmails','ProblemID','Difficulty','Language','SourceCode','PercentPassed','HintsUsed','SubmissionCount')".
      " VALUES ".
      "(%d,          '%s',      '%s',           '%s',        '%s',       '%s',      '%s',         %d,             %d,         %d)",
      time(),
      sql_kinda_escaped($_POST["TeamName"]),
      sql_kinda_escaped($_POST["ContactEmails"]),
      sql_kinda_escaped($_POST["ProblemID"]),
      $difficulty,
      $lang,
      sql_kinda_escaped($source_code),
      $percent_passed,
      $hints,
      $submission_num);
  }
  //echo "DEBUG: $sql_statement\n\n";
  $l_db->exec($sql_statement);
}

unlink($tmp_src);
exec("docker rm ".$testid);
exec("rm -rf ".escapeshellarg($tmp_dir));

echo "</pre>";
?>
  </body>
</body>