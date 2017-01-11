# Variables used by this module, they can change the default behavior and need
# to be set before calling find_package:
#
# ZeroMQ_ROOT_DIR Set this variable to the root installation of
# ZeroMQ if the module has problems finding
# the proper installation path.
#
# Variables defined by this module:
#
# ZEROMQ_FOUND System has ZeroMQ libs/headers
# ZeroMQ_LIBRARIES The ZeroMQ libraries
# ZeroMQ_INCLUDE_DIR The location of ZeroMQ headers

find_path(ZeroMQ_ROOT_DIR
    NAMES
        include/zmq.h 
        include/zmq/zmq.h
)

if(MSVC)
  set(_zmq_versions "4_0_5" "4_0_4" "4_0_3" "4_0_2" "4_0_1" "4_0_0"
                    "3_2_5" "3_2_4" "3_2_3" "3_2_2"  "3_2_1" "3_2_0" "3_1_0")
  set(_zmq_release_names)
  set(_zmq_debug_names)
  foreach( ver ${_zmq_versions})
    list(APPEND _zmq_release_names "libzmq-mt-${ver}")
  endforeach()
  foreach( ver ${_zmq_versions})
    list(APPEND _zmq_debug_names "libzmq-mt-gd-${ver}")
  endforeach()

  #now try to find the release and debug version
  find_library(ZeroMQ_LIBRARY_RELEASE
    NAMES ${_zmq_release_names} zmq libzmq
    HINTS ${ZeroMQ_ROOT_DIR}/bin
          ${ZeroMQ_ROOT_DIR}/lib
    )

  find_library(ZeroMQ_LIBRARY_DEBUG
    NAMES ${_zmq_debug_names} zmq libzmq
    HINTS ${ZeroMQ_ROOT_DIR}/bin
          ${ZeroMQ_ROOT_DIR}/lib
    )

  if(ZeroMQ_LIBRARY_RELEASE AND ZeroMQ_LIBRARY_DEBUG)
    set(ZeroMQ_LIBRARY
        debug ${ZeroMQ_LIBRARY_DEBUG}
        optimized ${ZeroMQ_LIBRARY_RELEASE}
        )
  elseif(ZeroMQ_LIBRARY_RELEASE)
    set(ZeroMQ_LIBRARY ${ZeroMQ_LIBRARY_RELEASE})
  elseif(ZeroMQ_LIBRARY_DEBUG)
    set(ZeroMQ_LIBRARY ${ZeroMQ_LIBRARY_DEBUG})
  endif()

else()
  find_library(ZeroMQ_LIBRARY
    NAMES zmq libzmq ZeroMQ
    HINTS ${ZeroMQ_ROOT_DIR}/lib
    )
endif()

find_path(ZeroMQ_INCLUDE_DIR
    NAMES zmq.h
    HINTS 
        ${ZeroMQ_ROOT_DIR}/include
        ${ZeroMQ_ROOT_DIR}/include/zmq

)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ZeroMQ DEFAULT_MSG
    ZeroMQ_LIBRARY
    ZeroMQ_INCLUDE_DIR
)

set(ZeroMQ_INCLUDE_DIRS ${ZeroMQ_INCLUDE_DIR})
set(ZeroMQ_LIBRARIES ${ZeroMQ_LIBRARY})

mark_as_advanced(
    ZeroMQ_ROOT_DIR
    ZeroMQ_LIBRARY
    ZeroMQ_INCLUDE_DIR
)
