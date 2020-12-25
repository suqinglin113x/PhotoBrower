//
//  TCSubmitTravelTripInfoCell.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/12/24.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

/// 出行人两种cell
 enum TravelTripInfoCellIdentity: Int {
    case one
    case two
}
class TCSubmitTravelTripInfoCell: UITableViewCell {

    var currentVC: UIViewController?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    static func cellForIdentity(tableView: UITableView, identity: TravelTripInfoCellIdentity) -> TCSubmitTravelTripInfoCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "\(identity)") as? TCSubmitTravelTripInfoCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("TCSubmitTravelTripInfoCell", owner: self, options: nil)?[identity.rawValue] as? TCSubmitTravelTripInfoCell
            
        }
        
        return cell ?? TCSubmitTravelTripInfoCell()
        
    }
    
    
}
