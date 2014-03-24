#----------------------------------------------------------------
# Generated CMake target import file for configuration "Debug".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "cryptlib" for configuration "Debug"
set_property(TARGET cryptlib APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(cryptlib PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
  IMPORTED_LINK_INTERFACE_LIBRARIES_DEBUG "Ws2_32"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/lib/cryptlib.lib"
  )

list(APPEND _IMPORT_CHECK_TARGETS cryptlib )
list(APPEND _IMPORT_CHECK_FILES_FOR_cryptlib "${_IMPORT_PREFIX}/lib/cryptlib.lib" )

# Import target "cryptopp" for configuration "Debug"
set_property(TARGET cryptopp APPEND PROPERTY IMPORTED_CONFIGURATIONS DEBUG)
set_target_properties(cryptopp PROPERTIES
  IMPORTED_IMPLIB_DEBUG "${_IMPORT_PREFIX}/lib/cryptopp.lib"
  IMPORTED_LINK_INTERFACE_LIBRARIES_DEBUG "Ws2_32"
  IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/bin/cryptopp.dll"
  )

list(APPEND _IMPORT_CHECK_TARGETS cryptopp )
list(APPEND _IMPORT_CHECK_FILES_FOR_cryptopp "${_IMPORT_PREFIX}/lib/cryptopp.lib" "${_IMPORT_PREFIX}/bin/cryptopp.dll" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
