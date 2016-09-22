cmake_minimum_required(VERSION 3.0)

if(NOT PATCH_EXECUTABLE)

    message(STATUS "Checking for patch...")
    
    
    # if we are building for Android, we should not use CMAKE_FIND_ROOT_PATH when finding a program
    # so we disable it temporarily, and we will reset it after find_program
    if( ANDROID )
        set( TMP_PREVIOUS_CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ${CMAKE_FIND_ROOT_PATH_MODE_PROGRAM})
        set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER )
    endif()
    
    #necessary hack
    set(PRGM_FILES_X86 "ProgramFiles(x86)")
    
    find_program(PATCH_EXECUTABLE 
        NAMES patch patch.exe
        PATHS "usr/bin"
              "$ENV{ProgramW6432}/GnuWin32/bin"
              "$ENV{ProgramW6432}/Git/bin"
              "$ENV{ProgramW6432}/Git/usr/bin"
              "$ENV{${PRGM_FILES_X86}}/GnuWin32/bin"
              "$ENV{${PRGM_FILES_X86}}/Git/bin"
              "$ENV{${PRGM_FILES_X86}}/Git/usr/bin"
              "${CMAKE_BINARY_DIR}/patch/msysgit-Git-1.9.5-preview20150319/bin"
    )
    
    # if we are building for Android, now we have to
    # reset CMAKE_FIND_ROOT_PATH_MODE_PROGRAM
    if( ANDROID )
        set( CMAKE_FIND_ROOT_PATH_MODE_PROGRAM ${TMP_PREVIOUS_CMAKE_FIND_ROOT_PATH_MODE_PROGRAM} )
    endif()  
    
    
    if(NOT PATCH_EXECUTABLE)
    
        message(STATUS "...not found in the given directories.")
        
        if(CMAKE_HOST_WIN32 OR WIN32)
        
            # make sure the patch does not exist, and that we missed it by error
            if(EXISTS "${CMAKE_BINARY_DIR}/patch/msysgit-Git-1.9.5-preview20150319/bin/patch.exe") 
                message(FATAL_ERROR "File ${CMAKE_BINARY_DIR}/patch/msysgit-Git-1.9.5-preview20150319/bin/patch.exe exists but var PATCH_EXECUTABLE was still not set")
            endif()
        
            #download git-patch for Windows
            message(STATUS "Downloading git-patch for Windows")
            set(PATCH_URL https://github.com/msysgit/msysgit/archive/Git-1.9.5-preview20150319.tar.gz)
            file(DOWNLOAD ${PATCH_URL} ${CMAKE_BINARY_DIR}/patch/Git-1.9.5-preview20150319.tar.gz
                 SHOW_PROGRESS
                 EXPECTED_MD5 297d65910bac4097a5b079b1bc36917e)
                 
            #uncompressing 
            message(STATUS "Uncompressing git-patch for Windows")
            execute_process(COMMAND ${CMAKE_COMMAND} -E tar xvf Git-1.9.5-preview20150319.tar.gz
                            WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/patch/")
                            
            #checking it's really ok
            if(NOT EXISTS "${CMAKE_BINARY_DIR}/patch/msysgit-Git-1.9.5-preview20150319/bin/patch.exe") 
                message(FATAL_ERROR "File ${CMAKE_BINARY_DIR}/patch/msysgit-Git-1.9.5-preview20150319/bin/patch.exe was still not found")                
            endif()
                     
            #done !
            set(PATCH_EXECUTABLE "${CMAKE_BINARY_DIR}/patch/msysgit-Git-1.9.5-preview20150319/bin/patch.exe")                   
            message(STATUS "Done")
            
        else()
            message(FATAL_ERROR "ABORT : Patch not found.")
        endif()
    endif()
    
    message(STATUS "SUCCESS : Found patch ${PATCH_EXECUTABLE}.")
    
    set(PATCH_EXECUTABLE ${PATCH_EXECUTABLE} CACHE FILEPATH "Patch executable" FORCE )
    
endif()


macro(patch_file baseDir patchFile)
    execute_process(COMMAND ${PATCH_EXECUTABLE} -p1 -i "${patchFile}"
                    WORKING_DIRECTORY "${baseDir}")
endmacro()
