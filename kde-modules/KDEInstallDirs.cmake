# SPDX-FileCopyrightText: 2021 Volker Krause <vkrause@kde.org>
#
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
KDEInstallDirs
--------------

Compatibility wrapper around :kde-module:`KDEInstallDirs6`.

Since 5.82.0.
#]=======================================================================]

cmake_policy(VERSION 3.16)

include(${CMAKE_CURRENT_LIST_DIR}/../modules/QtVersionOption.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/KDEInstallDirs6.cmake)
