CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

PROJECT(vtkBuilder)

INCLUDE(ExternalProject)

#TODO : currently using macport's tiff png and jpeg on osx
SET(VTK_CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX} 
                   -DCMAKE_BUILD_TYPE:PATH=${CMAKE_BUILD_TYPE}
                   -DCMAKE_PREFIX_PATH:PATH=${CMAKE_INSTALL_PREFIX}
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
                   -DVTK_USE_SYSTEM_FREETYPE:BOOL=ON
                   -DVTK_USE_TK:BOOL=OFF
                   -DVTK_LEGACY_REMOVE:BOOL=OFF
                   -DVTK_USE_PARALLEL:BOOL=ON
                   -DVTK_USE_HYBRID:BOOL=ON
                   -DVTK_Group_Qt:BOOL=OFF
                   -DVTK_WRAP_PYTHON:BOOL=OFF
                   -DVTK_MAKE_INSTANTIATORS:BOOL=ON
                   -DVTK_QT_VERSION:STRING=5
                   -DModule_vtkGUISupportQt:BOOL=ON
                   -DModule_vtkGUISupportQtOpenGL:BOOL=ON
                   -DModule_vtkGUISupportQtWebkit:BOOL=OFF
                   -DModule_vtkGUISupportQtSQL:BOOL=ON
                   -DModule_vtkRenderingQt:BOOL=ON
                   -DModule_vtkViewsQt:BOOL=ON
                   -DVTK_Group_StandAlone:BOOL=OFF #disabled hdf5 module
                   -DModule_vtkIOExport:BOOL=ON
                   -DModule_vtkImagingStencil:BOOL=ON
                   -DModule_vtkImagingStatistics:BOOL=ON
                   -DModule_vtkIOImport:BOOL=ON
)

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

GET_CACHED_URL(http://www.vtk.org/files/release/6.1/VTK-6.1.0.tar.gz CACHED_URL)

SET(VTK_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
SET(VTK_PATCH_CMD ${CMAKE_COMMAND} -E  copy_if_different "${VTK_PATCH_DIR}/IO_Import_CMakeLists.txt" "<SOURCE_DIR>/IO/Import/CMakeLists.txt"
    COMMAND ${CMAKE_COMMAND} -E  copy_if_different "${VTK_PATCH_DIR}/Main_CMakeLists.txt" "<SOURCE_DIR>/CMakeLists.txt")

SET(VTK_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/vtk-prefix/src/vtk)
IF(NOT WIN32)    
    SET(PKG_EXPORT export PKG_CONFIG_PATH=${CMAKE_INSTALL_PREFIX}/lib/pkgconfig)
    SET(VTK_CONFIGURE_CMD ${PKG_EXPORT} && ${CMAKE_COMMAND} ${VTK_CMAKE_ARGS} ${VTK_SRC_DIR})
ELSE()
    SET(VTK_CONFIGURE_CMD ${CMAKE_COMMAND} -G ${CMAKE_GENERATOR} ${VTK_CMAKE_ARGS} ${VTK_SRC_DIR})
ENDIF()

ExternalProject_Add(
    vtk
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    PATCH_COMMAND ${VTK_PATCH_CMD}
    DEPENDS zlib jpeg libpng tiff expat libxml freetype qt
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CONFIGURE_COMMAND ${VTK_CONFIGURE_CMD}
    BUILD_COMMAND ${MAKE} ${VTK_SRC_DIR}
    STEP_TARGETS CopyConfigFileToInstall
)

ExternalProject_Add_Step(vtk CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-VTK.cmake ${CMAKE_INSTALL_PREFIX}/fw-VTK.cmake
    COMMENT "Install configuration file"
)


