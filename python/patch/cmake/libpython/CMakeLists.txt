add_definitions(-DPy_BUILD_CORE)

add_definitions(-DVERSION="${LIBPYTHON_VERSION}")
add_definitions(-DVPATH="")

#add_definitions(-DPYTHONPATH="${EXTRA_PYTHONPATH}")

if(WIN32)
    set(CMAKE_DEBUG_POSTFIX "_d")
endif(WIN32)

if(NOT WIN32)
    add_definitions(-DPREFIX="${CMAKE_INSTALL_PREFIX}")
    add_definitions(-DEXEC_PREFIX="${CMAKE_INSTALL_PREFIX}")
    add_definitions(-DPLATFORM="linux2")
endif(NOT WIN32)

set(LIBPYTHON_SOURCES
    ${CMAKE_SOURCE_DIR}/Modules/_bisectmodule.c
    ${CMAKE_SOURCE_DIR}/Modules/_codecsmodule.c
    ${CMAKE_SOURCE_DIR}/Modules/_collectionsmodule.c
    ${CMAKE_SOURCE_DIR}/Modules/_csv.c
    ${CMAKE_SOURCE_DIR}/Modules/_functoolsmodule.c
    ${CMAKE_SOURCE_DIR}/Modules/_heapqmodule.c
    ${CMAKE_SOURCE_DIR}/Modules/_hotshot.c
    ${CMAKE_SOURCE_DIR}/Modules/_json.c
    ${CMAKE_SOURCE_DIR}/Modules/_localemodule.c
    ${CMAKE_SOURCE_DIR}/Modules/_lsprof.c
    ${CMAKE_SOURCE_DIR}/Modules/_math.c
    ${CMAKE_SOURCE_DIR}/Modules/_math.h
    ${CMAKE_SOURCE_DIR}/Modules/_randommodule.c
    ${CMAKE_SOURCE_DIR}/Modules/_sre.c
    ${CMAKE_SOURCE_DIR}/Modules/_struct.c
    ${CMAKE_SOURCE_DIR}/Modules/_weakref.c
    ${CMAKE_SOURCE_DIR}/Modules/arraymodule.c
    ${CMAKE_SOURCE_DIR}/Modules/audioop.c
    ${CMAKE_SOURCE_DIR}/Modules/binascii.c
    ${CMAKE_SOURCE_DIR}/Modules/cmathmodule.c
    ${CMAKE_SOURCE_DIR}/Modules/cPickle.c
    ${CMAKE_SOURCE_DIR}/Modules/cStringIO.c
    ${CMAKE_SOURCE_DIR}/Modules/datetimemodule.c
    ${CMAKE_SOURCE_DIR}/Modules/errnomodule.c
    ${CMAKE_SOURCE_DIR}/Modules/future_builtins.c
    ${CMAKE_SOURCE_DIR}/Modules/gcmodule.c
    ${CMAKE_SOURCE_DIR}/Modules/imageop.c
    ${CMAKE_SOURCE_DIR}/Modules/itertoolsmodule.c
    ${CMAKE_SOURCE_DIR}/Modules/main.c
    ${CMAKE_SOURCE_DIR}/Modules/mathmodule.c
    ${CMAKE_SOURCE_DIR}/Modules/md5.c
    ${CMAKE_SOURCE_DIR}/Modules/md5module.c
    ${CMAKE_SOURCE_DIR}/Modules/mmapmodule.c
    ${CMAKE_SOURCE_DIR}/Modules/operator.c
    ${CMAKE_SOURCE_DIR}/Modules/parsermodule.c
    ${CMAKE_SOURCE_DIR}/Modules/posixmodule.c
    ${CMAKE_SOURCE_DIR}/Modules/rotatingtree.c
    ${CMAKE_SOURCE_DIR}/Modules/rotatingtree.h
    ${CMAKE_SOURCE_DIR}/Modules/sha256module.c
    ${CMAKE_SOURCE_DIR}/Modules/sha512module.c
    ${CMAKE_SOURCE_DIR}/Modules/shamodule.c
    ${CMAKE_SOURCE_DIR}/Modules/signalmodule.c
    ${CMAKE_SOURCE_DIR}/Modules/stropmodule.c
    ${CMAKE_SOURCE_DIR}/Modules/symtablemodule.c
    ${CMAKE_SOURCE_DIR}/Modules/threadmodule.c
    ${CMAKE_SOURCE_DIR}/Modules/timemodule.c
    ${CMAKE_SOURCE_DIR}/Modules/xxsubtype.c
    ${CMAKE_SOURCE_DIR}/Modules/zipimport.c
    ${CMAKE_SOURCE_DIR}/Modules/zlibmodule.c
    ${CMAKE_SOURCE_DIR}/Modules/cjkcodecs/_codecs_cn.c
    ${CMAKE_SOURCE_DIR}/Modules/cjkcodecs/_codecs_hk.c
    ${CMAKE_SOURCE_DIR}/Modules/cjkcodecs/_codecs_iso2022.c
    ${CMAKE_SOURCE_DIR}/Modules/cjkcodecs/_codecs_jp.c
    ${CMAKE_SOURCE_DIR}/Modules/cjkcodecs/_codecs_kr.c
    ${CMAKE_SOURCE_DIR}/Modules/cjkcodecs/_codecs_tw.c
    ${CMAKE_SOURCE_DIR}/Modules/cjkcodecs/multibytecodec.c
    ${CMAKE_SOURCE_DIR}/Modules/_io/_iomodule.c
    ${CMAKE_SOURCE_DIR}/Modules/_io/bufferedio.c
    ${CMAKE_SOURCE_DIR}/Modules/_io/bytesio.c
    ${CMAKE_SOURCE_DIR}/Modules/_io/fileio.c
    ${CMAKE_SOURCE_DIR}/Modules/_io/iobase.c
    ${CMAKE_SOURCE_DIR}/Modules/_io/stringio.c
    ${CMAKE_SOURCE_DIR}/Modules/_io/textio.c
    ${CMAKE_SOURCE_DIR}/Modules/getbuildinfo.c
    
    
    ${CMAKE_SOURCE_DIR}/Objects/abstract.c
    ${CMAKE_SOURCE_DIR}/Objects/boolobject.c
    ${CMAKE_SOURCE_DIR}/Objects/bufferobject.c
    ${CMAKE_SOURCE_DIR}/Objects/bytearrayobject.c
    ${CMAKE_SOURCE_DIR}/Objects/bytes_methods.c
    ${CMAKE_SOURCE_DIR}/Objects/capsule.c
    ${CMAKE_SOURCE_DIR}/Objects/cellobject.c
    ${CMAKE_SOURCE_DIR}/Objects/classobject.c
    ${CMAKE_SOURCE_DIR}/Objects/cobject.c
    ${CMAKE_SOURCE_DIR}/Objects/codeobject.c
    ${CMAKE_SOURCE_DIR}/Objects/complexobject.c
    ${CMAKE_SOURCE_DIR}/Objects/descrobject.c
    ${CMAKE_SOURCE_DIR}/Objects/dictobject.c
    ${CMAKE_SOURCE_DIR}/Objects/enumobject.c
    ${CMAKE_SOURCE_DIR}/Objects/exceptions.c
    ${CMAKE_SOURCE_DIR}/Objects/fileobject.c
    ${CMAKE_SOURCE_DIR}/Objects/floatobject.c
    ${CMAKE_SOURCE_DIR}/Objects/frameobject.c
    ${CMAKE_SOURCE_DIR}/Objects/funcobject.c
    ${CMAKE_SOURCE_DIR}/Objects/genobject.c
    ${CMAKE_SOURCE_DIR}/Objects/intobject.c
    ${CMAKE_SOURCE_DIR}/Objects/iterobject.c
    ${CMAKE_SOURCE_DIR}/Objects/listobject.c
    ${CMAKE_SOURCE_DIR}/Objects/longobject.c
    ${CMAKE_SOURCE_DIR}/Objects/memoryobject.c
    ${CMAKE_SOURCE_DIR}/Objects/methodobject.c
    ${CMAKE_SOURCE_DIR}/Objects/moduleobject.c
    ${CMAKE_SOURCE_DIR}/Objects/object.c
    ${CMAKE_SOURCE_DIR}/Objects/obmalloc.c
    ${CMAKE_SOURCE_DIR}/Objects/rangeobject.c
    ${CMAKE_SOURCE_DIR}/Objects/setobject.c
    ${CMAKE_SOURCE_DIR}/Objects/sliceobject.c
    ${CMAKE_SOURCE_DIR}/Objects/stringobject.c
    ${CMAKE_SOURCE_DIR}/Objects/structseq.c
    ${CMAKE_SOURCE_DIR}/Objects/tupleobject.c
    ${CMAKE_SOURCE_DIR}/Objects/typeobject.c
    ${CMAKE_SOURCE_DIR}/Objects/unicodectype.c
    ${CMAKE_SOURCE_DIR}/Objects/unicodeobject.c
    ${CMAKE_SOURCE_DIR}/Objects/weakrefobject.c
    ${CMAKE_SOURCE_DIR}/Parser/acceler.c
    ${CMAKE_SOURCE_DIR}/Parser/bitset.c
    ${CMAKE_SOURCE_DIR}/Parser/firstsets.c
    ${CMAKE_SOURCE_DIR}/Parser/grammar1.c
    ${CMAKE_SOURCE_DIR}/Parser/grammar.c
    ${CMAKE_SOURCE_DIR}/Parser/listnode.c
    ${CMAKE_SOURCE_DIR}/Parser/metagrammar.c
    ${CMAKE_SOURCE_DIR}/Parser/myreadline.c
    ${CMAKE_SOURCE_DIR}/Parser/node.c
    ${CMAKE_SOURCE_DIR}/Parser/parser.c
    ${CMAKE_SOURCE_DIR}/Parser/parsetok.c
    ${CMAKE_SOURCE_DIR}/Parser/pgen.c
    ${CMAKE_SOURCE_DIR}/Parser/tokenizer.c
    ${CMAKE_SOURCE_DIR}/Python/asdl.c
    ${CMAKE_SOURCE_DIR}/Python/ast.c
    ${CMAKE_SOURCE_DIR}/Python/bltinmodule.c
    ${CMAKE_SOURCE_DIR}/Python/ceval.c
    ${CMAKE_SOURCE_DIR}/Python/codecs.c
    ${CMAKE_SOURCE_DIR}/Python/compile.c
    ${CMAKE_SOURCE_DIR}/Python/dtoa.c
    ${CMAKE_SOURCE_DIR}/Python/errors.c
    ${CMAKE_SOURCE_DIR}/Python/formatter_string.c
    ${CMAKE_SOURCE_DIR}/Python/formatter_unicode.c
    ${CMAKE_SOURCE_DIR}/Python/frozen.c
    ${CMAKE_SOURCE_DIR}/Python/future.c
    ${CMAKE_SOURCE_DIR}/Python/getargs.c
    ${CMAKE_SOURCE_DIR}/Python/getcompiler.c
    ${CMAKE_SOURCE_DIR}/Python/getcopyright.c
    ${CMAKE_SOURCE_DIR}/Python/getopt.c
    ${CMAKE_SOURCE_DIR}/Python/getplatform.c
    ${CMAKE_SOURCE_DIR}/Python/getversion.c
    ${CMAKE_SOURCE_DIR}/Python/graminit.c
    ${CMAKE_SOURCE_DIR}/Python/import.c
    ${CMAKE_SOURCE_DIR}/Python/importdl.c
    ${CMAKE_SOURCE_DIR}/Python/marshal.c
    ${CMAKE_SOURCE_DIR}/Python/modsupport.c
    ${CMAKE_SOURCE_DIR}/Python/mysnprintf.c
    ${CMAKE_SOURCE_DIR}/Python/mystrtoul.c
    ${CMAKE_SOURCE_DIR}/Python/peephole.c
    ${CMAKE_SOURCE_DIR}/Python/pyarena.c
    ${CMAKE_SOURCE_DIR}/Python/pyctype.c
    ${CMAKE_SOURCE_DIR}/Python/pyfpe.c
    ${CMAKE_SOURCE_DIR}/Python/pymath.c
    ${CMAKE_SOURCE_DIR}/Python/pystate.c
    ${CMAKE_SOURCE_DIR}/Python/pystrcmp.c
    ${CMAKE_SOURCE_DIR}/Python/pystrtod.c
    ${CMAKE_SOURCE_DIR}/Python/Python-ast.c
    ${CMAKE_SOURCE_DIR}/Python/pythonrun.c
    ${CMAKE_SOURCE_DIR}/Python/random.c
    ${CMAKE_SOURCE_DIR}/Python/structmember.c
    ${CMAKE_SOURCE_DIR}/Python/symtable.c
    ${CMAKE_SOURCE_DIR}/Python/sysmodule.c
    ${CMAKE_SOURCE_DIR}/Python/thread.c
    ${CMAKE_SOURCE_DIR}/Python/traceback.c
    ${CMAKE_SOURCE_DIR}/Python/_warnings.c
    ${builtin_source}
)

