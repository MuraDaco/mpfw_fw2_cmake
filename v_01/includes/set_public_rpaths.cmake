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
    message("DEBUG - CUSTOM set_public_rpaths_include_guard() of ${type_name_up}")
    return()
endif()
set(set_public_rpaths_${type_name_up}_guard       ON)


message(STATUS "Start set_public_rpath of -->> ${type_name_up} <<--")

### **************************************************
### --- set ..._<module name>_ROOT_RPATH variables
## --- start section

    if(${type_name_up}_LAYER_UP)
        set(${type_name_up}_ROOT_RPATH              ${rpath_mod}/${name_lw}/layer/${complete_name_lw} )
    else()
        set(${type_name_up}_ROOT_RPATH              ${rpath_mod}/${name_lw}/${complete_name_lw} )
        set(${type_name_up}_0ABST_ROOT_RPATH        ${${type_name_up}_ROOT_RPATH}/layer/0abst )
        set(${type_name_up}_4APPL_ROOT_RPATH        ${${type_name_up}_ROOT_RPATH}/layer/4appl )
    endif()

    ## --- end section
    ### **************************************************

### **************************************************
### --- set ..._<module name>_WSP_RPATH variables
## --- start section

    set(${type_name_up}_WSP_RPATH             ${${type_name_up}_ROOT_RPATH}/wsp/cmake/v_${${type_name_up}_WSP_VER} )
    if(${type_name_up}_PLATFORM)
        set(${type_name_up}_WSP_CMMN_RPATH          ${${type_name_up}_ROOT_RPATH}/common/wsp/cmake/v_${${type_name_up}_WSP_VER} )
        set(${type_name_up}_WSP_PLTF_RPATH          ${${type_name_up}_ROOT_RPATH}/platform/${PLATFORM_NAME}/wsp/cmake/v_${${type_name_up}_WSP_VER} )
        set(${type_name_up}_WSP_RPATH               ${${type_name_up}_WSP_PLTF_RPATH} )
    endif()
    if(NOT ${type_name_up}_LAYER_UP)
        set(${type_name_up}_0ABST_WSP_RPATH       ${${type_name_up}_0ABST_ROOT_RPATH}/wsp/cmake/v_${${type_name_up}_WSP_VER} )
        set(${type_name_up}_4APPL_WSP_RPATH       ${${type_name_up}_4APPL_ROOT_RPATH}/wsp/cmake/v_${${type_name_up}_WSP_VER} )
    endif()

    ## --- end section
    ### **************************************************

### **************************************************
### --- set ..._<module name>_BUILD_EXT_RPATH variables
## --- start section


    set(${type_name_up}_BUILD_EXT_RPATH               ${${type_name_up}_ROOT_RPATH}/build_main/${PLATFORM_NAME} )
    set(${type_name_up}_BUILD_RPATH                   ${${type_name_up}_ROOT_RPATH}/build/${PLATFORM_NAME} )
    if(${type_name_up}_PLATFORM)
        set(${type_name_up}_BUILD_EXT_PLTF_RPATH        ${${type_name_up}_ROOT_RPATH}/platform/${PLATFORM_NAME}/build_main/${PLATFORM_NAME} )
        set(${type_name_up}_BUILD_EXT_RPATH             ${${type_name_up}_BUILD_EXT_PLTF_RPATH} )
        set(${type_name_up}_BUILD_PLTF_RPATH            ${${type_name_up}_ROOT_RPATH}/platform/${PLATFORM_NAME}/build/${PLATFORM_NAME} )
        set(${type_name_up}_BUILD_RPATH                 ${${type_name_up}_BUILD_PLTF_RPATH} )
    endif()
    ## --- end section
    ### **************************************************

### **************************************************
### --- set ..._<module name>_SRC_RPATH variables
## --- start section

    set(${type_name_up}_SRC_RPATH             ${${type_name_up}_ROOT_RPATH}/src )
    if(${type_name_up}_PLATFORM)
        set(${type_name_up}_SRC_CMMN_RPATH     ${${type_name_up}_ROOT_RPATH}/common/src )
        set(${type_name_up}_SRC_PLTF_RPATH     ${${type_name_up}_ROOT_RPATH}/platform/${PLATFORM_NAME}/src )
        set(${type_name_up}_SRC_RPATH          ${${type_name_up}_SRC_PLTF_RPATH} )
    endif()
    if(NOT ${type_name_up}_LAYER_UP)
        set(${type_name_up}_0ABST_SRC_RPATH       ${${type_name_up}_0ABST_ROOT_RPATH}/src )
        set(${type_name_up}_4APPL_SRC_RPATH       ${${type_name_up}_4APPL_ROOT_RPATH}/src )
    endif()

    ## --- end section
    ### **************************************************

### **************************************************
### --- set ..._<module name>_INCLUDE_RPATH variables
## --- start section

    set(MPFW_FW2_${type_name_up}_INCLUDE_RPATH          ${${type_name_up}_WSP_RPATH} )
    if(${type_name_up}_PLATFORM)
        set(MPFW_FW2_${type_name_up}_INCLUDE_CMMN_RPATH     ${${type_name_up}_WSP_CMMN_RPATH} )
        set(MPFW_FW2_${type_name_up}_INCLUDE_PLTF_RPATH     ${${type_name_up}_WSP_PLTF_RPATH} )
        set(MPFW_FW2_${type_name_up}_INCLUDE_RPATH          ${MPFW_FW2_${type_name_up}_INCLUDE_PLTF_RPATH} )

    endif()
    if(NOT ${type_name_up}_LAYER_UP)
        set(MPFW_FW2_${type_name_up}_0ABST_INCLUDE_RPATH    ${${type_name_up}_0ABST_WSP_RPATH} )
        set(MPFW_FW2_${type_name_up}_4APPL_INCLUDE_RPATH    ${${type_name_up}_4APPL_WSP_RPATH} )
    endif()

    ## --- end section
    ### **************************************************

### **************************************************
### --- set ..._<module name>_CONFIG_RPATH variable
## --- start section

    ## my own config file

    ## other's config files

    ## --- end section
    ### **************************************************

##end_include()
