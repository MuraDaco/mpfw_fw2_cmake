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
#   macro_set_wsp_ver.cmake
#
#   Created on: June,  4th 2025  (Wed)
#   Author: Marco Dau
##
### ---------------------------

include_guard()

## macro(set_wsp_ver_macro LIST_NAME)
##     foreach(X IN LISTS ${LIST_NAME})
##         math(EXPR ROW_LIST "${ID_LIST} / 3")
##         math(EXPR COL_LIST "${ID_LIST} % 3")
##         ## message("X=${X} - ${ROW_LIST} - ${COL_LIST}")
##         if(COL_LIST EQUAL 0)
##             set(name    ${X})
##             ## message("set name")
##         endif()
##         if(COL_LIST EQUAL 1)
##             set(FNCT_${name}_WSP_VER    ${X})
##             message("FNCT_${name}_WSP_VER: .... ${FNCT_${name}_WSP_VER}")
##         endif()
##         if(COL_LIST EQUAL 2)
##             set(FNCT_${name}_SRC_CFG    ${X})
##             message("FNCT_${name}_SRC_CFG: .... ${FNCT_${name}_SRC_CFG}")
##         endif()
##         math(EXPR ID_LIST "${ID_LIST} + 1")
##     endforeach()
## endmacro()

function(recursive_test)
    block()

        math(EXPR COUNTER "2*${COUNTER} + 1")
        if(COUNTER LESS_EQUAL 100)
            message("INFO-TEST_RECURSVIE -> STEP BEFORE -> COUNTER: ${COUNTER}")
            recursive_test()
            message("INFO-TEST_RECURSVIE -> STEP AFTER  -> COUNTER: ${COUNTER}")
        endif()

        return(PROPAGATE COUNTER)
    endblock()
endfunction()

function(propagation_test)
    block()
        set(VAR_PLUTO topo_LINO)
        return(PROPAGATE VAR_PLUTO)
    endblock()
endfunction()

function(set_wsp_ver_macro LIST_NAME)
    block()
        set(ID_LIST     0)
        foreach(X IN LISTS ${LIST_NAME})
            math(EXPR ROW_LIST "${ID_LIST} / 3")
            math(EXPR COL_LIST "${ID_LIST} % 3")
            ## message("X=${X} - ${ROW_LIST} - ${COL_LIST}")
            if(COL_LIST EQUAL 0)
                set(name    ${X})
                ## message("set name")
            endif()
            if(COL_LIST EQUAL 1)
                set(FNCT_${name}_WSP_VER    ${X})
                message("FNCT_${name}_WSP_VER: .... ${FNCT_${name}_WSP_VER}")
            endif()
            if(COL_LIST EQUAL 2)
                set(FNCT_${name}_SRC_CFG    ${X})
                message("FNCT_${name}_SRC_CFG: .... ${FNCT_${name}_SRC_CFG}")
                set(VAR_PROPAGATION_LIST        ${VAR_PROPAGATION_LIST} FNCT_${name}_WSP_VER FNCT_${name}_SRC_CFG)
            endif()
            math(EXPR ID_LIST "${ID_LIST} + 1")
        endforeach()

        return(PROPAGATE VAR_PROPAGATION_LIST ${VAR_PROPAGATION_LIST} )
    endblock()
endfunction()

macro(print_wsp_ver_macro LIST_NAME)
    block()
        set(ID_LIST     0)
        foreach(X IN LISTS ${LIST_NAME})
            math(EXPR ROW_LIST "${ID_LIST} / 3")
            math(EXPR COL_LIST "${ID_LIST} % 3")
            ## message("X=${X} - ${ROW_LIST} - ${COL_LIST}")
            if(COL_LIST EQUAL 0)
                set(name    ${X})
                message("FNCT_${name}_WSP_VER: .... ${FNCT_${name}_WSP_VER}")
                message("FNCT_${name}_SRC_CFG: .... ${FNCT_${name}_SRC_CFG}")
                message(".................")
            endif()
            if(COL_LIST EQUAL 1)
                ## set(FNCT_${name}_WSP_VER    ${X})
                ## message("FNCT_${name}_WSP_VER: .... ${FNCT_${name}_WSP_VER}")
            endif()
            if(COL_LIST EQUAL 2)
                ## set(FNCT_${name}_SRC_CFG    ${X})
                ## message("FNCT_${name}_SRC_CFG: .... ${FNCT_${name}_SRC_CFG}")
            endif()
            math(EXPR ID_LIST "${ID_LIST} + 1")
        endforeach()

    endblock()
endmacro()


function(set_wsp_ver_funct MOD_NAME)
    block()
        ## message("RECURSIVE_DEBUG --- start function with ${MOD_NAME} module name")
        include(${MPFW_CODE_CMAKE_DIR}/rurls/set_modules_rurl.cmake)
        include(${MPFW_CODE_DIR}/${FNCT_${MOD_NAME}_INIT_RURL}/../../c_${FNCT_${MOD_NAME}_SRC_CFG}/set_src_ver.cmake)
        include(${MPFW_CODE_DIR}/${FNCT_${MOD_NAME}_INIT_RURL}/set_dependencies_list.cmake)
        set(ID_LIST     0)
        foreach(X IN LISTS FNCT_${MOD_NAME}_DEPS_LIST)
            math(EXPR ROW_LIST "${ID_LIST} / 3")
            math(EXPR COL_LIST "${ID_LIST} % 3")
            ## message("X=${X} - ${ROW_LIST} - ${COL_LIST}")
            if(COL_LIST EQUAL 0)
                set(name    ${X})
                ## message("set name")
                set(FNCT_${MOD_NAME}_DEPS_NAME_LIST      ${FNCT_${MOD_NAME}_DEPS_NAME_LIST} ${name})
            endif()
            if(COL_LIST EQUAL 1)
                set(FNCT_${name}_WSP_VER    ${X})
                ## message("FNCT_${name}_WSP_VER: ---- ${FNCT_${name}_WSP_VER}")
            endif()
            if(COL_LIST EQUAL 2)
                set(FNCT_${name}_SRC_CFG    ${X})
                ## message("FNCT_${name}_SRC_CFG: ---- ${FNCT_${name}_SRC_CFG}")
                set(VAR_PROPAGATION_LIST        ${VAR_PROPAGATION_LIST} 
                    FNCT_${name}_WSP_VER
                    FNCT_${name}_SRC_CFG
                )
                include(${MPFW_CODE_CMAKE_DIR}/rurls/set_modules_rurl.cmake)
                include(${MPFW_CODE_DIR}/${FNCT_${name}_INIT_RURL}/../../c_${FNCT_${name}_SRC_CFG}/set_src_ver.cmake)
            endif()
            math(EXPR ID_LIST "${ID_LIST} + 1")
        endforeach()

        set(VAR_PROPAGATION_LIST        ${VAR_PROPAGATION_LIST} 
            FNCT_${MOD_NAME}_DEPS_NAME_LIST
        )

        foreach(name IN LISTS FNCT_${MOD_NAME}_DEPS_NAME_LIST)
            set_wsp_ver_funct(${name})
        endforeach()

        ## message("VAR_PROPAGATION_LIST of ${MOD_NAME}: ....>>>> ${VAR_PROPAGATION_LIST}")
        ## message("FNCT_${MOD_NAME}_DEPS_NAME_LIST: ~~~~~~~~~<<<<<< ${FNCT_${MOD_NAME}_DEPS_NAME_LIST}")
        return(PROPAGATE VAR_PROPAGATION_LIST ${VAR_PROPAGATION_LIST} )
    endblock()
endfunction()
