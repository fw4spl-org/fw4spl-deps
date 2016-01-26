import os
import sys
import fnmatch

REPLACE_VAR = "${EXTERNAL_LIBRARIES}"

def replace(file_src, text_to_search , text_to_replace):
    print("[%s]\treplace: %s\tto: %s" % (file_src, text_to_search, text_to_replace))
    
    file_data = None
    with open(file_src, 'r') as file :
      file_data = file.read()
    
    # Replace the target string
    file_data = file_data.replace(text_to_search, text_to_replace)
    
    with open(file_src, 'wb') as file:
      file.write(file_data)

def main(args):
    if len(args) < 1:
        print("usage: %s install_prefix" % os.path.basename(__file__))
        sys.exit() 
    
    install_prefix = args[0]
    for root, dirnames, filenames in os.walk(install_prefix):
        for filename in fnmatch.filter(filenames, '*.cmake'):
            full_path = os.path.join(root, filename)
            replace(full_path, install_prefix, REPLACE_VAR)
     
if __name__ == '__main__':
    main(sys.argv[1:])
    
