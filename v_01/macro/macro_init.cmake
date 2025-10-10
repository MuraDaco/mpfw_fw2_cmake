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

        set_wsp_ver_macro           (${MOD_NAME})
        print_wsp_ver_funct         (${MOD_NAME})
        set_public_rpath_macro      (${MOD_NAME})
        set_src_cfg_macro           (${MOD_NAME})
        print_src_cfg_funct         (${MOD_NAME})
    endif()
endmacro()


macro(set_modules_names_macro MOD_NAME)
    include(${MPFW_CODE_DIR}/${${MOD_NAME}_INIT_RURL}/set_module_names.cmake)
    ## name_up / name_lw
        set(name_up     ${${MOD_NAME}_0NAME_UP} )
        string(TOLOWER  ${name_up}  name_lw)
        message("DEBUG - set_modules_names_macro - name_up/name_lw:     ${name_up}/${name_lw}")
    ## name_layer_up
        set(name_layer_up        ${name_up} )
        if(${MOD_NAME}_LAYER_UP)
            set(name_layer_up        ${name_up}_${${MOD_NAME}_LAYER_UP} )
        endif()
        message("DEBUG - set_modules_names_macro - name_layer_up:       ${name_layer_up}")
    ## type_name_up
        set(type_name_up         ${${MOD_NAME}_TYPE_UP}_${name_layer_up} )
        message("DEBUG - set_modules_names_macro - type_name_up:        ${type_name_up}")
    ## complete_name_lw
        string(TOLOWER  ${MODULE_PREFIX_UP}_${type_name_up}  complete_name_lw)
        message("DEBUG - set_modules_names_macro - complete_name_lw:    ${complete_name_lw}")
    ## rpath_mod
        set(rpath_mod            ${${MOD_NAME}_RPATH} )
        message("DEBUG - set_modules_names_macro - rpath_mod:           ${rpath_mod}")

endmacro()

macro(call_rpath_include_macro MOD_NAME)
    ## if(EXISTS "${MPFW_CODE_DIR}/${${MOD_NAME}_INIT_RURL}/set_module_names.cmake")
    ##     include(${MPFW_CODE_DIR}/${${MOD_NAME}_INIT_RURL}/set_module_names.cmake)
    ## endif()

    parsing_rpath( ${${MOD_NAME}_INIT_RURL} )

    ## name_up / name_lw
        set(name_up     ${${MOD_NAME}_0NAME_UP} )
        string(TOLOWER  ${name_up}  name_lw)
        message("DEBUG - call_rpath_include_macro - name_up/name_lw:     ${name_up}/${name_lw}")
    ## name_layer_up
        set(name_layer_up        ${name_up} )
        if(${MOD_NAME}_LAYER_UP)
            set(name_layer_up        ${name_up}_${${MOD_NAME}_LAYER_UP} )
        endif()
        message("DEBUG - call_rpath_include_macro - name_layer_up:       ${name_layer_up}")
    ## type_name_up
        set(type_name_up         ${${MOD_NAME}_TYPE_UP}_${name_layer_up} )
        message("DEBUG - call_rpath_include_macro - type_name_up:        ${type_name_up}")
    ## complete_name_lw
        string(TOLOWER  ${MODULE_PREFIX_UP}_${type_name_up}  complete_name_lw)
        message("DEBUG - call_rpath_include_macro - complete_name_lw:    ${complete_name_lw}")
    ## rpath_mod
        set(rpath_mod            ${${MOD_NAME}_RPATH} )
        message("DEBUG - call_rpath_include_macro - rpath_mod:           ${rpath_mod}")

    include(${MPFW_CODE_CMAKE_DIR}/includes/set_public_rpaths.cmake)
    include(${MPFW_CODE_DIR}/${${MOD_NAME}_INIT_RURL}/set_public_rpath.cmake)

endmacro()

macro(set_public_rpath_macro MOD_NAME)
    call_rpath_include_macro(${MOD_NAME})
    foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
        set_public_rpath_macro(${name})
    endforeach()
endmacro()

macro(call_dirs_include_macro MOD_NAME)
    set(type_name_up        ${MOD_NAME})
    include(${MPFW_CODE_CMAKE_DIR}/includes/set_public_dirs.cmake)
    include(${MPFW_CODE_DIR}/${${MOD_NAME}_INIT_RURL}/set_public_dirs.cmake)
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
    if(${MOD_NAME}_EXTNL_LIB STREQUAL "N")
        foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
            if(${name}_EXTNL_LIB STREQUAL "N")
                string(TOLOWER ${name} target_name_lw)
                if(NOT TARGET _${target_name_lw}.out)

                    message("DEBUG - add_subdir_macro - _${target_name_lw}.out")
                    add_subdirectory(${MPFW_CODE_DIR}/${${name}_WSP_RPATH}   ${MPFW_CODE_DIR_FROM_BUILD}/${${name}_BUILD_EXT_RPATH} )
                endif()
            endif()
        endforeach()
    endif()
