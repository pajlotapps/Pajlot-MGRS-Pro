
import UIKit

var mainColor = UIColor.rgb(red: 32, green: 32, blue: 32)
var bgColor = UIColor.rgb(red: 44, green: 44, blue: 44)

/* Latitude bands C..X 8° each, covering 80°S to 84°N */
let latBands = "CDEFGHJKLMNPQRSTUVWXX" // X is repeated for 80-84°N

/* 100km grid square column (‘e’) letters repeat every third zone */
let e100kLetters = ["ABCDEFGH", "JKLMNPQR", "STUVWXYZ"]

/* 100km grid square row (‘n’) letters repeat every other zone */
let n100kLetters = ["ABCDEFGHJKLMNPQRSTUV", "FGHJKLMNPQRSTUVABCDE"]
