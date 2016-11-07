<!-- advanced_leaderboard_6b60c608.php -->
<html>
  <head>
    <title>Advanced UMW ACM Programming Competition Leaderboard</title>
    <link rel='stylesheet' type='text/css' href='style.css'>
    <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.7.0/styles/default.min.css">
    <script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.7.0/highlight.min.js"></script>
    <script>hljs.initHighlightingOnLoad();</script>
    <meta http-equiv='refresh' content='60'>
    <style>
      html, body {
        background: white;
      }
    </style>
  </head>
  <body>
    <h1><u>Advanced ACM Bi-Weekly Challenge Leaderboard</u></h1>
    <a href='http://ec2-54-211-6-143.compute-1.amazonaws.com/phpliteadmin.php?download=%2Fvar%2Flib%2Facm_challenge_proctor%2Fleaderboard.db'>Download SQLite Database file.</a>
<?php

require_once 'leaderboard_db.php';

$query = $l_db->query("SELECT * FROM '$l_table' ORDER BY TimeStamp DESC");

echo "<table>";
echo "<tr> <th>Timestamp</th><th>Team Name</th><th>Email(s)</th><th>Difficulty</th><th>Percent Passed</th><th>Hints Used</th><th>Submissions</th><th>Source Code</th> </tr>";

while ($row = $query->fetchArray()) {
  echo sprintf("<tr class='%s'> <td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td style='padding:0;'><pre><code class='%s'>%s</code></pre></td> </tr>",
    strtotime(currentChallengeBeginDate()) - intval($row['TimeStamp']) < 0? "current":"history",
    date('Y-m-d H:i', $row['TimeStamp']),
    $row['TeamName'],
    $row['ContactEmails'],
    $row['Difficulty']." - ".$row['ProblemID'],
    $row['PercentPassed'],
    $row['HintsUsed'],
    $row['SubmissionCount'],
    strtolower($row['Language']),
    // Warning, this allows arbitrary javascript in source code to be eval'd by browser
    // Will fix someday with an anti-js regex
    reverse_sql_kinda_escaped($row['SourceCode']));
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