endmacro()

#### add_library_macro   (MOD_NAME)
 ###
  ##    _EXTNL_LIB (of current module that is ${MOD_NAME}) = N  ==>  build only ${MOD_NAME} source code files 
   #    _EXTNL_LIB (of current module that is ${MOD_NAME}) = Y  ==>  build ${MOD_NAME} source code files plus all dependencies modules ones
   #
  ##
 ###
####
macro(add_library_macro MOD_NAME)
    message("${MOD_NAME}_SOURCE_FILES_CPP_WDEP: ${${MOD_NAME}_SOURCE_FILES_CPP_WDEP}")
    if(${MOD_NAME}_EXTNL_LIB STREQUAL "N")
        add_library(${EXECUTABLE}
            ${${MOD_NAME}_SOURCE_FILES_CPP}
        )
    endif()
    if(${MOD_NAME}_EXTNL_LIB STREQUAL "Y")
        add_library(${EXECUTABLE}
            ${${MOD_NAME}_SOURCE_FILES_CPP_WDEP}
        )
    endif()
endmacro()

macro(add_executable_macro MOD_NAME)
    if(${MOD_NAME}_EXTNL_LIB STREQUAL "N")
        message("${MOD_NAME}_SOURCE_FILES_CPP: ${${MOD_NAME}_SOURCE_FILES_CPP}")
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


 ###
  ##    _EXTNL_LIB (of a depenedency module that is ${name} inside foreach loop) = N  ==>  do nothing
   #    _EXTNL_LIB (of a depenedency module that is ${name} inside foreach loop) = Y  ==>  create _SOURCE_FILES_CPP_WDEP list 
 ###
  ##    _EXTNL_LIB (of a depenedency module that is ${name} inside foreach loop) = N  ==>  add to _SOURCE_FILES_CPP_WDEP list
   #    _EXTNL_LIB (of a depenedency module that is ${name} inside foreach loop) = Y  ==>  do nothing; 
 ###
####
macro(set_src_cpp_files_list_macro MOD_NAME)
    set(${MOD_NAME}_SOURCE_FILES_CPP_WDEP )
    foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
        set_src_cpp_files_list_macro(${name})
        set(${MOD_NAME}_SOURCE_FILES_CPP_WDEP   ${${name}_SOURCE_FILES_CPP_WDEP}    ${${MOD_NAME}_SOURCE_FILES_CPP_WDEP}   )
    endforeach()
    include(${MPFW_FW2_${MOD_NAME}_INCLUDE_DIR}/cpp_files.cmake)
endmacro()

macro(set_src_header_files_list_macro MOD_NAME)
    set(${MOD_NAME}_SOURCE_FILES_H_WDEP )
    foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
        set_src_header_files_list_macro(${name})
        set(${MOD_NAME}_SOURCE_FILES_H_WDEP   ${${name}_SOURCE_FILES_H_WDEP}    ${${MOD_NAME}_SOURCE_FILES_H_WDEP}   )
    endforeach()
    include(${MPFW_FW2_${MOD_NAME}_INCLUDE_DIR}/include_files.cmake)

endmacro()

