set(Boost_DEBUG false)
file(GLOB BOOST_ROOT ${CMAKE_CURRENT_LIST_DIR})
set(Boost_NO_SYSTEM_PATHS ON)
set(Boost_USE_DEBUG_PYTHON ON)
set(Boost_USE_MULTITHREADED ON)

add_definitions(
        -DBOOST_ALL_DYN_LINK
        -DBOOST_LINKING_PYTHON
        -DBOOST_DEBUG_PYTHON
        -DBOOST_THREAD_DONT_PROVIDE_DEPRECATED_FEATURES_SINCE_V3_0_0
        -DBOOST_THREAD_PROVIDES_FUTURE
        -DBOOST_THREAD_VERSION=2
        )

IF(WIN32)
    set(BOOST_LIBRARYDIR ${BOOST_ROOT}/lib)

    set(Boost_COMPILER -vc100)
    add_definitions(
            -DBOOST_LIB_DIAGNOSTIC
            -DNOMINMAX
            -DWIN32_LEAN_AND_MEAN
            )
ENDIF()

IF(APPLE)
    set(Boost_COMPILER -clang-darwin42)
ELSE()
    IF(UNIX)
        IF("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
            string(REPLACE "." "" VERSION ${CMAKE_CXX_COMPILER_VERSION})
            string(SUBSTRING ${VERSION} 0 2 VERSION)
            set(Boost_COMPILER -clang${VERSION})
        ENDIF()
    ENDIF()
ENDIF()

