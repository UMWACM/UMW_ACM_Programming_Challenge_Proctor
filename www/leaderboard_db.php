<?php
require 'util.php';

// will be something like '2016-10-03', the day the challenge began
$l_table = "_".currentChallengeBeginDate();

$l_db = new SQLite3('/var/lib/acm_challenge_proctor/leaderboard.db');

$this_weeks_table_does_not_exist = count($l_db->query("SELECT count(*) FROM sqlite_master WHERE type='table' AND name='$l_table';")->fetchArray());

if ($this_weeks_table_does_not_exist < 2) {
  // Clone the TEMPLATE_TABLE table
  //$l_db->exec("SELECT * INTO '$l_table' FROM TEMPLATE_TABLE");
  //$l_db->("INSERT INTO '$l_table' SElECT * FROM TEMPLATE_TABLE");
  $l_db->exec("CREATE TABLE '$l_table' AS SELECT * FROM TEMPLATE_TABLE WHERE 0");
}



?>