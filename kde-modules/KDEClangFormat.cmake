# SPDX-FileCopyrightText: 2019 Christoph Cullmann <cullmann@kde.org>
# SPDX-FileCopyrightText: 2021 Alexander Lohnau <alexander.lohnau@gmx.de>
#
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
KDEClangFormat
--------------------

This module provides a functionality to format the source
code of your repository according to a predefined KDE
clang-format file.

This module provides the following function:

::

  kde_clang_format(<files>)

Using this function will create a clang-format target that will format all
``<files>`` passed to the function with the predefined KDE clang-format style.
To format the files you have to invoke the target with ``make clang-format`` or ``ninja clang-format``.
Once the project is formatted it is recommended to enforce the formatting using a pre-commit hook,
this can be done using :kde-module:`KDEGitCommitHooks`.

The ``.clang-format`` file from ECM will be copied to the source directory. This file should not be
added to version control. It is recommended to add it to the ``.gitignore`` file: ``/.clang-format``.

Since 5.79: If the source folder already contains a .clang-format file it is not overwritten.
Since version 5.80 this function is called by default in :kde-module:`KDEFrameworkCompilerSettings`. If directories should be excluded from
the formatting a .clang-format file with ``DisableFormat: true`` and ``SortIncludes: false`` should be created.

Example usage:

.. code-block:: cmake

  include(KDEClangFormat)
  file(GLOB_RECURSE ALL_CLANG_FORMAT_SOURCE_FILES *.cpp *.h *.hpp *.c)
  kde_clang_format(${ALL_CLANG_FORMAT_SOURCE_FILES})

To exclude directories from the formatting add a ``.clang-format``
file in the directory with the following contents:

.. code-block:: yaml

   DisableFormat: true
   SortIncludes: false

Since 5.64
#]=======================================================================]

cmake_policy(VERSION 3.16)

# try to find clang-format in path
find_program(KDE_CLANG_FORMAT_EXECUTABLE clang-format)

# Instantiate our clang-format file in the source directory for tooling if we
# have the tool. Files carrying ECM's generated-file marker are refreshed from
# the central template so all SonicDE repositories share the enforced policy.
# Project-owned files without the marker remain untouched.
if(KDE_CLANG_FORMAT_EXECUTABLE)
    set(CLANG_FORMAT_FILE ${CMAKE_CURRENT_SOURCE_DIR}/.clang-format)
    if (EXISTS ${CLANG_FORMAT_FILE})
        file(READ ${CLANG_FORMAT_FILE} CLANG_FORMAT_CONTENTS LIMIT 1000)
        string(FIND "${CLANG_FORMAT_CONTENTS}" "This file got automatically created by ECM, do not edit" matchres)
        if(${matchres} EQUAL -1)
            message(DEBUG "Using existing .clang-format file provided by project.")
        else()
            configure_file(${CMAKE_CURRENT_LIST_DIR}/clang-format.cmake ${CLANG_FORMAT_FILE} @ONLY)
        endif()
    else()
        configure_file(${CMAKE_CURRENT_LIST_DIR}/clang-format.cmake ${CLANG_FORMAT_FILE} @ONLY)
    endif()
endif()

# formatting target
function(KDE_CLANG_FORMAT)
    if (TARGET clang-format)
        # We can only define one clang-format target
        return()
    endif()

    # add target without specific commands first, we add the real calls file-per-file to avoid command line length issues and enable parallelization
    add_custom_target(clang-format COMMENT "Formatting sources in ${CMAKE_CURRENT_SOURCE_DIR} with ${KDE_CLANG_FORMAT_EXECUTABLE}...")

    # run clang-format only if available, else signal the user what is missing
    if(KDE_CLANG_FORMAT_EXECUTABLE)
        get_filename_component(_binary_dir ${CMAKE_BINARY_DIR} REALPATH)
        set(_ci_install_dir "${CMAKE_SOURCE_DIR}/_install") # on the KDE-CI, we install dependencies in-source
        foreach(_file ${ARGV})
            # check if the file is inside the build directory => ignore such files
            get_filename_component(_full_file_path ${_file} REALPATH)
            string(FIND ${_full_file_path} ${_binary_dir} _binary_idx)
            string(FIND ${_full_file_path} ${_ci_install_dir} _dependency_idx)
            if(NOT _binary_idx EQUAL 0 AND NOT _dependency_idx EQUAL 0)
                # Use a bounded hash rather than embedding the entire relative
                # path in the target name. Generated/autogen paths can be very
                # long and CMake appends its own suffixes when creating files
                # under CMakeFiles/, exceeding common filesystem name limits.
                string(SHA256 _file_hash "${_full_file_path}")
                string(SUBSTRING "${_file_hash}" 0 20 _file_hash)
                get_filename_component(_file_name "${_file}" NAME_WE)
                string(REGEX REPLACE "[^A-Za-z0-9_.+-]" "_" _file_name "${_file_name}")
                string(SUBSTRING "${_file_name}" 0 32 _file_name)
                set(unique_target_name "clang-format-${_file_name}-${_file_hash}")
                add_custom_target(${unique_target_name}
                    DEPENDS ${_full_file_path}
                )
                add_custom_command(TARGET ${unique_target_name}
                    POST_BUILD
                    COMMAND ${KDE_CLANG_FORMAT_EXECUTABLE} -style=file -i ${_full_file_path}
                    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                )
                add_dependencies(clang-format ${unique_target_name})
            endif()
        endforeach()
    else()
        add_custom_command(TARGET clang-format
            COMMAND
                POST_BUILD
                ${CMAKE_COMMAND} -E echo "Could not set up the clang-format target as the clang-format executable is missing."
            )
    endif()
endfunction()
