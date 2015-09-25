project(glmBuilder)

include(ExternalProject)

set(GLM_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                   -DBUILD_DOXYGEN:BOOL=OFF
)

set(CACHED_URL http://downloads.sourceforge.net/project/ogl-math/glm-0.9.6.3/glm-0.9.6.3.zip)

ExternalProject_Add(
    glm
    URL ${CACHED_URL}
    URL_HASH SHA256=14651b56b10fa68082446acaf6a1116d56b757c8d375b34b5226a83140acd2b2
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${GLM_CMAKE_ARGS}
    STEP_TARGETS CopyConfigFileToInstall
)

ExternalProject_Add_Step(glm CopyConfigFileToInstall
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/glm-prefix/src/glm/util/FindGLM.cmake ${CMAKE_INSTALL_PREFIX}/FindGLM.cmake
    COMMENT "Install configuration file"
    DEPENDEES install
)

