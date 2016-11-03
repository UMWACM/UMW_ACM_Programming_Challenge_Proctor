<!DOCTYPE html>
<html>
  <head>
    <title>UMW ACM Bi-Weekly Programming Competition</title>
    <link rel='stylesheet' type='text/css' href='style.css'>
  </head>
  <body>
    <h1>UMW ACM Bi-Weekly Programming Competition <a href='https://github.com/Jeffrey-P-McAteer/UMW_ACM_Programming_Challenge_Proctor/issues/new'><img title="Submit a bug report" height='36px' style='position:relative;top:12px;' src='/bugreport.png'></a></h1>
    
    <h2 style='display:inline-block;'><a onclick='toggle("About", this)' id='first'>About</a></h2>
    <h2 style='display:inline-block;'><a onclick='toggle("Easy", this)'>Easy</a></h2>
    <h2 style='display:inline-block;'><a onclick='toggle("Medium", this)'>Medium</a></h2>
    <h2 style='display:inline-block;'><a onclick='toggle("Difficult", this)'>Difficult</a></h2>
    <h2 style='display:inline-block;'><a onclick='toggle("Submit", this)'>Submit</a></h2>
    <h2 style='display:inline-block;'><a onclick='toggle("Leaderboard", this)'>Leaderboard</a></h2>
    <h2 style='display:inline-block;'><a href='/phpliteadmin.php'>DB Admin</a></h2>
    <h2 style='display:inline-block;'><a href='/advanced_leaderboard_6b60c608.php'>Admin Leaderboard</a></h2>
    <br>
    
      <iframe id='About' class='page2 doc' src='generated_instructions.html'>Your iframes aren't working! Don't worry, the document is <a href='generated_instructions.html'>here</a>.</iframe>
      
      <iframe id='Submit' style='display:none;' class='halfPage doc' src='/submit.php'>
      Please turn on iFrame support, or view the leaderboard <a href='/submit.php'>here</a>
      </iframe>
      
      <pre id='Easy' style='display:none;' class='iframe-like halfPage doc'>
<?php
require_once 'util.php';
echo trim( file_get_contents("/challenge_db/".currentChallengeBeginDate()."/easy/description.txt") );
?>
      </pre>
      
      <pre id='Medium' style='display:none;' class='iframe-like halfPage doc'>
<?php
require_once 'util.php';
echo trim( file_get_contents("/challenge_db/".currentChallengeBeginDate()."/medium/description.txt") );
?>
      </pre>
      
      <pre id='Difficult' style='display:none;' class='iframe-like halfPage doc'>
<?php
require_once 'util.php';
echo trim( file_get_contents("/challenge_db/".currentChallengeBeginDate()."/difficult/description.txt") );
?>
      </pre>
      
      <iframe id='Leaderboard' style='display:none;' class='page1 doc' src='/leaderboard.php'>Please turn on iFrame support, or view the leaderboard <a href='/leaderboard.php'>here</a></iframe>
    
      <script>
var LAST_LINK = document.getElementById('first');
var LAST_ELM = document.getElementById('About');

function toggle(id, link) {
  var elm = document.getElementById(id);
  if (LAST_LINK) hide(null, LAST_LINK);
  if (LAST_ELM) hide(LAST_ELM, null);
  if (elm.style.display === 'none') {
    show(elm, link);
  } else {
    hide(elm, link);
  }
  LAST_LINK = link;
  LAST_ELM = elm;
}
function show(elm, link) {
  if (elm) elm.style.display = '';
  if (link) {
    link.style.fontWeight = 'bold';
    link.style.textDecoration = 'underline';
  }
}
function hide(elm, link) {
  if (elm) elm.style.display = 'none';
  if (link) {
    link.style.fontWeight = 'normal';
    link.style.textDecoration = '';
  }
}
show(LAST_ELM, LAST_LINK);

     </script>
  </body>
</html>