//  *******************************************************************************
//  
//  mpfw / fw2 - Multi Platform FirmWare FrameWork 
//      library that contains the "main" entry point and, 
//      eventualy, application code that is platform dependent
//  Copyright (C) (2023) Marco Dau
//  
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Affero General Public License as published
//  by the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//  
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Affero General Public License for more details.
//  
//  You should have received a copy of the GNU Affero General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//  
//  You can contact me by the following email address
//  marco <d o t> ing <d o t> dau <a t> gmail <d o t> com
//  
//  *******************************************************************************
/*
 * krInitStaticTbl_template.cpp
 *
 *  Created on: July, 22nd 2025 (Tue)
 *      Author: Marco Dau
 */


   //   ->> #include modules here ... <<-
#include "Xtest1.h"
#include "Xtest2.h"
#include "Xtest3.h"


namespace fw2 { namespace core { namespace core {

krInitStaticTbl::InitFunction_t krInitStaticTbl::krInitStaticPtrArrayBis[] = {
    
    //   ->> list of pointer function here ... <<-
        PTR_TASK_OF_krThread_000_task0
        PTR_TASK_OF_krThread_001_task1
        PTR_TASK_OF_krThread_002_task2
        PTR_TASK_OF_krThread_003_task3

	nullptr
};

} } }	// namespace fw2::core::core

