project(glmBuilder)

include(ExternalProject)

set(GLM_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                   -DBUILD_DOXYGEN:BOOL=OFF
)

set(CACHED_URL https://github.com/g-truc/glm/archive/0.9.9.0.tar.gz)

ExternalProject_Add(
    glm
    URL ${CACHED_URL}
    URL_HASH SHA256=514dea9ac0099dc389cf293cf1ab3d97aff080abad55bf79d4ab7ff6895ee69c
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${GLM_CMAKE_ARGS}
)


