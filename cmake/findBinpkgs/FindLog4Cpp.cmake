# Variables used by this module, they can change the default behavior and need
# to be set before calling find_package:
#
# Log4Cpp_ROOT_DIR Set this variable to the root installation of
# Log4Cpp if the module has problems finding
# the proper installation path.
#
# Variables defined by this module:
#
# LOG4CPP_FOUND System has Log4Cpp libs/headers
# Log4Cpp_LIBRARIES The Log4Cpp libraries
# Log4Cpp_INCLUDE_DIR The location of Log4Cpp headers


find_path(Log4Cpp_INCLUDE_DIR
    NAMES
        include/Export.hh
        include/log4cpp/Export.hh
)


find_library(Log4Cpp_LIBRARY
    NAMES log4cpp log4cppD liblog4cpp Log4Cpp
    HINTS ${Log4Cpp_ROOT_DIR}/lib
)

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(log4cpp DEFAULT_MSG
    Log4Cpp_LIBRARY
    Log4Cpp_INCLUDE_DIR
)

