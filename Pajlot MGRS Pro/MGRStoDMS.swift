//
//  MGRStoLL.swift
//  Pajlot MGRS Pro
//
//  Created by Adam Olechno on 12/01/2019.
//  Copyright © 2019 Adam Olechno. All rights reserved.
//

import UIKit
//import Coordinates

class MGRStoDMS: UIViewController, UITextFieldDelegate {
    
    //MARK: -
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - IBOutlets DECLARATIONS
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var mgrsCoordsDisplayedLabel: UILabel!
    @IBOutlet var inputTextFields: [UITextField]!
    
    @IBOutlet weak var gzd_zoneTextField: UITextField!// zone 6° (1..60 - 180°W..180°E).
    @IBOutlet weak var gzd_bandTextField: UITextField!// band 8°(C..X - 80°S..84°N).
    
    @IBOutlet weak var e100kmTextField: UITextField!
    @IBOutlet weak var n100kmTextField: UITextField!
    @IBOutlet weak var eastingTextField: UITextField!
    @IBOutlet weak var northingTextField: UITextField!
    
    @IBOutlet weak var clearButton: CustomButton!
    
    var storedLatLon: LatLon?
    
    //MARK: - LIFECYCLE
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.endEditing(true)
    }
    
    //MARK: - IBActions DECLARATIONS
    @IBAction func gzd_zoneInfoDidTap(_ sender: Any) {
        Service.shared.showAlert(on: self, style: .alert , title: "Grid Zone Designator", message: "6° longitudinal zone \n The value must be from 1 to 60 \n which is covering 180°W - 180°E")
    }
    
    @IBAction func gzd_bandInfoDidTap(_ sender: Any) {
        Service.shared.showAlert(on: self, style: .alert , title: "Grid Zone Designator", message: "8° latitudinal band \n The value must be one from \n\n CDEFGHJKLMNPQRSTUVWX \n\n (C..X covering 80°S - 84°N)")
    }
    
    @IBAction func sqIDInfoDidTap(_ sender: Any) {
        Service.shared.showAlert(on: self, style: .alert , title: "Square ID", message: "Two-letter ID for 100km square. \n First letter must be from \n\n ABCDEFGH, JKLMNPQR, STUVWXYZ\n(depending on the selected zone)\n\n second letter must be from  \n\n ABCDEFGHJKLMNPQRSTUV\n (depending on the selected band)")
    }
    
    @IBAction func eastingInfoDidTap(_ sender: Any) {
        // Number of digits to display for x,y coords
        //  One digit:    10 km precision      eg. "18S UJ 2 1"
        //  Two digits:   1 km precision       eg. "18S UJ 23 06"
        //  Three digits: 100 meters precision eg. "18S UJ 234 064"
        //  Four digits:  10 meters precision  eg. "18S UJ 2348 0647"
        //  Five digits:  1 meter precision    eg. "18S UJ 23480 06470"
        
        Service.shared.showAlert(on: self, style: .alert , title: "Easting Info", message: "Easting in metres within 100km grid square. \n\n One digit: 10 km precision \n Two digits: 1 km precision \nThree digits: 100 meters precision\nFour digits:  10 meters precision\nFive digits:  1 meter precision")
    }
    
    @IBAction func northingInfoDidTap(_ sender: Any) {
        Service.shared.showAlert(on: self, style: .alert , title: "Northing Info", message: "Northing in metres within 100km grid square. \n\n One digit: 10 km precision \n Two digits: 1 km precision \nThree digits: 100 meters precision\nFour digits:  10 meters precision\nFive digits:  1 meter precision ")
    }
    
    
    @IBAction func calculateLLDidTap(_ sender: Any) {
        convertToLL()
        //resultLabel.alpha = 1.0
        
    }
    @IBAction func clearResultsDidTap(_ sender: Any) {
        clearDisplay()
    }
    
    
    //MARK: - FUNCTIONS
    func updateView() {
        setPlaceholders()
        inputTextFields.forEach { (textfield) in
            textfield.delegate = self
            textfield.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        }
        
        clearButton.alpha = 0.0
        resultLabel.alpha = 0.0
        mgrsCoordsDisplayedLabel.alpha = 0.0
    }
    
    func clearDisplay(){
        resultLabel.alpha = 0.0
        mgrsCoordsDisplayedLabel.alpha = 0.0
        setPlaceholders()
        
        inputTextFields.forEach { (textfield) in
            textfield.text = ""
        }
        
        storedLatLon = nil
        view.endEditing(true)
    }
    
    func setPlaceholders() {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font : UIFont(name: "Avenir-book", size: 10)!
        ]
        
        for item in inputTextFields {
            item.tintColor = UIColor.clear
        }
        
        gzd_zoneTextField.attributedPlaceholder = NSAttributedString(string: "< _ _ >", attributes: attributes)
        gzd_bandTextField.attributedPlaceholder = NSAttributedString(string: "< _ >", attributes: attributes)
        e100kmTextField.attributedPlaceholder = NSAttributedString(string: "< _ >", attributes: attributes)
        n100kmTextField.attributedPlaceholder = NSAttributedString(string: "< _ >", attributes: attributes)
        eastingTextField.attributedPlaceholder = NSAttributedString(string: "< _ _ _ _ _ >", attributes: attributes)
        northingTextField.attributedPlaceholder = NSAttributedString(string: "< _ _ _ _ _ >", attributes: attributes)
    }
    
    
    
    func convertToLL() {
        guard let gzd_zone = gzd_zoneTextField.text else { return }
        guard let gzd_band = gzd_bandTextField.text else { return }
        guard let e100km = e100kmTextField.text else { return }
        guard let n100km = n100kmTextField.text else { return }
        guard let easting = eastingTextField.text else { return }
        guard let northing = northingTextField.text else { return }
        
        let mgrsEntered = String(gzd_zone + gzd_band + e100km + n100km + easting + northing)
        
        print("mgrsEntered: \(mgrsEntered)")
        
        if mgrsEntered.count >= 7 {
            //if let mgrsEntered = mgrsConcatenate, mgrsEntered.count > 0 {
            do{
                let mgrs = try Mgrs.parse(fromString: mgrsEntered)
                print("mgrs: \(mgrs)")
                
                let utm = try mgrs.toUTM()
                print("utm: \(utm)")
                
                let latLon = utm.toLatLonE()
                print("latLon: \(latLon)")
                
                mgrsCoordsDisplayedLabel.text = mgrs.toString(precision: 5)
                
                resultLabel.alpha = 1.0
                mgrsCoordsDisplayedLabel.alpha = 1.0
                
                resultLabel.text = latLon.toString(format: .degreesMinutesSeconds, decimalPlaces: 4)
                clearButton.alpha = 1.0
                
                storedLatLon = latLon
                view.endEditing(true)
            }
            catch MgrsError.invalidFormat(let format) {
                displayAlertController(msg: format, thrower: .mgrs)
                return
            }
            catch MgrsError.invalidGrid(let grid) {
                displayAlertController(msg: grid, thrower: .mgrs)
                return
            }
            catch MgrsError.invalidZone(let zone) {
                displayAlertController(msg: zone, thrower: .mgrs)
                return
            }
            catch MgrsError.invalidBand(let band) {
                displayAlertController(msg: band, thrower: .mgrs)
                return
            }
            catch MgrsError.invalidEasting(let easting) {
                displayAlertController(msg: easting, thrower: .mgrs)
                return
            }
            catch MgrsError.invalidNorthing(let northing) {
                displayAlertController(msg: northing, thrower: .mgrs)
                return
            }
            catch UtmError.badLatLon(let err) {
                displayAlertController(msg: err, thrower: .utm )
                return
            }
            catch UtmError.invalidEasting(let easting) {
                displayAlertController(msg: easting, thrower: .utm)
                return
            }
            catch UtmError.invalidNorthing(let northing) {
                displayAlertController(msg: northing, thrower: .utm)
                return
            }
            catch UtmError.invalidZone(let zone) {
                displayAlertController(msg: zone, thrower: .utm)
                return
            }
            catch {
                displayAlertController(msg: "Unknown error occurred", thrower: .unk )
                return
            }
        } else {
            displayAlertController(msg: "Invalid MGRS Entered", thrower: .unk)
        }
    }
    
    func displayAlertController(msg: String, thrower: errorOrigin) {
        let title: String
        switch thrower{
        case .mgrs:
            title = "Error Converting to MGRS"
        case .utm:
            title = "Error Converting to UTM"
        case .latLon:
            title = "Error Converting to Lat Lon"
        case .unk:
            title = "Error"
        }
        
        Service.shared.showAlert(on: self, style: .alert, title: title, message: msg)
        
    }
    
    enum errorOrigin: Error{
        case mgrs
        case utm
        case latLon
        case unk
    }
    
    
    // MARK: - TEXTFIELDS SECTION
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var maxLength = 0
        
        switch textField {
        case gzd_zoneTextField:
            maxLength = 2
        case gzd_bandTextField:
            maxLength = 1
        case e100kmTextField:
            maxLength = 1
        case n100kmTextField:
            maxLength = 1
        case eastingTextField:
            maxLength = 5
        case northingTextField:
            maxLength = 5
        default:
            break
        }
        
        guard let text = textField.text else { return true }
        let count = text.count + string.count - range.length
        return count <= maxLength
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        //        textField.resignFirstResponder()
//        //        return true
//
//        switch textField {
//        case gzd_zoneTextField:
//            gzd_bandTextField.becomeFirstResponder()
//        case gzd_bandTextField:
//            e100kmTextField.becomeFirstResponder()
//        case e100kmTextField:
//            n100kmTextField.becomeFirstResponder()
//        case n100kmTextField:
//            eastingTextField.becomeFirstResponder()
//        case eastingTextField:
//            northingTextField.becomeFirstResponder()
//        case northingTextField:
//            textField.resignFirstResponder()
//        default:
//            textField.resignFirstResponder()
//        }
//        return false
//    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        switch textField {
        case gzd_zoneTextField:
            if textField.text?.utf16.count == 2 {
                gzd_bandTextField.becomeFirstResponder()
            }
        case gzd_bandTextField:
            if textField.text?.utf16.count == 1 {
                e100kmTextField.becomeFirstResponder()
            }
        case e100kmTextField:
            if textField.text?.utf16.count == 1 {
                n100kmTextField.becomeFirstResponder()
            }
        case n100kmTextField:
            if textField.text?.utf16.count == 1 {
                eastingTextField.becomeFirstResponder()
            }
        case eastingTextField:
            if textField.text?.utf16.count == 5 {
                northingTextField.becomeFirstResponder()
            }
        case northingTextField:
            if textField.text?.utf16.count == 5 {
                textField.resignFirstResponder()
            }
        default:
            break
        }
    }
}
