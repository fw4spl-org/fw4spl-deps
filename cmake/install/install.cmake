
# CMake script to install file in specified path
# This function automatically adds a target to uninstall the file (in target <BINPKG>_uninstall)
# Parameters of the function:
# - BINPKG: name of the associated BinPkg
# - SRC: source path of the file to install
# - DEST: destination path of the file
function(fwInstallFile)
    cmake_parse_arguments(_install "" "BINPKG;SRC;DEST" "" ${ARGN})
    get_filename_component(_install_SRC_FILENAME ${_install_SRC} NAME)

    ExternalProject_Add_Step(${_install_BINPKG} Copy${_install_SRC_FILENAME}ToInstall
        COMMAND ${CMAKE_COMMAND} -E copy ${_install_SRC} ${_install_DEST}
        COMMENT "-- Installing: ${_install_DEST}"
        DEPENDEES install
    )
    add_custom_target(${_install_BINPKG}_${_install_SRC_FILENAME}_uninstall
        COMMAND ${CMAKE_COMMAND} -E remove ${_install_DEST}
        COMMENT "-- Uninstalling ${_install_DEST}"
    )
    add_dependencies(${_install_BINPKG}_uninstall
                     ${_install_BINPKG}_${_install_SRC_FILENAME}_uninstall)
endfunction()


# CMake script to install folder in specified path
# This function automatically adds a target to uninstall the folder (in target <BINPKG>_uninstall)
# Parameters of the function:
# - BINPKG: name of the associated BinPkg
# - SRC: source path of the folder to install
# - DEST: destination path of the folder
function(fwInstallDir)
    cmake_parse_arguments(_install "" "BINPKG;SRC;DEST" "" ${ARGN})
    string(REGEX MATCHALL "([^/]+)" _regex_out ${_install_SRC})
    list(REVERSE _regex_out)
    list(GET _regex_out 0 _install_SRC_DIRNAME)

    ExternalProject_Add_Step(${_install_BINPKG} Copy${_install_SRC_DIRNAME}ToInstall
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${_install_SRC} ${_install_DEST}
        COMMENT "-- Installing: ${_install_DEST}"
        DEPENDEES install
    )
    add_custom_target(${_install_BINPKG}_${_install_SRC_DIRNAME}_uninstall
        COMMAND ${CMAKE_COMMAND} -E remove_directory ${_install_DEST}
        COMMENT "-- Uninstalling ${_install_DEST}"
    )
    add_dependencies(${_install_BINPKG}_uninstall
                     ${_install_BINPKG}_${_install_SRC_DIRNAME}_uninstall)
endfunction()
