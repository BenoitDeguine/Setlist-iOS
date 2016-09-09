//
//  UIImage.swift
//  setlist
//
//  Created by Benoit Deguine on 31/08/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit

extension UIImage {
    
    func saveImageFromUIImage(name:String, myImageToSave:UIImage)->Bool{
        
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
        let logsPath = documentsPath.URLByAppendingPathComponent(App.File.folderName)
        
        if (!NSFileManager.defaultManager().isReadableFileAtPath(logsPath.path!)) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(logsPath.path!, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("Unable to create directory \(error.debugDescription)")
            }
        }
        
        let fileManager = NSFileManager.defaultManager()
        let paths = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent(App.File.folderName + "/" + name + ".jpg")
        return fileManager.createFileAtPath(paths as String, contents: UIImageJPEGRepresentation(myImageToSave, 1), attributes: nil)
    }
    
    func getImageFromName(name:String)->UIImage{
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0])
        let logsPath = documentsPath.URLByAppendingPathComponent(App.File.folderName)
        
        if (NSFileManager.defaultManager().fileExistsAtPath(logsPath.path!)) {
            let fileManager = NSFileManager.defaultManager()
            let paths = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent(App.File.folderName + "/" + name + ".jpg")
            
            return UIImage(contentsOfFile: paths as String)!
        } else {
            return UIImage()
        }
        
    }
    
    func takeScreenshoot(view:UIView)->UIImage{
        
        let layer = UIApplication.sharedApplication().keyWindow!.layer
        let scale = UIScreen.mainScreen().scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshot
    }
    
}
