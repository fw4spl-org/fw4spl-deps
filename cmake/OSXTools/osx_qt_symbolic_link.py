# -*- coding: UTF8 -*-

# osx_qt_symbolic_link.py:
# Launch script inside de the Qt install dir
# If 5 and Current inside Qt frameworks 
# are both a copy of the current lib,
# The script will replace the Current folder
# by a symbolic link of 5 folder

import glob
import os

path=os.getcwd()

if(os.path.isdir("lib")):
    filesList = []
    os.chdir("lib")
    print "Create symbolic link for: "
    count = 0
    for framework in glob.glob("Qt*.framework"):
        currentPath = framework+"/Versions/Current"
        if( os.path.isdir(currentPath) and os.path.islink(currentPath) == False):
            print framework
            rmCmd ="rm -rf "+currentPath
            os.system(rmCmd)
            lnCmd ="ln -s 5 "+currentPath
            os.system(lnCmd)
            count+=1
    if(count==0):
        print "-- Already done."
    else:
        print "-- ",count," symbolic link created."