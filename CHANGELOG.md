# fw4spl-deps 17.2.0

## Bug fixes:

### gdcm

*Update and fix GDCMwriter leak.*

GDCM has been updated to v2.8.7 which allows removing some of our patches. A memory leak has been fixed in the GDCM `Writer` class, and [the patch was submitted upstream](https://github.com/malaterre/GDCM/pull/54).

## Refactor:

### FreeImage

*Remove dependency.*

## New features:

### glm

*Update to version 0.9.9.0.*

Update glm version to 0.9.9.0 (fixes compilation with gcc 7 on Linux)

### Ogre

*Update Ogre to version 1.11.*

Updates Ogre to version 1.11 with a new custom color mask feature ([accepted in the main repo](https://github.com/OGRECave/ogre/pull/811)).

Cleans up the script by removing useless variables and disabling unused components.

Fixes the zlib hack on windows so we don't end up with two zlibs which breaks `FindZLib.cmake`.




# fw4spl-deps 17.1.0

## Bug fixes:

### ogre

*Disable python component build.*

## New features:

### boost

*Update boost to version 1.67.*

Previous boost 1.65 with newer apple clang seems to be unstable with serialization.

## Refactor:

### CMakeLists.txt

*Move RealSense and VLC to fw4spl-ar.*




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


