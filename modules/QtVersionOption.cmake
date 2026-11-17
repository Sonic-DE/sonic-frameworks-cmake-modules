# SPDX-FileCopyrightText: 2021 Volker Krause <vkrause@kde.org>
#
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
QtVersionOption
---------------

Defines ``QT_MAJOR_VERSION`` for modules that need to know the major Qt version.
SonicDE builds only against Qt 6, so it is always "6"; any other value set by
the caller is an error.

Since 5.82.0.
#]=======================================================================]

cmake_policy(VERSION 3.16)

if (DEFINED QT_MAJOR_VERSION AND NOT QT_MAJOR_VERSION STREQUAL "6")
    message(FATAL_ERROR "QT_MAJOR_VERSION is ${QT_MAJOR_VERSION}; only Qt 6 is supported")
endif()

set(QT_MAJOR_VERSION 6)
