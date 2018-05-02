//
//  FileOperation.swift
//  indeclap
//
//  Created by Huulke on 12/13/17.
//  Copyright © 2017 Huulke. All rights reserved.
//

import UIKit

class FileOperation: NSObject {
    
    // MARK: Directory Operation
    
    /**
     Create directory at the given path.
     
     - Parameter dbPath: Absolute path for thh directory to be created.
     
     - Returns: true of created successfully else false.
     */
    func createDirectoryAtPath(dbPath:String) -> Bool {
        // Create a directory at path
        let fileManager         = FileManager.default
        do {
            try fileManager.createDirectory(atPath: dbPath, withIntermediateDirectories: true, attributes: nil)
        }
        catch _ as NSError {
            return false
        }
        return true
    }
    
    // MARK: File Operation
    
    /**
     Copy file at the given destination path with the source file path.
     
     - Parameter sourceFilePath: Path of the file from the Bundle Resource.
     
     - Parameter destinationFilePath: Path of the file where the new fill will be copied.
     
     - Returns: true if file created successfully or already exists else false.
     */
    func createFileAtPath(sourceFilePath:String, destinationFilePath filePath:String) -> Bool {
        // Copy file at desination path of file does not exist
        let fileManager         = FileManager.default
        let doesFileExist       = fileManager.fileExists(atPath: filePath)
        if !doesFileExist  {
            do {
                try fileManager.copyItem(atPath: sourceFilePath, toPath: filePath)
            }
            catch _ as NSError {
                return false
            }
        }
        return true
    }
    
    func write(image:UIImage, path:String) -> Bool {
        // Write image at the specified path
        do {
            try UIImagePNGRepresentation(image)?.write(to: URL.init(fileURLWithPath: path), options: Data.WritingOptions.atomic)
            return true
        }
        catch let error as NSError {
            print("Error in writing image \(error.localizedDescription)")
        }
        return false
    }
    
    func imageWithPath(path: String) -> UIImage? {
        let fileManager    = FileManager.default
        if let imageData   = fileManager.contents(atPath: path) {
            let image = UIImage.init(data: imageData)
            return image
        }
        
        return nil
    }
    
    /**
     Delete the file permanently at the given path.
     
     - Parameter path: Path of the file to be deleted.
     
     - Returns: true if deleted successfully else false.
     */
    func deleteFileAtPath(path:String) -> Bool  {
        let fileManager         = FileManager.default
        do {
            try fileManager.removeItem(atPath: path)
        }
        catch _ as NSError {
            return false
            
        }
        return true
    }
}
