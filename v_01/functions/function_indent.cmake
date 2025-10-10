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
#   function_indent.cmake
#
#   Created on: June,  2nd 2025  (Mon)
#   Author: Marco Dau
##
### ---------------------------

include_guard()

    set(MPFW_TRACE_FILE_INDENT      0)

    macro(set_indent_begin)
        MATH(EXPR MPFW_TRACE_FILE_INDENT "${MPFW_TRACE_FILE_INDENT}+1")    
        string(REPEAT "    " ${MPFW_TRACE_FILE_INDENT} INDENT_STRING)
    endmacro()

    macro(set_indent_end)
        MATH(EXPR MPFW_TRACE_FILE_INDENT "${MPFW_TRACE_FILE_INDENT}-1")    
    endmacro()
