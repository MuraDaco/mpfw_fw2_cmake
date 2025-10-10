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
#   cmake_check_src_ver_n_dir.cmake
#
#   Created on: June, 16th 2025  (Thu)
#   Author: Marco Dau
##
### ---------------------------

    if(NOT ${CMAKE_SRC_VER})
        set(CMAKE_SRC_VER       ${CMAKE_SRC_VER_MODULE})
    else()

        if(NOT ${CMAKE_SRC_VER} STREQUAL ${CMAKE_SRC_VER_MODULE})
            message(SEND_ERROR "CMAKE_SRC_VER (${CMAKE_SRC_VER}) variable is already set but is not equal to CMAKE_SRC_VER_MODULE (${CMAKE_SRC_VER_MODULE}) the CMAKE_SRC_VER associated to current module")
        endif()

    endif()

    set(MPFW_CODE_CMAKE_DIR     ${MPFW_CODE_DIR}/cmake/mpfw_fw2_cmake/v_${CMAKE_SRC_VER} )
