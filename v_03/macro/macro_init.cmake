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
#   macro_init.cmake
#
#   Created on: June,  4th 2025  (Wed)
#   Author: Marco Dau
##
### ---------------------------

include_guard()

macro(init_wsp_ver_macro MOD_NAME)
    ## determine the wsp version of current/root module
    message("DEBUG - init_wsp_ver_macro - begin")
    if(NOT ${MOD_NAME}_WSP_VER)
        ## the current module is the root project
        string(LENGTH ${CMAKE_CURRENT_SOURCE_DIR} CUR_DIR_LENGTH )
        math(EXPR VER_POSITION "${CUR_DIR_LENGTH}-6")    
        string(SUBSTRING ${CMAKE_CURRENT_SOURCE_DIR} ${VER_POSITION} 6 ${MOD_NAME}_WSP_VER )
        message("DEBUG - init_wsp_ver_macro - after WSP_VER is set")
    endif()
endmacro()

macro(init_var_macro MOD_NAME)
    if(NOT INIT_DONE)
        set(INIT_DONE       ON)
        init_wsp_ver_macro(${MOD_NAME})

        set_wsp_ver_macro               (${MOD_NAME})
        print_wsp_ver_funct             (${MOD_NAME})
        set_public_rpath_macro          (${MOD_NAME})
        set_src_cfg_macro               (${MOD_NAME})
        set_public_config_rpath_macro   (${MOD_NAME})
        print_src_cfg_funct             (${MOD_NAME})
    endif()
endmacro()



macro(call_module_include_cmake_file MOD_NAME   FILE_INCLUDE)

    
    if(EXISTS "${MPFW_CODE_DIR}/${${MOD_NAME}_cmmn_WSP_RPATH}/${FILE_INCLUDE}")
        include(${MPFW_CODE_DIR}/${${MOD_NAME}_cmmn_WSP_RPATH}/${FILE_INCLUDE})
    endif()
    foreach(item IN LISTS ${MOD_NAME}_TRDP_FNCT_LIST)
        if(EXISTS "${MPFW_CODE_DIR}/${${MOD_NAME}_${item}_WSP_RPATH}/${FILE_INCLUDE}")
            include(${MPFW_CODE_DIR}/${${MOD_NAME}_${item}_WSP_RPATH}/${FILE_INCLUDE})
        endif()
    endforeach()

endmacro()

macro(call_rpath_include_macro MOD_NAME)

    parsing_rpath_2( ${${MOD_NAME}_INIT_RURL} )
    include(${MPFW_CODE_CMAKE_DIR}/includes/set_public_rpaths.cmake)
    call_module_include_cmake_file(${MOD_NAME} "init/set_public_rpath.cmake")

endmacro()

macro(set_public_rpath_macro MOD_VAR_NAME)
    call_rpath_include_macro(${MOD_VAR_NAME})
    foreach(var_name IN LISTS ${MOD_VAR_NAME}_DEPS_NAME_LIST)
        set_public_rpath_macro(${var_name})
    endforeach()
endmacro()

macro(set_public_config_rpath_macro MOD_NAME)
    call_module_include_cmake_file(${MOD_NAME} "init/set_public_config_rpath.cmake")
    foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
        set_public_config_rpath_macro(${name})
    endforeach()
endmacro()

macro(call_dirs_include_macro MOD_NAME)
    set(type_name_up        ${MOD_NAME})
    include(${MPFW_CODE_CMAKE_DIR}/includes/set_public_dirs.cmake)
    call_module_include_cmake_file(${MOD_NAME} "init/set_public_dirs.cmake")

endmacro()

macro(set_public_dirs_macro MOD_NAME)
    call_dirs_include_macro     (${MOD_NAME})
    foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
        set_public_dirs_macro(${name})
    endforeach()
endmacro()

#### add_subdir_macro   (MOD_NAME)
 ###
  ##    _EXTNL_LIB (of current module that is ${MOD_NAME}) = N  ==>  call [add_subdirecrtory] command
   #    _EXTNL_LIB (of current module that is ${MOD_NAME}) = Y  ==>  do nothing; in fact it is unusefull to call [add_subdirectory] command about all dependencies libs because
   #                                                                    all dependencies source code must be contained in the current module, about this issue see 
   #                                                                    [add_library_macro] (it is implemented just below)
   #
  ##    _EXTNL_LIB (of a depenedency module that is ${name} inside foreach loop) = N  ==>  call [add_subdirecrtory] command
   #    _EXTNL_LIB (of a depenedency module that is ${name} inside foreach loop) = Y  ==>  do nothing; in fact it is unusefull to call [add_subdirectory] command about dependency libs because
   #                                                                    dependency source code is already build and available in the directory contained in the 
   #                                                                    ${MPFW_CODE_DIR}/${${name}_BUILD_EXT_RPATH variable
   #                                                                    see [set_target_link_dir_macro] implemented below
  ##
 ###
####
macro(add_subdir_macro MOD_NAME)
    message("DEBUG - add_subdir_macro - ${MOD_NAME}_EXTNL_LIB:      ${${MOD_NAME}_EXTNL_LIB}")
    if(${MOD_NAME}_EXTNL_LIB STREQUAL "N")
        foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
            if(${name}_EXTNL_LIB STREQUAL "N")
                string(TOLOWER ${name} target_name_lw)
                if(NOT TARGET _${target_name_lw}.out)

                    message("DEBUG - add_subdir_macro - _${target_name_lw}.out")
                    add_subdirectory(${MPFW_CODE_DIR}/${${name}_cmmn_WSP_RPATH}   ${MPFW_CODE_DIR_FROM_BUILD}/${${name}_BUILD_EXT_RPATH} )
                endif()
            endif()
        endforeach()
    endif()
endmacro()

#### add_library_macro   (MOD_NAME)
 ###
  ##    _EXTNL_LIB (of current module that is ${MOD_NAME}) = N  ==>  build only ${MOD_NAME} source code files 
  ##    _EXTNL_LIB (of current module that is ${MOD_NAME}) = Y  ==>  build ${MOD_NAME} source code files plus all dependencies modules ones
 ###
####
macro(add_library_macro MOD_NAME)
    if(${MOD_NAME}_EXTNL_LIB STREQUAL "N")
        ## message("${MOD_NAME}_sdk_SOURCE_FILES_CPP: ${${MOD_NAME}_sdk_SOURCE_FILES_CPP}")
        ## message("${MOD_NAME}_SOURCE_FILES_CPP: ${${MOD_NAME}_SOURCE_FILES_CPP}")
        ## message("${MOD_NAME}_SOURCE_FILES_H: ${${MOD_NAME}_SOURCE_FILES_H}")
        add_library(${EXECUTABLE}
            ${${MOD_NAME}_SOURCE_FILES_CPP}
        )
    endif()
    if(${MOD_NAME}_EXTNL_LIB STREQUAL "Y")
        message("${MOD_NAME}_SOURCE_FILES_CPP_WDEP: ${${MOD_NAME}_SOURCE_FILES_CPP_WDEP}")
        add_library(${EXECUTABLE}
            ${${MOD_NAME}_SOURCE_FILES_CPP_WDEP}
        )
    endif()
endmacro()

macro(add_executable_macro MOD_NAME)
    if(${MOD_NAME}_EXTNL_LIB STREQUAL "N")
        message("DEBUG - add_executable_macro - ${MOD_NAME}_SOURCE_FILES_CPP: ${${MOD_NAME}_SOURCE_FILES_CPP}")
        add_executable(${EXECUTABLE}
            ${${MOD_NAME}_SOURCE_FILES_CPP}
            ${CPP_TBL_AUTO_GEN_LIST}
        )
    endif()
    if(${MOD_NAME}_EXTNL_LIB STREQUAL "Y")
        message("${MOD_NAME}_SOURCE_FILES_CPP_WDEP: ${${MOD_NAME}_SOURCE_FILES_CPP_WDEP}")
        add_executable(${EXECUTABLE}
            ${${MOD_NAME}_SOURCE_FILES_CPP_WDEP}
            ${CPP_TBL_AUTO_GEN_LIST}
        )
    endif()
