

FIND_PATH(HDF5_INCLUDE_DIR cpp/H5Cpp.h
  HINTS
  $ENV{HDF5_DIR}
  PATH_SUFFIXES include
  PATHS
  ~/Library/Frameworks
  /Library/Frameworks
  /usr/local
  /usr
  /sw # Fink
  /opt/local # DarwinPorts
  /opt/csw # Blastwave
  /opt
)


FIND_LIBRARY(HDF5_LIBRARY 
  NAMES hdf5ddll hdf5dll hdf5 hdf5d hdf5_debug
  HINTS
  $ENV{HDF5_DIR}
  PATH_SUFFIXES lib64 lib
  PATHS
  ~/Library/Frameworks
  /Library/Frameworks
  /usr/local
  /usr
  /sw
  /opt/local
  /opt/csw
  /opt
)

FIND_LIBRARY(HDF5_CPP_LIBRARY 
  NAMES hdf5_cppddll hdf5_cppdll hdf5_cpp hdf5_cppd hdf5_cpp_debug
  HINTS
  $ENV{HDF5_DIR}
  PATH_SUFFIXES lib64 lib
  PATHS
  ~/Library/Frameworks
  /Library/Frameworks
  /usr/local
  /usr
  /sw
  /opt/local
  /opt/csw
  /opt
)

SET(HDF5_LIBRARIES "${HDF5_LIBRARY};${HDF5_CPP_LIBRARY}" CACHE STRING "HDF5 Libraries")

INCLUDE(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set HDF5_FOUND to TRUE if 
# all listed variables are TRUE
FIND_PACKAGE_HANDLE_STANDARD_ARGS(HDF5 DEFAULT_MSG HDF5_LIBRARIES HDF5_INCLUDE_DIR)

MARK_AS_ADVANCED(HDF5_INCLUDE_DIR HDF5_LIBRARIES HDF5_LIBRARY)