macro(set_wsp_ver_macro MOD_NAME)
        message("RECURSIVE_DEBUG --- start function with ${MOD_NAME} module name")
        ## message("${MOD_NAME}_WSP_VER: ---- ${${MOD_NAME}_WSP_VER}")
        ## message("${MOD_NAME}_SRC_CFG: ---- ${${MOD_NAME}_SRC_CFG}")
        string(TOLOWER ${MOD_NAME} MOD_NAME_LOWER )
        include(${MPFW_CODE_CMAKE_DIR}/rurls/set_${MOD_NAME_LOWER}_rurl.cmake)
        ## include(${MPFW_CODE_DIR}/${${MOD_NAME}_INIT_RURL}/set_module_names.cmake)
        include(${MPFW_CODE_DIR}/${${MOD_NAME}_INIT_RURL}/set_dependencies_list.cmake)
        set(ID_LIST     0)
        set(${MOD_NAME}_DEPS_NAME_LIST)
        ## message("${MOD_NAME}_DEPS_LIST: ${${MOD_NAME}_DEPS_LIST}")
        foreach(X IN LISTS ${MOD_NAME}_DEPS_LIST)
            math(EXPR ROW_LIST "${ID_LIST} / 4")
            math(EXPR COL_LIST "${ID_LIST} % 4")
            if(COL_LIST EQUAL 0)
                set(name    ${X})
                ## message("set name")
                set(${MOD_NAME}_DEPS_NAME_LIST      ${${MOD_NAME}_DEPS_NAME_LIST} ${name})
            endif()
            if(COL_LIST EQUAL 1)
                set(${name}_WSP_VER    ${X})
                ## message("${name}_WSP_VER: ---- ${${name}_WSP_VER}")
            endif()
            if(COL_LIST EQUAL 2)
                set(${name}_SRC_CFG    ${X})
                ## message("${name}_SRC_CFG: ---- ${${name}_SRC_CFG}")
            endif()
            if(COL_LIST EQUAL 3)
                set(${name}_EXTNL_LIB    ${X})
                message("${name}_EXTNL_LIB: ---- ${${name}_EXTNL_LIB}")
            endif()
            math(EXPR ID_LIST "${ID_LIST} + 1")
        endforeach()

        foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
            set_wsp_ver_macro(${name})
        endforeach()

endmacro()

macro(set_src_cfg_macro MOD_NAME)
        message("${MOD_NAME}_SRC_CFG: ---- ${MOD_NAME} / ${${MOD_NAME}_SRC_CFG}")
        include(${MPFW_CODE_DIR}/${${MOD_NAME}_INIT_RURL}/../../c_${${MOD_NAME}_SRC_CFG}/set_src_ver.cmake)

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


macro(set_inc_list_tbl MOD_NAME)
    set(${MOD_NAME}_SOURCE_FILES_CPP_WDEP )
    foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
        set_src_cpp_files_list_macro(${name})
        set(${MOD_NAME}_SOURCE_FILES_CPP_WDEP   ${${name}_SOURCE_FILES_CPP_WDEP}    ${${MOD_NAME}_SOURCE_FILES_CPP_WDEP}   )
    endforeach()
    include(${MPFW_FW2_${MOD_NAME}_INCLUDE_DIR}/cpp_files.cmake)
endmacro()

function(set_inc_list_tbl    MOD_NAME)
    block()

        message("${INDENT_STRING}- ${MOD_NAME}_SRC_CFG: ~~~~~~~ ${${MOD_NAME}_SRC_CFG}")

        foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
            print_src_cfg_funct(${name})
        endforeach()


    endblock()
endfunction()

macro(set_inc_list_tbl      MOD_NAME)
    foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
        set_inc_list_tbl(${name})
    endforeach()

    file(READ "${${MOD_NAME}_SRC_DIR}/tb/kr/krInit/v_${VER_krInit}/${type_name_up}/krInitStaticIncFnctTbl.cpp.in" LIST_INC_FROM_FILE_UNIT)
    set(LIST_INC_FROM_FILE ${LIST_INC_FROM_FILE} ${LIST_INC_FROM_FILE_UNIT})
endmacro()

macro(set_inc_list_tbl MOD_NAME SERVICE_NAME)
    set(${MOD_NAME}_LIST_INC_FROM_FILE_WDEP )
    foreach(name IN LISTS ${MOD_NAME}_DEPS_NAME_LIST)
        set_inc_list_tbl(${name} ${SERVICE_NAME})
        set(${MOD_NAME}_LIST_INC_FROM_FILE_WDEP   ${${name}_LIST_INC_FROM_FILE_WDEP}    ${${MOD_NAME}_LIST_INC_FROM_FILE_WDEP}   )
    endforeach()

    file(READ "${${MOD_NAME}_SRC_DIR}/tb/kr/krInit/v_${VER_krInit}/${type_name_up}/krInitStaticIncFnctTbl.cpp.in" ${MOD_NAME}_LIST_INC_FROM_FILE)
    set(${MOD_NAME}_LIST_INC_FROM_FILE_WDEP   ${${MOD_NAME}_LIST_INC_FROM_FILE_WDEP}   ${${name}_LIST_INC_FROM_FILE}    )
