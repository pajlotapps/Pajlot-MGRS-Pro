

import UIKit

class globalFunctions: UIViewController {

    @objc func hideKeyboard(tf: UITextField) {
        tf.resignFirstResponder()        
    }
    
    func dmsDecimal (dd: Int, mm: Int, ss: Int, direction: String) -> Double {
        let sign = (direction == "W" || direction == "S") ? -1.0 : 1.0
        let ddDecimal =  sign * (Double(dd) + Double(mm) / 60 + Double(ss) / 3600)
        return ddDecimal
    }
    
    
    func LatLongFromMGRSstring (a: String) {
    var b = a.trim()
        
        
        if b.contains(find: "S"){
            b = "S"
        }else{
            b = ""
        }
        
        
        if (b.isEmpty || b.count != 4){
            
        }
        /*
    var c = (b[0].length < 3) ? b[0][0] : b[0].slice(0,2);
    var d = (b[0].length < 3) ? b[0][1] : b[0][2];
    var e = (c*6-183)*Math.PI / 180;
    var f = ["ABCDEFGH","JKLMNPQR","STUVWXYZ"][(c-1) % 3].indexOf(b[1][0]) + 1;
    var g = "CDEFGHJKLMNPQRSTUVWXX".indexOf(d);
    var h = ["ABCDEFGHJKLMNPQRSTUV","FGHJKLMNPQRSTUVABCDE"][(c-1) % 2].indexOf(b[1][1]);
    var i = [1.1,2.0,2.8,3.7,4.6,5.5,6.4,7.3,8.2,9.1,0,0.8,1.7,2.6,3.5,4.4,5.3,6.2,7.0,7.9];
    var j = [0,2,2,2,4,4,6,6,8,8,0,0,0,2,2,4,4,6,6,6];
    var k = i[g];
    var l = Number(j[g]) + h / 10;
    if (l < k) l += 2;
    var m = f*100000.0 + Number(b[2]);
    var n = l*1000000 + Number(b[3]);
    m -= 500000.0;
    if (d < 'N') n -= 10000000.0;
    m /= 0.9996; n /= 0.9996;
    var o = n / 6367449.14570093;
    var p = o + (0.0025188266133249035*Math.sin(2.0*o)) + (0.0000037009491206268*Math.sin(4.0*o)) + (0.0000000074477705265*Math.sin(6.0*o)) + (0.0000000000170359940*Math.sin(8.0*o));
    var q = Math.tan(p);
    var r = q*q;
    var s = r*r;
    var t = Math.cos(p);
    var u = 0.006739496819936062*Math.pow(t,2);
    var v = 40680631590769 / (6356752.314*Math.sqrt(1 + u));
    var w = v;
    var x = 1.0 / (w*t); w *= v;
    var y = q / (2.0*w); w *= v;
    var z = 1.0 / (6.0*w*t); w *= v;
    var aa = q / (24.0*w); w *= v;
    var ab = 1.0 / (120.0*w*t); w *= v;
    var ac = q / (720.0*w); w *= v;
    var ad = 1.0 / (5040.0*w*t); w *= v;
    var ae = q / (40320.0*w);
    var af = -1.0-u;
    var ag = -1.0-2*r-u;
    var ah = 5.0 + 3.0*r + 6.0*u-6.0*r*u-3.0*(u*u)-9.0*r*(u*u);
    var ai = 5.0 + 28.0*r + 24.0*s + 6.0*u + 8.0*r*u;
    var aj = -61.0-90.0*r-45.0*s-107.0*u + 162.0*r*u;
    var ak = -61.0-662.0*r-1320.0*s-720.0*(s*r);
    var al = 1385.0 + 3633.0*r + 4095.0*s + 1575*(s*r);
    var lat = p + y*af*(m*m) + aa*ah*Math.pow(m,4) + ac*aj*Math.pow(m,6) + ae*al*Math.pow(m,8);
    var lng = e + x*m + z*ag*Math.pow(m,3) + ab*ai*Math.pow(m,5) + ad*ak*Math.pow(m,7);
    lat = lat*180 / Math.PI;
    lng = lng*180 / Math.PI;
    return [true,lat,lng];
    */
    }
 
    
}
