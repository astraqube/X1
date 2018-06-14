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
    @IBOutlet weak var timeSlotPickerView: UIPickerView!
    @IBOutlet weak var timeSlotCollectionView: UICollectionView!
    
    
    //MARK: - View Life Cycle
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
          datePickerView.datePickerMode = .date
          datePickerView.addTarget(self, action: #selector(PrincipalAvailablityViewController.datePickerValueChanged(_:)), for: .valueChanged)
    }
    
    
    //MARK: - Date Picker
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MMM-dd-yyyy"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        print("Selected value \(selectedDate)")
    }
    
}

extension PrincipalAvailablityViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 24
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing: (row+1));
    }
    
}
extension PrincipalAvailablityViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

extension PrincipalAvailablityViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let availabilityCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableIdentifier.availabilityCollectionCell, for: indexPath) as! AvailabilityCollectionCell
        return availabilityCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 100, height: 30)
    }
    
    
}
extension PrincipalAvailablityViewController: UICollectionViewDelegate {
    
}