endmacro()

macro(set_include_directories_macro MOD_NAME)
    target_include_directories(${EXECUTABLE} PRIVATE
        ${${MOD_NAME}_SOURCE_FILES_H_WDEP}
    )
endmacro()

####
 ###
  ## 
   #    add only external libs build directory 
  ## 
 ###
####
macro(set_target_link_dir_macro MOD_NAME)
    set(TARGET_LIB_LIST      )
    foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
        if(${${name}_EXTNL_LIB} STREQUAL "Y")
            set(TARGET_LIB_LIST   ${TARGET_LIB_LIST}    ${MPFW_CODE_DIR}/${${name}_BUILD_RPATH}   )
        endif()
    endforeach()
    target_link_directories(${EXECUTABLE} PUBLIC
        ${TARGET_LIB_LIST}
    )
endmacro()

####
 ###
  ##    _EXTNL_LIB (of current module that is ${MOD_NAME}) = N  ==>  add all dependencies libs
   #    _EXTNL_LIB (of current module that is ${MOD_NAME}) = Y  ==>  add only all dependencies external libs
 ###
####
macro(set_target_link_lib_macro MOD_NAME)
    set(TARGET_LIB_LIST      )
    foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
        if(${${MOD_NAME}_EXTNL_LIB} STREQUAL "N")
            string(TOLOWER ${name} target_name_lw)
            set(TARGET_LIB_LIST   ${TARGET_LIB_LIST}    _${target_name_lw}.out   )
        endif()
        if(${${MOD_NAME}_EXTNL_LIB} STREQUAL "Y")
            if(${${name}_EXTNL_LIB} STREQUAL "Y")
                string(TOLOWER ${name} target_name_lw)
                set(TARGET_LIB_LIST   ${TARGET_LIB_LIST}    _${target_name_lw}.out   )
            endif()
        endif()
    endforeach()
    target_link_libraries(${EXECUTABLE} PUBLIC
        ${TARGET_LIB_LIST}
    )
endmacro()


####
 ###
  ##    _EXTNL_LIB (of a depenedency module that is ${name} inside foreach loop) = N  ==>  do nothing
   #    _EXTNL_LIB (of a depenedency module that is ${name} inside foreach loop) = Y  ==>  create _SOURCE_FILES_CPP_WDEP list 
 ###
  ##    _EXTNL_LIB (of a depenedency module that is ${name} inside foreach loop) = N  ==>  add to _SOURCE_FILES_CPP_WDEP list
   #    _EXTNL_LIB (of a depenedency module that is ${name} inside foreach loop) = Y  ==>  do nothing; 
 ###
####
macro(set_src_cpp_files_list_macro MOD_NAME)
    
    ## set _SOURCE_FILES_CPP_WDEP list
        set(${MOD_NAME}_SOURCE_FILES_CPP_WDEP )
        foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
            set_src_cpp_files_list_macro(${name})
            set(${MOD_NAME}_SOURCE_FILES_CPP_WDEP   ${${name}_SOURCE_FILES_CPP_WDEP}    ${${MOD_NAME}_SOURCE_FILES_CPP_WDEP}   )
        endforeach()
        list(REMOVE_DUPLICATES  ${MOD_NAME}_SOURCE_FILES_CPP_WDEP )

    ## set _SOURCE_FILES_CPP list
        set(${MOD_NAME}_SOURCE_FILES_CPP )
        if(EXISTS "${${MOD_NAME}_cmmn_INCLUDE_DIR}/cpp_files.cmake")
            include(${${MOD_NAME}_cmmn_INCLUDE_DIR}/cpp_files.cmake)
            set(${MOD_NAME}_SOURCE_FILES_CPP        ${${MOD_NAME}_cmmn_SOURCE_FILES_CPP} )
        endif()
        foreach(item IN LISTS ${MOD_NAME}_TRDP_FNCT_LIST)
            if(EXISTS "${${MOD_NAME}_${item}_INCLUDE_DIR}/cpp_files.cmake")
                include(${${MOD_NAME}_${item}_INCLUDE_DIR}/cpp_files.cmake)
                set(${MOD_NAME}_SOURCE_FILES_CPP        ${${MOD_NAME}_SOURCE_FILES_CPP}     ${${MOD_NAME}_${item}_SOURCE_FILES_CPP} )
            endif()
        endforeach()

    ## set _SOURCE_FILES_CPP_WDEP list
        set(${MOD_NAME}_SOURCE_FILES_CPP_WDEP
            ${${MOD_NAME}_SOURCE_FILES_CPP_WDEP}
            ${${MOD_NAME}_SOURCE_FILES_CPP}
        )

    ## message("DEBUG - set_src_cpp_files_list_macro - MOD_NAME:                 ${MOD_NAME}")
    ## message("DEBUG - set_src_cpp_files_list_macro - ${MOD_NAME}_cmmn_INCLUDE_DIR:               ${${MOD_NAME}_cmmn_INCLUDE_DIR}")
    ## message("DEBUG - set_src_cpp_files_list_macro - ${MOD_NAME}_sdk_INCLUDE_DIR:                ${${MOD_NAME}_sdk_INCLUDE_DIR}")
    ## message("DEBUG - set_src_cpp_files_list_macro - ${MOD_NAME}_TRDP_FNCT_LIST:                 ${${MOD_NAME}_TRDP_FNCT_LIST}")
    ## message("DEBUG - set_src_cpp_files_list_macro - ${MOD_NAME}_cmmn_INCLUDE_DIR:               ${${MOD_NAME}_cmmn_INCLUDE_DIR}")
    ## message("DEBUG - set_src_cpp_files_list_macro - ${MOD_NAME}_cmmn_SOURCE_FILES_CPP:          ${${MOD_NAME}_cmmn_SOURCE_FILES_CPP}")
    ## message("DEBUG - set_src_cpp_files_list_macro - ${MOD_NAME}_cmmn_SOURCE_FILES_CPP_WDEP:     ${${MOD_NAME}_cmmn_SOURCE_FILES_CPP_WDEP}")
    ## message("DEBUG - set_src_cpp_files_list_macro - ${MOD_NAME}_sdk_SOURCE_FILES_CPP_WDEP:      ${${MOD_NAME}_sdk_SOURCE_FILES_CPP_WDEP}")
    ## message("DEBUG - set_src_cpp_files_list_macro - ${MOD_NAME}_SOURCE_FILES_CPPP:              ${${MOD_NAME}_SOURCE_FILES_CPP}")
    ## message("DEBUG - set_src_cpp_files_list_macro - ${MOD_NAME}_SOURCE_FILES_CPP_WDEP:          ${${MOD_NAME}_SOURCE_FILES_CPP_WDEP}")

endmacro()

####
 ###    * function set_ccp_files_list(_module_) -> OUT _module_/_SOURCE_FILES_CPP & _module_/_SOURCE_FILES_CPP_WDEP
  ##        * loop _item_ IN LIST _module_/_DEPS_LIST
   #            * set_ccp_files_list(_item_)
 ###            * _module_/_SOURCE_FILES_CPP_WDEP = _module_/_SOURCE_FILES_CPP_WDEP + _item_/_SOURCE_FILES_CPP_WDEP
  ##        * end loop
   #        * _module_/_SOURCE_FILES_CPP        = _module_/_cmmn_SOURCE_FILES_CPP + Sum(_module_/_[id]_SOURCE_FILES_CPP; [id] IN LIST _module_/_TRDP_LIST)
 ###        * _module_/_SOURCE_FILES_CPP_WDEP   = _module_/_SOURCE_FILES_CPP_WDEP + _module_/_SOURCE_FILES_CPP
