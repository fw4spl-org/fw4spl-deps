cmake_minimum_required(VERSION 3.0)

project(vlc)

include(ExternalProject)

if(WIN32)
    set(VLC_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/vlc-prefix/src/vlc)
    ExternalProject_Add(
            vlc
            URL "http://ftp.free.org/mirrors/videolan/vlc/2.2.4/win64/vlc-2.2.4-win64.7z"
            URL_HASH SHA256=983db9e452dc03f82d7637dccd359ec5f89bb4f1802670bcc86f1cf7e3824a03
            DOWNLOAD_DIR ${ARCHIVE_DIR}
            CONFIGURE_COMMAND echo "Nothing to configure..."
            BUILD_COMMAND echo "Nothing to build..."
            INSTALL_COMMAND ${CMAKE_COMMAND} -E copy_directory "${VLC_SRC_DIR}/plugins" "${INSTALL_PREFIX_vlc}/vlc/plugins"
                  COMMAND ${CMAKE_COMMAND} -E copy_directory "${VLC_SRC_DIR}/sdk/lib" "${INSTALL_PREFIX_vlc}/lib/vlc"
                  COMMAND ${CMAKE_COMMAND} -E copy_directory "${VLC_SRC_DIR}/sdk/include" "${INSTALL_PREFIX_vlc}/include"
                  COMMAND ${CMAKE_COMMAND} -E copy "${VLC_SRC_DIR}/axvlc.dll" "${INSTALL_PREFIX_vlc}/bin/axvlc.dll"
                  COMMAND ${CMAKE_COMMAND} -E copy "${VLC_SRC_DIR}/libvlc.dll" "${INSTALL_PREFIX_vlc}/bin/libvlc.dll"
                  COMMAND ${CMAKE_COMMAND} -E copy "${VLC_SRC_DIR}/libvlccore.dll" "${INSTALL_PREFIX_vlc}/bin/libvlccore.dll"
                  COMMAND ${CMAKE_COMMAND} -E copy "${VLC_SRC_DIR}/npvlc.dll" "${INSTALL_PREFIX_vlc}/bin/npvlc.dll"
        )
    ExternalProject_Add_Step(vlc COPY_FILES
        COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_vlc} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.cmake
        DEPENDEES install
    )
