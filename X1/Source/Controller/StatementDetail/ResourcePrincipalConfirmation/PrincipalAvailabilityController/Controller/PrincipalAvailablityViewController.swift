//
//  PrincipalAvailablityViewController.swift
//  Solviant
//
//  Created by Sushil Mishra on 14/06/18.
//  Copyright © 2018 AstraQube. All rights reserved.
//

import UIKit

class PrincipalAvailablityViewController: UIViewController {

    //MARK: - Outlets
   
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var timeSlotCollectionView: UICollectionView!
    
    //MARK: - Property
    var durationValue = 15 //static need to change as per requiremnet
    var selectedDate : Date?
    var timeSlots = [String]()
    
    //MARK: - View Life Cycle
    
    override func loadView() {
        super.loadView()
        configureUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: - Actions
    
    @IBAction func confirm(_ sender: Any) {
        
        
        
    }
    
    
    //MARK: - Utility
    
    func configureUI(){
          datePickerView.timeZone = NSTimeZone.local
          datePickerView.backgroundColor = UIColor.white
          datePickerView.datePickerMode = .dateAndTime
          datePickerView.addTarget(self, action: #selector(PrincipalAvailablityViewController.datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    
    //MARK: - Date Picker
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        selectedDate = sender.date
    }
    
    
    //MARK: - actions
    
    @IBAction func selectDate(_ sender: Any) {
        if selectedDate != nil {
            // Create date formatter
            let dateFormatter: DateFormatter = DateFormatter()
            
            // Set date format
            dateFormatter.dateFormat = "E, MMM d, h:mm a"
            
            // Apply date format
            let startDate: String = dateFormatter.string(from: selectedDate!)
            let endDate = selectedDate?.addingTimeInterval(TimeInterval(durationValue * 60))
            let timeFormat : DateFormatter = DateFormatter()
            timeFormat.dateFormat = "h:mm a"
            let endTimeStr: String = timeFormat.string(from: endDate!)
            let timeSlotStr = "\(startDate) - \(endTimeStr)"
            print("end date \(timeSlotStr)")
            
            var isExist = false
            for timeStr in timeSlots {
                if timeStr == timeSlotStr {
                    isExist = true
                    break
                }
            }
            if !isExist {
                timeSlots.append(timeSlotStr)
            }
            
            self.timeSlotCollectionView.reloadData()
        }

    }
    
}

extension PrincipalAvailablityViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.timeSlots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let availabilityCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableIdentifier.availabilityCollectionCell, for: indexPath) as! AvailabilityCollectionCell
        if self.timeSlots.count > 0 {
            availabilityCell.availabilityTimeLabel.text = self.timeSlots[indexPath.item]
            availabilityCell.removeButton.tag = indexPath.item
             availabilityCell.removeButton.addTarget(self, action: #selector(removeItem(sender:)), for: UIControlEvents.touchUpInside)
        }
        
        return availabilityCell
    }
    
    @objc func removeItem(sender : UIButton) {
        self.timeSlots.remove(at: sender.tag)
        self.timeSlotCollectionView.reloadData()

    }
}

extension PrincipalAvailablityViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: (self.timeSlotCollectionView.frame.size.width - 10)/2, height: (self.timeSlotCollectionView.frame.size.height - 10)/2)
    }
    
}

extension PrincipalAvailablityViewController: UICollectionViewDelegate {
    
}
