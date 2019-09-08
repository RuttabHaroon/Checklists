//
//  ChecklistItem.swift
//  Checklists
//
//  Created by RUTTAB on 8/11/19.
//  Copyright © 2019 RUTTAB. All rights reserved.
//

import Foundation

class ChecklistItem {
    var text = ""
    var checked = false
    
    func toggleChecked() {
        checked = !checked
    }
}
