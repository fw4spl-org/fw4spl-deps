# fw4spl-deps 17.0.0

## Bug fixes:

### CMakeLists.txt

*Change the extension of the repo file.*

We don't want deps and src repositories to be mixed together... So we now use a different auto discovery extension file.

### libSGM

*Gate behind ENABLE_EXTRAS, don't build and warn if CUDA is disabled.*

## New features:

### CMakeLists.txt

*Add discovery of additional repositories.*

Setting the CMake variable ADDITIONAL_DEPS was tedious and error-prone. Now we explore the folders at the same level of FW4SPL to find extra repositories. Then a CMake option, set to ON by default, is proposed to enable/disable the repository. This will make CMake configuration phase easier than ever !

### qt

*Update to 5.9.5 LTS.*

## Refactor:

### CMakeLists.txt

*Always expose ENABLE_OGRE and ENABLE_EXTRAS.*

ENABLE_OGRE no longer requires ENABLE_AR to be on. ENABLE_EXTRAS no longer requires ENABLE_AR and ENABLE_OGRE

### CMakeLists.txt

*Simplify deps options and reorganize deps.*

We now have an option for each additional repository that gather all
required dependencies. So we introduce:
- ENABLE_AR
- ENABLE_OGRE
- ENABLE_EXTRAS

To achieve this we move some dependencies. cgogn, cryptopp, orbslam2 and
vlc are promoted to fw4spl-deps. These dependencies are used widely so
this seems reasonable. Now ext-deps only contains aram and ndkgui, so
really experimental deps, making it useless for most people.

Some obsolete deps are cleand:
- ann
- curl

We keep two packages options for SOFA and PTAM as people do not always
want them.


