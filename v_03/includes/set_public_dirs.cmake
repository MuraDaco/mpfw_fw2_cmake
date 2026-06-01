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
    ## message("DEBUG - CUSTOM include_guard() of ${type_name_up}")
    return()
endif()
set(set_public_dirs_${type_name_up}_guard       ON)

### **************************************************
### --- set ..._<module name>_ROOT_DIR variables
## --- start section

    set(${type_name_up}_ROOT_DIR              ${MPFW_CODE_DIR}/${${type_name_up}_ROOT_RPATH} )

    set(${type_name_up}_cmmn_ROOT_DIR             ${MPFW_CODE_DIR}/${${type_name_up}_cmmn_ROOT_RPATH} )
    set(${type_name_up}_ROOT_DIR                ${MPFW_CODE_DIR}/${${type_name_up}_cmmn_ROOT_RPATH} )
    foreach(item IN LISTS ${type_name_up}_TRDP_FNCT_LIST)
        set(${type_name_up}_${item}_ROOT_DIR            ${MPFW_CODE_DIR}/${${type_name_up}_${item}_ROOT_RPATH} )
    endforeach()


    ## --- end section
    ### **************************************************

### **************************************************
### --- set ..._<module name>_WSP_DIR variables
## --- start section

    set(${type_name_up}_cmmn_WSP_DIR             ${MPFW_CODE_DIR}/${${type_name_up}_cmmn_WSP_RPATH} )
    set(${type_name_up}_WSP_DIR                 ${MPFW_CODE_DIR}/${${type_name_up}_cmmn_WSP_RPATH} )
    foreach(item IN LISTS ${type_name_up}_TRDP_FNCT_LIST)
        set(${type_name_up}_${item}_WSP_DIR            ${MPFW_CODE_DIR}/${${type_name_up}_${item}_WSP_RPATH} )
    endforeach()

    ## --- end section
    ### **************************************************

### **************************************************
### --- set ..._<module name>_SRC_DIR variables
## --- start section

    set(${type_name_up}_cmmn_SRC_DIR             ${MPFW_CODE_DIR}/${${type_name_up}_cmmn_SRC_RPATH} )
    set(${type_name_up}_SRC_DIR             ${MPFW_CODE_DIR}/${${type_name_up}_cmmn_SRC_RPATH} )
    foreach(item IN LISTS ${type_name_up}_TRDP_FNCT_LIST)
        set(${type_name_up}_${item}_SRC_DIR            ${MPFW_CODE_DIR}/${${type_name_up}_${item}_SRC_RPATH} )
    endforeach()

    ## --- end section
    ### **************************************************

### **************************************************
### --- set ..._<module name>_INCLUDE_DIR variables
## --- start section

    set(${type_name_up}_cmmn_INCLUDE_DIR          ${MPFW_CODE_DIR}/${${type_name_up}_cmmn_INCLUDE_RPATH}          )
    set(${type_name_up}_INCLUDE_DIR          ${MPFW_CODE_DIR}/${${type_name_up}_cmmn_INCLUDE_RPATH}          )
    ## message("DEBUG - set_public_dirs.cmake - ${type_name_up}_cmmn_INCLUDE_DIR: ${${type_name_up}_cmmn_INCLUDE_DIR}")
    foreach(item IN LISTS ${type_name_up}_TRDP_FNCT_LIST)
        set(${type_name_up}_${item}_INCLUDE_DIR            ${MPFW_CODE_DIR}/${${type_name_up}_${item}_INCLUDE_RPATH} )
        ## message("DEBUG - set_public_dirs.cmake - ${type_name_up}_${item}_INCLUDE_DIR: ${${type_name_up}_${item}_INCLUDE_DIR}")
    endforeach()
    
    ## message(FATAL_ERROR "DEBUG - set_public_dirs.cmake - EXIT TEST")

    ## --- end section
    ### **************************************************


##end_include()
