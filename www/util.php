<?php

// Turn these on during development
error_reporting(E_ALL);
ini_set('display_errors', 1);

function currentChallengeBeginDate() {
  $first_challenge_epoch = strtotime("2016/10/03");
  $two_weeks = 2 * 7 * 24 * 60 * 60;
  $now_epoch = time();
  $delta = $now_epoch - $first_challenge_epoch;
  $weeks = floor($delta / $two_weeks);
  $this_challenge_epoch = $first_challenge_epoch + ($weeks * $two_weeks);
  date_default_timezone_set('GMT');
  return date('Y-m-d', $this_challenge_epoch);
}

?>