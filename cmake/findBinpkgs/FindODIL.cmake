# Variables used by this module, they can change the default behavior and need
# to be set before calling find_package:
#
# ODIL_ROOT_DIR Set this variable to the root installation of
# odil if the module has problems finding
# the proper installation path.
#
# Variables defined by this module:
#
# JSONCPP_FOUND System has odil libs/headers
# ODIL_LIBRARIES The ODIL libraries
# ODIL_INCLUDE_DIR The location of odil headers

find_path(ODIL_INCLUDE_DIR
    NAMES
        include/odil/odil.h
)

find_library(ODIL_LIBRARY
    NAMES odil libodil
    HINTS lib
)

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(ODIL DEFAULT_MSG
    ODIL_LIBRARY
    ODIL_INCLUDE_DIR
)

