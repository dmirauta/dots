#!/usr/bin/env python

import sys
from subprocess import getoutput

_, window_id, class_name, instance_name, consequences = sys.argv
window_name = getoutput(f"xprop -id {window_id} | grep \"WM_NAME(STRING)\"")

# with open("/tmp/sanity_check", "a") as f:
#     f.write(f"{sys.argv}\n")

if "Figure" in window_name:
    print("state=floating")
else:
    print() # no special props

