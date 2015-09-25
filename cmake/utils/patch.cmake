cmake_minimum_required(VERSION 3.0)

if(NOT PATCH_EXECUTABLE)

    message(STATUS "Checking for patch")
    set(PRGM_FILES_X86 "ProgramFiles(x86))")
    find_program(PATCH_EXECUTABLE 
        NAME patch
        PATHS "usr/bin"
              "$ENV{ProgramFiles}/GnuWin32/bin"
              "$ENV{${PRGM_FILES_X86}}/GnuWin32/bin"
              "$ENV{ProgramFiles}/Git/bin"
              "$ENV{${PRGM_FILES_X86}}/Git/bin"
              "${CMAKE_BINARY_DIR}/patch/msysgit-Git-1.9.5-preview20150319"
    )
    
    if(NOT PATCH_EXECUTABLE)
        if(WIN32)
            #download git-patch for Windows
            set(PATCH_URL https://github.com/msysgit/msysgit/archive/Git-1.9.5-preview20150319.tar.gz)
            file(DOWNLOAD ${PATCH_URL} ${CMAKE_BINARY_DIR}/patch/Git-1.9.5-preview20150319.tar.gz
                 SHOW_PROGRESS
                 EXPECTED_MD5 297d65910bac4097a5b079b1bc36917e)
            execute_process(COMMAND ${CMAKE_COMMAND} -E tar xvf Git-1.9.5-preview20150319.tar.gz
                            WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/patch/")
            set(PATCH_EXECUTABLE "${CMAKE_BINARY_DIR}/patch/msysgit-Git-1.9.5-preview20150319/bin/patch.exe")
        else()
            message(FATAL_ERROR "Patch not found")
        endif()
    endif()
    
    message(STATUS "Found patch: ${PATCH_EXECUTABLE}")
    
    set(PATCH_EXECUTABLE ${PATCH_EXECUTABLE} CACHE STRING "Patch executable" FORCE )
    
endif()


macro(patch_file baseDir patchFile)
    execute_process(COMMAND ${PATCH_EXECUTABLE} -p1 -i "${patchFile}"
                    WORKING_DIRECTORY "${baseDir}")
endmacro()
