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
#   set_public_rpath.cmake
#
#   Created on: May, 23rd 2025  (Fri)
#   Author: Marco Dau
##
### ---------------------------

##trace_execution()

if(set_public_rpaths_${type_name_up}_guard)
    ## message("DEBUG - CUSTOM set_public_rpaths_include_guard() of ${type_name_up}")
    return()
endif()
set(set_public_rpaths_${type_name_up}_guard       ON)


message(STATUS "Start set_public_rpath of -->> ${type_name_up} <<--")

### **************************************************
### --- set ..._<module name>_ROOT_RPATH variables
## --- start section

    set(${type_name_up}_ROOT_RPATH              ${${type_name_up}_INIT_RURL} )

    ## --- end section
    ### **************************************************

### **************************************************
### --- set ..._<module name>_WSP_RPATH variables
## --- start section

    set(WSP_RPATH   wsp/v_${${type_name_up}_WSP_VER}/cmake )

    set(${type_name_up}_cmmn_WSP_RPATH             ${${type_name_up}_cmmn_ROOT_RPATH}/${WSP_RPATH} )
    set(${type_name_up}_WSP_RPATH               ${${type_name_up}_cmmn_ROOT_RPATH}/${WSP_RPATH} )
    foreach(item IN LISTS ${type_name_up}_TRDP_FNCT_LIST)
        set(${type_name_up}_${item}_WSP_RPATH             ${${type_name_up}_${item}_ROOT_RPATH}/${WSP_RPATH} )
    endforeach()

    ## --- end section
    ### **************************************************

### **************************************************
### --- set ..._<module name>_BUILD_EXT_RPATH variables
## --- start section

    set(${type_name_up}_BUILD_EXT_RPATH               ${${type_name_up}_cmmn_ROOT_RPATH}/build_main/${PLATFORM_NAME} )
    set(${type_name_up}_BUILD_RPATH                   ${${type_name_up}_cmmn_ROOT_RPATH}/build/${PLATFORM_NAME} )

    ## --- end section
    ### **************************************************

### **************************************************
### --- set ..._<module name>_SRC_RPATH variables
## --- start section

    set(${type_name_up}_cmmn_SRC_RPATH             ${${type_name_up}_cmmn_ROOT_RPATH}/src )
    set(${type_name_up}_SRC_RPATH               ${${type_name_up}_cmmn_ROOT_RPATH}/src )
    foreach(item IN LISTS ${type_name_up}_TRDP_FNCT_LIST)
        set(${type_name_up}_${item}_SRC_RPATH             ${${type_name_up}_${item}_ROOT_RPATH}/src )
    endforeach()

    ## --- end section
    ### **************************************************

### **************************************************
### --- set ..._<module name>_INCLUDE_RPATH variables
## --- start section

    set(${type_name_up}_cmmn_INCLUDE_RPATH          ${${type_name_up}_cmmn_WSP_RPATH} )
    set(${type_name_up}_INCLUDE_RPATH           ${${type_name_up}_cmmn_WSP_RPATH} )
    foreach(item IN LISTS ${type_name_up}_TRDP_FNCT_LIST)
        set(${type_name_up}_${item}_INCLUDE_RPATH             ${${type_name_up}_${item}_WSP_RPATH} )
    endforeach()

    ## --- end section
    ### **************************************************


##end_include()
