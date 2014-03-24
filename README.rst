VP Binpkgs
==========

About
-----

VP Binpkgs are the dependencies necessary to build the VP applications.
They need to be built in order to compile anything from VP.

Requirements
------------


Build steps
-----------

* Get the sources from the repository. If you read this README, you should know how to do it
* Create a dir and cd in it
* do a

.. code-block:: bash

    $ cmake -DCMAKE_BUILD_TYPE=<build_type> -DCMAKE_INSTALL_PREFIX=<install_prefix>

With

    * <build_type> being Debug or Release as used by cmake
    * <install_prefix> being a directory where all libs and exe from the binpkgs will be installed (better to be a personnal folder right now, don't use /usr/local or other)

* do a

.. code-block:: bash

    $ make itk json-spirit camp dcmtk hdf5 ann cryptopp -j <number of parallel compilation tasks to run>

Use from VP
-----------

When compiling VP applications, in the cmake, you should inform that the binpkgs are available in their <install_prefix> defined in the `build steps`_
