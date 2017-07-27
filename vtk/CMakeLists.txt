cmake_minimum_required(VERSION 3.0)

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
    -DVTK_USE_SYSTEM_GLEW:BOOL=ON

    -DBUILD_SHARED_LIBS:BOOL=ON

    -DVTK_Group_StandAlone:BOOL=OFF #disabled hdf5 module
)

set(CACHED_URL https://github.com/Kitware/VTK/archive/v8.0.0.tar.gz)
set(VTK_HASHSUM fed9774f448e7b0ddc34a13a0812b31f6fba5233cda06312a62ca8fea7b8390b)

if(NOT ANDROID)

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
        -DModule_vtkFiltersFlowPaths:BOOL=ON
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
        -DModule_vtkIOLegacy:BOOL=ON
        -DModule_vtkIOGeometry:BOOL=ON
        -DModule_vtkIOPLY:BOOL=ON  # request for PCL
    )

    if(CMAKE_SYSTEM_NAME STREQUAL Linux)
        set(VTK_DEPENDS qt)
    else()
        set(VTK_DEPENDS jpeg expat libxml freetype libpng tiff qt)
    endif()

else( )

    add_definitions(-DANDROID)

    list(APPEND VTK_CMAKE_ARGS
        -DBUILD_SHARED_LIBS:BOOL=ON
        -DVTK_BUILD_QT_DESIGNER_PLUGIN=OFF
        -DVTK_RENDERING_BACKEND:STRING=OpenGL2
        -DOPENGL_ES_VERSION:STRING=3.0
        -DBUILD_TESTING:BOOL=OFF
        -DVTK_Group_Rendering:BOOL=OFF
        -DVTK_Group_StandAlone:BOOL=OFF
        -DVTK_Group_Imaging:BOOL=OFF
        -DVTK_Group_MPI:BOOL=OFF
        -DVTK_Group_Views:BOOL=OFF
        -DVTK_Group_Qt:BOOL=OFF
        -DVTK_Group_Tk:BOOL=OFF
        -DVTK_Group_Web:BOOL=OFF
        -DModule_vtkFiltersCore:BOOL=ON
        -DModule_vtkFiltersModeling:BOOL=ON
        -DModule_vtkFiltersSources:BOOL=ON
        -DModule_vtkFiltersGeometry:BOOL=ON
        -DModule_vtkIOGeometry:BOOL=ON
        -DModule_vtkIOLegacy:BOOL=ON
        -DModule_vtkIOImage:BOOL=OFF
        -DModule_vtkIOPLY:BOOL=ON
        -DModule_vtkIOInfovis:BOOL=ON
        -DModule_vtkImagingCore:BOOL=ON
        -DModule_vtkInteractionStyle:BOOL=ON
        -DModule_vtkParallelCore:BOOL=ON
        -DModule_vtkRenderingCore:BOOL=ON
        -DModule_vtkRenderingFreeType:BOOL=OFF
        -DModule_vtkInteractionWidgets=ON
        -DCMAKE_CXX_COMPILER_VERSION=${ANDROID_COMPILER_VERSION}

       -DModule_vtkFiltersTexture:BOOL=ON
       -DModule_vtkFiltersHybrid:BOOL=ON

        # Find utilities build on desktop
        -DVTKCompileTools_DIR:PATH=${CMAKE_CURRENT_BINARY_DIR}/vtk-prefix/src/vtk-build-desktop

        -DModule_vtkGUISupportQtOpenGL:BOOL=OFF
        -DModule_vtkGUISupportQtWebkit:BOOL=OFF
        -DModule_vtkGUISupportQtSQL:BOOL=OFF
        -DModule_vtkRenderingQt:BOOL=OFF
        -DModule_vtkRenderingContextOpenGL2=OFF
        -DModule_vtkViewsQt:BOOL=OFF
        )

        if(ENABLE_QT_ANDROID)
            set(VTK_DEPENDS qt)
            list(APPEND VTK_CMAKE_ARGS
                -DVTK_QT_VERSION:STRING=5
                -DModule_vtkGUISupportQt:BOOL=ON
            )
        else()
            set(VTK_DEPENDS zlib jpeg expat libxml freetype libpng tiff)
        endif()
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
elseif(UNIX AND NOT ANDROID)
    # This helps to find freetype on recent linux distributions (Ubuntu 14.04, Archlinux, etc...)
    list(APPEND VTK_CMAKE_ARGS
        -DFREETYPE_INCLUDE_DIR_freetype2:PATH=${CMAKE_INSTALL_PREFIX}/include/freetype2
    )
endif()

set(VTK_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/vtk-prefix/src/vtk)
set(VTK_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(VTK_PATCH_CMD "${PATCH_EXECUTABLE}" -p1 -i ${VTK_PATCH_DIR}/IO_Import_CMakeLists.diff -d <SOURCE_DIR>
          COMMAND "${PATCH_EXECUTABLE}" -p1 -i ${VTK_PATCH_DIR}/optimization.diff -d <SOURCE_DIR>
          COMMAND "${PATCH_EXECUTABLE}" -p1 -i ${VTK_PATCH_DIR}/CMakeLists_glew.diff -d <SOURCE_DIR>
          COMMAND "${PATCH_EXECUTABLE}" -p1 -i ${VTK_PATCH_DIR}/QVTKOpenGLWidget.diff -d <SOURCE_DIR>
          )

if(ANDROID)
    list(APPEND VTK_PATCH_CMD
         COMMAND "${PATCH_EXECUTABLE}" -p1 -i ${VTK_PATCH_DIR}/android/Core_CMakeLists.diff -d <SOURCE_DIR>
         COMMAND "${PATCH_EXECUTABLE}" -p1 -i ${VTK_PATCH_DIR}/android/vtkModuleMacros.diff -d <SOURCE_DIR>
                  COMMAND "${PATCH_EXECUTABLE}" -p1 -i ${VTK_PATCH_DIR}/android/vtkOpenGLPolyDataMapper.diff -d <SOURCE_DIR>
    )
endif()

set(VTK_CONFIGURE_CMD ${CMAKE_COMMAND} -G ${CMAKE_GENERATOR} ${VTK_CMAKE_ARGS} ${VTK_SRC_DIR})

ExternalProject_Add(
    vtk
    URL ${CACHED_URL}
    URL_HASH SHA256=${VTK_HASHSUM}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    PATCH_COMMAND ${VTK_PATCH_CMD}
    DEPENDS glew ${VTK_DEPENDS}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CONFIGURE_COMMAND ${VTK_CONFIGURE_CMD}
    BUILD_COMMAND ${MAKE} ${VTK_SRC_DIR}
)

if (ANDROID)
    # Cross compilation needs utilities compiled on desktop
    ExternalProject_Add_Step(vtk VtkDesktopCompile
        COMMAND ${CMAKE_COMMAND} ${COMMON_CMAKE_ARGS} -DMAKE=${MAKE} -DCMAKE_GENERATOR=${CMAKE_GENERATOR} -P ${VTK_PATCH_DIR}/android/vtkDesktopLight.cmake
        COMMENT "Compile light vtk for desktop"
        DEPENDEES patch
        DEPENDERS configure
    )
endif()

ExternalProject_Add_Step(vtk CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-VTK.cmake ${CMAKE_INSTALL_PREFIX}/fw-VTK.cmake
    COMMENT "Install configuration file"
    DEPENDEES install
)
