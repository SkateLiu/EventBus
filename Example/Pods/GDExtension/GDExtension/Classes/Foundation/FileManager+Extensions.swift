//
//  FileManager+Extensions.swift
//  GDExtension
//
//  Created by Objc on 2019/8/26.
//

import UIKit


private extension FileManager{
    
    static let FileManagerErrorDomain = "FileManagerErrorDomain"

    func error( withMessage message: String) -> Error {
        return NSError(domain: FileManager.FileManagerErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: message])
    }
    //MARK: - Private
    
    func checkAndCreateDir(atPath path: String, component: String) throws -> String {
        
        if component.isEmpty {
            throw error(withMessage: "SubDir path component is empty.")
        }
        
        let fullPath = (path as NSString).appendingPathComponent(component)
        try createDirIfNotExists(atPath: fullPath)
        return fullPath
    }
    
    func createDirIfNotExists(atPath path: String) throws {
        
        if self.fileExists(atPath: path) {
            return
        }
        
        try self.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }
    
    func applicationSupportDir() throws -> String {
        
        let path = try self.applicationSupportDirPath()
        try createDirIfNotExists(atPath: path)
        return path
    }
}
// MARK: - Methods for actions
public extension FileManager{
    func deleteDirContens(atPath path: String) throws {
        let _fileExists = fileExists(atPath: path)
        
        if !_fileExists {
            print("No dir at path.")
            throw error(withMessage: "No dir at path.")
        }
        
        let _isDir = isDir(atPath: path)
        
        if !_isDir {
            print("File at path instead of dir.")
            throw error(withMessage: "File at path instead of dir.")
        }
        
        let files = try self.contentsOfDirectory(atPath: path)
        
        for file in files {
            let path = (path as NSString).appendingPathComponent(file)
            try self.removeItem(atPath: path)
        }
    }
    
    func isDir(atPath path: String) -> Bool {
        var isDir = ObjCBool(true)
        self.fileExists(atPath: path, isDirectory: &isDir)
        return isDir.boolValue
    }
    
    func isFile(atPath path: String) -> Bool {
        return self.fileExists(atPath:path)
    }
    
}

// MARK: - Methods for creat dirctory
public extension FileManager{
    
    func documentSubDir(withComponent component: String, backUp: Bool = false) throws -> String {
        
        let path = try self.documentDir()
        let fullPath = try checkAndCreateDir(atPath: path, component: component)
        return fullPath
    }
    
    func librarySubDir(withComponent component: String) throws -> String {
        
        let path = try self.libraryDir()
        let fullPath = try checkAndCreateDir(atPath: path, component: component)
        return fullPath
    }
    
    func cachesSubDir(withComponent component: String) throws -> String {
        
        let path = try self.cachesDir()
        let fullPath = try checkAndCreateDir(atPath: path, component: component)
        return fullPath
    }
    
    func tmpSubDir(withComponent component: String) throws -> String {
        
        let path = self.tmpDir()
        let fullPath = try checkAndCreateDir(atPath: path, component: component)
        return fullPath
    }
    
    func applicationSupportSubDir(withComponent component: String) throws -> String {
        
        let path = try self.applicationSupportDir()
        let fullPath = try checkAndCreateDir(atPath: path, component: component)
        return fullPath
    }
    
}

// MARK: - Methods for dictorylocations
public extension FileManager{
    func homeDir() -> String {
        return NSHomeDirectory()
    }
    
    func documentDir() throws -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        if let path = paths.first {
            return path
        }
        
        throw error(withMessage: "Failed to get Document directory.")
    }
    
    func tmpDir() -> String {
        return NSTemporaryDirectory()
    }
    
    func libraryDir() throws -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        if let path = paths.first {
            return path
        }
        
        throw error(withMessage: "Failed to get Library directory.")
    }
    
    func cachesDir() throws -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        if let path = paths.first {
            return path
        }
        
        throw error(withMessage: "Failed to get Library/Caches directory.")
    }
    
    func applicationSupportDirPath() throws -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        if let path = paths.first {
            return path
        }
        
        throw error(withMessage: "Failed to get Library/ApplicationSupport directory.")
    }
}
