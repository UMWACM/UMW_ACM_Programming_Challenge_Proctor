#!/usr/bin/env python

# see http://raspberrywebserver.com/cgiscripting/sending-data-to-an-HTTP-server-get-and-post-methods.html

import sys

args=sys.stdin.read()

# print header
print "Content-type: text/html\n\n"

print "<h2>Arguments</h2>"

arg_list=args.split('&')

i=1
for arg in arg_list:
    key, value=arg.split('=')
    print "key "+str(i)+": "+key+"<br>"
    print"value "+str(i)+": "+value+"<br>"
    i +=1
