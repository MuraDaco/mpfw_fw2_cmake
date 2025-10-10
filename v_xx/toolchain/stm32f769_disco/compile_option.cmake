#   *******************************************************************************
#   
#   mpfw / fw2 - Multi Platform FirmWare FrameWork
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
target_compile_definitions(${EXECUTABLE} PRIVATE
    #-DDEBUG 
    -DNDEBUG
    -DUSE_HAL_DRIVER 
    -DSTM32F769xx
    #-DUSE_STM32F7469I_DISCO 
    -DRS485_ADDRESS=0x36
)

target_compile_options(${EXECUTABLE} PRIVATE
    -mcpu=cortex-m7 
    #-g3 
    -c 

    $<IF:$<COMPILE_LANG_AND_ID:ASM,GNU>, -x assembler-with-cpp ,                                                     >
    $<IF:$<COMPILE_LANG_AND_ID:C,GNU>,   -std=gnu11   -Os -ffunction-sections -fdata-sections -Wall -fstack-usage,   >
    $<IF:$<COMPILE_LANG_AND_ID:CXX,GNU>, -std=gnu++14 -Os -ffunction-sections -fdata-sections -Wall -fstack-usage,   >
    $<IF:$<COMPILE_LANG_AND_ID:CXX,GNU>, -fno-rtti -fno-exceptions -fno-use-cxa-atexit,                              >

    --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb 
)

