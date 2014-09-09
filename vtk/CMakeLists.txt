cmake_minimum_required(VERSION 2.8)

project(vtkBuilder)

include(ExternalProject)

#TODO : currently using macport's tiff png and jpeg on osx
set(VTK_CMAKE_ARGS -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX} 
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

if(APPLE)
   if(CMAKE_SIZEOF_VOID_P EQUAL 8) #x64
           list(APPEND VTK_CMAKE_ARGS 
                   -DVTK_USE_CARBON:BOOL=OFF
                   -DVTK_USE_COCOA:BOOL=ON
            )
    else()
        list(APPEND VTK_CMAKE_ARGS 
                   -DVTK_USE_CARBON:BOOL=ON
                   -DVTK_USE_COCOA:BOOL=OFF
            )
    endif()
endif(APPLE)

getCachedUrl(http://www.vtk.org/files/release/6.1/VTK-6.1.0.tar.gz CACHED_URL)

set(VTK_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(VTK_PATCH_CMD ${CMAKE_COMMAND} -E  copy_if_different "${VTK_PATCH_DIR}/IO_Import_CMakeLists.txt" "<SOURCE_DIR>/IO/Import/CMakeLists.txt"
    COMMAND ${CMAKE_COMMAND} -E  copy_if_different "${VTK_PATCH_DIR}/Main_CMakeLists.txt" "<SOURCE_DIR>/CMakeLists.txt")

set(VTK_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/vtk-prefix/src/vtk)
if(NOT WIN32)    
    set(PKG_EXPORT export PKG_CONFIG_PATH=${CMAKE_INSTALL_PREFIX}/lib/pkgconfig)
    set(VTK_CONFIGURE_CMD ${PKG_EXPORT} && ${CMAKE_COMMAND} ${VTK_CMAKE_ARGS} ${VTK_SRC_DIR})
else()
    set(VTK_CONFIGURE_CMD ${CMAKE_COMMAND} -G ${CMAKE_GENERATOR} ${VTK_CMAKE_ARGS} ${VTK_SRC_DIR})
endif()

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


