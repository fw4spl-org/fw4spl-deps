# Installs a Python build from the Visual Studio directory to target directory

import glob
import os
import shutil
import sys

import os.path

from os.path import dirname
from os.path import abspath

def make_directory(d):
    if not os.path.exists(d):
        print "Creating directory: %s" % repr(d)
        os.makedirs(d)

def copy_files(filelist, dst):
    for f in filelist:
        f = f.replace('/', '\\')
        f, ext = os.path.splitext(f)
        for ext_ in [ext, '_d' + ext]:
            f_ = f + ext_
            if os.path.isfile(f_):
                print "Copying %s --> %s" % (f_, dst)
                shutil.copy(f_, dst)

def copy_directory(src_dir, dst_dir):
    if not os.path.isdir(src_dir):
        raise RuntimeError("Oops, couldn't find path: %s" % repr(src_dir))
    if os.path.isdir(dst_dir):
        shutil.rmtree(dst_dir)
    print "Copying %s --> %s" % (src_dir, dst_dir)
    shutil.copytree(src_dir, dst_dir)

def main(args):
    if(len(args) == 3):
        SRC_DIR = args[0]
        DST_DIR = args[1]
        CPU = args[2]
    else:
        print("usage script.py url dbname")
        return 1
        
    #SRC_DIR = r"C:\build\Python-3.5.1"
    #DST_DIR = r"C:\install\Python-3.5.1"
    #CPU = "amd64"
    
    print("SRC_DIR = %s" % SRC_DIR)
    print("DST_DIR = %s" % DST_DIR)
    print("CPU = %s" % CPU)

    if not os.path.isdir(SRC_DIR):
        raise RuntimeError("Oops, could not find path: %s" % repr(p))

    print "DST_DIR =", DST_DIR
    make_directory(DST_DIR)

    # copy python.exe
    PCBUILD_DIR = "{SRC_DIR}/PCbuild/{CPU}".format(SRC_DIR = SRC_DIR, CPU = CPU)
    filelist = """
        {py_prefix}/python.exe
        {py_prefix}/pythonw.exe
        {py_prefix}/python35.dll
    """.format(py_prefix = PCBUILD_DIR).split()
    copy_files(filelist, DST_DIR)

    # copy DLLs
    src_list = glob.glob(PCBUILD_DIR + r"\*.pyd")
    dst_dir = os.path.join(DST_DIR, "DLLs")
    make_directory(dst_dir)
    copy_files(src_list, dst_dir)

    # copy include
    src_dir = os.path.join(SRC_DIR, "Include")
    dst_dir = os.path.join(DST_DIR, "include")
    copy_directory(src_dir, dst_dir)
    src_list = ["{SRC_DIR}/PC/pyconfig.h".format(SRC_DIR = SRC_DIR)]
    copy_files(src_list, dst_dir)

    # copy Lib
    src_dir = os.path.join(SRC_DIR, "Lib")
    dst_dir = os.path.join(DST_DIR, "Lib")
    copy_directory(src_dir, dst_dir)

    # copy libs
    src_list = glob.glob(PCBUILD_DIR + r"\*.lib")
    dst_dir = os.path.join(DST_DIR, "libs")
    make_directory(dst_dir)
    copy_files(src_list, dst_dir)

    # Scripts dir
    make_directory(os.path.join(DST_DIR, "Scripts"))

    print "All done!"

if __name__ == "__main__":
    main(sys.argv[1:])

