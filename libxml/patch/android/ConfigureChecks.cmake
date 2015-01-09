# NOTE: only add something here if it is really needed by all of kdelibs.
#     Otherwise please prefer adding to the relevant config-foo.h.cmake file,
#     and the CMakeLists.txt that generates it (or a separate ConfigureChecks.make file if you prefer)
#     to minimize recompilations and increase modularity.

include(CheckIncludeFile)
include(CheckIncludeFiles)
include(CheckSymbolExists)
include(CheckFunctionExists)
include(CheckLibraryExists)
#include(CheckPrototypeExists)
#include(CheckTypeSize)
#include(CheckStructMember)
#include(CheckCXXSourceCompiles)


#check for libz using the cmake supplied FindZLIB.cmake
if (ZLIB_FOUND)
    set (HAVE_LIBZ 1)
endif (ZLIB_FOUND)
    
#macro_bool_to_01(ZLIB_FOUND HAVE_LIBZ)                  # zlib is required


check_include_files(arpa/inet.h       HAVE_ARPA_INET_H   )
check_include_files(arpa/nameser.h    HAVE_ARPA_NAMESER_H)
check_include_files(config.h          HAVE_CONFIG_H      )
check_include_files(ctype.h           HAVE_CTYPE_H       )
check_include_files(dlfcn.h           HAVE_DLFCN_H       )
check_include_files(dl.h              HAVE_DL_H          )
check_include_files(errno.h           HAVE_ERRNO_H       )
check_include_files(fcntl.h           HAVE_FCNTL_H       )
check_include_files(float.h           HAVE_FLOAT_H       )
check_include_files(limits.h          HAVE_LIMITS_H      )
check_include_files(malloc.h          HAVE_MALLOC_H      )
check_include_files(math.h            HAVE_MATH_H        )
check_include_files(netdb.h           HAVE_NETDB_H       )
check_include_files(netinet/in.h      HAVE_NETINET_IN_H  )
check_include_files(pthread.h         HAVE_PTHREAD_H     )
check_include_files(resolv.h          HAVE_RESOLV_H      )
check_include_files(signal.h          HAVE_SIGNAL_H      )
check_include_files(stdarg.h          HAVE_STDARG_H      )
check_include_files(stdlib.h          HAVE_STDLIB_H      )
check_include_files(strings.h         HAVE_STRINGS_H     )
check_include_files(string.h          HAVE_STRING_H      )
check_include_files(sys/mman.h        HAVE_SYS_MMAN_H    )
check_include_files(sys/select.h      HAVE_SYS_SELECT_H  )
check_include_files(sys/socket.h      HAVE_SYS_SOCKET_H  )
check_include_files(sys/stat.h        HAVE_SYS_STAT_H    )
check_include_files(sys/timeb.h       HAVE_SYS_TIMEB_H   )
check_include_files(sys/time.h        HAVE_SYS_TIME_H    )
check_include_files(sys/types.h       HAVE_SYS_TYPES_H   )
check_include_files(time.h            HAVE_TIME_H        )
check_include_files(unistd.h          HAVE_UNISTD_H      )
check_include_files(zlib.h            HAVE_ZLIB_H        )
check_include_files(stdarg.h          HAVE_STDARG_H      )



# TODO
#HAVE_BEOS
#HAVE_BEOS_THREADS
#HAVE_BROKEN_SS_FAMILY
#HAVE_FTIME
#HAVE_OS2
#HAVE_STAT
#HAVE_SHLLOAD             /* HAVE_SHLLOAD */
#HAVE_VA_COPY
#HAVE_WIN32_THREADS
#HAVE___VA_COPY
#HAVE_DLOPEN
#LIBXML_STATIC
#HAVE_GETADDRINFO
#SUPPORT_IP6
#RES_USE_INET6
#HAVE_LOCALTIME
#HAVE_STRFTIME
#HOST_NOT_FOUND
#HAVE_GETTIMEOFDAY
#HAVE_BEOS_THREADS
#HAVE_COMPILER_TLS

#check_symbol_exists(strcmp string.h HAVE_STRCMP)

check_function_exists(gettimeofday    HAVE_GETTIMEOFDAY)
check_function_exists(snprintf HAVE_SNPRINTF)
check_function_exists(sscanf HAVE_SSCANF)
check_function_exists(sprintf HAVE_SPRINTF)
check_symbol_exists(GetModuleHandleA winbase.h HAVE_GETMODULEHANDLEA)
#check_library_exists(readline test_func  HAVE_LIBREADLINE)
#check_library_exists(history test_func  HAVE_LIBHISTORY)

