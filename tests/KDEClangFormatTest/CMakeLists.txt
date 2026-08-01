cmake_minimum_required(VERSION 3.16)
project(KDEClangFormatTest LANGUAGES CXX)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../kde-modules")
include(KDEClangFormat)

kde_clang_format(main.cpp)
