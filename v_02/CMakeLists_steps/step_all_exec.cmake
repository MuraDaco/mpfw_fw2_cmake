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
#   step_all_exec.cmake
#
#   Created on: June,  18th 2025  (Wed)
#   Author: Marco Dau
##
### ---------------------------

#### _______________________________________________________________
## *** Section  5 - SET STANDARD PROJECT VARIABLES
    set(EXECUTABLE exec_${APP_NAME_LOWER}.out )

    enable_language( ASM)

    # specify the C++ standard
    set(CMAKE_CXX_STANDARD 20)
    set(CMAKE_CXX_STANDARD_REQUIRED true)

    ## message(STATUS "TOOLCHAIN - ASM:                  ${CMAKE_ASM_COMPILER}")
    ## message(STATUS "TOOLCHAIN - C:                    ${CMAKE_C_COMPILER}"  )
    ## message(STATUS "TOOLCHAIN - C++:                  ${CMAKE_CXX_COMPILER}")


    #### _______________________________________________________________
    ## *** Section  5.1 - COMMAND BUILD PARAMETERS CHECK

        ## PLATFORM Definitions

            if(NOT DEFINED PLATFORM_NAME)
                message(FATAL_ERROR "NO PLATFORM selected !!!!" )
            else()
                message(STATUS "PLATFORM selected is -->>${PLATFORM_NAME}<<--" )
            endif()

#### _______________________________________________________________
## *** Section  6 - SET SPECIFIC PROJECT VARIABLES

    init_var_macro          (${MODULE_NAME})
    add_subdir_macro        (${MODULE_NAME})
    set_public_dirs_macro   (${MODULE_NAME})

    ## set library files 
    set_src_header_files_list_macro (${MODULE_NAME})
    set_src_cpp_files_list_macro    (${MODULE_NAME})

#### _______________________________________________________________
## *** Section  7 - BUILD LIBRARY CONFIGURATION COMMANDS

    if(NOT EXISTS ${MPFW_CODE_CMAKE_DIR}/scripts/get_deps_list.sh )
        message(FATAL_ERROR "The \"${MPFW_CODE_DIR}/cmake/mpfw_fw2_cmake/v_01/scripts/get_deps_list.sh\" file does not exist")
    else()
        message("DEBUG - auto-generate procedure - OK - The \"${MPFW_CODE_DIR}/cmake/mpfw_fw2_cmake/v_01/scripts/get_deps_list.sh\" file exists")
    endif()

    execute_process(

        COMMAND ${MPFW_CODE_CMAKE_DIR}/scripts/get_services_list.sh "${${MODULE_NAME}_SOURCE_FILES_H_WDEP}"

        OUTPUT_VARIABLE test_exec_process
        RESULT_VARIABLE test_exex_prc_result
    )
    set(item_id 0)
    foreach(item IN LISTS test_exec_process)
        ## message("DEBUG - get_services_list.sh - item: ${item}")

        math(EXPR COL_LIST "${item_id} % 3")
        string(STRIP ${item} item)
        if(COL_LIST EQUAL 0)
            if(item)
                set(service_name          ${item} )
                set(SERVICE_NAME_LIST     ${SERVICE_NAME_LIST} ${item} )
            endif()
        endif()
        if(COL_LIST EQUAL 1)
            set(CPP_${service_name}_TBL_TEMPLATE                ${item})
        endif()
        if(COL_LIST EQUAL 2)
            set(CPP_${service_name}_TBL_DIR_AUTO_GEN        "${${MODULE_NAME}_SRC_DIR}/auto_gen/${APP_NAME}/tb/${item}" )
            set(CPP_${service_name}_TBL_AUTO_GEN            "${CPP_${service_name}_TBL_DIR_AUTO_GEN}/${service_name}Tbl.cpp" )
            set(CPP_TBL_AUTO_GEN_LIST                       ${CPP_TBL_AUTO_GEN_LIST} ${CPP_${service_name}_TBL_AUTO_GEN} )
        endif()

        math(EXPR item_id "${item_id} + 1")
        message("DEBUG - get_services_list - item: ${item}")
    endforeach()
##    message("DEBUG - get_services_list - SERVICE_NAME_LIST:       ${SERVICE_NAME_LIST}" )
##    message("DEBUG - get_services_list - CPP_TBL_AUTO_GEN_LIST:   ${CPP_TBL_AUTO_GEN_LIST}" )
##
##    message("DEBUG - execute_process - test_exex_prc_result:    ${test_exex_prc_result}")

    foreach(service_name IN LISTS SERVICE_NAME_LIST)

##        message("DEBUG - AUTO-GENERATED FILE - ***********************************  "   )
##        message("DEBUG - get_deps_list - start --> service_name: ${service_name}")
##        message("   -----   ")

        execute_process(

            COMMAND ${MPFW_CODE_CMAKE_DIR}/scripts/get_deps_list.sh "${${MODULE_NAME}_SOURCE_FILES_H_WDEP}" "${service_name}"

            OUTPUT_VARIABLE test_exec_process
            RESULT_VARIABLE test_exex_prc_result
        )
