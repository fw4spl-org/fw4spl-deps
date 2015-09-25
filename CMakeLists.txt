cmake_minimum_required(VERSION 2.8)

project(BinPkgs)

#looking for patch command
include( ${CMAKE_SOURCE_DIR}/cmake/utils/patch.cmake)

set(COMMON_CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
                      -DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}
                      -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                      -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
                      -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
                      -DCMAKE_LINKER=${CMAKE_LINKER}
)

set(CROSS_COMPILING OFF CACHE BOOL "Cross compilation option")

if(CROSS_COMPILING)
    if(NOT CMAKE_TOOLCHAIN_FILE)
        execute_process(COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/android/clean_all.cmake)
        set(CMAKE_TOOLCHAIN_FILE CACHE FILEPATH "Path to the toolchain file")
    endif()
    list(APPEND COMMON_CMAKE_ARGS -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}
                                  -DANDROID_ABI=${ANDROID_ABI}
                                  -DANDROID_NATIVE_API_LEVEL=${ANDROID_NATIVE_API_LEVEL})
endif()

if(WIN32 OR CMAKE_HOST_WIN32 )
    set(MAKE nmake)
else()
    set(MAKE make)
    if(NOT APPLE)
        list(APPEND COMMON_CMAKE_ARGS -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON)
    endif()
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

##DESKTOP DEPS ##
if(NOT ANDROID)
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
    list(APPEND SUBDIRECTORIES itk)
    list(APPEND SUBDIRECTORIES camp)
    list(APPEND SUBDIRECTORIES cppunit)
    list(APPEND SUBDIRECTORIES ann)
    list(APPEND SUBDIRECTORIES dcmtk)

    list(APPEND SUBDIRECTORIES cryptopp)
    list(APPEND SUBDIRECTORIES tetgen)
    list(APPEND SUBDIRECTORIES json-spirit)
    list(APPEND SUBDIRECTORIES glm)
##ANDROID DEPS##
else()
    list(APPEND SUBDIRECTORIES jpeg)
    list(APPEND SUBDIRECTORIES zlib)
    list(APPEND SUBDIRECTORIES tiff)
    list(APPEND SUBDIRECTORIES png)
    list(APPEND SUBDIRECTORIES libiconv)
    list(APPEND SUBDIRECTORIES libxml)
    list(APPEND SUBDIRECTORIES expat)
    list(APPEND SUBDIRECTORIES boost)
    list(APPEND SUBDIRECTORIES freetype)
    list(APPEND SUBDIRECTORIES vtk)
    list(APPEND SUBDIRECTORIES camp)
    list(APPEND SUBDIRECTORIES ann)
    list(APPEND SUBDIRECTORIES json-spirit)
    list(APPEND SUBDIRECTORIES android_native_app)
    list(APPEND SUBDIRECTORIES glm)
endif()

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

if(APPLE)
    find_program(PYTHON_EXECUTABLE python ${PATH})

    add_custom_target(install_tool
        COMMAND find . -name '*.dylib' -o -name '*.framework' | xargs ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/CMake/OSXTools/osx_install_name_tool.py –-progress -a -f -u -p
        WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}
    )

endif(APPLE)
