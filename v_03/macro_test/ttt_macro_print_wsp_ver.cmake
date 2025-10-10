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
#   macro_print_wsp_ver.cmake
#
#   Created on: June,  2nd 2025  (Mon)
#   Author: Marco Dau
##
### ---------------------------

include_guard()

macro(print_wsp_ver_macro)
    include(${MPFW_CODE_CMAKE_DIR}/functions/function_indent.cmake)

    set_indent_begin()

    if(FNCT_${MODULE_NAME}_WSP_VER)
        message("${INDENT_STRING}- FNCT_${MODULE_NAME}_WSP_VER: ........ ${FNCT_${MODULE_NAME}_WSP_VER}" )
        ## set dependencies list: "MODULE_NAME" is updated to dependencies module name
        include(${MPFW_CODE_DIR}/${FNCT_${MODULE_NAME}_INIT_RURL}/set_dependencies_list.cmake)
    else()
        string(LENGTH ${CMAKE_CURRENT_SOURCE_DIR} CUR_DIR_LENGTH )
        math(EXPR VER_POSITION "${CUR_DIR_LENGTH}-2")    
        string(SUBSTRING ${CMAKE_CURRENT_SOURCE_DIR} ${VER_POSITION} 2 FNCT_${MODULE_NAME}_WSP_VER )

        message("${INDENT_STRING}- FNCT_${MODULE_NAME}_WSP_VER: ........ ${FNCT_${MODULE_NAME}_WSP_VER}" )
        ## set dependencies list
        ##include(${MPFW_CODE_DIR}/${FNCT_${MODULE_NAME}_INIT_RURL}/set_dependencies_list.cmake)
        include(init/set_dependencies_list.cmake)
    endif()

    ## "MODULE_NAME" is updated to dependencies module name
    block()
        foreach(X IN LISTS FNCT_${MODULE_NAME}_DEPS_LIST)
            set(MODULE_NAME     ${X})
            include(${MPFW_CODE_DIR}/${FNCT_${MODULE_NAME}_INIT_RURL}/print_wsp_config.cmake)
        endforeach()

    endblock()

    set_indent_end()
endmacro()