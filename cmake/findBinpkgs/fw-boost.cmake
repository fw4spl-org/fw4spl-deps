set(Boost_DEBUG false)
file(GLOB BOOST_ROOT ${CMAKE_CURRENT_LIST_DIR})
set(Boost_NO_SYSTEM_PATHS ON)
set(Boost_USE_DEBUG_PYTHON ON)
set(Boost_USE_MULTITHREADED ON)
set(BOOST_VERSION "1_57")
set(BOOST_INCLUDEDIR ${BOOST_ROOT}/include/boost-${BOOST_VERSION})

add_definitions(
        -DBOOST_ALL_DYN_LINK
        -DBOOST_LINKING_PYTHON
        -DBOOST_DEBUG_PYTHON
        -DBOOST_THREAD_DONT_PROVIDE_DEPRECATED_FEATURES_SINCE_V3_0_0
        -DBOOST_THREAD_PROVIDES_FUTURE
        -DBOOST_THREAD_VERSION=2
        )

if(WIN32)
    set(BOOST_LIBRARYDIR ${BOOST_ROOT}/lib)
    if(MSVC12)
        set(VERSION "120")
    elseif(MSVC10)
        set(VERSION "100")
    else()
        message(SEND_ERROR "Compiler version not supported")
    endif()
    set(Boost_COMPILER -vc${VERSION})
    add_definitions(
            -DBOOST_LIB_DIAGNOSTIC
            -DNOMINMAX
            -DWIN32_LEAN_AND_MEAN
            -DBOOST_ALL_NO_LIB
            )
endif()

if(APPLE)
    set(Boost_COMPILER -clang-darwin42)
else()
    if(UNIX)
        if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
            string(REPLACE "." "" VERSION ${CMAKE_CXX_COMPILER_VERSION})
            string(SUBSTRING ${VERSION} 0 2 VERSION)
            set(Boost_COMPILER -clang${VERSION})
        endif()
    endif()
endif()

