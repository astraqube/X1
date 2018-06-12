//
//  TimerView.swift
//  Solviant
//
//  Created by Sushil Mishra on 11/06/18.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class TimerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var selectTimer: ((_ result : TimerStruct?, _ error : Error?)->(Void))?

    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var timerTableView: UITableView!
    struct TimerStruct {
        let title: String!;
        let value: Int;
    }
    
    
    //MARK: - initializer
    
    var timerOptions: [TimerStruct] = [
        TimerStruct(title: NSLocalizedString("5_minutes", comment: ""), value: 5),
        TimerStruct(title: NSLocalizedString("10_minutes", comment: ""), value: 10),
        TimerStruct(title: NSLocalizedString("15_minutes", comment: ""), value: 15),
        TimerStruct(title: NSLocalizedString("30_minutes", comment: ""), value: 30)

    ]
    
    
    
    // MARK: - Initializer
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       // commonInit()
        
      
    }
    
   func configure() {
        timerTableView.dataSource = self;
        timerTableView.delegate = self;
        timerTableView.reloadData()
    }
    
}


extension TimerView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerOptions.count
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
        let currentStruct = timerOptions[indexPath.row];
        cell.titleLabel.text = currentStruct.title
        cell.selectionStyle = .none
        
    }
    
}



extension TimerView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentStruct = timerOptions[indexPath.row];
        if self.selectTimer != nil{
            self.selectTimer!(currentStruct, nil)
        }
    }
    
}


