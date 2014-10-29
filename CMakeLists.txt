cmake_minimum_required(VERSION 2.8)

project(BinPkgs)

if(WIN32)
    set(MAKE nmake)
else()
    set(MAKE make)
endif()

set(ARCHIVE_DIR ${CMAKE_SOURCE_DIR}/archive CACHE PATH "Archive directory")

macro(getCachedUrl URL CACHED_URL)
    string(REGEX MATCH "[^/]*$" FNAME "${URL}")
    if(EXISTS ${ARCHIVE_DIR}/${FNAME})
        set(${CACHED_URL} ${ARCHIVE_DIR}/${FNAME})
    else()
        set(${CACHED_URL} ${URL})
    endif()
endmacro()


#Debug/Release
set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Choose the type of build.")
set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/${CMAKE_BUILD_TYPE}" CACHE PATH "Install directory")

set(NUMBER_OF_PARALLEL_BUILD "1" CACHE STRING "Number of parallel build for non-make based subprojects")

if(CMAKE_BUILD_TYPE MATCHES "Release")
    set(IS_DEBUG FALSE)
else()
    set(IS_DEBUG TRUE)
endif()

set(ADDITIONAL_DEPS CACHE PATH "Paths to the additional deps")

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

if(NOT APPLE)
    list(APPEND SUBDIRECTORIES curl)
    list(APPEND SUBDIRECTORIES numpy)
endif()

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

if(NOT APPLE)
    list(APPEND SUBDIRECTORIES wxWidgets)
endif() 

list(APPEND SUBDIRECTORIES cryptopp)
list(APPEND SUBDIRECTORIES tetgen)
list(APPEND SUBDIRECTORIES json-spirit)

foreach(subdir ${SUBDIRECTORIES})
    # define an uninstall target for each project
    configure_file(
        "${CMAKE_CURRENT_SOURCE_DIR}/cmake_uninstall.cmake.in"
        "${CMAKE_CURRENT_BINARY_DIR}/${subdir}/cmake_uninstall.cmake"
        IMMEDIATE @ONLY)

    add_custom_target(${subdir}_uninstall
        COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/${subdir}/cmake_uninstall.cmake)

    # define the standard location for the intermediate install directory
    set(INSTALL_PREFIX_${subdir} ${CMAKE_CURRENT_BINARY_DIR}/${subdir}/${subdir}-prefix/src/${subdir}-install-tmp)

    add_subdirectory(${subdir})
endforeach()

set(SUBDIRECTORIES "")

if(ADDITIONAL_DEPS)

    foreach(DEPS ${ADDITIONAL_DEPS})
        get_filename_component(DEPS_NAME ${DEPS} NAME)
        add_subdirectory(${DEPS} ${CMAKE_BINARY_DIR}/additional_deps/${DEPS_NAME})
    endforeach()
    
endif()
