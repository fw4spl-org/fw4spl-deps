cmake_minimum_required(VERSION 2.8)

project(vtkBuilder)


include(ExternalProject)

set(VTK_CMAKE_ARGS 
    ${COMMON_CMAKE_ARGS}
    -DBUILD_EXAMPLES:BOOL=OFF
    -DBUILD_TESTING:BOOL=OFF
    -DBUILD_DOCUMENTATION:BOOL=OFF

    -DVTK_USE_SYSTEM_EXPAT:BOOL=ON
    -DVTK_USE_SYSTEM_JPEG:BOOL=ON
    -DVTK_USE_SYSTEM_LIBXML2:BOOL=ON
    -DVTK_USE_SYSTEM_PNG:BOOL=ON
    -DVTK_USE_SYSTEM_ZLIB:BOOL=ON
    -DVTK_USE_SYSTEM_FREETYPE:BOOL=ON
    -DVTK_USE_SYSTEM_TIFF:BOOL=ON
    -DBUILD_SHARED_LIBS:BOOL=ON

    -DVTK_Group_StandAlone:BOOL=OFF #disabled hdf5 module
)

if(NOT ANDROID)

    getCachedUrl(http://www.vtk.org/files/release/6.1/VTK-6.1.0.tar.gz CACHED_URL)

    list(APPEND VTK_CMAKE_ARGS
        -DVTK_USE_GL2PS:BOOL=ON
        -DVTK_USE_GLSL_SHADERS:BOOL=ON
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
        -DModule_vtkIOExport:BOOL=ON
        -DModule_vtkImagingStencil:BOOL=ON
        -DModule_vtkImagingStatistics:BOOL=ON
        -DModule_vtkIOImport:BOOL=ON
        -DModule_vtkIOPLY:BOOL=ON  # request for PCL 
    )
  
else( )
    getCachedUrl(https://github.com/Kitware/VTK/archive/7ec662ca6e6b216e333ab5a4389c297d0f7b2c3c.tar.gz CACHED_URL)
    
    list(APPEND VTK_CMAKE_ARGS
        -DVTK_Group_Rendering:BOOL=OFF
        -DModule_vtkFiltersCore:BOOL=ON
        -DModule_vtkFiltersModeling:BOOL=ON
        -DModule_vtkFiltersSources:BOOL=ON
        -DModule_vtkFiltersGeometry:BOOL=ON
        -DModule_vtkIOGeometry:BOOL=ON
        -DModule_vtkIOLegacy:BOOL=ON
        -DModule_vtkIOXML:BOOL=ON
        -DModule_vtkIOImage:BOOL=ON
        -DModule_vtkIOInfovis:BOOL=ON
        -DModule_vtkImagingCore:BOOL=ON
        -DModule_vtkRenderingCore:BOOL=ON
        -DModule_vtkInteractionStyle:BOOL=ON
        # Find utilities build on desktop
        -DVTKCompileTools_DIR:PATH=${CMAKE_CURRENT_BINARY_DIR}/vtk-prefix/src/vtk-build-desktop
        )
endif()

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
elseif(UNIX)
    # This helps to find freetype on recent linux distributions (Ubuntu 14.04, Archlinux, etc...)
    list(APPEND VTK_CMAKE_ARGS
        -DFREETYPE_INCLUDE_DIR_freetype2:PATH=${CMAKE_INSTALL_PREFIX}/include/freetype2
    )
endif()

set(VTK_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/vtk-prefix/src/vtk)
set(VTK_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(VTK_PATCH_CMD ${CMAKE_COMMAND} -E  copy_if_different "${VTK_PATCH_DIR}/IO_Import_CMakeLists.txt" "<SOURCE_DIR>/IO/Import/CMakeLists.txt")

if(ANDROID)
    list(APPEND VTK_PATCH_CMD  
        COMMAND ${CMAKE_COMMAND} -E copy_if_different "${VTK_PATCH_DIR}/Core_CMakeLists.txt" "<SOURCE_DIR>/Common/Core/CMakeLists.txt"
        COMMAND ${CMAKE_COMMAND} -E copy_if_different "${VTK_PATCH_DIR}/RenderingOpenGL2_CMakeLists.txt"  "<SOURCE_DIR>/Rendering/OpenGL2/CMakeLists.txt"
        COMMAND ${CMAKE_COMMAND} -E copy_if_different "${VTK_PATCH_DIR}/vtkModuleMacros.cmake"  "<SOURCE_DIR>/CMake/vtkModuleMacros.cmake"
    )   
else()
    list(APPEND VTK_PATCH_CMD  
        COMMAND ${CMAKE_COMMAND} -E  copy_if_different "${VTK_PATCH_DIR}/Main_CMakeLists.txt" "<SOURCE_DIR>/CMakeLists.txt"
    )
    set(EXTRA_DEPENDS qt)
endif()

set(VTK_CONFIGURE_CMD ${CMAKE_COMMAND} -G ${CMAKE_GENERATOR} ${VTK_CMAKE_ARGS} ${VTK_SRC_DIR})

ExternalProject_Add(
    vtk
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    PATCH_COMMAND ${VTK_PATCH_CMD}
    DEPENDS zlib jpeg expat libxml freetype libpng tiff ${EXTRA_DEPENDS}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CONFIGURE_COMMAND ${VTK_CONFIGURE_CMD}
    BUILD_COMMAND ${MAKE} ${VTK_SRC_DIR}
    STEP_TARGETS VtkDesktopCompile CopyConfigFileToInstall
)

if (ANDROID)
    # Cross compilation needs utilities compiled on desktop
    ExternalProject_Add_Step(vtk VtkDesktopCompile
        COMMAND ${CMAKE_COMMAND} ${COMMON_CMAKE_ARGS} -DMAKE=${MAKE} -DCMAKE_GENERATOR=${CMAKE_GENERATOR} -P ${VTK_PATCH_DIR}/vtkDesktopLight.cmake
        COMMENT "Compile light vtk for desktop"
        DEPENDEES patch
        DEPENDERS configure
    )
endif()

ExternalProject_Add_Step(vtk CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-VTK.cmake ${CMAKE_INSTALL_PREFIX}/fw-VTK.cmake
    COMMENT "Install configuration file"
)