else()

    find_path(VLC_INCLUDE_DIR vlc/vlc.h PATHS
        /usr/include
        /usr/local/include
        /Applications/VLC.app/Contents/MacOS/include
    )

    find_library(VLC_LIBRARY NAMES vlc PATHS
        /usr/lib
        /usr/local/lib
        /Applications/VLC.app/Contents/MacOS/lib
    )

    find_library(VLC_CORE_LIBRARY NAMES vlccore PATHS
        /usr/lib
        /usr/local/lib
        /Applications/VLC.app/Contents/MacOS/lib
    )

    if(${VLC_INCLUDE_DIR} STREQUAL VLC_INCLUDE_DIR-NOTFOUND)
        message(FATAL_ERROR "Missing vlc headers on the system."
                            "You must install them, i.e. on Debian sudo apt-get install libvlc-dev.")
    endif()

    if(${VLC_LIBRARY} STREQUAL VLC_LIBRARY-NOTFOUND OR ${VLC_CORE_LIBRARY} STREQUAL VLC_CORE_LIBRARY-NOTFOUND)
        message(FATAL_ERROR "Missing vlc libraries on the system."
                            "You must install them, i.e. on Debian sudo apt-get install libvlc.")
    endif()


    if (APPLE)
        set (VLC_INSTALL_FILES)

        get_filename_component(PATH_DIR ${VLC_INCLUDE_DIR} DIRECTORY)
        get_filename_component(VLC_LIB_DIR ${VLC_LIBRARY} DIRECTORY)

        get_filename_component(VLC_LIB_NAME ${VLC_LIBRARY} NAME_WE)
        get_filename_component(VLC_CORE_LIB_NAME ${VLC_CORE_LIBRARY} NAME_WE)

        set (VLC_PLUGIN_DIR "${PATH_DIR}/plugins")

        ExternalProject_Add(
            vlc
            DOWNLOAD_COMMAND echo "Nothing to download..."
            DOWNLOAD_DIR ${ARCHIVE_DIR}
            CONFIGURE_COMMAND echo "Nothing to configure..."
            BUILD_COMMAND echo "Nothing to build..."
            INSTALL_COMMAND sh -c "cp ${VLC_LIB_DIR}/${VLC_LIB_NAME}* ${CMAKE_INSTALL_PREFIX}/lib"
                    COMMAND sh -c "cp ${VLC_LIB_DIR}/${VLC_CORE_LIB_NAME}* ${CMAKE_INSTALL_PREFIX}/lib"
                    COMMAND ${CMAKE_COMMAND} -E copy_directory ${VLC_INCLUDE_DIR} ${CMAKE_INSTALL_PREFIX}/include
                    COMMAND ${CMAKE_COMMAND} -E copy_directory ${VLC_PLUGIN_DIR} ${CMAKE_INSTALL_PREFIX}/vlc/plugins
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        )

        # Retrieve all the installed files to write install_manifest
        file(GLOB VLC_LIBRARIES ${VLC_LIB_DIR}/${VLC_LIB_NAME}.*dylib)
        file(GLOB VLC_CORE_LIBRARIES ${VLC_LIB_DIR}/${VLC_CORE_LIB_NAME}.*dylib)

        foreach(LIB ${VLC_LIBRARIES})
            string(REPLACE "${PATH_DIR}/" "${CMAKE_INSTALL_PREFIX}/" LIB ${LIB})
            string(APPEND VLC_INSTALL_FILES ${LIB} "\n")
        endforeach()

        foreach(LIB ${VLC_CORE_LIBRARIES})
            string(REPLACE "${PATH_DIR}/" "${CMAKE_INSTALL_PREFIX}/" LIB ${LIB})
            string(APPEND VLC_INSTALL_FILES ${LIB} "\n")
        endforeach()

        file(GLOB_RECURSE VLC_PLUGIN_FILES ${VLC_PLUGIN_DIR}/*.*)

        foreach(PLUGIN ${VLC_PLUGIN_FILES})
            string(REPLACE "${PATH_DIR}/" "${CMAKE_INSTALL_PREFIX}/vlc/" PLUGIN ${PLUGIN})
            string(APPEND VLC_INSTALL_FILES ${PLUGIN} "\n")
        endforeach()

        file(GLOB_RECURSE VLC_INCLUDE_FILES ${VLC_INCLUDE_DIR}/vlc/*.h)

        foreach(FILE ${VLC_INCLUDE_FILES})
            string(REPLACE "${PATH_DIR}/" "${CMAKE_INSTALL_PREFIX}/" FILE ${FILE})
            string(APPEND VLC_INSTALL_FILES ${FILE} "\n")
        endforeach()

        file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/vlc-prefix/src/vlc-build/install_manifest.txt ${VLC_INSTALL_FILES})

    else()

        string(FIND ${VLC_LIBRARY} "/" PATH_FILE_INDEX REVERSE)
        string(SUBSTRING ${VLC_LIBRARY} 0 ${PATH_FILE_INDEX} PATH_DIR)

        # We use cp command directly from a shell to be able to use a wildcard
        # This is not the most elegant way but as we are only on Linux this is okish...
        ExternalProject_Add(
            vlc
            DOWNLOAD_COMMAND echo "Nothing to download..."
            DOWNLOAD_DIR ${ARCHIVE_DIR}
            CONFIGURE_COMMAND echo "Nothing to configure..."
            BUILD_COMMAND echo "Nothing to build..."
            INSTALL_COMMAND sh -c "cp ${VLC_LIBRARY}* ${CMAKE_INSTALL_PREFIX}/lib"
                    COMMAND sh -c "cp ${VLC_CORE_LIBRARY}* ${CMAKE_INSTALL_PREFIX}/lib"
                    COMMAND ${CMAKE_COMMAND} -E copy_directory ${PATH_DIR}/vlc ${CMAKE_INSTALL_PREFIX}/lib/vlc
            INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        )

        ExternalProject_Add_Step(vlc CopyConfigFileToInstall
            COMMAND ${CMAKE_INSTALL_PREFIX}/lib/vlc/vlc-cache-gen ${CMAKE_INSTALL_PREFIX}/lib/vlc/plugins/
            COMMENT "Generate plugin cache"
            DEPENDEES install
        )

        # Create the uninstall log to allow uninstalling
        string(REPLACE "${PATH_DIR}/" "" VLC_LIBRARY_NAME ${VLC_LIBRARY})
        string(REPLACE "${PATH_DIR}/" "" VLC_CORE_LIBRARY_NAME ${VLC_CORE_LIBRARY})
        string(APPEND VLC_INSTALL_FILES ${CMAKE_INSTALL_PREFIX}/lib/${VLC_LIBRARY_NAME} "\n" ${CMAKE_INSTALL_PREFIX}/lib/${VLC_CORE_LIBRARY_NAME} "\n")

        file(GLOB_RECURSE VLC_PLUGIN_FILES ${CMAKE_INSTALL_PREFIX}/lib/vlc/*.*)

        foreach(FILE ${VLC_PLUGIN_FILES})
            string(APPEND VLC_INSTALL_FILES ${FILE} "\n")
        endforeach()

        file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/vlc-prefix/src/vlc-build/install_manifest.txt ${VLC_INSTALL_FILES})

    endif()
endif()