endmacro()

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
            message("DEBUG - STEP 0 - STRING_current_source_dir_LENGTH: ${STRING_current_source_dir_LENGTH}")

            string(FIND ${CMAKE_CURRENT_SOURCE_DIR} "/v_" SUBSTRING_CMakeLists_dir_POS REVERSE)
            math(EXPR SUBSTRING_CMakeLists_version_POS "${SUBSTRING_CMakeLists_dir_POS}+3")
            math(EXPR SUBSTRING_CMakeLists_version_LENGTH "${STRING_current_source_dir_LENGTH}-${SUBSTRING_CMakeLists_version_POS}")
            string(SUBSTRING ${CMAKE_CURRENT_SOURCE_DIR} ${SUBSTRING_CMakeLists_version_POS} ${SUBSTRING_CMakeLists_version_LENGTH} SUBSTRING_CMakeLists_version )
            message("DEBUG - STEP 0 - SUBSTRING_CMakeLists_version: ${SUBSTRING_CMakeLists_version}")

            string(FIND ${CMAKE_CURRENT_SOURCE_DIR} "/mpfw_code/" SUBSTRING_mpfw_code_POS )
            string(SUBSTRING ${CMAKE_CURRENT_SOURCE_DIR} 0 ${SUBSTRING_mpfw_code_POS} TEST_MPFW_CODE_DIR )
            set(TEST_MPFW_CODE_DIR "${TEST_MPFW_CODE_DIR}/mpfw_code")
            message("DEBUG - STEP 0 - TEST_MPFW_CODE_DIR: ${TEST_MPFW_CODE_DIR}")

            math(EXPR SUBSTRING_mpfw_code_POS "${SUBSTRING_mpfw_code_POS}+10")
            message("DEBUG - STEP 0 - SUBSTRING_mpfw_code_POS: ${SUBSTRING_mpfw_code_POS}")

            math(EXPR SUBSTRING_mpfw_code_LENGTH "${STRING_current_source_dir_LENGTH}-${SUBSTRING_mpfw_code_POS}")
            string(SUBSTRING ${CMAKE_CURRENT_SOURCE_DIR} ${SUBSTRING_mpfw_code_POS} ${SUBSTRING_mpfw_code_LENGTH} SUBSTRING_current_source_RPATH )
            message("DEBUG - STEP 0 - SUBSTRING_current_source_RPATH: ${SUBSTRING_current_source_RPATH}")

            string(REGEX MATCHALL "[^/]*/" OCCURENCES_LIST ${SUBSTRING_current_source_RPATH} )
            message("DEBUG - STEP 0 - OCCURENCES_LIST: ${OCCURENCES_LIST}")

            set(MPFW_CODE_DIR "..")
            set(MPFW_CODE_DIR_LEVEL 1 )
            foreach(item IN LISTS OCCURENCES_LIST)
                if(NOT item STREQUAL "/")
                    set(MPFW_CODE_DIR "${MPFW_CODE_DIR}/.." )
                    math(EXPR MPFW_CODE_DIR_LEVEL "${MPFW_CODE_DIR_LEVEL}+1")
                endif()
            endforeach()

            set(MPFW_CODE_DIR  ${TEST_MPFW_CODE_DIR} )
            message("DEBUG - STEP 0 - MPFW_CODE_DIR: ${MPFW_CODE_DIR}")

            if(EXISTS "${MPFW_CODE_DIR}/main")
                message(WARNING "DEBUG - STEP 0 - MPFW_CODE_DIR: ${MPFW_CODE_DIR} IS CORRECT")
            else()
                message(FATAL_ERROR "DEBUG - STEP 0 - MPFW_CODE_DIR: ${MPFW_CODE_DIR} is wrong")
            endif()
endmacro()


