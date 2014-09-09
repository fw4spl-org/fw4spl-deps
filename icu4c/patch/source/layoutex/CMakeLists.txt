cmake_minimum_required(VERSION 2.8)

project(iculx)

include_directories(
    ../common
    ../
)
  
set(ICULX_SOURCE_FILES
    LXUtilities.cpp
    ParagraphLayout.cpp
    playout.cpp
    plruns.cpp
    RunArrays.cpp
)
set(ICULX_HEADER_FILES
    LXUtilities.h
    layout/ParagraphLayout.h
    layout/playout.h
    layout/plruns.h
    layout/RunArrays.h
)
source_group("Source Files" FILES ${ICULX_SOURCE_FILES})
source_group("Header Files" FILES ${ICULX_HEADER_FILES})

set_source_files_properties(ICULX_HEADER_FILES PROPERTIES HEADER_FILE_ONLY TRUE)
list(APPEND ICULX_SOURCE_FILES ${ICULX_HEADER_FILES})
 
add_definitions(
    -DU_LAYOUTEX_IMPLEMENTATION
)

add_library(iculx SHARED ${ICULX_SOURCE_FILES})
target_link_libraries(iculx icule icuuc)

install(TARGETS iculx
        RUNTIME DESTINATION "${INSTALL_BIN_DIR}"
        ARCHIVE DESTINATION "${INSTALL_LIB_DIR}"
        LIBRARY DESTINATION "${INSTALL_LIB_DIR}" )
install(DIRECTORY ${PROJECT_SOURCE_DIR}/layout
        DESTINATION "${INSTALL_INC_DIR}" FILES_MATCHING PATTERN "*.h")
