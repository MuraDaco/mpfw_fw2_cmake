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
#   set_public_dirs.cmake
#
#   Created on: May, 23rd 2025  (Fri)
#   Author: Marco Dau
##
### ---------------------------

##trace_execution()

if(set_public_dirs_${type_name_up}_guard)
    message("DEBUG - CUSTOM include_guard() of ${type_name_up}")
    return()
endif()
set(set_public_dirs_${type_name_up}_guard       ON)

### **************************************************
### --- set ..._<module name>_ROOT_DIR variables
## --- start section

    set(${type_name_up}_ROOT_DIR              ${MPFW_CODE_DIR}/${${type_name_up}_ROOT_RPATH} )
    if(NOT ${type_name_up}_LAYER_UP )
        set(${type_name_up}_0ABST_ROOT_DIR        ${MPFW_CODE_DIR}/${${type_name_up}_0ABST_ROOT_RPATH} )
        set(${type_name_up}_4APPL_ROOT_DIR        ${MPFW_CODE_DIR}/${${type_name_up}_4APPL_ROOT_RPATH} )
    endif()

    ## --- end section
    ### **************************************************

### **************************************************
### --- set ..._<module name>_WSP_DIR variables
## --- start section

    set(${type_name_up}_WSP_DIR                 ${MPFW_CODE_DIR}/${${type_name_up}_WSP_RPATH} )
    if(${type_name_up}_PLATFORM )
        set(${type_name_up}_WSP_CMMN_DIR          ${MPFW_CODE_DIR}/${${type_name_up}_WSP_CMMN_RPATH} )
        set(${type_name_up}_WSP_PLTF_DIR          ${MPFW_CODE_DIR}/${${type_name_up}_WSP_PLTF_RPATH} )
        set(${type_name_up}_WSP_DIR               ${${type_name_up}_WSP_PLTF_DIR} )
    endif()
    if(NOT ${type_name_up}_LAYER_UP )
        set(${type_name_up}_0ABST_WSP_DIR         ${MPFW_CODE_DIR}/${${type_name_up}_0ABST_WSP_RPATH} )
        set(${type_name_up}_4APPL_WSP_DIR         ${MPFW_CODE_DIR}/${${type_name_up}_4APPL_WSP_RPATH} )
    endif()

    ## --- end section
    ### **************************************************

### **************************************************
### --- set ..._<module name>_SRC_DIR variables
## --- start section

    set(${type_name_up}_SRC_DIR               ${MPFW_CODE_DIR}/${${type_name_up}_SRC_RPATH} )
    if(${type_name_up}_PLATFORM )
        set(${type_name_up}_SRC_CMMN_DIR           ${MPFW_CODE_DIR}/${${type_name_up}_SRC_CMMN_RPATH} )
        set(${type_name_up}_SRC_PLTF_DIR           ${MPFW_CODE_DIR}/${${type_name_up}_SRC_PLTF_RPATH} )
        set(${type_name_up}_SRC_DIR                ${MPFW_CODE_DIR}/${${type_name_up}_SRC_RPATH} )
    endif()
    if(NOT ${type_name_up}_LAYER_UP )
        set(${type_name_up}_0ABST_SRC_DIR         ${MPFW_CODE_DIR}/${${type_name_up}_0ABST_SRC_RPATH} )
        set(${type_name_up}_4APPL_SRC_DIR         ${MPFW_CODE_DIR}/${${type_name_up}_4APPL_SRC_RPATH} )
    endif()

    ## --- end section
    ### **************************************************

### **************************************************
### --- set ..._<module name>_INCLUDE_DIR variables
## --- start section

    set(MPFW_FW2_${type_name_up}_INCLUDE_DIR          ${MPFW_CODE_DIR}/${MPFW_FW2_${type_name_up}_INCLUDE_RPATH}          )
    if(NOT ${type_name_up}_LAYER_UP)
        set(MPFW_FW2_${type_name_up}_0ABST_INCLUDE_DIR    ${MPFW_CODE_DIR}/${MPFW_FW2_${type_name_up}_0ABST_INCLUDE_RPATH}    )
        set(MPFW_FW2_${type_name_up}_4APPL_INCLUDE_DIR    ${MPFW_CODE_DIR}/${MPFW_FW2_${type_name_up}_4APPL_INCLUDE_RPATH}    )
    endif()

    ## --- end section
    ### **************************************************

### **************************************************
### --- set ..._<module name>_CONFIG_DIR variable
## --- start section

    ## my own config file

    ## other's config files

    ## --- end section
    ### **************************************************

##end_include()
