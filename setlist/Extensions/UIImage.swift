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
    
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func getImageFromName(name:String)->UIImage{
        let fileManager = NSFileManager.defaultManager()
        let imagePAth = (self.getDirectoryPath() as NSString).stringByAppendingPathComponent(name)
        if fileManager.fileExistsAtPath(imagePAth){
            return UIImage(contentsOfFile: imagePAth)!
        } else {
            print("No Image")
            return UIImage()
        }
    }
    
}
