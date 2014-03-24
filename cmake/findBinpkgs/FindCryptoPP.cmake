# Locate CryptoPP library
# This module defines
#  CryptoPP_FOUND, if false, do not try to link to CryptoPP
#  CryptoPP_LIBRARIES
#  CryptoPP_INCLUDE_DIR, where to find cryptopp/config.h


    FIND_PATH(CryptoPP_INCLUDE_DIR cryptopp/config.h
        HINTS
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

    FIND_LIBRARY(CryptoPP_LIBRARY 
        NAMES cryptopp 
        HINTS
        PATH_SUFFIXES lib
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

IF(WIN32)
    FIND_LIBRARY(CryptoPP_LIB
        NAMES cryptlib 
        HINTS
        PATH_SUFFIXES lib
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
    SET(CryptoPP_LIBRARIES "${CryptoPP_LIB};${CryptoPP_LIBRARY}" CACHE LIST "CryptoPP Libraries")
ELSE()
    SET(CryptoPP_LIBRARIES "${CryptoPP_LIBRARY}" CACHE LIST "CryptoPP Libraries")
ENDIF()



INCLUDE(FindPackageHandleStandardArgs)
# handle the QUIETLY and REQUIRED arguments and set CryptoPP_FOUND to TRUE if 
# all listed variables are TRUE
FIND_PACKAGE_HANDLE_STANDARD_ARGS(CryptoPP DEFAULT_MSG CryptoPP_LIBRARIES CryptoPP_INCLUDE_DIR)

MARK_AS_ADVANCED(CryptoPP_INCLUDE_DIR CryptoPP_LIBRARIES CryptoPP_LIBRARY)

