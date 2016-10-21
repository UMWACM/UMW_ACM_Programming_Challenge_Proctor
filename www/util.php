<?php

$first_challenge_date = "2016/10/20";

// Turn these on during development
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Was going to write myself, but then I saw http://stackoverflow.com/a/1162502
function sql_kinda_escaped($value) {
    $search = array("\\",  "\x00", "\n",  "\r",  "'",  '"', "\x1a");
    $replace = array("\\\\","\\0","\\n", "\\r", "\'", '\"', "\\Z");
    return str_replace($search, $replace, $value);
}

function reverse_sql_kinda_escaped($value) {
    $search = array("\\\\","\\0","\\n", "\\r", "\'", '\"', "\\Z");
    $replace = array("\\",  "\x00", "\n",  "\r",  "'",  '"', "\x1a");
    return str_replace($search, $replace, $value);
}

function currentChallengeBeginDate() {
  global $first_challenge_date;
  $first_challenge_epoch = strtotime($first_challenge_date);
  $two_weeks = 2 * 7 * 24 * 60 * 60;
  $now_epoch = time();
  $delta = $now_epoch - $first_challenge_epoch;
  $weeks = floor($delta / $two_weeks);
  $this_challenge_epoch = $first_challenge_epoch + ($weeks * $two_weeks);
  date_default_timezone_set('GMT');
  return date('Y-m-d', $this_challenge_epoch);
}

function previousChallengeBeginDate($num) {
  global $first_challenge_date;
  $num = $num + 1;
  $first_challenge_epoch = strtotime($first_challenge_date);
  $two_weeks = 2 * 7 * 24 * 60 * 60;
  $now_epoch = time();
  $delta = $now_epoch - $first_challenge_epoch;
  if ($delta / ($num * $two_weeks) < 0.01) {
    echo "$delta / ($num * $two_weeks) = ".($delta / ($num * $two_weeks))."\n";
    die("Gone too far back in time!\n");
  }
  $weeks = floor($delta / ($num * $two_weeks));
  $this_challenge_epoch = $first_challenge_epoch + ($weeks * $two_weeks);
  date_default_timezone_set('GMT');
  return date('Y-m-d', $this_challenge_epoch);
}

function getChalDir($id, $back) {
  $prefix = "/challenge_db/".previousChallengeBeginDate($back);
  
  $easy_id = strtolower(rtrim( file_get_contents($prefix."/easy/id.txt") ));
  $medium_id = strtolower(rtrim( file_get_contents($prefix."/medium/id.txt") ));
  $difficult_id = strtolower(rtrim( file_get_contents($prefix."/difficult/id.txt") ));
  
  $difficulty = "unknown";
  if ($id == $easy_id) {
    $difficulty = "easy";
  }
  else if ($id == $medium_id) {
    $difficulty = "medium";
    
  } else if ($id == $difficult_id) {
    $difficulty = "difficult";
  } else {
    echo "Problem with ID $id not found for week".
         currentChallengeBeginDate().", going back 1 week...\n";
    return getChalDir($id, $back + 1);
    
  }
  return $prefix."/".$difficulty;
}

?>