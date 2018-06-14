//
//  ChangeLocationView.swift
//  Solviant
//
//  Created by Sushil Mishra on 14/06/18.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class ChangeLocationView: UIView {

    var selectLocation: ((_ result : LocationStruct?, _ error : Error?)->(Void))?
    
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var locationTableView: UITableView!
    struct LocationStruct {
        let title: String!;
        let value: Int;
    }
    
    
    //MARK: - initializer
    
    var locationOptions: [LocationStruct] = [
        LocationStruct(title: NSLocalizedString("5_minutes", comment: ""), value: 5),
        LocationStruct(title: NSLocalizedString("10_minutes", comment: ""), value: 10),
        LocationStruct(title: NSLocalizedString("15_minutes", comment: ""), value: 15),
        LocationStruct(title: NSLocalizedString("30_minutes", comment: ""), value: 30)
        
    ]
    
    
    
    // MARK: - Initializer
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // commonInit()
        
        
    }
    
    func configure() {
        locationTableView.dataSource = self;
        locationTableView.delegate = self;
        locationTableView.reloadData()
    }
    
}


extension ChangeLocationView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationOptions.count
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
        let currentStruct = locationOptions[indexPath.row];
        cell.titleLabel.text = currentStruct.title
        cell.selectionStyle = .none
        
    }
    
}



extension ChangeLocationView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentStruct = locationOptions[indexPath.row];
        if self.selectLocation != nil{
            self.selectLocation!(currentStruct, nil)
        }
    }
    
}