##        message("   DEBUG - get_deps_list - check --> matrix of ${service_name} service: ${test_exec_process}")

        set(task_${service_name}_desps       )
        set(task_${service_name}_include     )
        set(task_${service_name}_define      )
        set(task_${service_name}_pointer     )
        set(item_id 0)
        foreach(item IN LISTS test_exec_process)
            math(EXPR COL_LIST "${item_id} % 4")
            string(STRIP ${item} item)
            if(COL_LIST EQUAL 0)
                set(task_${service_name}_desps          ${task_${service_name}_desps} ${item})
            endif()
            if(COL_LIST EQUAL 1)
                set(task_${service_name}_include        ${task_${service_name}_include} ${item})
            endif()
            if(COL_LIST EQUAL 2)
                set(task_${service_name}_define         ${task_${service_name}_define} ${item})
            endif()
            if(COL_LIST EQUAL 3)
                set(task_${service_name}_pointer        ${task_${service_name}_pointer} ${item})
            endif()

            message("   DEBUG - get_deps_list - check --> item of ${service_name} service: ${item}")

            math(EXPR item_id "${item_id} + 1")
        endforeach()

        list(REMOVE_DUPLICATES task_${service_name}_desps )
        list(REMOVE_DUPLICATES task_${service_name}_include )
##        message("   DEBUG - AUTO-GENERATED FILE - task_${service_name}_desps:   ${task_${service_name}_desps}"   )
##        message("   DEBUG - AUTO-GENERATED FILE"   )
##        message("   DEBUG - AUTO-GENERATED FILE - task_${service_name}_include: ${task_${service_name}_include}" )
##        message("   DEBUG - AUTO-GENERATED FILE"   )
##        message("   DEBUG - AUTO-GENERATED FILE - task_${service_name}_define:  ${task_${service_name}_define}"  )
##        message("   DEBUG - AUTO-GENERATED FILE"   )
##        message("   DEBUG - AUTO-GENERATED FILE - task_${service_name}_pointer: ${task_${service_name}_pointer}" )
##        message("   -----   ")

        if(NOT EXISTS ${CPP_${service_name}_TBL_DIR_AUTO_GEN})
            message(WARNING "   DEBUG - AUTO-GENERATED FILE - The \"${CPP_${service_name}_TBL_DIR_AUTO_GEN}\" directory does not exist")
            file(MAKE_DIRECTORY  ${CPP_${service_name}_TBL_DIR_AUTO_GEN} )
        endif()

        if(EXISTS ${CPP_${service_name}_TBL_DIR_AUTO_GEN})
            message("   DEBUG - auto-generate procedure - OK - The \"${CPP_${service_name}_TBL_DIR_AUTO_GEN}\" directory has been created")
        else()
            message(FATAL_ERROR "   DEBUG - auto-generate procedure - Some issues occurred in making directory ${CPP_${service_name}_TBL_DIR_AUTO_GEN}")
        endif()

        message("   -----   ")
        execute_process(
    
            COMMAND ${MPFW_CODE_CMAKE_DIR}/scripts/create_tbl_cpp.sh "${task_${service_name}_include}" "${task_${service_name}_define}"

            INPUT_FILE      "${CPP_${service_name}_TBL_TEMPLATE}"
            OUTPUT_FILE     "${CPP_${service_name}_TBL_AUTO_GEN}"
            RESULT_VARIABLE creation_process_result
        )
        if(NOT creation_process_result EQUAL 0)
            message(FATAL_ERROR "   DEBUG - AUTO-GENERATED FILE - creation_process_result: ${creation_process_result}")
        endif()

##        message("   -----   ")
##        message("   DEBUG - get_deps_list - end --> service_name: ${service_name}")
##        message("   DEBUG - AUTO-GENERATED FILE - ***********************************  "   )


        add_custom_command(
            OUTPUT ${CPP_${service_name}_TBL_AUTO_GEN}
            COMMENT "Creating ${CPP_${service_name}_TBL_AUTO_GEN} file ..."
    
            COMMAND cat "${CPP_${service_name}_TBL_TEMPLATE}" | ${MPFW_CODE_CMAKE_DIR}/scripts/create_tbl_cpp.sh "${task_${service_name}_include}" "${task_${service_name}_define}" > "${CPP_${service_name}_TBL_AUTO_GEN}"
    
            DEPENDS ${MPFW_CODE_CMAKE_DIR}/scripts/get_deps_list.sh  ${MPFW_CODE_CMAKE_DIR}/scripts/create_tbl_cpp.sh "${CPP_${service_name}_TBL_TEMPLATE}" ${task_${service_name}_desps}
            VERBATIM
        
        )
    endforeach()

    add_executable_macro                (${MODULE_NAME})

    set_include_directories_macro       (${MODULE_NAME})
    set_target_link_dir_macro           (${MODULE_NAME})
    set_target_link_lib_macro           (${MODULE_NAME})

    message("DEBUG - LIBRARY LINK - TARGET_LIB_LIST:    ${TARGET_LIB_LIST}")

    include(${MPFW_CODE_CMAKE_DIR}/toolchain/${PLATFORM_NAME}/compile_option.cmake )
    include(${MPFW_CODE_CMAKE_DIR}/toolchain/${PLATFORM_NAME}/link_option.cmake )
