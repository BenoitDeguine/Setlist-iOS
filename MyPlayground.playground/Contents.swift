import UIKit


let dateFormatter = NSDateFormatter()
dateFormatter.dateStyle = .ShortStyle
dateFormatter.timeStyle = .ShortStyle
dateFormatter.doesRelativeDateFormatting = true

let date = NSDate()
let dateString = dateFormatter.stringFromDate(date)