# Platform-specific source files
if(UNIX)
    list(APPEND LIBPYTHON_SOURCES
        ${CMAKE_SOURCE_DIR}/Python/dynload_shlib.c
        ${CMAKE_SOURCE_DIR}/Modules/getpath.c
    )
elseif(WIN32)
    list(APPEND LIBPYTHON_SOURCES
        ${CMAKE_SOURCE_DIR}/PC/_subprocess.c
        ${CMAKE_SOURCE_DIR}/PC/_winreg.c
        ${CMAKE_SOURCE_DIR}/PC/config.c
        ${CMAKE_SOURCE_DIR}/PC/dl_nt.c
        ${CMAKE_SOURCE_DIR}/PC/getpathp.c
        ${CMAKE_SOURCE_DIR}/PC/import_nt.c
        ${CMAKE_SOURCE_DIR}/PC/msvcrtmodule.c
        ${CMAKE_SOURCE_DIR}/Python/dynload_win.c
    )
endif(UNIX)

# Create the parts of config.c for platform-specific and user-controlled
# builtin modules.
set(config_inits_file ${CMAKE_CURRENT_BINARY_DIR}/platform-config-inits.c)
set(config_entries_file ${CMAKE_CURRENT_BINARY_DIR}/platform-config-entries.c)
include_directories(${CMAKE_CURRENT_BINARY_DIR})
include_directories(${builtin_includedirs})
include_directories(${ZLIB_INCLUDE_DIRS})

