//
//  UIImage.swift
//  setlist
//
//  Created by Benoit Deguine on 31/08/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit

extension UIImage {
    
    func saveImageFromUIImage(_ name:String, myImageToSave:UIImage)->Bool{
        
        let documentsPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let logsPath = documentsPath.appendingPathComponent(App.File.folderName)
        
        if (!FileManager.default.isReadableFile(atPath: logsPath.path)) {
            do {
                try FileManager.default.createDirectory(atPath: logsPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print("Unable to create directory \(error.debugDescription)")
            }
        }
        
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(App.File.folderName + "/" + name + ".jpg")
        return fileManager.createFile(atPath: paths as String, contents: UIImageJPEGRepresentation(myImageToSave, 1), attributes: nil)
    }
    
    func getImageFromName(_ name:String)->UIImage{
        let documentsPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let logsPath = documentsPath.appendingPathComponent(App.File.folderName)
        
        if (FileManager.default.fileExists(atPath: logsPath.path)) {
            let fileManager = FileManager.default
            let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(App.File.folderName + "/" + name + ".jpg")
            
            return UIImage(contentsOfFile: paths as String)!
        } else {
            return UIImage()
        }
        
    }
    
    func takeScreenshoot(_ view:UIView)->UIImage{
        
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return screenshot!
    }
    
}
