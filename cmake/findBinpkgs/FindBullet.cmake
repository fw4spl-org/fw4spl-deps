# - Try to find the Bullet physics engine
#
#  This module defines the following variables
#
#  BULLET_FOUND - Was bullet found
#  BULLET_INCLUDE_DIRS - the Bullet include directories
#  BULLET_LIBRARIES - Link to this, by default it includes
#                     all bullet components (Dynamics,
#                     Collision, LinearMath, & SoftBody)
#
#  This module accepts the following variables
#
#  BULLET_ROOT - Can be set to bullet install path or Windows build path
#

#=============================================================================
# Copyright 2009 Kitware, Inc.
# Copyright 2009 Philip Lowman <philip@yhbt.com>
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)

macro(_FIND_BULLET_LIBRARY _var)
  find_library(${_var}
     NAMES
        ${ARGN}
     HINTS
        ${BULLET_ROOT}
        ${BULLET_ROOT}/lib/Release
        ${BULLET_ROOT}/lib/Debug
        ${BULLET_ROOT}/out/release8/libs
        ${BULLET_ROOT}/out/debug8/libs
     PATH_SUFFIXES lib
  )
  mark_as_advanced(${_var})
endmacro()

find_path(BULLET_INCLUDE_DIR NAMES btBulletCollisionCommon.h
  HINTS
    ${BULLET_ROOT}/include
    ${BULLET_ROOT}/src
  PATH_SUFFIXES bullet
)

# Find the libraries
_FIND_BULLET_LIBRARY(BULLET_DYNAMICS_LIBRARY
                     BulletDynamics BulletDynamics_Debug BulletDynamics_RelWithDebugInfo)
_FIND_BULLET_LIBRARY(BULLET_COLLISION_LIBRARY
                     BulletCollision BulletCollision_Debug BulletCollision_RelWithDebugInfo)
_FIND_BULLET_LIBRARY(BULLET_MATH_LIBRARY
                     BulletMath LinearMath BulletMath_Debug LinearMath_Debug
                     BulletMath_RelWithDebugInfo LinearMath_RelWithDebugInfo)
_FIND_BULLET_LIBRARY(BULLET_SOFTBODY_LIBRARY
                     BulletSoftBody BulletSoftBody_Debug BulletSoftBody_RelWithDebugInfo)


# handle the QUIETLY and REQUIRED arguments and set BULLET_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Bullet DEFAULT_MSG
    BULLET_DYNAMICS_LIBRARY BULLET_COLLISION_LIBRARY BULLET_MATH_LIBRARY
    BULLET_SOFTBODY_LIBRARY BULLET_INCLUDE_DIR)

if(BULLET_FOUND)
    set(BULLET_INCLUDE_DIRS ${BULLET_INCLUDE_DIR})
    
    list(APPEND BULLET_LIBRARIES ${BULLET_DYNAMICS_LIBRARY} 
                             ${BULLET_COLLISION_LIBRARY} 
                             ${BULLET_MATH_LIBRARY} 
                             ${BULLET_SOFTBODY_LIBRARY})
endif()
