# Variables used by this module, they can change the default behavior and need
# to be set before calling find_package:
#
# JsonCpp_ROOT_DIR Set this variable to the root installation of
# JsonCpp if the module has problems finding
# the proper installation path.
#
# Variables defined by this module:
#
# JSONCPP_FOUND System has JsonCpp libs/headers
# JsonCpp_LIBRARIES The JsonCpp libraries
# JsonCpp_INCLUDE_DIR The location of JsonCpp headers



find_path(JsonCpp_INCLUDE_DIR
    NAMES
        include/json.h
        include/json/json.h
)


find_library(JsonCpp_LIBRARY
    NAMES jsoncpp libjsoncpp JsonCpp
    HINTS ${JsonCpp_ROOT_DIR}/lib
)


include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(JsonCpp DEFAULT_MSG
    JsonCpp_LIBRARY
    JsonCpp_INCLUDE_DIR
)