####

macro(set_src_header_files_list_macro MOD_NAME)
    ## set _SOURCE_FILES_H_WDEP list
        set(${MOD_NAME}_SOURCE_FILES_H_WDEP )
        foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
            set_src_header_files_list_macro(${name})
            set(${MOD_NAME}_SOURCE_FILES_H_WDEP   ${${name}_SOURCE_FILES_H_WDEP}    ${${MOD_NAME}_SOURCE_FILES_H_WDEP}   )
        endforeach()
        list(REMOVE_DUPLICATES  ${MOD_NAME}_SOURCE_FILES_H_WDEP )

    ## set _SOURCE_FILES_H list
        set(${MOD_NAME}_SOURCE_FILES_H )
        if(EXISTS "${${MOD_NAME}_cmmn_INCLUDE_DIR}/include_files.cmake")
            include(${${MOD_NAME}_cmmn_INCLUDE_DIR}/include_files.cmake)
            set(${MOD_NAME}_SOURCE_FILES_H        ${${MOD_NAME}_cmmn_SOURCE_FILES_H} )
        endif()
        foreach(item IN LISTS ${MOD_NAME}_TRDP_FNCT_LIST)
            if(EXISTS "${${MOD_NAME}_${item}_INCLUDE_DIR}/include_files.cmake")
                include(${${MOD_NAME}_${item}_INCLUDE_DIR}/include_files.cmake)
                set(${MOD_NAME}_SOURCE_FILES_H        ${${MOD_NAME}_SOURCE_FILES_H}     ${${MOD_NAME}_${item}_SOURCE_FILES_H} )
            endif()
        endforeach()

    ## set _SOURCE_FILES_H_WDEP list
        set(${MOD_NAME}_SOURCE_FILES_H_WDEP
            ${${MOD_NAME}_SOURCE_FILES_H_WDEP}
            ${${MOD_NAME}_SOURCE_FILES_H}
        )

    ## message("DEBUG - set_src_header_files_list_macro - ${MOD_NAME}_SOURCE_FILES_H:              ${${MOD_NAME}_SOURCE_FILES_H}")
    ## message("DEBUG - set_src_header_files_list_macro - ${MOD_NAME}_SOURCE_FILES_H_WDEP:         ${${MOD_NAME}_SOURCE_FILES_H_WDEP}")

endmacro()

macro(get_files_list_macro   MOD_NAME FILE_TO_SEARCH)

    ## message("DEBUG - get_files_list_macro - ")
    ## message("DEBUG - get_files_list_macro - ***************************************************************")
    ## message("DEBUG - get_files_list_macro - ")

    ## message("DEBUG - get_files_list_macro - ${MOD_NAME}_INIT_RURL:      ${${MOD_NAME}_INIT_RURL}")
    ## message("DEBUG - get_files_list_macro - FILE_TO_SEARCH:             ${FILE_TO_SEARCH}")
    ## message("DEBUG - get_files_list_macro - ${MOD_NAME}_WSP_VER:        v_${${MOD_NAME}_WSP_VER}")
    ## message("DEBUG - get_files_list_macro - TRDP_LIST:                  ${TRDP_LIST}")

    execute_process(

        COMMAND ${MPFW_CODE_CMAKE_DIR}/scripts/get_cmake_files_list.sh "${MPFW_CODE_DIR}/${${MOD_NAME}_INIT_RURL}" "${FILE_TO_SEARCH}" "v_${${MOD_NAME}_WSP_VER}" "${TRDP_LIST}" 

        OUTPUT_VARIABLE files_list
        RESULT_VARIABLE files_list_cmd_result
    )

    ## message("DEBUG - get_files_list_macro - files_list:                 ${files_list}")
    ## message("DEBUG - get_files_list_macro - files_list_cmd_result:      ${files_list_cmd_result}")

    foreach(item IN LISTS files_list)
        ## message("DEBUG - get_files_list_macro - item:      ${item}")
        string(STRIP ${item} item )
        if(item)
            include("${item}")
        endif()
    endforeach()

    ## ## message("DEBUG - get_files_list_macro - ${MOD_NAME}_cmmn_DEPS_LIST:      ${${MOD_NAME}_cmmn_DEPS_LIST}")
    set(${MOD_NAME}_DEPS_LIST  ${${MOD_NAME}_DEPS_LIST}   ${${MOD_NAME}_cmmn_DEPS_LIST} )
    foreach(item IN LISTS ${MOD_NAME}_TRDP_FNCT_LIST)
        ## ## message("DEBUG - get_files_list_macro - ${MOD_NAME}_${item}_DEPS_LIST:      ${${MOD_NAME}_${item}_DEPS_LIST}")
        set(${MOD_NAME}_DEPS_LIST  ${${MOD_NAME}_DEPS_LIST}   ${${MOD_NAME}_${item}_DEPS_LIST} )
    endforeach()
    ## message("DEBUG - get_files_list_macro - ${MOD_NAME}_DEPS_LIST:      ${${MOD_NAME}_DEPS_LIST}")


endmacro()

macro(set_wsp_ver_macro MOD_NAME)

        string(TOLOWER ${MOD_NAME} MOD_NAME_LOWER )
        include(${MPFW_CODE_CMAKE_DIR}/rurls/set_${MOD_NAME_LOWER}_rurl.cmake)
        set_module_cmmn_root_path(${MOD_NAME} ${${MOD_NAME}_INIT_RURL})
        set_module_trdp_root_path(${MOD_NAME} ${${MOD_NAME}_INIT_RURL})
        
        ## include(${MPFW_CODE_DIR}/${${MOD_NAME}_INIT_RURL}/set_dependencies_list.cmake)
        get_files_list_macro(${MOD_NAME} "set_dependencies_list.cmake")

        ## message(FATAL_ERROR "DEBUG - init_var_macro - test & exit")

        set(ID_LIST     0)
        set(${MOD_NAME}_DEPS_NAME_LIST)
        foreach(X IN LISTS ${MOD_NAME}_DEPS_LIST)
            math(EXPR ROW_LIST "${ID_LIST} / 4")
            math(EXPR COL_LIST "${ID_LIST} % 4")
            if(COL_LIST EQUAL 0)
                set(name    ${X})
                set(${MOD_NAME}_DEPS_NAME_LIST      ${${MOD_NAME}_DEPS_NAME_LIST} ${name})
            endif()
            if(COL_LIST EQUAL 1)
                set(${name}_WSP_VER    ${X})
            endif()
            if(COL_LIST EQUAL 2)
                set(${name}_SRC_CFG    ${X})
            endif()
            if(COL_LIST EQUAL 3)
                set(${name}_EXTNL_LIB    ${X})
            endif()
            math(EXPR ID_LIST "${ID_LIST} + 1")
        endforeach()

        foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
            set_wsp_ver_macro(${name})
        endforeach()

endmacro()

