#Light vtk to compile utilities on desktop. This utilities are needed by vtk for android.

set(VTK_LIGHT_CMAKE_ARGS
    # Does not use COMMON_CMAKE_ARGS because compilation must not use android parameters
    -DCMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
    -DCMAKE_PREFIX_PATH=${CMAKE_INSTALL_PREFIX}
    -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE}
    -DVTK_INSTALL_NO_DEVELOPMENT:BOOL=ON
    -DBUILD_EXAMPLES:BOOL=OFF
    -DBUILD_TESTING:BOOL=OFF
    -DBUILD_DOCUMENTATION:BOOL=OFF

    -DVTK_Group_Rendering:BOOL=OFF
    -DVTK_Group_Imaging:BOOL=OFF
    -DVTK_Group_MPI:BOOL=OFF
    -DVTK_Group_Qt:BOOL=OFF
    -DVTK_Group_Rendering:BOOL=OFF
    -DVTK_Group_StandAlone:BOOL=OFF
    -DVTK_Group_Tk:BOOL=OFF
    -VTK_Group_Views:BOOL=OFF
    -DVTK_Group_StandAlone:BOOL=OFF

    -DModule_vtkCommonCore:BOOL=ON
    -DModule_vtkUtilitiesEncodeString:BOOL=ON #compile EncodeString utilities
    -DModule_vtkUtilitiesHashSource:BOOL=ON #compile HashSource utilities
    -DModule_vtkParseOGLExt:BOOL=ON #compile ParseOGLExt utilities
)

set(VTK_SRC_DIR ${CMAKE_CURRENT_BINARY_DIR}/vtk-prefix/src/vtk)
set(VTK_BUILD_DIR ${CMAKE_CURRENT_BINARY_DIR}/vtk-prefix/src/vtk-build-desktop)

set(VTK_CONFIGURE_CMD ${CMAKE_COMMAND} -G ${CMAKE_GENERATOR} ${VTK_LIGHT_CMAKE_ARGS} ${VTK_SRC_DIR})

# Compile vtk in VTK_BUILD_DIR
execute_process(COMMAND ${CMAKE_COMMAND} -E make_directory ${VTK_BUILD_DIR})
execute_process(COMMAND ${VTK_CONFIGURE_CMD}
    WORKING_DIRECTORY ${VTK_BUILD_DIR})
execute_process(COMMAND ${MAKE} ${VTK_SRC_DIR}
    WORKING_DIRECTORY ${VTK_BUILD_DIR})
execute_process(COMMAND ${MAKE} install
    WORKING_DIRECTORY ${VTK_BUILD_DIR})
