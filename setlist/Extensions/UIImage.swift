//
//  UIImage.swift
//  setlist
//
//  Created by Benoit Deguine on 31/08/2016.
//  Copyright © 2016 Benoit Deguine. All rights reserved.
//

import UIKit

extension UIImage {
    
    func saveImage(name:String, myImageToSave:UIImage){

        let fileManager = NSFileManager.defaultManager()
        let paths = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent(name)
        print(paths)
        fileManager.createFileAtPath(paths as String, contents: UIImageJPEGRepresentation(myImageToSave, 1), attributes: nil)
    
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
        }else{
            print("No Image")
            return UIImage()
        }
    }
    
}
