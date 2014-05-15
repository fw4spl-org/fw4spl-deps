CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(BinPkgs)

IF(WIN32)
    SET(MAKE nmake)
ELSE()
    SET(MAKE make)
ENDIF()

SET(ARCHIVE_DIR ${CMAKE_SOURCE_DIR}/archive CACHE PATH "Archive directory")

MACRO(GET_CACHED_URL URL CACHED_URL)
    STRING(REGEX MATCH "[^/]*$" FNAME "${URL}")
    IF(EXISTS ${ARCHIVE_DIR}/${FNAME})
        SET(${CACHED_URL} ${ARCHIVE_DIR}/${FNAME})
    ELSE()
        SET(${CACHED_URL} ${URL})
    ENDIF()
ENDMACRO()


#Debug/Release
SET(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Choose the type of build.")
SET(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/${CMAKE_BUILD_TYPE}" CACHE PATH "Install directory")

SET(NUMBER_OF_PARALLEL_BUILD "1" CACHE STRING "Number of parallel build for non-make based subprojects")

IF(CMAKE_BUILD_TYPE MATCHES "Release")
    SET(IS_DEBUG FALSE)
ELSE()
    SET(IS_DEBUG TRUE)
ENDIF()

SET(ADDITIONAL_DEPS CACHE PATH "Paths to the additional deps")

list(APPEND SUBDIRECTORIES jpeg)
list(APPEND SUBDIRECTORIES zlib)
list(APPEND SUBDIRECTORIES tiff)
list(APPEND SUBDIRECTORIES png)
list(APPEND SUBDIRECTORIES libiconv)
list(APPEND SUBDIRECTORIES libxml)
list(APPEND SUBDIRECTORIES expat)
list(APPEND SUBDIRECTORIES python)
list(APPEND SUBDIRECTORIES boost)
list(APPEND SUBDIRECTORIES freetype)
list(APPEND SUBDIRECTORIES icu4c)

IF(NOT APPLE)
    list(APPEND SUBDIRECTORIES curl)
    list(APPEND SUBDIRECTORIES numpy)
ENDIF()

list(APPEND SUBDIRECTORIES qt)
list(APPEND SUBDIRECTORIES vtk)
list(APPEND SUBDIRECTORIES vxl)
list(APPEND SUBDIRECTORIES gdcm)
list(APPEND SUBDIRECTORIES hdf5)
list(APPEND SUBDIRECTORIES itk)
list(APPEND SUBDIRECTORIES camp)
list(APPEND SUBDIRECTORIES cppunit)
list(APPEND SUBDIRECTORIES ann)
list(APPEND SUBDIRECTORIES dcmtk)

IF(NOT APPLE)
    list(APPEND SUBDIRECTORIES wxWidgets)
ENDIF() 

list(APPEND SUBDIRECTORIES cryptopp)
list(APPEND SUBDIRECTORIES tetgen)
list(APPEND SUBDIRECTORIES json-spirit)

FOREACH(subdir ${SUBDIRECTORIES})
    # define an uninstall target for each project
    configure_file(
        "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
        "${CMAKE_CURRENT_BINARY_DIR}/${subdir}/cmake_uninstall.cmake"
        IMMEDIATE @ONLY)

    add_custom_target(${subdir}_uninstall
        COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/${subdir}/cmake_uninstall.cmake)

    # define the standard location for the intermediate install directory
    SET(INSTALL_PREFIX_${subdir} ${CMAKE_CURRENT_BINARY_DIR}/${subdir}/${subdir}-prefix/src/${subdir}-install-tmp)

    ADD_SUBDIRECTORY(${subdir})
ENDFOREACH()

set(SUBDIRECTORIES "")

IF(ADDITIONAL_DEPS)

    FOREACH(DEPS ${ADDITIONAL_DEPS})
        GET_FILENAME_COMPONENT(DEPS_NAME ${DEPS} NAME)
        ADD_SUBDIRECTORY(${DEPS} ${CMAKE_BINARY_DIR}/additional_deps/${DEPS_NAME})
    ENDFOREACH()
    
ENDIF()
