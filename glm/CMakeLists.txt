project(glmBuilder)

include(ExternalProject)

set(GLM_CMAKE_ARGS ${COMMON_CMAKE_ARGS}
                   -DBUILD_DOXYGEN:BOOL=OFF
)

set(CACHED_URL https://github.com/g-truc/glm/archive/0.9.8.4.tar.gz)

ExternalProject_Add(
    glm
    URL ${CACHED_URL}
    URL_HASH SHA256=a220e60f8711265595be3221e530d632d5823641ecd46a3a54bc174933bff14c
    DOWNLOAD_DIR ${ARCHIVE_DIR}
    INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
    CMAKE_ARGS ${GLM_CMAKE_ARGS}
)


