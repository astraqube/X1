//
//  PriorityView.swift
//  Solviant
//
//  Created by Sushil Mishra on 14/06/18.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class PriorityView: UIView {

    var selectPriority: ((_ result : PriorityStruct?, _ error : Error?)->(Void))?
    
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var priorityTableView: UITableView!
    struct PriorityStruct {
        let title: String!;
        let value: Int;
    }
    
    
    //MARK: - initializer
    // TODO: Change as per need

    
    var priorityOptions: [PriorityStruct] = [
        PriorityStruct(title: "Priority 1", value: 5),
        PriorityStruct(title: "Priority 2", value: 10),
        PriorityStruct(title: "Priority 3", value: 15),
        PriorityStruct(title: "Priority 4", value: 30)
        
    ]
    
    
    
    // MARK: - Initializer
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // commonInit()
        
        
    }
    
    func configure() {
        priorityTableView.dataSource = self;
        priorityTableView.delegate = self;
        priorityTableView.reloadData()
    }
    
}


extension PriorityView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return priorityOptions.count
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
        let currentStruct = priorityOptions[indexPath.row];
        cell.titleLabel.text = currentStruct.title
        cell.selectionStyle = .none
        
    }
    
}



extension PriorityView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentStruct = priorityOptions[indexPath.row];
        if self.selectPriority != nil{
            self.selectPriority!(currentStruct, nil)
        }
    }
    
}