macro(set_src_cfg_macro MOD_NAME)
        ## message("DEBUG - set_src_cfg_macro - ${MOD_NAME}_SRC_CFG: ---- ${MOD_NAME} / ${${MOD_NAME}_SRC_CFG}")
        
        include(${MPFW_CODE_DIR}/${${MOD_NAME}_cmmn_WSP_RPATH}/../../c_${${MOD_NAME}_SRC_CFG}/set_src_ver.cmake)
        foreach(item IN LISTS ${MOD_NAME}_TRDP_FNCT_LIST)
            ## message("DEBUG - set_src_cfg_macro - ${MOD_NAME}_SRC_CFG: ---- ${MOD_NAME} / ${${MOD_NAME}_SRC_CFG}")
            ## message("DEBUG - set_src_cfg_macro - ${MPFW_CODE_DIR}/${${MOD_NAME}_${item}_WSP_RPATH}/../../c_${${MOD_NAME}_SRC_CFG}/set_src_ver.cmake")
            if(EXISTS "${MPFW_CODE_DIR}/${${MOD_NAME}_${item}_WSP_RPATH}/../../c_${${MOD_NAME}_SRC_CFG}/set_src_ver.cmake")
                include(${MPFW_CODE_DIR}/${${MOD_NAME}_${item}_WSP_RPATH}/../../c_${${MOD_NAME}_SRC_CFG}/set_src_ver.cmake)
                ## message("DEBUG - set_src_cfg_macro - include has been read - OK ")
            endif()
        endforeach()

        foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
            set_src_cfg_macro(${name})
        endforeach()

endmacro()


function(print_wsp_ver_funct    MOD_NAME)
    block()
        include(${MPFW_CODE_CMAKE_DIR}/functions/function_indent.cmake)

        set_indent_begin()

        message("${INDENT_STRING}- ${MOD_NAME}_WSP_VER: ~~~~~~~ ${${MOD_NAME}_WSP_VER}")

        foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
            print_wsp_ver_funct(${name})
        endforeach()

        set_indent_end()

    endblock()
endfunction()

function(print_src_cfg_funct    MOD_NAME)
    block()
        include(${MPFW_CODE_CMAKE_DIR}/functions/function_indent.cmake)

        set_indent_begin()

        message("${INDENT_STRING}- ${MOD_NAME}_SRC_CFG: ~~~~~~~ ${${MOD_NAME}_SRC_CFG}")

        foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
            print_src_cfg_funct(${name})
        endforeach()

        set_indent_end()

    endblock()
endfunction()


## macro(set_inc_list_tbl MOD_NAME)
##     set(${MOD_NAME}_SOURCE_FILES_CPP_WDEP )
##     foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
##         set_src_cpp_files_list_macro(${name})
##         set(${MOD_NAME}_SOURCE_FILES_CPP_WDEP   ${${name}_SOURCE_FILES_CPP_WDEP}    ${${MOD_NAME}_SOURCE_FILES_CPP_WDEP}   )
##     endforeach()
##     include(${MPFW_FW2_${MOD_NAME}_INCLUDE_DIR}/cpp_files.cmake)
## endmacro()
## 
## function(set_inc_list_tbl    MOD_NAME)
##     block()
## 
##         message("${INDENT_STRING}- ${MOD_NAME}_SRC_CFG: ~~~~~~~ ${${MOD_NAME}_SRC_CFG}")
## 
##         foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
##             print_src_cfg_funct(${name})
##         endforeach()
## 
## 
##     endblock()
## endfunction()
## 
## macro(set_inc_list_tbl      MOD_NAME)
##     foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
##         set_inc_list_tbl(${name})
##     endforeach()
## 
##     file(READ "${${MOD_NAME}_SRC_DIR}/tb/kr/krInit/v_${VER_krInit}/${type_name_up}/krInitStaticIncFnctTbl.cpp.in" LIST_INC_FROM_FILE_UNIT)
##     set(LIST_INC_FROM_FILE ${LIST_INC_FROM_FILE} ${LIST_INC_FROM_FILE_UNIT})
## endmacro()
## 
## macro(set_inc_list_tbl MOD_NAME SERVICE_NAME)
##     set(${MOD_NAME}_LIST_INC_FROM_FILE_WDEP )
##     foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
##         set_inc_list_tbl(${name} ${SERVICE_NAME})
##         set(${MOD_NAME}_LIST_INC_FROM_FILE_WDEP   ${${name}_LIST_INC_FROM_FILE_WDEP}    ${${MOD_NAME}_LIST_INC_FROM_FILE_WDEP}   )
##     endforeach()
## 
##     file(READ "${${MOD_NAME}_SRC_DIR}/tb/kr/krInit/v_${VER_krInit}/${type_name_up}/krInitStaticIncFnctTbl.cpp.in" ${MOD_NAME}_LIST_INC_FROM_FILE)
##     set(${MOD_NAME}_LIST_INC_FROM_FILE_WDEP   ${${MOD_NAME}_LIST_INC_FROM_FILE_WDEP}   ${${name}_LIST_INC_FROM_FILE}    )
## endmacro()

macro(check_CMAKE_SRC_VER )
    include(init/cmake_set_src_ver.cmake)

    string(LENGTH  ${MPFW_CODE_CMAKE_DIR} STRING_mpfw_code_cmake_dir_LENGTH)
    string(FIND ${MPFW_CODE_CMAKE_DIR} "/v_" SUBSTRING_mpfw_code_cmake_version_POS REVERSE)
    math(EXPR SUBSTRING_mpfw_code_cmake_version_POS     "${SUBSTRING_mpfw_code_cmake_version_POS}+3")
    math(EXPR SUBSTRING_mpfw_code_cmake_version_LENGTH  "${STRING_mpfw_code_cmake_dir_LENGTH}-${SUBSTRING_mpfw_code_cmake_version_POS}")
    string(SUBSTRING ${MPFW_CODE_CMAKE_DIR} ${SUBSTRING_mpfw_code_cmake_version_POS} ${SUBSTRING_mpfw_code_cmake_version_LENGTH} CMAKE_SRC_VER )

    list(FIND CMAKE_SRC_VER_MODULE ${CMAKE_SRC_VER} check_result)

    if(check_result EQUAL -1)
        message(FATAL_ERROR "CMAKE_SRC_VER (${CMAKE_SRC_VER}) is not contained in the list CMAKE_SRC_VER_MODULE (${CMAKE_SRC_VER_MODULE}) the CMAKE_SRC_VER associated to current module")
    endif()
endmacro()

