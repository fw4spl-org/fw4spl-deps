cmake_minimum_required(VERSION 3.0)

project(icu4cBuilder)

include(ExternalProject)

set(MAJOR_VERSION 51)
set(CACHED_URL http://download.icu-project.org/files/icu4c/${MAJOR_VERSION}.2/icu4c-${MAJOR_VERSION}_2-src.tgz)

if(WIN32)

    set(ICU4C_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
    set(ICU4C_CMAKE_ARGS ${COMMON_CMAKE_ARGS})
    ExternalProject_Add(
        icu4c
        URL ${CACHED_URL}
        URL_MD5 072e501b87065f3a0ca888f1b5165709
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        PATCH_COMMAND ${CMAKE_COMMAND} -E  copy_directory "${ICU4C_PATCH_DIR}/" "<SOURCE_DIR>"
        INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
        CMAKE_ARGS ${ICU4C_CMAKE_ARGS}
    )
else()
    ExternalProject_Add(
        icu4c
        URL ${CACHED_URL}
        URL_MD5 072e501b87065f3a0ca888f1b5165709
        DOWNLOAD_DIR ${ARCHIVE_DIR}
        BUILD_IN_SOURCE 1
        CONFIGURE_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR>/source ./configure
                        --enable-shared
                        --disable-static
                        --prefix=${CMAKE_INSTALL_PREFIX}
        BUILD_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR>/source ${MAKE}
        INSTALL_COMMAND ${CMAKE_COMMAND} -E chdir <SOURCE_DIR>/source ${MAKE} DESTDIR=${INSTALL_PREFIX_icu4c} install
    )

    ExternalProject_Add_Step(icu4c COPY_FILES
        COMMAND ${CMAKE_COMMAND} -D SRC:PATH=${INSTALL_PREFIX_icu4c} -D DST:PATH=${CMAKE_INSTALL_PREFIX} -P ${CMAKE_SOURCE_DIR}/Install.txt
        DEPENDEES install
    )
    
    if(APPLE)
        set(ICU4C_SCRIPT_DIR ${CMAKE_CURRENT_SOURCE_DIR}/script)
        ExternalProject_Add_Step(icu4c OSX_INSTALL_TOOL
            COMMAND chmod +x ${ICU4C_SCRIPT_DIR}/install_tool_icu4c.sh 
            COMMAND sh -c "${ICU4C_SCRIPT_DIR}/install_tool_icu4c.sh ${CMAKE_INSTALL_PREFIX}/lib ${MAJOR_VERSION}"
            DEPENDEES COPY_FILES
        )
    endif()
endif()
