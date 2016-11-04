#!/bin/bash

server=ec2-54-211-6-143.compute-1.amazonaws.com

# Python test
curl -X POST -F 'TeamName=Python Test Team' \
             -F 'ContactEmails=odi@mail.umw.edu' \
             -F 'ProblemID=d9615f' \
             -F 'Language=Python' \
             -F 'SolutionCode=@/Users/jeffrey/Downloads/easy.py' \
             http://$server/submit.php

# Java test
curl -X POST -F 'TeamName=Java Test Team' \
               -F 'ContactEmails=duke@mail.umw.edu' \
               -F 'ProblemID=d9615f' \
               -F 'Language=Java' \
               -F 'SolutionCode=@/Users/jeffrey/Downloads/easy.java' \
               http://$server/submit.php

# Tests a language incompatability bug
curl -X POST -F "TeamName=Test Team'" \
               -F 'ContactEmails=onions@mail.umw.edu' \
               -F 'ProblemID=abc123' \
               -F 'Language=Java' \
               -F 'SolutionCode=@/tmp/a.java' \
               http://$server/submit.php

curl -X POST -F "TeamName=Test Team'" \
               -F 'ContactEmails=onions@mail.umw.edu' \
               -F 'ProblemID=abc123' \
               -F 'Language=Python3' \
               -F 'SolutionCode=@/tmp/a.py' \
               http://$server/submit.php

curl -X POST -F "TeamName=Test Team'" \
               -F 'ContactEmails=onions@mail.umw.edu' \
               -F 'ProblemID=abc123' \
               -F 'Language=C' \
               -F 'SolutionCode=@/tmp/a.c' \
               http://$server/submit.php


