
import UIKit
import Darwin

class LLtoGRS: UIViewController {
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var outputLbl: UILabel!
    @IBOutlet weak var latitudeLbl: UILabel!
    @IBOutlet weak var latitudeDirection: UISegmentedControl!
    @IBOutlet weak var longitudeLbl: UILabel!
    @IBOutlet weak var longitudeDirection: UISegmentedControl!
    @IBOutlet weak var calculateBtnLbl: CustomButton!
    
    @IBOutlet var tfCollection: [UITextField]!
    @IBOutlet weak var latDDTF: UITextField!
    @IBOutlet weak var latMMTF: UITextField!
    @IBOutlet weak var latSSTF: UITextField!
    
    @IBOutlet weak var longDDTF: UITextField!
    @IBOutlet weak var longMMTF: UITextField!
    @IBOutlet weak var longSSTF: UITextField!
    
    var latDirection = "N"
    var latitudeDD = 0
    var latitudeMM = 0
    var latitudeSS = 0
    
    var longDirection = "E"
    var longitudeDD = 0
    var longitudeMM = 0
    var longitudeSS = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        setPlaceholders()
    }
    
    @IBAction func latDD(_ sender: Any) {
        if latDDTF.text?.count != 0 {
            if let val = latDDTF.text {
                if Int(val)! < 90 {
                    latitudeDD = Int(val)!
                }else{
                    latitudeDD = 89
                    latDDTF.text = "89"
                    latitudeMM = 59
                    latMMTF.text = "59"
                    latitudeSS = 59
                    latSSTF.text = "59"
                }
            }
        }else{
            latitudeDD = 0
            latDDTF.text = "0"
        }
        globalFunctions().hideKeyboard(tf: latDDTF)
    }
    
    
    @IBAction func latMM(_ sender: Any) {
        if latMMTF.text?.count != 0 {

            if let val = latMMTF.text {
                if Int(val)! < 60 {
                    latitudeMM = Int(val)!
                }else{
                    latitudeMM = 59
                    latMMTF.text = "59"
                }
            }
        }else{
            latitudeMM = 0
            latMMTF.text = "0"
        }
        globalFunctions().hideKeyboard(tf: latMMTF)
    }
    
    @IBAction func latSS(_ sender: Any) {
        if latSSTF.text?.count != 0 {

            if let val = latSSTF.text {
                if Int(val)! < 60 {
                    latitudeSS = Int(val)!
                }else{
                    latitudeSS = 59
                    latSSTF.text = "59"
                }
            }
        }else{
            latitudeSS = 0
            latSSTF.text = "0"

        }
        globalFunctions().hideKeyboard(tf: latSSTF)
    }
    
    @IBAction func longDD(_ sender: Any) {
        if longDDTF.text?.count != 0 {
            if let val = longDDTF.text {

                if Int(val)! < 180 {
                    longitudeDD = Int(val)!
                }else{
                    longitudeDD = 179
                    longDDTF.text = "179"
                    longitudeMM = 59
                    longMMTF.text = "59"
                    longitudeSS = 59
                    longSSTF.text = "59"
                }
            }
            if let val = longDDTF.text {
                longitudeDD = Int(val)!
                }
        }else{
            longitudeDD = 0
            longDDTF.text = "0"

        }
        globalFunctions().hideKeyboard(tf: longDDTF)
    }
    
    @IBAction func longMM(_ sender: Any) {
        if longMMTF.text?.count != 0 {

            if let val = longMMTF.text {
                if Int(val)! < 60 {
                    longitudeMM = Int(val)!
                }else{
                    longitudeMM = 59
                    longMMTF.text = "59"
                }
            }
        }else{
            longitudeMM = 0
            longMMTF.text = "0"

        }
        globalFunctions().hideKeyboard(tf: longMMTF)
    }
    
    @IBAction func longSS(_ sender: Any) {
        if longSSTF.text?.count != 0 {

            if let val = longSSTF.text {
                if Int(val)! < 60 {
                    longitudeSS = Int(val)!
                }else{
                    longitudeSS = 59
                    longSSTF.text = "59"
                }
            }
        }else{
            longitudeSS = 0
            longSSTF.text = "0"

        }
        globalFunctions().hideKeyboard(tf: longSSTF)
    }
    
    @IBAction func calculateDidTap(_ sender: Any) {
        let latitude = globalFunctions().dmsDecimal(dd: latitudeDD, mm: latitudeMM, ss: latitudeSS, direction: latDirection)
        let longitude = globalFunctions().dmsDecimal(dd: longitudeDD, mm: longitudeMM, ss: longitudeSS, direction: longDirection)
        outputLbl.text = MGRSString(Lat: latitude, Long: longitude)
    }
    
    @IBAction func latDirSelector(_ sender: Any) {
        let val = latitudeDirection.selectedSegmentIndex
        if val == 0 {
            latDirection = "N"
        }else{
            latDirection = "S"
        }
    }
    
    @IBAction func lonDirSelector(_ sender: Any) {
        let val = longitudeDirection.selectedSegmentIndex
        if val == 0 {
            longDirection = "E"
        }else{
            longDirection = "W"
        }
    }
    
    func setPlaceholders() {
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.font : UIFont(name: "Avenir-book", size: 10)!
        ]
        
        for item in tfCollection {
            item.tintColor = UIColor.clear
        }

        latDDTF.attributedPlaceholder = NSAttributedString(string: "<dd>", attributes: attributes)
        longDDTF.attributedPlaceholder = NSAttributedString(string: "<dd>", attributes: attributes)
        latMMTF.attributedPlaceholder = NSAttributedString(string: "<mm>", attributes: attributes)
        longMMTF.attributedPlaceholder = NSAttributedString(string: "<mm>", attributes: attributes)
        latSSTF.attributedPlaceholder = NSAttributedString(string: "<ss>", attributes: attributes)
        longSSTF.attributedPlaceholder = NSAttributedString(string: "<ss>", attributes: attributes)
    }


    
    func MGRSString (Lat: Double, Long: Double) -> String {
        
        var output = ""
        
        if (Lat < -80) {
            output = "To far South"
            return output
        }else if (Lat > 84){
            output = "To far North"
            return output

        }else{
            let c = 1 + floor((Long + 180) / 6)
            let e = c * 6 - 183
            let k = Lat * Double.pi / 180
            let l = Long * Double.pi / 180
            let m = e * Double.pi / 180
            let n = cos(k)
            let o = 0.006739496819936062 * pow(n, 2)
            let p = 40680631590769 / (6356752.314 * (1 + o).squareRoot())
            let q = tan(k)
            let r = pow(q, 2)
            //let s = pow(r, 3) - pow(q, 6)
            let t = l - m
            let u = 1.0 - r + o
            let v = 5.0 - r + 9 * o + 4.0 * pow(o, 2)
            let w = 5.0 - 18.0 * r + pow(r, 2) + 14.0 * o - 58.0 * r * o
            
            let x = 61.0 - 58.0 * r + pow(r, 2) + 270.0 * o - 330.0 * r * o
            let y = 61.0 - 479.0 * r + 179.0 * pow(r,2) - pow(r, 3)
            let z = 1385.0 - 3111.0 * r + 543.0 * pow(r,2) - pow(r, 3)
            
            var aa = p * n * t + (p / 6.0 * pow(n, 3) * u * pow(t, 3)) + (p/120.0 * pow(n, 5) * w * pow(t, 5)) + (p / 5040.0 * pow(n, 7) * y * pow(t, 7))
            var ab = 6367449.14570093 * (k - (0.00251882794504 * sin(2 * k)) + (0.00000264354112 * sin(4 * k)) - (0.00000000345262 * sin(6 * k)) + (0.000000000004892 * sin (8 * k))) + (q / 2.0 * p * pow(n, 2) * pow(t, 2)) + (q / 24.0 * p * pow(n, 4) * v * pow(t,4)) + (q / 720.0 * p * pow(n, 6) * x * pow(t, 6)) + (q / 40320.0 * p * pow(n, 8) * z * pow(t, 8))
            aa = aa * 0.9996 + 500000.0
            
            ab = ab * 0.9996
            if (ab < 0.0){
              ab += 10000000.0
            }
            
            let ad = "CDEFGHJKLMNPQRSTUVWXX".charAt(at: Int(floor(Lat / 8 + 10)))
            
            let ae = floor(aa / 100000)
            var afArray = ["ABCDEFGH", "JKLMNPQR", "STUVWXYZ"]
            let afIndex = (c-1).truncatingRemainder(dividingBy: 3)
            let afString = afArray[Int(afIndex)]
            let af = afString.charAt(at: Int(ae-1))
    
            let ag = floor(ab / 100000).truncatingRemainder(dividingBy: 20)
            let ahArray = ["ABCDEFGHJKLMNPQRSTUV","FGHJKLMNPQRSTUVABCDE"]
            let ahIndex = (c-1).truncatingRemainder(dividingBy: 2)
            let ahString = ahArray[Int(ahIndex)]
            let ah = ahString.charAt(at: Int(ag))
    
            
            aa = floor(aa.truncatingRemainder(dividingBy: 100000))
            let aaString = pad(val: aa)
            
            ab = floor(ab.truncatingRemainder(dividingBy: 100000))
            let abString = pad(val: ab)
            
            let cClean = c.cleanValue
            
            let MGRS = "\(cClean)\(ad) \(af)\(ah) \(aaString) \(abString)"
            output = MGRS
            return output
        }
    }
    
    func pad (val: Double) -> String {
        
        var output: String
        let valClean = val.cleanValue
        if (val < 10) {
            output = "0000\(valClean)"
            return output
        }else if (val < 100) {
            output = "000\(valClean)"
            return output

        }else if (val < 1000) {
            output = "00\(valClean)"
            return output
        }else if (val < 10000) {
            output = "0\(valClean)"
            return output
        }else{
            output = "\(valClean)"
            return output
        }
    }
}

