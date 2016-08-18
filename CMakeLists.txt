cmake_minimum_required(VERSION 3.0)

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

if(NOT WIN32 AND NOT APPLE)
    set(SET_COMPILER_ENV export CC=${CMAKE_C_COMPILER} CXX=${CMAKE_CXX_COMPILER} &&)
endif()

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
    # This important to use '$(MAKE)' and not just 'make' to forward the flags from the command line (-j for instance)
    set(MAKE $(MAKE))
    if(NOT APPLE)
        list(APPEND COMMON_CMAKE_ARGS 
            -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=ON
        )
    else()
        list(APPEND COMMON_CMAKE_ARGS
            -DCMAKE_MACOSX_RPATH:BOOL=ON
        )
    endif()
endif()

set(ARCHIVE_DIR ${CMAKE_SOURCE_DIR}/archive CACHE PATH "Archive directory")

#Debug/Release
if (NOT CMAKE_BUILD_TYPE)
    message(STATUS "Setting build type to 'Debug' as none was specified.")
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Choose the type of build." FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release")
endif()

set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/${CMAKE_BUILD_TYPE}" CACHE PATH "Install directory")

# estimate the processor cout
include(ProcessorCount)
ProcessorCount(CPUS_COUNT)
if(CPUS_COUNT EQUAL 0)
    # default to 1 if cmake fails  
    set(CPUS_COUNT 1)
endif()

mark_as_advanced(NUMBER_OF_PARALLEL_BUILD)
set(NUMBER_OF_PARALLEL_BUILD ${CPUS_COUNT} CACHE STRING "Number of parallel build for non-make based subprojects (Boost for instance)")

if(CMAKE_BUILD_TYPE MATCHES "Release")
    set(IS_DEBUG FALSE)
else()
    set(IS_DEBUG TRUE)
endif()

set(ADDITIONAL_DEPS CACHE PATH "Paths to the additional deps")

option(ENABLE_OPEN_MP "Set to ON use allow the use of OpenMP" OFF)
option(ENABLED_OGRE_DEPS "Set to ON to build ogre" OFF)
option(ENABLED_SOFA_DEPS "Set to ON to build sofa" OFF)
option(ENABLED_PCL_DEPS "Set to ON to build PCL" OFF)

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

    list(APPEND SUBDIRECTORIES qt)
    list(APPEND SUBDIRECTORIES vtk)
    list(APPEND SUBDIRECTORIES vxl)
    list(APPEND SUBDIRECTORIES gdcm)
    list(APPEND SUBDIRECTORIES itk)
    list(APPEND SUBDIRECTORIES camp)
    list(APPEND SUBDIRECTORIES cppunit)
    list(APPEND SUBDIRECTORIES ann)
    list(APPEND SUBDIRECTORIES dcmtk)

    list(APPEND SUBDIRECTORIES tetgen)
    list(APPEND SUBDIRECTORIES json-spirit)
    list(APPEND SUBDIRECTORIES glm)
    
    list(APPEND SUBDIRECTORIES opencv)
    list(APPEND SUBDIRECTORIES aruco)
    list(APPEND SUBDIRECTORIES eigen)
    list(APPEND SUBDIRECTORIES flann)
    list(APPEND SUBDIRECTORIES bullet)
    list(APPEND SUBDIRECTORIES geodesic)

    list(APPEND SUBDIRECTORIES libarchive)
    list(APPEND SUBDIRECTORIES openigtlink)
    list(APPEND SUBDIRECTORIES zeromq)
    
    if(ENABLED_PCL_DEPS)
        if(UNIX)
            list(APPEND SUBDIRECTORIES libusb)
        endif()
        list(APPEND SUBDIRECTORIES openni)
        if(UNIX)
            list(APPEND SUBDIRECTORIES libfreenect)
        endif()
        list(APPEND SUBDIRECTORIES pcl)
    endif()
    
    if(ENABLED_SOFA_DEPS)
        list(APPEND SUBDIRECTORIES glew)
        if (NOT APPLE)
            list(APPEND SUBDIRECTORIES freeglut)
        endif()
        list(APPEND SUBDIRECTORIES sofa)
    endif()    

    if(ENABLED_OGRE_DEPS)
        list(APPEND SUBDIRECTORIES zzip)
        list(APPEND SUBDIRECTORIES freeimage)
        list(APPEND SUBDIRECTORIES ogre)
    endif()

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
    list(APPEND SUBDIRECTORIES vxl)
    list(APPEND SUBDIRECTORIES opencv)
    list(APPEND SUBDIRECTORIES aruco)
    if(ENABLED_PCL_DEPS)
        list(APPEND SUBDIRECTORIES flann)
        list(APPEND SUBDIRECTORIES eigen)
        list(APPEND SUBDIRECTORIES pcl)
    endif()

    list(APPEND SUBDIRECTORIES libarchive)
    list(APPEND SUBDIRECTORIES openigtlink)
    list(APPEND SUBDIRECTORIES zeromq)
endif()

macro(createUninstallTarget SUBDIR )

    # define an uninstall target for each project
    configure_file(
        "${CMAKE_SOURCE_DIR}/cmake_uninstall.cmake.in"
        "${CMAKE_CURRENT_BINARY_DIR}/${SUBDIR}/cmake_uninstall.cmake"
        IMMEDIATE @ONLY)

    add_custom_target(${SUBDIR}_uninstall
        COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/${SUBDIR}/cmake_uninstall.cmake)

    # define the standard location for the intermediate install directory
    set(INSTALL_PREFIX_${SUBDIR} ${CMAKE_CURRENT_BINARY_DIR}/${SUBDIR}/${SUBDIR}-prefix/src/${SUBDIR}-install-tmp)

endmacro()

macro(createCleanTarget SUBDIR )

    configure_file(
        "${CMAKE_SOURCE_DIR}/cmake_clean.cmake.in"
        "${CMAKE_CURRENT_BINARY_DIR}/${SUBDIR}/cmake_clean.cmake"
        IMMEDIATE @ONLY)

    add_custom_target(${SUBDIR}_clean
        COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/${SUBDIR}/cmake_clean.cmake)
    add_dependencies(${SUBDIR}_clean ${SUBDIR}_uninstall)

endmacro()

foreach(subdir ${SUBDIRECTORIES})

    # define an uninstall target for each project
    createUninstallTarget(${subdir})

    # define a clean target for each project
    createCleanTarget(${subdir})

    add_subdirectory(${subdir})
endforeach()

set(SUBDIRECTORIES "")

if(ADDITIONAL_DEPS)

    foreach(DEPS ${ADDITIONAL_DEPS})
        get_filename_component(DEPS_NAME ${DEPS} NAME)
        add_subdirectory(${DEPS} ${CMAKE_BINARY_DIR}/additional_deps/${DEPS_NAME})
    endforeach()

endif()

find_program(PYTHON_EXECUTABLE python ${PATH})

if(APPLE)
    add_custom_target(install_tool
        COMMAND find . -name '*.dylib' -o -name '*.framework' | xargs ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/CMake/OSXTools/osx_install_name_tool.py –-progress -a -f -u -p
        WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}
    )
endif()

add_custom_target(fix_path
    COMMAND ${PYTHON_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/CMake/utils/fix_path.py "${CMAKE_INSTALL_PREFIX}"
    WORKING_DIRECTORY ${CMAKE_INSTALL_PREFIX}
)
