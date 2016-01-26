CMAKE_MINIMUM_REQUIRED(VERSION 2.8)

project(libxml2)

set (LIBXML_MAJOR_VERSION 2)
set (LIBXML_MINOR_VERSION 9)
set (LIBXML_MICRO_VERSION 1)
set (LIBXML_MICRO_VERSION_SUFFIX )

# where to look first for cmake modules, before ${CMAKE_ROOT}/Modules/ is checked
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/modules")



set(CMAKE_MODULE_PATH ${CMAKE_INSTALL_PREFIX})

find_package(ZLIB REQUIRED)
find_package(Iconv REQUIRED)
#find_package(Python)

set (LIBXML_VERSION ${LIBXML_MAJOR_VERSION}.${LIBXML_MINOR_VERSION}.${LIBXML_MICRO_VERSION}${LIBXML_MICRO_VERSION_SUFFIX})
MATH(EXPR LIBXML_VERSION_INFO "${LIBXML_MAJOR_VERSION} + ${LIBXML_MINOR_VERSION}")
set (LIBXML_VERSION_INFO "${LIBXML_VERSION_INFO}:$LIBXML_MICRO_VERSION:$LIBXML_MINOR_VERSION)")
MATH(EXPR LIBXML_VERSION_NUMBER "${LIBXML_MAJOR_VERSION}*10000 + ${LIBXML_MINOR_VERSION}*100 + ${LIBXML_MICRO_VERSION}")

set (PACKAGE ${CMAKE_PROJECT_NAME})
set (PACKAGE_BUGREPORT "")
set (PACKAGE_NAME ${CMAKE_PROJECT_NAME})
set (PACKAGE_STRING "${CMAKE_PROJECT_NAME}-${LIBXML_VERSION}")
set (PACKAGE_TARNAME "")
set (PACKAGE_VERSION ${LIBXML_VERSION})
set (VERSION ${LIBXML_VERSION_NUMBER})

# detect last svn revision
find_path(SVN_DIR NAMES .svn
    PATHS 
        ${CMAKE_SOURCE_DIR}
        NO_DEFAULT_PATH
        NO_CMAKE_ENVIRONMENT_PATH
        NO_CMAKE_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_SYSTEM_PATH    
)

if (SVN_DIR)
    EXECUTE_PROCESS(COMMAND svn info
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        RESULT_VARIABLE result
        OUTPUT_VARIABLE output
        ERROR_QUIET
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
    )
    
    if (NOT result)
        STRING(REGEX MATCH "Revision: [0-9]+" _revision "${output}")
        STRING(REGEX MATCH "([0-9][0-9]+)" revision "${_revision}")
        set (LIBXML_VERSION_EXTRA "-SVN${revision}")
    endif (NOT result)    
endif(SVN_DIR)

include(ConfigureChecks.cmake)

if (MSVC)
    set (LIBXML libxml2)
else (MSVC)
    set (LIBXML xml2)
endif (MSVC)

if (MSVC)
    if(CMAKE_COMPILER_2005)
        # to avoid a lot of deprecated warnings
        add_definitions( -D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE -D_SCL_SECURE_NO_WARNINGS )
        # 'identifier' : no suitable definition provided for explicit template instantiation request
        set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -wd4661" )
    endif(CMAKE_COMPILER_2005)
endif (MSVC)


#TODO 
SET (LIBXML_VERSION_NUMBER 20630)
SET (VERSION ${LIBXML_VERSION_NUMBER})
SET (LIBXML_VERSION_EXTRA )
SET (WITH_TRIO 1)
SET (WITH_TRIO_SOURCES 1)
SET (WITH_THREADS 0)
SET (WITH_OUTPUT 1 )
SET (WITH_PUSH 1)
SET (WITH_READER 1)
SET (WITH_PATTERN 1)
SET (WITH_WRITER 1)
SET (WITH_TREE 1)
SET (WITH_SAX1 1)
SET (WITH_FTP 1)
SET (WITH_HTTP 1)
SET (WITH_VALID 1)
SET (WITH_HTML 1)
SET (WITH_LEGACY 1)
SET (WITH_C14N 1)
SET (WITH_CATALOG 1)
SET (WITH_DOCB 1)
SET (WITH_XPATH 1)
SET (WITH_XPTR 1)
SET (WITH_XINCLUDE 1)
SET (WITH_ICONV ${ICONV_FOUND})
SET (WITH_ISO8859X 1)
SET (WITH_DEBUG 0)
SET (WITH_MEM_DEBUG 0)
SET (WITH_RUN_DEBUG 0)
SET (WITH_REGEXPS 1)
SET (WITH_SCHEMAS 1)
SET (WITH_SCHEMATRON 1)
SET (WITH_MODULES 1)
SET (MODULE_EXTENSION 0)
SET (WITH_ZLIB  ${ZLIB_FOUND})
SET (WITH_THREAD_ALLOC 1)
SET (WITH_ICU 0)
SET (WITH_LZMA 0)

if (WIN32)
    configure_file(win32config.h.cmake ${CMAKE_BINARY_DIR}/win32config.h)
endif (WIN32)

set (HAVE_CONFIG_H 1)
add_definitions(-DHAVE_CONFIG_H=1)

configure_file(config.h.cmake ${CMAKE_BINARY_DIR}/config.h)

