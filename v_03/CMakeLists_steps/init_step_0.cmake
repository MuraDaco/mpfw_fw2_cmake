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
## *** Section  0 - INCLUDE MACRO & UTILITIES FUNCTIONS

    include(${MPFW_CODE_CMAKE_DIR}/macro/macro_init.cmake)

    ## check the CMAKE_SRC_VER
        check_CMAKE_SRC_VER()

    ## determine MPFW_CODE_DIR
        init_MPFW_CODE_DIR()

    ## determine MPFW_CODE_DIR_FROM_BUILD
        init_MPFW_CODE_DIR_FROM_BUILD()

    ## determine module names
        string(REGEX REPLACE "^/" "" OCCURENCE_TEST ${SUBSTRING_current_source_RPATH} )
        parsing_rpath_2(${OCCURENCE_TEST})

        set(MODULE_NAME                 ${TMP_MODULE_NAME} )
        set(${MODULE_NAME}_WSP_VER      ${SUBSTRING_CMakeLists_version} )

        ## message("DEBUG - STEP 0 - MODULE_NAME:     ${MODULE_NAME}")
        ## message("DEBUG - STEP 0 - ${MODULE_NAME}_WSP_VER:     ${${MODULE_NAME}_WSP_VER}")

    ## determine APP_NAME

        if(${MODULE_NAME}_TYPE_UP STREQUAL "MAIN")
            if(APP_NAME)
                string(TOUPPER ${APP_NAME} APP_NAME_UPPER )
                string(TOLOWER ${APP_NAME} APP_NAME_LOWER )
            else()
                message(FATAL_ERROR "\"APP_NAME\" build parameter is not set " )
            endif()
        endif()

        if(${MODULE_NAME}_TYPE_UP STREQUAL "APPL")
            if(APP_NAME)
                ## CMakeLists.txt is called by "main" module and "APP_NAME" is set as build parameter
                ## check APP_NAME: it must be equal to ${MODULE_NAME}_0NAME_UP
                string(TOLOWER "${${MODULE_NAME}_0NAME_UP}" ${MODULE_NAME}_0NAME_LW)
                if(NOT APP_NAME STREQUAL "${${MODULE_NAME}_0NAME_LW}")
                    message(FATAL_ERROR "\"APP_NAME\" (${APP_NAME}) build parameter is not equal to \"${MODULE_NAME}_0NAME_LW\" (${${MODULE_NAME}_0NAME_LW}) parameter " )
                endif()
            else()
                ## CMakeLists.txt is called by the user via cmake build command
                string(TOLOWER ${${MODULE_NAME}_0NAME_UP} APP_NAME)
                string(TOUPPER ${APP_NAME} APP_NAME_UPPER )
                string(TOLOWER ${APP_NAME} APP_NAME_LOWER )
            endif()
        endif()

        message("DEBUG - STEP 1 - APP_NAME:           ${APP_NAME}")
        message("DEBUG - STEP 1 - APP_NAME_UPPER:     ${APP_NAME_UPPER}")
        message("DEBUG - STEP 1 - APP_NAME_LOWER:     ${APP_NAME_LOWER}")

        ## message(FATAL_ERROR "DEBUG - STEP 0")


#### _______________________________________________________________
## *** Section  2 - INCLUDE MACRO & UTILITIES FUNCTIONS
    set(MODULE_PREFIX_UP                MPFW_FW2 )

    ## OK - if(EXISTS "../cmake/init/init_module_name.cmake" )
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/init/init_module_name.cmake" )
        include(init/init_module_name.cmake)
    endif()

    if(NOT ${MODULE_NAME}_SRC_CFG)
        if(SRC_CFG)
            set(${MODULE_NAME}_SRC_CFG ${SRC_CFG})
        else()
            message(FATAL_ERROR "SRC_CFG parameter is missed!! you must set it.")
        endif()
    endif()

    string(TOLOWER  ${MODULE_NAME} MODULE_TYPE_NAME_LW )
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/init/set_module_names.cmake" )
        include(init/set_module_names.cmake)
    endif()

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

#### _______________________________________________________________
## *** Section  4 - SET PROJECT NAME
    set(PROJECT_NAME ${MODULE_TYPE_NAME_LW}_LibraryPrj)
    message(STATUS "Start CMakeLists.txt of -->>${PROJECT_NAME}<<--")


