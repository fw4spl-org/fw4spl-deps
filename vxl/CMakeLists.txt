cmake_minimum_required(VERSION 3.0)

project(vxlBuilder)

include(ExternalProject)

set(VXL_PATCH_DIR ${CMAKE_CURRENT_SOURCE_DIR}/patch)
set(VXL_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                   -DBUILD_TESTING:BOOL=OFF
                   -DBUILD_EXAMPLES:BOOL=OFF
                   -DBUILD_CONTRIB_VIDL2:BOOL=OFF
                   -DBUILD_CORE_VIDEO=OFF
                   -DBUILD_CONTRIB=OFF
                   -DVNL_CONFIG_LEGACY_METHODS:BOOL=ON
                   -DVXL_BUILD_DCMTK:BOOL=OFF
                   -DVXL_FORCE_V3P_JPEG:BOOL=OFF
                   -DVXL_FORCE_V3P_PNG:BOOL=OFF
                   -DVXL_FORCE_V3P_TIFF:BOOL=OFF
                   -DVXL_FORCE_V3P_ZLIB:BOOL=OFF
)

if(ANDROID)
    list(APPEND VXL_CMAKE_ARGS
        ${COMMON_CMAKE_ARGS}
        -DBUILD_CORE_NUMERICS:BOOL=ON
        -DBUILD_CORE_SERIALISATION:BOOL=OFF
        -DBUILD_CORE_UTILITIES:BOOL=OFF
        -DBUILD_CORE_GEOMETRY:BOOL=ON
        -DBUILD_CORE_IMAGING:BOOL=OFF
        -DBUILD_CORE_VIDEO=OFF
        -DVXL_LEGACY_ERROR_REPORTING:BOOL=OFF
        -DBUILD_TESTING:BOOL=OFF
        -DBUILD_EXAMPLES:BOOL=OFF
        -DBUILD_CONTRIB_VIDL2:BOOL=OFF
        -DBUILD_CONTRIB=OFF
        -DVNL_CONFIG_LEGACY_METHODS:BOOL=ON
        -DVXL_BUILD_DCMTK:BOOL=OFF
        -DVXL_FORCE_V3P_JPEG:BOOL=OFF
        -DVXL_FORCE_V3P_PNG:BOOL=OFF
        -DVXL_FORCE_V3P_TIFF:BOOL=OFF
        -DVXL_FORCE_V3P_ZLIB:BOOL=OFF
    )
endif()

if(WIN32)
    #VXL does not support the CMake "Shared Library" feature on MSVC.
    list(APPEND VXL_CMAKE_ARGS -DBUILD_SHARED_LIBS:BOOL=OFF)
else()
    list(APPEND VXL_CMAKE_ARGS -DBUILD_SHARED_LIBS:BOOL=ON)
    #fixed error: 'constexpr' needed for in-class initialization of static data member 'tolerance' of non-integral type
    # -> define VCL_CAN_STATIC_CONST_INIT_FLOAT to 0
    set(VXL_PATCH_CMD ${PATCH_EXECUTABLE} -p1 -i ${VXL_PATCH_DIR}/vcl_config_compiler.h.in.diff -d <SOURCE_DIR>)
    if(ANDROID)
        list(APPEND VXL_PATCH_CMD
            COMMAND ${PATCH_EXECUTABLE} -p1 -i ${VXL_PATCH_DIR}/config_CMakeLists.txt.diff -d <SOURCE_DIR>
            COMMAND ${PATCH_EXECUTABLE} -p1 -i ${VXL_PATCH_DIR}/core_CMakeLists.diff -d <SOURCE_DIR>
            COMMAND ${PATCH_EXECUTABLE} -p1 -i ${VXL_PATCH_DIR}/vgl_homg_point_3d.diff -d <SOURCE_DIR>
            COMMAND ${PATCH_EXECUTABLE} -p1 -i ${VXL_PATCH_DIR}/vnl_cpoly_roots.diff -d <SOURCE_DIR>
            COMMAND ${PATCH_EXECUTABLE} -p1 -i ${VXL_PATCH_DIR}/vnl_rnpoly_solve.diff -d <SOURCE_DIR>
            COMMAND ${PATCH_EXECUTABLE} -p1 -i ${VXL_PATCH_DIR}/vcsl_CMakeLists.diff -d <SOURCE_DIR>
        )
    endif()
endif()

# VXL 1.18.0 (on master)
set(CACHED_URL https://github.com/vxl/vxl/archive/fbe829dd16e4c1bdf312cf287b33c6ea845ff782.tar.gz)

ExternalProject_Add(
    vxl
    URL ${CACHED_URL}
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    DOWNLOAD_NAME vxl_1.18.0.tar.gz
    DEPENDS zlib jpeg libpng tiff expat
    PATCH_COMMAND ${VXL_PATCH_CMD}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${VXL_CMAKE_ARGS}
    STEP_TARGETS CopyConfigFileToInstall
)

ExternalProject_Add_Step(vxl CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/cmake/findBinpkgs/fw-VXL.cmake ${CMAKE_INSTALL_PREFIX}/fw-VXL.cmake
    COMMENT "Install configuration file"
)
