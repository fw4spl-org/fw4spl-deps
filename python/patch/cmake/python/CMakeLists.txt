set(PYTHON_SOURCES
    ${CMAKE_SOURCE_DIR}/Modules/python.c
)

 if(WIN32)
    set(PYTHON_SOURCES ${PYTHON_SOURCES} ${CMAKE_SOURCE_DIR}/PC/python_exe.rc )
endif(WIN32)
        
add_executable(python ${PYTHON_SOURCES})

# Link against the shared libpython if it was built, otherwise use the static
# version.
target_link_libraries(python ${LIBPYTHON})
if(ENABLE_STATIC)
    set_target_properties(python PROPERTIES COMPILE_DEFINITIONS Py_NO_ENABLE_SHARED)
endif(ENABLE_STATIC)

install(TARGETS python RUNTIME DESTINATION bin)
