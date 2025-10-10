#   *******************************************************************************
#   
#   mpfw / fw2 - Multi Platform FirmWare FrameWork 
#       
#   Copyright (C) (2023) Marco Dau
#   
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published
#   by the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#   
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#   
#   You should have received a copy of the GNU Affero General Public License
#   along with this program.  If not, see <https://www.gnu.org/licenses/>.
#   
#   You can contact me by the following email address
#   marco <d o t> ing <d o t> dau <a t> gmail <d o t> com
#   
#   *******************************************************************************

### ---------------------------
##
#   step_all_exec.cmake
#
#   Created on: June,  18th 2025  (Wed)
#   Author: Marco Dau
##
### ---------------------------

#### _______________________________________________________________
## *** Section  5 - SET STANDARD PROJECT VARIABLES
    set(EXECUTABLE exec_${APP_NAME_LOWER}.out )

    # specify the C++ standard
    set(CMAKE_CXX_STANDARD 20)
    set(CMAKE_CXX_STANDARD_REQUIRED true)

    ## message(STATUS "TOOLCHAIN - ASM:                  ${CMAKE_ASM_COMPILER}")
    ## message(STATUS "TOOLCHAIN - C:                    ${CMAKE_C_COMPILER}"  )
    ## message(STATUS "TOOLCHAIN - C++:                  ${CMAKE_CXX_COMPILER}")


    #### _______________________________________________________________
    ## *** Section  5.1 - COMMAND BUILD PARAMETERS CHECK

        ## PLATFORM Definitions

            if(NOT DEFINED PLATFORM_NAME)
                message(FATAL_ERROR "NO PLATFORM selected !!!!" )
            else()
                message(STATUS "PLATFORM selected is -->>${PLATFORM_NAME}<<--" )
            endif()

#### _______________________________________________________________
## *** Section  6 - SET SPECIFIC PROJECT VARIABLES

    init_var_macro          (${MODULE_NAME})
    add_subdir_macro        (${MODULE_NAME})
    set_public_dirs_macro   (${MODULE_NAME})

    ## set library files
    set_src_header_files_list_macro (${MODULE_NAME})
    set_src_cpp_files_list_macro    (${MODULE_NAME})

#### _______________________________________________________________
## *** Section  7 - BUILD LIBRARY CONFIGURATION COMMANDS

    add_executable_macro                (${MODULE_NAME})

    set_include_directories_macro       (${MODULE_NAME})
    set_target_link_dir_macro           (${MODULE_NAME})
    set_target_link_lib_macro           (${MODULE_NAME})

    target_link_options(${EXECUTABLE} PRIVATE
        -O3 
        -Wall 
        -Wextra 
        -pedantic 
        -lncurses
    )

