macro(installWatchUnix TEMP_PATH INSTALL_PATH)
    set(TEMP_PATH ${TEMP_PATH}${INSTALL_PATH})

    # create the directory where the install_manifest.txt will be written
    string(FIND ${CMAKE_CURRENT_SOURCE_DIR} "/" SLASHPOS REVERSE)
    string(SUBSTRING ${CMAKE_CURRENT_SOURCE_DIR} ${SLASHPOS} -1 PROJECTNAME)
    set(BUILD_DIR "${CMAKE_CURRENT_SOURCE_DIR}${PROJECTNAME}-prefix/src${PROJECTNAME}-build")
    file(MAKE_DIRECTORY ${BUILD_DIR})

    # retrieve the list of files in the intermediate install path
    file(GLOB_RECURSE FILE_LIST "${TEMP_PATH}/*")

    # clean the old install_manifest.txt
    file(REMOVE "${BUILD_DIR}/install_manifest.txt")

    foreach(FILENAME IN LISTS FILE_LIST)
        # write the filename in the install_manifest.txt
        file(RELATIVE_PATH REL_FILENAME ${TEMP_PATH} ${FILENAME})
        file(TO_NATIVE_PATH "/${REL_FILENAME}" INSTALL_FILENAME)
        file(RELATIVE_PATH REL_FILENAME ${INSTALL_PATH} "/${REL_FILENAME}")
        file(APPEND "${BUILD_DIR}/install_manifest.txt" "${INSTALL_FILENAME}\n")
        
        # patch .la files on Linux and MacOSX to reflect the library move
        # it would be better to perform this with libtool but no solution was found atm
 #       if(UNIX OR APPLE)
 #           string(LENGTH ${REL_FILENAME} LEN_FILENAME)
 #           math(EXPR EXT_POS "${LEN_FILENAME}-3")
 #           string(SUBSTRING ${REL_FILENAME} ${EXT_POS} -1 EXTENSION)
 #           if(${EXTENSION} STREQUAL ".la" OR ${EXTENSION} STREQUAL ".pc")
 #               file(STRINGS ${FILENAME} FILE_CONTENT NEWLINE_CONSUME)
 #               string(REPLACE ${TEMP_PATH} ${INSTALL_PATH} FILE_CONTENT ${FILE_CONTENT})
 #               file(WRITE ${FILENAME} "${FILE_CONTENT}")
 #           endif()
 #       endif()

        # Copy the file at the final install place    
        string(FIND ${INSTALL_FILENAME} "/" SLASHPOS REVERSE)
        string(SUBSTRING  ${INSTALL_FILENAME} 0 ${SLASHPOS} INSTALL_DIR)
        file(INSTALL ${FILENAME} DESTINATION ${INSTALL_DIR} USE_SOURCE_PERMISSIONS)
    endforeach()

    file(REMOVE_RECURSE ${TEMP_PATH})
endmacro()

macro(installWatchWin32 TEMP_PATH INSTALL_PATH)
    # create the directory where the install_manifest.txt will be written
    get_filename_component(PROJECTNAME ${CMAKE_CURRENT_SOURCE_DIR} NAME)
    set(BUILD_DIR "${CMAKE_CURRENT_SOURCE_DIR}/${PROJECTNAME}-prefix/src/${PROJECTNAME}-build")
    file(MAKE_DIRECTORY ${BUILD_DIR})

    # retrieve the list of files in the intermediate install path
    file(GLOB_RECURSE FILE_LIST "${TEMP_PATH}/*")

    # clean the old install_manifest.txt
    file(REMOVE "${BUILD_DIR}/install_manifest.txt")

    foreach(FILENAME IN LISTS FILE_LIST)
        # write the filename in the install_manifest.txt
        file(RELATIVE_PATH REL_FILENAME ${TEMP_PATH} ${FILENAME})
        file(TO_CMAKE_PATH "${INSTALL_PATH}/${REL_FILENAME}" INSTALL_FILENAME)
        file(APPEND "${BUILD_DIR}/install_manifest.txt" "${INSTALL_FILENAME}\n")
        
        # Copy the file at the final install place
        get_filename_component(INSTALL_DIR ${INSTALL_FILENAME} DIRECTORY)
        file(INSTALL ${FILENAME} DESTINATION ${INSTALL_DIR} USE_SOURCE_PERMISSIONS)
    endforeach()

    file(REMOVE_RECURSE ${TEMP_PATH})
endmacro()

if(WIN32)
    installWatchWin32(${SRC} ${DST})
else()
    installWatchUnix(${SRC} ${DST})
endif()