file(WRITE "${config_inits_file}" "")
file(WRITE "${config_entries_file}" "")

foreach(ext ${builtin_extensions})
    file(APPEND "${config_inits_file}" "extern void init${ext}(void);\n")
    file(APPEND "${config_entries_file}" "{\"${ext}\", init${ext}},\n")
endforeach(ext)


function (add_libpython name type)
    add_library(${name} ${type} ${LIBPYTHON_SOURCES})
    target_link_libraries(${name}
        ${builtin_link_libraries}
        ${CMAKE_THREAD_LIBS_INIT}
        ${ZLIB_LIBRARIES}
        #dl
        #m
    )

    if(UNIX)
        target_link_libraries(${name} util)
    endif(UNIX)

    if(builtin_definitions)
        set_target_properties(${name} PROPERTIES COMPILE_DEFINITIONS "${builtin_definitions}")
    endif(builtin_definitions)

    install(TARGETS ${name}
        RUNTIME DESTINATION bin
        ARCHIVE DESTINATION ${LIBDIR}
        LIBRARY DESTINATION ${LIBDIR}
    )
endfunction (add_libpython)

if(ENABLE_SHARED)
    add_definitions(-DPy_ENABLE_SHARED)
    add_libpython(${LIBPYTHON} SHARED)
endif(ENABLE_SHARED)

if(ENABLE_STATIC)
    add_libpython(${LIBPYTHON} STATIC)
    set_target_properties(libpython-static PROPERTIES COMPILE_DEFINITIONS Py_NO_ENABLE_SHARED)
endif(ENABLE_STATIC)
