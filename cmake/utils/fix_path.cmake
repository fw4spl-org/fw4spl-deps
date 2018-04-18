# Fix hardcoded paths in VTK cmake files
message("Fix VTK CMake export files...")

file(GLOB_RECURSE VTK_CMAKE_FILES "${CMAKE_INSTALL_PREFIX}/lib/cmake/vtk*/*.cmake")

foreach(CMAKE_FILE ${VTK_CMAKE_FILES})
    file(STRINGS ${CMAKE_FILE} CMAKE_FILE_CONTENT NEWLINE_CONSUME)
    string(REGEX REPLACE "${HOST_INSTALL_PATH}" "\${VTK_INSTALL_PREFIX}" CMAKE_FILE_CONTENT_MODIFIED "${CMAKE_FILE_CONTENT}")
    file(WRITE ${CMAKE_FILE} ${CMAKE_FILE_CONTENT_MODIFIED})
endforeach()

# Fix hardcoded paths in Dcmtk cmake files
message("Fix DCMTK CMake export files...")

file(GLOB_RECURSE DCMTK_CMAKE_FILES "${CMAKE_INSTALL_PREFIX}/lib/cmake/dcmtk/*.cmake")

foreach(CMAKE_FILE ${DCMTK_CMAKE_FILES})
    file(STRINGS ${CMAKE_FILE} CMAKE_FILE_CONTENT NEWLINE_CONSUME)
    string(REGEX REPLACE "${HOST_INSTALL_PATH}" "\${_IMPORT_PREFIX}" CMAKE_FILE_CONTENT_MODIFIED "${CMAKE_FILE_CONTENT}")
    file(WRITE ${CMAKE_FILE} ${CMAKE_FILE_CONTENT_MODIFIED})
endforeach()

# Fix hardcoded paths in PCL cmake files
message("Fix PCL CMake export files...")

file(GLOB_RECURSE PCL_CMAKE_FILES "${CMAKE_INSTALL_PREFIX}/share/pcl*/*.cmake")

foreach(CMAKE_FILE ${PCL_CMAKE_FILES})
    file(STRINGS ${CMAKE_FILE} CMAKE_FILE_CONTENT NEWLINE_CONSUME)
    string(REGEX REPLACE "${HOST_INSTALL_PATH}" "\${PCL_ROOT}" CMAKE_FILE_CONTENT_MODIFIED "${CMAKE_FILE_CONTENT}")
    file(WRITE ${CMAKE_FILE} ${CMAKE_FILE_CONTENT_MODIFIED})
endforeach()

# Fix hardcoded paths in Ceres cmake files
message("Fix Ceres CMake export files...")

if(WIN32)
    set(CERES_CMAKE_DIR "${CMAKE_INSTALL_PREFIX}/cmake")
else()
    set(CERES_CMAKE_DIR "${CMAKE_INSTALL_PREFIX}/lib/cmake/Ceres")
endif()

file(GLOB_RECURSE CERES_CMAKE_FILES "${CERES_CMAKE_DIR}/Ceres*.cmake")

foreach(CMAKE_FILE ${CERES_CMAKE_FILES})
    file(STRINGS ${CMAKE_FILE} CMAKE_FILE_CONTENT NEWLINE_CONSUME)
    string(REGEX REPLACE "${HOST_INSTALL_PATH}" "\${_IMPORT_PREFIX}" CMAKE_FILE_CONTENT_MODIFIED "${CMAKE_FILE_CONTENT}")
    file(WRITE ${CMAKE_FILE} ${CMAKE_FILE_CONTENT_MODIFIED})
endforeach()

# Fix hardcoded paths in Sofa cmake files
message("Fix Sofa CMake export files...")

file(GLOB_RECURSE SOFA_CMAKE_FILES "${CMAKE_INSTALL_PREFIX}/lib/cmake/SofaFramework/*.cmake")

foreach(CMAKE_FILE ${SOFA_CMAKE_FILES})
    file(STRINGS ${CMAKE_FILE} CMAKE_FILE_CONTENT NEWLINE_CONSUME)
    string(REGEX REPLACE "${HOST_INSTALL_PATH}" "\${_IMPORT_PREFIX}" CMAKE_FILE_CONTENT_MODIFIED "${CMAKE_FILE_CONTENT}")
    file(WRITE ${CMAKE_FILE} ${CMAKE_FILE_CONTENT_MODIFIED})
endforeach()