CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(vtkBuilder)

INCLUDE(ExternalProject)

#TODO : currently using macport's tiff png and jpeg on osx
SET(VTK_CMAKE_ARGS -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX} 
                   -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
                   -DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}
                   -DBUILD_EXAMPLES:BOOL=OFF
                   -DBUILD_SHARED_LIBS:BOOL=ON
                   -DBUILD_TESTING:BOOL=OFF
                   -DBUILD_DOXYGEN:BOOL=OFF
                   -DVTK_USE_GL2PS:BOOL=ON
                   -DVTK_USE_GLSL_SHADERS:BOOL=ON
                   -DVTK_USE_SYSTEM_EXPAT:BOOL=ON
                   -DVTK_USE_SYSTEM_JPEG:BOOL=ON
                   -DVTK_USE_SYSTEM_LIBXML2:BOOL=ON
                   -DVTK_USE_SYSTEM_PNG:BOOL=ON
                   -DVTK_USE_SYSTEM_TIFF:BOOL=ON
                   -DVTK_USE_SYSTEM_ZLIB:BOOL=ON
                   -DVTK_USE_TK:BOOL=OFF
                   -DVTK_LEGACY_REMOVE:BOOL=OFF
                   -DVTK_USE_PARALLEL:BOOL=ON
                   -DVTK_USE_HYBRID:BOOL=ON
                   -DVTK_USE_QT:BOOL=ON
                   -DVTK_USE_QVTK_QTOPENGL:BOOL=ON  #QVTKWidget2 for compatibility with Ogre
                   -DVTK_QT_USE_WEBKIT:BOOL=OFF
                   -DVTK_WRAP_PYTHON:BOOL=OFF
)

IF("${CMAKE_SYSTEM}" MATCHES "Linux")
           LIST(APPEND VTK_CMAKE_ARGS 
                   -DQT_QMAKE_EXECUTABLE=${CMAKE_INSTALL_PREFIX}/bin/qmake
            )
ENDIF("${CMAKE_SYSTEM}" MATCHES "Linux")

IF(APPLE)
    IF(CMAKE_SIZEOF_VOID_P EQUAL 8) #x64
           LIST(APPEND VTK_CMAKE_ARGS 
                   -DVTK_USE_CARBON:BOOL=OFF
                   -DVTK_USE_COCOA:BOOL=ON
            )
    ELSE()
        LIST(APPEND VTK_CMAKE_ARGS 
                   -DVTK_USE_CARBON:BOOL=ON
                   -DVTK_USE_COCOA:BOOL=OFF
            )
    ENDIF()
ENDIF(APPLE)

GET_CACHED_URL(http://www.vtk.org/files/release/5.10/vtk-5.10.1.tar.gz CACHED_URL)

ExternalProject_Add(
    vtk
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DEPENDS zlib jpeg libpng tiff expat libxml qt
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${VTK_CMAKE_ARGS}
    STEP_TARGETS CopyConfigFileToInstall
)

ExternalProject_Add_Step(vtk CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-VTK.cmake ${CMAKE_INSTALL_PREFIX}/fw-VTK.cmake
    COMMENT "Install configuration file"
)