macro(init_MPFW_CODE_DIR_FROM_BUILD )
        ## determine MPFW_CODE_DIR_FROM_BUILD
            string(REGEX MATCHALL "[^/]*/" OCCURENCES_LIST ${BUILD_DIR} )
            message("DEBUG - STEP 0 - OCCURENCES_LIST: ${OCCURENCES_LIST}")

            set(STEP_FOLDER_COUNTER 1)
            foreach(item IN LISTS OCCURENCES_LIST)
                if(item STREQUAL "../")
                    math(EXPR STEP_FOLDER_COUNTER "${STEP_FOLDER_COUNTER}-1")
                else()
                    math(EXPR STEP_FOLDER_COUNTER "${STEP_FOLDER_COUNTER}+1")
                endif()
            endforeach()
            message("DEBUG - STEP 0 - STEP_FOLDER_COUNTER: ${STEP_FOLDER_COUNTER}")

            math(EXPR MPFW_CODE_DIR_FROM_BUILD_LEVEL "${MPFW_CODE_DIR_LEVEL}+${STEP_FOLDER_COUNTER}")
            message("DEBUG - STEP 0 - MPFW_CODE_DIR_FROM_BUILD_LEVEL: ${MPFW_CODE_DIR_FROM_BUILD_LEVEL}")

            math(EXPR MPFW_CODE_DIR_FROM_BUILD_LEVEL_MINUS_ONE "${MPFW_CODE_DIR_FROM_BUILD_LEVEL}-1")
            string(REPEAT "../" ${MPFW_CODE_DIR_FROM_BUILD_LEVEL_MINUS_ONE} MPFW_CODE_DIR_FROM_BUILD )
            set(MPFW_CODE_DIR_FROM_BUILD "${MPFW_CODE_DIR_FROM_BUILD}..")

            set(MPFW_CODE_DIR_FROM_BUILD  ${TEST_MPFW_CODE_DIR} )
            message("DEBUG - STEP 0 - MPFW_CODE_DIR_FROM_BUILD: ${MPFW_CODE_DIR_FROM_BUILD}")

            set(MPFW_CODE_CMAKE_DIR             ${MPFW_CODE_DIR}/cmake/mpfw_fw2_cmake/v_${CMAKE_SRC_VER} )
            set(MPFW_CODE_CMAKE_DIR_FROM_BUILD  ${MPFW_CODE_DIR_FROM_BUILD}/cmake/mpfw_fw2_cmake/v_${CMAKE_SRC_VER} )
endmacro()

macro(parsing_rpath RPATH_TO_PARSE)

        ## determine module names
            string(REPLACE "/" ";" OCCURENCES_LIST ${RPATH_TO_PARSE} )
            message("DEBUG - STEP 0 - OCCURENCES_LIST: ${OCCURENCES_LIST}")

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
                            message("DEBUG - STEP 0 - layer has been found - break")
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
                    message("DEBUG - STEP 0 - item: ${item} -> item_state: ${item_state} ")
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
                    message("DEBUG - STEP 0 - item: ${item} -> item_state: ${item_state} ")

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
                    message("DEBUG - STEP 0 - item: ${item} -> item_state: ${item_state} ")

                    if(item STREQUAL PLATFORM_NAME)
                        set(TEST_MODULE_PLATFORM   ${item} )
                        set(item_state "STATE_CHECK_WSP_FOLDER" )
                    else()
                        message(FATAL_ERROR "DEBUG - STEP 0 - \"platform name\" (\"${item}\") does not match the one that is set as build parameter (\"PLATFORM_NAME\" cmake variable = \"${PLATFORM_NAME}\") ")
                    endif()

                elseif(item_state STREQUAL "STATE_CHECK_WSP_FOLDER")
                    message("DEBUG - STEP 0 - item: ${item} -> item_state: ${item_state} ")

                    if(NOT item STREQUAL "wsp")
                        message(FATAL_ERROR "DEBUG - STEP 0 - After \"platform name\" folder there must be \"wsp\" folder instead there is ${item}")
                    endif()
                    break()
                endif()

                math(EXPR item_id "${item_id}+1")

            endforeach()

            message("DEBUG - STEP 0 - TEST_MODULE_TYPE:         ${TEST_MODULE_TYPE}")
            message("DEBUG - STEP 0 - TEST_MODULE_RPATH:        ${TEST_MODULE_RPATH}")
            message("DEBUG - STEP 0 - TEST_MODULE_0NAME:        ${TEST_MODULE_0NAME}")
            message("DEBUG - STEP 0 - TEST_MODULE_LAYER:        ${TEST_MODULE_LAYER}")
            message("DEBUG - STEP 0 - TEST_MODULE_PLATFORM:     ${TEST_MODULE_PLATFORM}")

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

            message("DEBUG - STEP 0 - TEST_MODULE_NAME:                 ${TEST_MODULE_NAME}")
            message("DEBUG - STEP 0 - ${TEST_MODULE_NAME}_TYPE_UP:      ${${TEST_MODULE_NAME}_TYPE_UP}")
            message("DEBUG - STEP 0 - ${TEST_MODULE_NAME}_RPATH:        ${${TEST_MODULE_NAME}_RPATH}")
            message("DEBUG - STEP 0 - ${TEST_MODULE_NAME}_0NAME_UP:     ${${TEST_MODULE_NAME}_0NAME_UP}")
            message("DEBUG - STEP 0 - ${TEST_MODULE_NAME}_LAYER_UP:     ${${TEST_MODULE_NAME}_LAYER_UP}")
            message("DEBUG - STEP 0 - ${TEST_MODULE_NAME}_PLATFORM:     ${${TEST_MODULE_NAME}_PLATFORM}")

endmacro()
