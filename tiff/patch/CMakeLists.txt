cmake_minimum_required(VERSION 2.8.6)
project(libtiff C)

find_package(JPEG REQUIRED)
if(NOT JPEG_FOUND)
    message(FATAL_ERROR "JPEG not found !")
endif()

find_package(ZLIB REQUIRED)
if(NOT ZLIB_FOUND)
    message(FATAL_ERROR "ZLIB not found !")
endif()

if(ANDROID)
  find_library(M_LIBRARY
    NAMES m
    REQUIRED
  )
endif()

set(INSTALL_BIN_DIR "${CMAKE_INSTALL_PREFIX}/bin" 
    CACHE PATH "Installation directory for executables")
set(INSTALL_LIB_DIR "${CMAKE_INSTALL_PREFIX}/lib" 
    CACHE PATH "Installation directory for libraries")
set(INSTALL_INC_DIR "${CMAKE_INSTALL_PREFIX}/include" 
    CACHE PATH "Installation directory for headers")

if(WIN32 OR ANDROID)
    #configure libtiff
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/libtiff/tif_config.vc.h
                   ${CMAKE_CURRENT_BINARY_DIR}/tif_config.h COPYONLY)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/libtiff/tiffconf.vc.h
                   ${CMAKE_CURRENT_BINARY_DIR}/tiffconf.h COPYONLY)
else()
   # message(FATAL_ERROR "CMake script not yet available for this platform :( ")
endif()

set(LIBTIFF_INC
    libtiff/t4.h
    libtiff/tiff.h
    libtiff/tiffio.h
    libtiff/tiffiop.h
    libtiff/tiffvers.h
    libtiff/tif_dir.h
    libtiff/tif_fax3.h
    libtiff/tif_predict.h
    libtiff/uvcode.h
    ${CMAKE_CURRENT_BINARY_DIR}/tiffconf.h
    ${CMAKE_CURRENT_BINARY_DIR}/tif_config.h
)
set(LIBTIFF_SRC
    libtiff/tif_aux.c
    libtiff/tif_close.c
    libtiff/tif_codec.c
    libtiff/tif_color.c
    libtiff/tif_compress.c
    libtiff/tif_dir.c
    libtiff/tif_dirinfo.c
    libtiff/tif_dirread.c
    libtiff/tif_dirwrite.c
    libtiff/tif_dumpmode.c
    libtiff/tif_error.c
    libtiff/tif_extension.c
    libtiff/tif_fax3.c
    libtiff/tif_fax3sm.c
    libtiff/tif_getimage.c
    libtiff/tif_jbig.c
    libtiff/tif_jpeg.c
    #libtiff/tif_jpeg_12.c
    libtiff/tif_ojpeg.c
    libtiff/tif_flush.c
    libtiff/tif_luv.c
    libtiff/tif_lzw.c
    libtiff/tif_next.c
    libtiff/tif_open.c
    libtiff/tif_packbits.c
    libtiff/tif_pixarlog.c
    libtiff/tif_predict.c
    libtiff/tif_print.c
    libtiff/tif_read.c
    libtiff/tif_stream.cxx
    libtiff/tif_swab.c
    libtiff/tif_strip.c
    libtiff/tif_thunder.c
    libtiff/tif_tile.c
    libtiff/tif_version.c
    libtiff/tif_warning.c
    libtiff/tif_write.c
    libtiff/tif_zip.c
    
)

if(WIN32)
    list(APPEND LIBTIFF_SRC
        libtiff/tif_win32.c
    )
else()
    list(APPEND LIBTIFF_SRC
        libtiff/tif_unix.c
    )
endif()

include_directories(${CMAKE_CURRENT_BINARY_DIR} ${JPEG_INCLUDE_DIR} ${ZLIB_INCLUDE_DIR} )

add_definitions(-DZIP_SUPPORT -DJPEG_SUPPORT)

add_library(tiff SHARED ${LIBTIFF_SRC} libtiff/libtiff.def)
target_link_libraries(tiff ${JPEG_LIBRARY} ${ZLIB_LIBRARY} ${M_LIBRARY})
   
install(TARGETS tiff
        RUNTIME DESTINATION "${INSTALL_BIN_DIR}"
        ARCHIVE DESTINATION "${INSTALL_LIB_DIR}"
        LIBRARY DESTINATION "${INSTALL_LIB_DIR}" )
install(FILES ${LIBTIFF_INC} DESTINATION "${INSTALL_INC_DIR}")
