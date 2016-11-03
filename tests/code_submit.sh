#!/bin/bash

# Python test
curl -X POST -F 'TeamName=Python Test Team' \
             -F 'ContactEmails=odi@mail.umw.edu' \
             -F 'ProblemID=d9615f' \
             -F 'Language=Python' \
             -F 'SolutionCode=@/Users/jeffrey/Downloads/easy.py' \
             http://localhost:8080/submit.php

# Java test
curl -X POST -F 'TeamName=Java Test Team' \
               -F 'ContactEmails=duke@mail.umw.edu' \
               -F 'ProblemID=d9615f' \
               -F 'Language=Java' \
               -F 'SolutionCode=@/Users/jeffrey/Downloads/easy.java' \
               http://localhost:8080/submit.php