macro(init_MPFW_CODE_DIR )
        ## determine MPFW_CODE_DIR
            message(WARNING "CMAKE_CURRENT_SOURCE_DIR: ${CMAKE_CURRENT_SOURCE_DIR}")

            string(LENGTH  ${CMAKE_CURRENT_SOURCE_DIR} STRING_current_source_dir_LENGTH)
            ## message("DEBUG - STEP 0 - STRING_current_source_dir_LENGTH: ${STRING_current_source_dir_LENGTH}")

            string(FIND ${CMAKE_CURRENT_SOURCE_DIR} "/v_" SUBSTRING_CMakeLists_dir_POS REVERSE)
            math(EXPR SUBSTRING_CMakeLists_version_POS "${SUBSTRING_CMakeLists_dir_POS}+3")
            string(FIND ${CMAKE_CURRENT_SOURCE_DIR} "/cmake" SUBSTRING_cmake_dir_POS REVERSE)
            math(EXPR SUBSTRING_CMakeLists_version_LENGTH "${SUBSTRING_cmake_dir_POS}-${SUBSTRING_CMakeLists_version_POS}")
            string(SUBSTRING ${CMAKE_CURRENT_SOURCE_DIR} ${SUBSTRING_CMakeLists_version_POS} ${SUBSTRING_CMakeLists_version_LENGTH} SUBSTRING_CMakeLists_version )
            ## message("DEBUG - STEP 0 - SUBSTRING_CMakeLists_version: ${SUBSTRING_CMakeLists_version}")

            string(FIND ${CMAKE_CURRENT_SOURCE_DIR} "/mpfw_code/" SUBSTRING_mpfw_code_POS )
            string(SUBSTRING ${CMAKE_CURRENT_SOURCE_DIR} 0 ${SUBSTRING_mpfw_code_POS} TEST_MPFW_CODE_DIR )
            set(TEST_MPFW_CODE_DIR "${TEST_MPFW_CODE_DIR}/mpfw_code")
            ## message("DEBUG - STEP 0 - TEST_MPFW_CODE_DIR: ${TEST_MPFW_CODE_DIR}")

            math(EXPR SUBSTRING_mpfw_code_POS "${SUBSTRING_mpfw_code_POS}+10")
            ## message("DEBUG - STEP 0 - SUBSTRING_mpfw_code_POS: ${SUBSTRING_mpfw_code_POS}")

            math(EXPR SUBSTRING_mpfw_code_LENGTH "${STRING_current_source_dir_LENGTH}-${SUBSTRING_mpfw_code_POS}")
            string(SUBSTRING ${CMAKE_CURRENT_SOURCE_DIR} ${SUBSTRING_mpfw_code_POS} ${SUBSTRING_mpfw_code_LENGTH} SUBSTRING_current_source_RPATH )
            ## message("DEBUG - STEP 0 - SUBSTRING_current_source_RPATH: ${SUBSTRING_current_source_RPATH}")

            string(REGEX MATCHALL "[^/]*/" OCCURENCES_LIST ${SUBSTRING_current_source_RPATH} )
            ## message("DEBUG - STEP 0 - OCCURENCES_LIST: ${OCCURENCES_LIST}")

            set(MPFW_CODE_DIR "..")
            set(MPFW_CODE_DIR_LEVEL 1 )
            foreach(item IN LISTS OCCURENCES_LIST)
                if(NOT item STREQUAL "/")
                    set(MPFW_CODE_DIR "${MPFW_CODE_DIR}/.." )
                    math(EXPR MPFW_CODE_DIR_LEVEL "${MPFW_CODE_DIR_LEVEL}+1")
                endif()
            endforeach()

            set(MPFW_CODE_DIR  ${TEST_MPFW_CODE_DIR} )
            ## message("DEBUG - STEP 0 - MPFW_CODE_DIR: ${MPFW_CODE_DIR}")

            if(EXISTS "${MPFW_CODE_DIR}/main")
                message(WARNING "DEBUG - STEP 0 - MPFW_CODE_DIR: ${MPFW_CODE_DIR} IS CORRECT")
            else()
                message(FATAL_ERROR "DEBUG - STEP 0 - MPFW_CODE_DIR: ${MPFW_CODE_DIR} is wrong")
            endif()
endmacro()


macro(init_MPFW_CODE_DIR_FROM_BUILD )
        ## determine MPFW_CODE_DIR_FROM_BUILD
            string(REGEX MATCHALL "[^/]*/" OCCURENCES_LIST ${BUILD_DIR} )
            ## message("DEBUG - STEP 0 - OCCURENCES_LIST: ${OCCURENCES_LIST}")

            set(STEP_FOLDER_COUNTER 1)
            foreach(item IN LISTS OCCURENCES_LIST)
                if(item STREQUAL "../")
                    math(EXPR STEP_FOLDER_COUNTER "${STEP_FOLDER_COUNTER}-1")
                else()
                    math(EXPR STEP_FOLDER_COUNTER "${STEP_FOLDER_COUNTER}+1")
                endif()
            endforeach()
            ## message("DEBUG - STEP 0 - STEP_FOLDER_COUNTER: ${STEP_FOLDER_COUNTER}")

            math(EXPR MPFW_CODE_DIR_FROM_BUILD_LEVEL "${MPFW_CODE_DIR_LEVEL}+${STEP_FOLDER_COUNTER}")
            ## message("DEBUG - STEP 0 - MPFW_CODE_DIR_FROM_BUILD_LEVEL: ${MPFW_CODE_DIR_FROM_BUILD_LEVEL}")

            math(EXPR MPFW_CODE_DIR_FROM_BUILD_LEVEL_MINUS_ONE "${MPFW_CODE_DIR_FROM_BUILD_LEVEL}-1")
            string(REPEAT "../" ${MPFW_CODE_DIR_FROM_BUILD_LEVEL_MINUS_ONE} MPFW_CODE_DIR_FROM_BUILD )
            set(MPFW_CODE_DIR_FROM_BUILD "${MPFW_CODE_DIR_FROM_BUILD}..")

            set(MPFW_CODE_DIR_FROM_BUILD  ${TEST_MPFW_CODE_DIR} )
            ## message("DEBUG - STEP 0 - MPFW_CODE_DIR_FROM_BUILD: ${MPFW_CODE_DIR_FROM_BUILD}")

            set(MPFW_CODE_CMAKE_DIR             ${MPFW_CODE_DIR}/cmake/mpfw_fw2_cmake/v_${CMAKE_SRC_VER} )
            set(MPFW_CODE_CMAKE_DIR_FROM_BUILD  ${MPFW_CODE_DIR_FROM_BUILD}/cmake/mpfw_fw2_cmake/v_${CMAKE_SRC_VER} )
endmacro()

