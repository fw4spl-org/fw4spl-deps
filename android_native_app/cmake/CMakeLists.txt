cmake_minimum_required(VERSION 3.0)

project(android_native_app)

include_directories(
  ${ANDROID_NDK}/platforms/android-${ANDROID_NATIVE_API_LEVEL}/arch-${ANDROID_ARCH_NAME}/usr/include
  ${ANDROID_NDK}/sources/android/native_app_glue
)

add_library(android_native_app STATIC 
    ${ANDROID_NDK}/sources/android/native_app_glue/android_native_app_glue.c
)

install(TARGETS android_native_app
    RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
    LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
    ARCHIVE DESTINATION ${CMAKE_INSTALL_PREFIX}/lib
)
install(FILES ${ANDROID_NDK}/sources/android/native_app_glue/android_native_app_glue.h 
    DESTINATION ${CMAKE_INSTALL_PREFIX}/include/)
