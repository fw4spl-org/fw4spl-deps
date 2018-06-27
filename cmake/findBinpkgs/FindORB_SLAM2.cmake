###############################################################################
# Find ORB_SLAM2
#
# This sets the following variables:
# ORB_SLAM2_FOUND - True if ORB_SLAM2 was found.
# ORB_SLAM2_INCLUDE_DIRS - Directories containing the ORB_SLAM2 include files.
# ORB_SLAM2_LIBRARIES - Libraries needed to use ORB_SLAM2.

find_package(PkgConfig QUIET)

find_library(ORB_SLAM2_LIBRARY
    NAMES ORB_SLAM2
    PATH_SUFFIXES lib/
)

find_library(DBOW2_LIBRARY
    NAMES DBoW2
    PATH_SUFFIXES lib/
)

find_library(G2O_LIBRARY
    NAMES g2o
    PATH_SUFFIXES lib/
)

find_path(ORB_SLAM2_INCLUDE_DIR NAMES orb_slam2_export.h PATH_SUFFIXES include/ORB_SLAM2/)
find_path(DBOW2_INCLUDE_DIR NAMES dbow2_export.h         PATH_SUFFIXES include/ORB_SLAM2/Thirdparty/DBoW2/)
find_path(G2O_INCLUDE_DIR NAMES config.h                 PATH_SUFFIXES include/ORB_SLAM2/Thirdparty/g2o/)

set(ORB_SLAM2_INCLUDE_DIRS ${ORB_SLAM2_INCLUDE_DIR} ${DBOW2_INCLUDE_DIR} ${G2O_INCLUDE_DIR} ${G2O_INCLUDE_DIR}/g2o)
set(ORB_SLAM2_LIBRARIES ${ORB_SLAM2_LIBRARY} ${DBOW2_LIBRARY} ${G2O_LIBRARY})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ORB_SLAM2 DEFAULT_MSG ORB_SLAM2_LIBRARIES ORB_SLAM2_INCLUDE_DIRS)

message(STATUS "(ORB_SLAM2_FOUND : ${ORB_SLAM2_FOUND} include: ${ORB_SLAM2_INCLUDE_DIRS}, lib: ${ORB_SLAM2_LIBRARIES})")

mark_as_advanced(ORB_SLAM2_FOUND)

if(ORB_SLAM2_FOUND)
    set(ORB_SLAM2_FOUND TRUE CACHE BOOL "" FORCE)
else()
    set(ORB_SLAM2_FOUND FALSE CACHE BOOL "" FORCE)
endif()