macro(parsing_rpath RPATH_TO_PARSE)

        parsing_rpath_2()
        ## determine module names
            string(REPLACE "/" ";" OCCURENCES_LIST ${RPATH_TO_PARSE} )
            ## message("DEBUG - STEP 0 - OCCURENCES_LIST: ${OCCURENCES_LIST}")

            set(item_id 0 )
            set(item_state "STATE_TYPE" )
            set(TEST_MODULE_0NAME )
            foreach(item IN LISTS OCCURENCES_LIST)

                if(item_state STREQUAL "STATE_TYPE")
                    
                    set(TEST_MODULE_TYPE ${item} )
                    set(TEST_MODULE_RPATH ${item} )
                    set(item_state "STATE_RPATH_N_0NAME" )

                elseif(item_state STREQUAL "STATE_RPATH_N_0NAME")

                    string(FIND "${item}" "mpfw_fw2_${TEST_MODULE_TYPE}_" substring_pos)
                    if(substring_pos GREATER_EQUAL 0)
                        set(item_state "STATE_END" )
                        set(TEST_MODULE_LAYER )
                        set(TEST_MODULE_PLATFORM )
                        break()
                    else()
                        if(item STREQUAL "layer")
                            ## message("DEBUG - STEP 0 - layer has been found - break")
                            set(item_state "STATE_LAYER" )
                        else()
                            if(TEST_MODULE_0NAME)
                                if(item_id GREATER 1)
                                    set(TEST_MODULE_RPATH   "${TEST_MODULE_RPATH}/${TEST_MODULE_0NAME}" )
                                else()
                                    message(FATAL_ERROR "DEBUG - STEP 0 - \"module_0name\" can't be set in a level less than 2")
                                endif()
                            endif()
                            set(TEST_MODULE_0NAME    ${item} )
                        endif()
                    endif()

                elseif(item_state STREQUAL "STATE_LAYER")
                    ## message("DEBUG - STEP 0 - item: ${item} -> item_state: ${item_state} ")
                    string(FIND "${item}" "mpfw_fw2_${TEST_MODULE_TYPE}_" substring_pos)
                    if(substring_pos GREATER_EQUAL 0)
                        string(LENGTH "${item}" string_length)
                        string(LENGTH "mpfw_fw2_${TEST_MODULE_TYPE}_${TEST_MODULE_0NAME}_" substring_pos)
                        math(EXPR substring_length "${string_length}-${substring_pos}")
                        string(SUBSTRING ${item} ${substring_pos} ${substring_length} TEST_MODULE_LAYER)

                        set(item_state "STATE_PLATFORM" )
                    else()
                        message(FATAL_ERROR "DEBUG - STEP 0 - After \"layer\" folder there must be a complete module name that starts with \"mpfw_fw2_ ...\"")
                    endif()

                elseif(item_state STREQUAL "STATE_PLATFORM")
                    ## message("DEBUG - STEP 0 - item: ${item} -> item_state: ${item_state} ")

                    if(item STREQUAL "platform")
                        set(item_state "STATE_PLATFORM_OK" )
                    else()
                        if(item STREQUAL "wsp")
                            ## there isn't platform
                            set(TEST_MODULE_PLATFORM )
                            break()
                        else()
                            message(FATAL_ERROR "DEBUG - STEP 0 - After \"module root\" folder there must be \"platform\" or \"wsp\" folder")
                        endif()
                    endif()

                elseif(item_state STREQUAL "STATE_PLATFORM_OK")
                    ## message("DEBUG - STEP 0 - item: ${item} -> item_state: ${item_state} ")

                    if(item STREQUAL PLATFORM_NAME)
                        set(TEST_MODULE_PLATFORM   ${item} )
                        set(item_state "STATE_CHECK_WSP_FOLDER" )
                    else()
                        message(FATAL_ERROR "DEBUG - STEP 0 - \"platform name\" (\"${item}\") does not match the one that is set as build parameter (\"PLATFORM_NAME\" cmake variable = \"${PLATFORM_NAME}\") ")
                    endif()

                elseif(item_state STREQUAL "STATE_CHECK_WSP_FOLDER")
                    ## message("DEBUG - STEP 0 - item: ${item} -> item_state: ${item_state} ")

                    if(NOT item STREQUAL "wsp")
                        message(FATAL_ERROR "DEBUG - STEP 0 - After \"platform name\" folder there must be \"wsp\" folder instead there is ${item}")
                    endif()
                    break()
                endif()

                math(EXPR item_id "${item_id}+1")

            endforeach()

            ## message("DEBUG - STEP 0 - TEST_MODULE_TYPE:         ${TEST_MODULE_TYPE}")
            ## message("DEBUG - STEP 0 - TEST_MODULE_RPATH:        ${TEST_MODULE_RPATH}")
            ## message("DEBUG - STEP 0 - TEST_MODULE_0NAME:        ${TEST_MODULE_0NAME}")
            ## message("DEBUG - STEP 0 - TEST_MODULE_LAYER:        ${TEST_MODULE_LAYER}")
            ## message("DEBUG - STEP 0 - TEST_MODULE_PLATFORM:     ${TEST_MODULE_PLATFORM}")

            string(TOUPPER "${TEST_MODULE_TYPE}_${TEST_MODULE_0NAME}" TEST_MODULE_NAME )
            if(TEST_MODULE_LAYER)
                string(TOUPPER "${TEST_MODULE_NAME}_${TEST_MODULE_LAYER}" TEST_MODULE_NAME)
            endif()
            string(TOUPPER "${TEST_MODULE_TYPE}"  ${TEST_MODULE_NAME}_TYPE_UP )
            set(${TEST_MODULE_NAME}_RPATH  ${TEST_MODULE_RPATH} )
            string(TOUPPER "${TEST_MODULE_0NAME}"  ${TEST_MODULE_NAME}_0NAME_UP )
            if(TEST_MODULE_LAYER)
                string(TOUPPER "${TEST_MODULE_LAYER}"  ${TEST_MODULE_NAME}_LAYER_UP )
            endif()
            set(${TEST_MODULE_NAME}_PLATFORM ${TEST_MODULE_PLATFORM} )

            ## message("DEBUG - STEP 0 - TEST_MODULE_NAME:                 ${TEST_MODULE_NAME}")
            ## message("DEBUG - STEP 0 - ${TEST_MODULE_NAME}_TYPE_UP:      ${${TEST_MODULE_NAME}_TYPE_UP}")
            ## message("DEBUG - STEP 0 - ${TEST_MODULE_NAME}_RPATH:        ${${TEST_MODULE_NAME}_RPATH}")
            ## message("DEBUG - STEP 0 - ${TEST_MODULE_NAME}_0NAME_UP:     ${${TEST_MODULE_NAME}_0NAME_UP}")
            ## message("DEBUG - STEP 0 - ${TEST_MODULE_NAME}_LAYER_UP:     ${${TEST_MODULE_NAME}_LAYER_UP}")
            ## message("DEBUG - STEP 0 - ${TEST_MODULE_NAME}_PLATFORM:     ${${TEST_MODULE_NAME}_PLATFORM}")

endmacro()