# may be moved to include/libxml/CMakeLists.txt 
set (xmlinc_HEADERS
    include/libxml/SAX.h
    include/libxml/entities.h
    include/libxml/encoding.h
    include/libxml/parser.h
    include/libxml/parserInternals.h
    include/libxml/xmlerror.h
    include/libxml/HTMLparser.h
    include/libxml/HTMLtree.h
    include/libxml/debugXML.h
    include/libxml/tree.h
    include/libxml/list.h
    include/libxml/hash.h
    include/libxml/xpath.h
    include/libxml/xpathInternals.h
    include/libxml/xpointer.h
    include/libxml/xinclude.h
    include/libxml/xmlIO.h
    include/libxml/xmlmemory.h
    include/libxml/nanohttp.h
    include/libxml/nanoftp.h
    include/libxml/uri.h
    include/libxml/valid.h
    include/libxml/xlink.h
# is generated
#    include/libxml/xmlversion.h
    include/libxml/DOCBparser.h
    include/libxml/catalog.h
    include/libxml/threads.h
    include/libxml/globals.h
    include/libxml/c14n.h
    include/libxml/xmlautomata.h
    include/libxml/xmlregexp.h
    include/libxml/xmlmodule.h
    include/libxml/xmlschemas.h
    include/libxml/schemasInternals.h
    include/libxml/xmlschemastypes.h
    include/libxml/xmlstring.h
    include/libxml/xmlunicode.h
    include/libxml/xmlreader.h
    include/libxml/relaxng.h
    include/libxml/dict.h
    include/libxml/SAX2.h
    include/libxml/xmlexports.h
    include/libxml/xmlwriter.h
    include/libxml/chvalid.h
    include/libxml/pattern.h
    include/libxml/xmlsave.h
    include/libxml/schematron.h
)
list(APPEND xmlinc_HEADERS ${CMAKE_BINARY_DIR}/xmlversion.h)
configure_file(include/libxml/xmlversion.h.in ${CMAKE_BINARY_DIR}/xmlversion.h)

install(FILES ${xmlinc_HEADERS} DESTINATION include/libxml2/libxml)

if (WITH_TRIO_SOURCES)
    set (libxml2_SOURCES 
        SAX.c entities.c encoding.c error.c parserInternals.c
        parser.c tree.c hash.c list.c xmlIO.c xmlmemory.c uri.c
        valid.c xlink.c HTMLparser.c HTMLtree.c debugXML.c xpath.c
        xpointer.c xinclude.c nanohttp.c nanoftp.c DOCBparser.c
        catalog.c globals.c threads.c c14n.c xmlstring.c
        xmlregexp.c xmlschemas.c xmlschemastypes.c xmlunicode.c
        triostr.c trionan.c trio.c xmlreader.c relaxng.c dict.c SAX2.c
        xmlwriter.c legacy.c chvalid.c pattern.c xmlsave.c
        xmlmodule.c schematron.c buf.c
    )
else (WITH_TRIO_SOURCES)
    set (libxml2_SOURCES 
        SAX.c entities.c encoding.c error.c parserInternals.c
        parser.c tree.c hash.c list.c xmlIO.c xmlmemory.c uri.c
        valid.c xlink.c HTMLparser.c HTMLtree.c debugXML.c xpath.c
        xpointer.c xinclude.c nanohttp.c nanoftp.c DOCBparser.c
        catalog.c globals.c threads.c c14n.c xmlstring.c
        xmlregexp.c xmlschemas.c xmlschemastypes.c xmlunicode.c
        xmlreader.c relaxng.c dict.c SAX2.c
        xmlwriter.c legacy.c chvalid.c pattern.c xmlsave.c
        xmlmodule.c schematron.c buf.c
    )
endif (WITH_TRIO_SOURCES)


if (STATIC)
    add_definitions(-DLIBXML_STATIC=1)
endif (STATIC)

add_definitions(-DICONV_CONST=const -DLIBXML_THREAD_ENABLED=0 -DTRIO_MINIMAL=0 -DF_LOG10=0 -DTRIO_FUNC_TO_FLOAT=1 -DHAVE_DLOPEN=1)

set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -lm" )
set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -lm" )

# CMAKE_BINARY_DIR must be first because of generated config.h 
include_directories(${CMAKE_BINARY_DIR} ${CMAKE_SOURCE_DIR}/include ${ICONV_INCLUDE_DIR})

if (WIN32)
    set (LIBS ${ICONV_LIBRARIES} ${ZLIB_LIBRARIES} ws2_32)
else ()
    set (LIBS ${ICONV_LIBRARIES} ${ZLIB_LIBRARIES})
endif()

if (STATIC)
    add_library(${LIBXML}_static STATIC ${libxml2_SOURCES})
    target_link_libraries(${LIBXML}_static ${LIBS})
else (STATIC)
    add_library(${LIBXML} SHARED ${libxml2_SOURCES})
    target_link_libraries(${LIBXML} ${LIBS})
endif (STATIC)

install(TARGETS ${LIBXML} LIBRARY DESTINATION lib RUNTIME DESTINATION bin ARCHIVE DESTINATION lib)


add_executable(xmllint xmllint.c)
target_link_libraries(xmllint ${LIBXML})
install(TARGETS xmllint DESTINATION bin)

add_executable(xmlcatalog xmlcatalog.c)
target_link_libraries(xmlcatalog ${LIBXML})
install(TARGETS xmlcatalog DESTINATION bin)


# move to test 
# set (TESTS 
    # testSchemas testRelax testSAX testHTML testXPath testURI
    # testC14N testAutomata testRegexp
    # testReader testapi testModule runtest runsuite
# )

# if (WIN32)
    # list(APPEND TESTS  testThreadsWin32)
# else(WIN32)
    # list(APPEND TESTS  testThreads)
# endif(WIN32)

# foreach(test ${TESTS})
    # add_executable(${test} ${test}.c)
    # target_link_libraries(${test} ${LIBXML})
# endforeach(test)


set (SHARED_SOURCES 
    entities.c 
    parser.c 
    tree.c 
    SAX.c
)

#add_executable(tester ${SHARED_SOURCES} tester.c)
#target_link_libraries(tester ${LIBXML})
