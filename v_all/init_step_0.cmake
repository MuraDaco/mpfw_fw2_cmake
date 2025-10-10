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
#   init_step_0.cmake
#
#   Created on: June, 16th 2025  (Thu)
#   Author: Marco Dau
##
### ---------------------------


#### _______________________________________________________________
## *** Section  1 - SET CMAKE SOFTWARE SOURCE VERSION & CMAKE MODULE DIRECTORY

    ## check and set cmake script source version & set MPFW_CODE_CMAKE_DIR variable
        include(init/cmake_set_src_ver.cmake)
        if(NOT CMAKE_SRC_VER)
            set(CMAKE_SRC_VER       ${CMAKE_SRC_VER_MODULE})
        else()

            if(NOT ${CMAKE_SRC_VER} STREQUAL ${CMAKE_SRC_VER_MODULE})
                message(SEND_ERROR "CMAKE_SRC_VER (${CMAKE_SRC_VER}) variable is already set but is not equal to CMAKE_SRC_VER_MODULE (${CMAKE_SRC_VER_MODULE}) the CMAKE_SRC_VER associated to current module")
            endif()
        endif()

        set(MPFW_CODE_CMAKE_DIR     ${MPFW_CODE_DIR}/cmake/mpfw_fw2_cmake/v_${CMAKE_SRC_VER} )

#### _______________________________________________________________
## *** Section  2 - INCLUDE MACRO & UTILITIES FUNCTIONS
    set(MODULE_PREFIX_UP                MPFW_FW2 )

    include(init/init_module_name.cmake)
    if(NOT ${MODULE_NAME}_SRC_CFG)
        if(SRC_CFG)
            set(${MODULE_NAME}_SRC_CFG ${SRC_CFG})
        else()
            message(FATAL_ERROR "SRC_CFG parameter is missed!! you must set it.")
        endif()
    endif()

    string(TOLOWER  ${MODULE_NAME} MODULE_TYPE_NAME_LW )
    include(init/set_module_names.cmake)

    include(${MPFW_CODE_CMAKE_DIR}/macro/macro_init.cmake)
    include(${MPFW_CODE_CMAKE_DIR}/functions/function_register.cmake)

#### _______________________________________________________________
## *** Section  3 - EXTERNAL LIBRARIES OPTION MANAGEMENT

    if(NOT ${MODULE_NAME}_EXTNL_LIB)
        if(EXTNL_LIB)
            set(${MODULE_NAME}_EXTNL_LIB    ${EXTNL_LIB} )
        else()
            set(${MODULE_NAME}_EXTNL_LIB    N )
        endif()
    endif()

    if(NOT ${CMAKE_SRC_VER} STREQUAL ${CMAKE_SRC_VER_MODULE})
        message(FATAL_ERROR "Current module is ${MODULE_NAME}")
    endif()

#### _______________________________________________________________
## *** Section  4 - SET PROJECT NAME
    set(PROJECT_NAME ${MODULE_TYPE_NAME_LW}_LibraryPrj)
    message(STATUS "Start CMakeLists.txt of -->>${PROJECT_NAME}<<--")