macro(parsing_rpath_2 RPATH_TO_PARSE)

            ## parsing path to determine MODULE_TYPE, MODULE_FNCT, MODULE_OWNER & MODULE_RPATH
                string(REPLACE "/" ";" OCCURENCES_LIST ${RPATH_TO_PARSE} )

                list(POP_FRONT OCCURENCES_LIST  MODULE_TYPE MODULE_FNCT )
                set(MODULE_NAME_PART1_TYPE    ${MODULE_TYPE})
                set(MODULE_NAME_PART2_FNCT    ${MODULE_FNCT})
                set(MODULE_RPATH_PART1_TYPE_FNCT1 "${MODULE_TYPE}/${MODULE_FNCT}" )
                if(MODULE_TYPE STREQUAL "trdp")
                    list(POP_FRONT OCCURENCES_LIST  MODULE_OWNER )
                    set(MODULE_NAME_PART2_FNCT    "${MODULE_NAME_PART2_FNCT}-${MODULE_OWNER}")
                    set(MODULE_RPATH_PART1_TYPE_FNCT1 "${MODULE_RPATH_PART1_TYPE_FNCT1}/${MODULE_OWNER}" )
                endif()
                string(LENGTH "${MODULE_RPATH_PART1_TYPE_FNCT1}" MODULE_RPATH_PART1_TYPE_FNCT1_LENGTH)
                math(EXPR MODULE_RPATH_PART1_TYPE_FNCT1_LENGTH_PLUS_ONE "${MODULE_RPATH_PART1_TYPE_FNCT1_LENGTH} + 1")
                string(REPLACE "/" "-" MODULE_NAME_STEP1_TYPE_FNCT1 ${MODULE_RPATH_PART1_TYPE_FNCT1} )
                ## message("DEBUG - STEP 0 - MODULE_RPATH_PART1_TYPE_FNCT1:     ${MODULE_RPATH_PART1_TYPE_FNCT1}" )
                ## message("DEBUG - STEP 0 - MODULE_NAME_STEP1_TYPE_FNCT1:     ${MODULE_NAME_STEP1_TYPE_FNCT1}" )
                ## message("DEBUG - STEP 0 - MODULE_RPATH_PART1_TYPE_FNCT1_LENGTH:     ${MODULE_RPATH_PART1_TYPE_FNCT1_LENGTH}" )
                ## message("DEBUG - STEP 0 - RPATH_TO_PARSE:       ${RPATH_TO_PARSE}" )

                string(FIND "${RPATH_TO_PARSE}" "/layer/mpfw_fw2-${MODULE_NAME_STEP1_TYPE_FNCT1}-" substring_pos)
                if(substring_pos GREATER_EQUAL MODULE_RPATH_PART1_TYPE_FNCT1_LENGTH)
                    string(SUBSTRING ${RPATH_TO_PARSE} 0 ${substring_pos} MODULE_RPATH)
                    string(REPLACE "/" "-" MODULE_NAME_STEP2_TYPE_FNCT ${MODULE_RPATH} )
                else()
                    message(FATAL_ERROR "Module path is incorrect, it does not match the pattern \"${MODULE_RPATH_PART1_TYPE_FNCT1}/.../layer/mpfw_fw2-${MODULE_NAME_STEP1_TYPE_FNCT1}-\" " )
                endif()

                ## message("DEBUG - STEP 0 - MODULE_RPATH:         ${MODULE_RPATH}" )
                set(MODULE_RPATH_N_PARTIAL_NAME "${MODULE_RPATH}/layer/mpfw_fw2-${MODULE_NAME_STEP1_TYPE_FNCT1}" )
                ## message("DEBUG - STEP 0 - MODULE_RPATH_N_PARTIAL_NAME:     ${MODULE_RPATH_N_PARTIAL_NAME}" )

            ## determine MODULE_FNCT_ATTR
                set(MODULE_FNCT_ATTR)
                math(EXPR substring_length "${substring_pos} - ${MODULE_RPATH_PART1_TYPE_FNCT1_LENGTH_PLUS_ONE}" )
                if(substring_length GREATER 0)
                    string(SUBSTRING ${MODULE_RPATH} ${MODULE_RPATH_PART1_TYPE_FNCT1_LENGTH_PLUS_ONE} ${substring_pos} MODULE_FNCT_ATTR)
                    string(REPLACE "/" "-" MODULE_FNCT_ATTR ${MODULE_FNCT_ATTR} )
                    set(MODULE_RPATH_N_PARTIAL_NAME "${MODULE_RPATH_N_PARTIAL_NAME}-${MODULE_FNCT_ATTR}" )
                endif()
                string(LENGTH "${MODULE_RPATH_N_PARTIAL_NAME}" MODULE_RPATH_N_PARTIAL_NAME_LENGTH)

            ## determine MODULE_NAME_PART2_FNCT 
                if(MODULE_FNCT_ATTR)
                    set(MODULE_NAME_PART2_FNCT    ${MODULE_NAME_PART2_FNCT}-${MODULE_FNCT_ATTR})
                endif()

            ## message("DEBUG - STEP 0 - MODULE_NAME_STEP2_TYPE_FNCT:     ${MODULE_NAME_STEP2_TYPE_FNCT}" )
            ## message("DEBUG - STEP 0 - MODULE_FNCT_ATTR:     ${MODULE_FNCT_ATTR}" )
            ## message("DEBUG - STEP 0 - MODULE_RPATH_PART1_TYPE_FNCT1_LENGTH_PLUS_ONE:     ${MODULE_RPATH_PART1_TYPE_FNCT1_LENGTH_PLUS_ONE}" )
            ## message("DEBUG - STEP 0 - MODULE_RPATH_N_PARTIAL_NAME:     ${MODULE_RPATH_N_PARTIAL_NAME}" )

            
            ## message("DEBUG - STEP 0 - RPATH_TO_PARSE:       ${RPATH_TO_PARSE}" )
            ## message("DEBUG - STEP 0 - MODULE_TYPE:          ${MODULE_TYPE}" )
            ## message("DEBUG - STEP 0 - MODULE_NAME_PART1_TYPE:          ${MODULE_NAME_PART1_TYPE}" )
            ## message("DEBUG - STEP 0 - MODULE_FNCT:          ${MODULE_FNCT}" )
            ## message("DEBUG - STEP 0 - MODULE_OWNER:         ${MODULE_OWNER}" )
            ## message("DEBUG - STEP 0 - MODULE_FNCT_ATTR:     ${MODULE_FNCT_ATTR}" )

            ## message("DEBUG - STEP 0 - MODULE_RPATH:         ${MODULE_RPATH}" )
            ## message("DEBUG - STEP 0 - MODULE_NAME_PART2_FNCT:         ${MODULE_NAME_PART2_FNCT}" )
            set(MODULE_0NAME    ${MODULE_NAME_PART2_FNCT})
            ## message("DEBUG - STEP 0 - MODULE_0NAME:         ${MODULE_0NAME}" )


            ## determine MODULE_LAYER (MODULE_LAYER_FNCT & MODULE_LAYER_FNCT_ATTR)

                string(SUBSTRING ${RPATH_TO_PARSE} ${MODULE_RPATH_N_PARTIAL_NAME_LENGTH} -1 MODULE_RPATH_END)
                string(REPLACE "/" ";" MODULE_RPATH_END_STR ${MODULE_RPATH_END} )
                list(POP_FRONT MODULE_RPATH_END_STR  MODULE_LAYER )
                string(SUBSTRING ${MODULE_LAYER} 1 -1 MODULE_LAYER)

            ## message("DEBUG - STEP 0 - MODULE_LAYER:         ${MODULE_LAYER}" )

                string(REPLACE "-" ";" MODULE_LAYER_LIST ${MODULE_LAYER} )
                list(POP_FRONT MODULE_LAYER_LIST  MODULE_LAYER_BEGIN )
                if(MODULE_TYPE STREQUAL "trdp")
                    if(MODULE_LAYER_BEGIN STREQUAL "0trdp" OR MODULE_LAYER_BEGIN STREQUAL "1trdp")
                        list(POP_FRONT MODULE_LAYER_LIST  MODULE_LAYER_FNCT MODULE_LAYER_FNCT_ATTR )
                    endif()
                else()
                    if(MODULE_LAYER_BEGIN STREQUAL "2wrpr")
                        list(POP_FRONT MODULE_LAYER_LIST  MODULE_LAYER_FNCT MODULE_LAYER_FNCT_ATTR )
                    endif()
                    if(MODULE_LAYER_BEGIN STREQUAL "1trdp" OR MODULE_LAYER_BEGIN STREQUAL "2wrpr")
                        list(POP_FRONT MODULE_LAYER_LIST  MODULE_LAYER_FNCT MODULE_LAYER_OWNER MODULE_LAYER_FNCT_ATTR )
                    endif()
                endif()

            ## message("DEBUG - STEP 0 - MODULE_LAYER_BEGIN:       ${MODULE_LAYER_BEGIN}" )
            ## message("DEBUG - STEP 0 - MODULE_LAYER_FNCT:        ${MODULE_LAYER_FNCT}" )
            ## message("DEBUG - STEP 0 - MODULE_LAYER_OWNER:       ${MODULE_LAYER_OWNER}" )
            ## message("DEBUG - STEP 0 - MODULE_LAYER_FNCT_ATTR:   ${MODULE_LAYER_FNCT_ATTR}" )
            ## message("DEBUG - STEP 0 - MODULE_LAYER_LIST:        ${MODULE_LAYER_LIST}" )

                ## message("DEBUG - STEP 0 - MODULE_RPATH_PART1_TYPE_FNCT1:    ${MODULE_RPATH_PART1_TYPE_FNCT1}" )
                ## message("DEBUG - STEP 0 - MODULE_RPATH:                     ${MODULE_RPATH_PART1_TYPE_FNCT1}" )

                set(MODULE_PREFIX_UP    "MPFW_FW2")

                ## message("DEBUG - STEP 0 - MODULE_PREFIX_UP:                 ${MODULE_PREFIX_UP}")
                ## message("DEBUG - STEP 0 - MODULE_NAME_STEP1_TYPE_FNCT1:     ${MODULE_NAME_STEP1_TYPE_FNCT1}")
                ## message("DEBUG - STEP 0 - MODULE_NAME_STEP2_TYPE_FNCT:      ${MODULE_NAME_STEP2_TYPE_FNCT}")

                ## message("DEBUG - STEP 0 - MODULE_NAME_PART1_TYPE:           ${MODULE_NAME_PART1_TYPE}")
                ## message("DEBUG - STEP 0 - MODULE_NAME_PART2_FNCT:           ${MODULE_NAME_PART2_FNCT}")

                ## message("DEBUG - STEP 0 - MODULE_NAME_PART1_LAYER_PREFIX:   ${MODULE_NAME_PART1_LAYER_PREFIX}")
                ## message("DEBUG - STEP 0 - MODULE_NAME_PART2_LAYER_DESC:     ${MODULE_NAME_PART2_LAYER_DESC}")

                set(MODULE_NAME_LAYER    ${MODULE_LAYER} )
                ## message("DEBUG - STEP 0 - MODULE_NAME_LAYER:                ${MODULE_NAME_LAYER}")

                set(MODULE_NAME_COMPLETE_WO_PREFIX  "${MODULE_NAME_STEP2_TYPE_FNCT}-${MODULE_NAME_LAYER}")
                ## message("DEBUG - STEP 0 - MODULE_NAME_COMPLETE_WO_PREFIX:   ${MODULE_NAME_COMPLETE_WO_PREFIX}")

                set(MODULE_NAME_COMPLETE  "${MODULE_PREFIX_UP}-${MODULE_NAME_COMPLETE_WO_PREFIX}")
                ## message("DEBUG - STEP 0 - MODULE_NAME_COMPLETE:             ${MODULE_NAME_COMPLETE}")

                set(rpath_mod            ${MODULE_RPATH} )
                string(TOUPPER "${MODULE_NAME_COMPLETE_WO_PREFIX}" type_name_up)
                string(TOLOWER "${MODULE_NAME_COMPLETE}" complete_name_lw)

            ## message("DEBUG - STEP 0 - ****************************************************************")
            ## message("DEBUG - STEP 0 - ****************************************************************")

            set(MODULE_PREFIX_UP    "MPFW_FW2")

            ## message("DEBUG - STEP 0 - MODULE_PREFIX_UP:     ${MODULE_PREFIX_UP}")
            ## message("DEBUG - STEP 0 - MODULE_TYPE:          ${MODULE_TYPE}")
            ## message("DEBUG - STEP 0 - MODULE_RPATH:         ${MODULE_RPATH}")
            ## message("DEBUG - STEP 0 - MODULE_0NAME:         ${MODULE_0NAME}")
            ## message("DEBUG - STEP 0 - MODULE_LAYER:         ${MODULE_LAYER}")
            ## message("DEBUG - STEP 0 - MODULE_PLATFORM:      ${MODULE_PLATFORM}")

            string(TOUPPER "${MODULE_TYPE}-${MODULE_0NAME}" TMP_MODULE_NAME )
            if(MODULE_LAYER)
                string(TOUPPER "${TMP_MODULE_NAME}-${MODULE_LAYER}" TMP_MODULE_NAME)
            endif()
            string(TOUPPER "${MODULE_TYPE}"  ${TMP_MODULE_NAME}_TYPE_UP )
            set(${TMP_MODULE_NAME}_RPATH  ${MODULE_RPATH} )
            string(TOUPPER "${MODULE_0NAME}"  ${TMP_MODULE_NAME}_0NAME_UP )
            if(MODULE_LAYER)
                string(TOUPPER "${MODULE_LAYER}"  ${TMP_MODULE_NAME}_LAYER_UP )
            endif()
            set(${TMP_MODULE_NAME}_PLATFORM ${MODULE_PLATFORM} )


            ## message("DEBUG - STEP 0 - TMP_MODULE_NAME:                 ${TMP_MODULE_NAME}")
            ## message("DEBUG - STEP 0 - ${TMP_MODULE_NAME}_TYPE_UP:      ${${TMP_MODULE_NAME}_TYPE_UP}")
            ## message("DEBUG - STEP 0 - ${TMP_MODULE_NAME}_RPATH:        ${${TMP_MODULE_NAME}_RPATH}")
            ## message("DEBUG - STEP 0 - ${TMP_MODULE_NAME}_0NAME_UP:     ${${TMP_MODULE_NAME}_0NAME_UP}")
            ## message("DEBUG - STEP 0 - ${TMP_MODULE_NAME}_LAYER_UP:     ${${TMP_MODULE_NAME}_LAYER_UP}")
            ## message("DEBUG - STEP 0 - ${TMP_MODULE_NAME}_PLATFORM:     ${${TMP_MODULE_NAME}_PLATFORM}")

            set(MOD_NAME    ${TMP_MODULE_NAME} )
            ## message("DEBUG - STEP 0 - TMP_MODULE_NAME:          ${TMP_MODULE_NAME}")
            ## message("DEBUG - STEP 0 - MOD_NAME:             ${MOD_NAME}")

            ## message("DEBUG - parsing_rpath_2 - rpath_mod:           ${rpath_mod}")
            ## message("DEBUG - parsing_rpath_2 - type_name_up:        ${type_name_up}")
            ## message("DEBUG - parsing_rpath_2 - complete_name_lw:    ${complete_name_lw}")


            ## message(FATAL_ERROR "DEBUG - STEP 0")
            ## ****************************************************************************************************


