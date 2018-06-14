//
//  AvailabilityView.swift
//  Solviant
//
//  Created by Sushil Mishra on 14/06/18.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class AvailabilityView: UIView {

    
    var selectAvailability: ((_ result : AvailabilityStruct?, _ error : Error?)->(Void))?
    
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var availabilityTableView: UITableView!
    struct AvailabilityStruct {
        let title: String!;
        let value: Int;
    }
    
    
    //MARK: - initializer
    
    var availabilityOptions: [AvailabilityStruct] = [
        AvailabilityStruct(title: NSLocalizedString("5_minutes", comment: ""), value: 5),
        AvailabilityStruct(title: NSLocalizedString("10_minutes", comment: ""), value: 10),
        AvailabilityStruct(title: NSLocalizedString("15_minutes", comment: ""), value: 15),
        AvailabilityStruct(title: NSLocalizedString("30_minutes", comment: ""), value: 30)
        
    ]
    
    
    
    // MARK: - Initializer
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // commonInit()
        
        
    }
    
    func configure() {
        availabilityTableView.dataSource = self;
        availabilityTableView.delegate = self;
        availabilityTableView.reloadData()
    }
    
}


extension AvailabilityView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availabilityOptions.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellReuseIdentifier = ReusableIdentifier.timerTableCell
        let timerTableCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! TimerTableCell
        //Configure Cell....
        configure(cell: timerTableCell, indexPath: indexPath)
        
        return timerTableCell
    }
    
    
    func configure(cell: TimerTableCell, indexPath: IndexPath)  {
        // UI configure
        let currentStruct = availabilityOptions[indexPath.row];
        cell.titleLabel.text = currentStruct.title
        cell.selectionStyle = .none
        
    }
    
}



extension AvailabilityView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentStruct = availabilityOptions[indexPath.row];
        if self.selectAvailability != nil{
            self.selectAvailability!(currentStruct, nil)
        }
    }
    
}