endmacro()

macro(set_module_cmmn_root_path MOD_NAME MODULE_ROOT_RPATH)
    set(${MOD_NAME}_cmmn_ROOT_RPATH    ${MODULE_ROOT_RPATH}     )
    if(EXISTS "${MPFW_CODE_DIR}/${MODULE_ROOT_RPATH}/common")
        set(${MOD_NAME}_cmmn_ROOT_RPATH    "${MODULE_ROOT_RPATH}/common" )
    endif()
endmacro()

macro(set_module_trdp_root_path MOD_NAME MODULE_ROOT_RPATH)

    set(TRDP_RPATH      ${MODULE_ROOT_RPATH}/trdp )
    set(TRDP_DIR        ${MPFW_CODE_DIR}/${TRDP_RPATH} )
    if(EXISTS "${TRDP_DIR}")
        execute_process(

            COMMAND ${MPFW_CODE_CMAKE_DIR}/scripts/get_trdp_root_rpath_list.sh "${TRDP_DIR}" "${TRDP_LIST}" 

            OUTPUT_VARIABLE TRDP_ROOT_RPATHS_LIST
            RESULT_VARIABLE trdp_root_dirs_cmd_result
        )
        ## ## message("DEBUG - TRDP ROOT DIRS - TRDP_DIR:                         ${TRDP_DIR}")
        ## ## message("DEBUG - TRDP ROOT DIRS - TRDP_LIST:                        ${TRDP_LIST}")
        ## ## message("DEBUG - TRDP ROOT DIRS - TRDP_ROOT_RPATHS_LIST:            ${TRDP_ROOT_RPATHS_LIST}")
        ## ## message("DEBUG - TRDP ROOT DIRS - trdp_root_dirs_cmd_result:        ${trdp_root_dirs_cmd_result}")
    else()
        ## message("DEBUG - TRDP ROOT DIRS - TRDP_DIR:     ${TRDP_DIR}")
        ## message("DEBUG - TRDP ROOT DIRS - ${TRDP_DIR} does not exist")
        set(TRDP_ROOT_RPATHS_LIST )
    endif()

    set(${MOD_NAME}_TRDP_FNCT_LIST )
    foreach(item IN LISTS TRDP_ROOT_RPATHS_LIST)
        string(STRIP ${item} item)
        string(FIND "${item}" "/" string_pos)
        if(string_pos GREATER 0)
            ## message("DEBUG - TRDP_ROOT_RPATHS_LIST - item:     ${item}")
            string(SUBSTRING "${item}" 0 ${string_pos} trdp_fnct)
            set(${MOD_NAME}_TRDP_FNCT_LIST      ${${MOD_NAME}_TRDP_FNCT_LIST}  ${trdp_fnct} )
            set(${MOD_NAME}_${trdp_fnct}_ROOT_RPATH     ${TRDP_RPATH}/${item})
        endif()
    endforeach()

    ## message("DEBUG - STEP 0 - ${MOD_NAME}_TRDP_FNCT_LIST:     ${${MOD_NAME}_TRDP_FNCT_LIST}")
    ## message("DEBUG - STEP 0 - TRDP-SDK-STM-STM32F769_DISCO-0TRDP_sdk_ROOT_RPATH:     ${TRDP-SDK-STM-STM32F769_DISCO-0TRDP_sdk_ROOT_RPATH}")
    ## message("DEBUG - STEP 0 - TRDP-SDK-STM-STM32F769_DISCO-0TRDP_usb_ROOT_RPATH:     ${TRDP-SDK-STM-STM32F769_DISCO-0TRDP_usb_ROOT_RPATH}")
    
endmacro()
