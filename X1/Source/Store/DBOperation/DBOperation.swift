//
//  DBOperation.swift
//  indeclap
//
//  Created by Huulke on 12/13/17.
//  Copyright © 2017 Huulke. All rights reserved.
//

import UIKit
import FMDB

class DBOperation: NSObject {
    
    private var lastInsertId:Int64?
    let dbDirectoryPath:String     = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending("/library/database/")
    let databaseFile:String        = "solviant.db" // Change name as per the file name in the resouce file
    var db:FMDatabase?
    // MARK: -  Manage DB File
    
    /**
     Copies a file to system default directory on the given path.
     
     */
    func copyDatabase() {
        // Copy database to file system directory
        let nameComponents         = databaseFile.components(separatedBy: ".")
        if let dbResourcePath      = Bundle.main.path(forResource: nameComponents.first!, ofType:nameComponents.last!) {
            let fileManager        = FileOperation()
            let status             = fileManager.createDirectoryAtPath(dbPath: dbDirectoryPath)
            if status {
                let dbFilePath = dbDirectoryPath.appending(databaseFile)
                print("Database path \(dbFilePath)")
                _ = fileManager.createFileAtPath(sourceFilePath: dbResourcePath, destinationFilePath: dbFilePath)
            }
        }
    }
    
    /**
     Delete database file from system directory.
     
     */
    func delteDatabase()  {
        // Delete database file from system directory
        let dbFilePath  = dbDirectoryPath.appending(databaseFile)
        let fileManager = FileOperation()
        _               = fileManager.deleteFileAtPath(path: dbFilePath)
    }
    
    // MARK: DB Connection
    
    func openConnection() -> Bool  {
        let dbFilePath = dbDirectoryPath.appending(databaseFile)
        db = FMDatabase(path: dbFilePath)
        print("DB File Path \(dbFilePath)")
        let status =  db?.open()
        return status ?? false
    }
    
    func closeConnection() {
        db?.close()
    }
    
    // MARK: DML Query
    
    func autoIncrementId() -> Int64? {
        return lastInsertId
    }
    
    func executeInsertUpdate(query: String, columnValues:[Any]) {
        // Execute insert update query
        defer {
            closeConnection()
        }
        do {
            if openConnection() {
                try db?.executeUpdate(query, values: columnValues)
                lastInsertId = db?.lastInsertRowId
            }
        } catch {
            print("error = \(error)")
        }
    }
    
    func executeBatchInsertUpdate(query: String, columnValues:[Any]) {
        // Caller has the responsibility to open the datbase and close the database
        do {
            try db?.executeUpdate(query, values: columnValues)
            lastInsertId = db?.lastInsertRowId
        } catch {
            print("error = \(error)")
        }
    }
    
    func executeDelete(query: String) {
        // Execute insert update query
        defer {
            closeConnection()
        }
        if openConnection() {
            db?.executeStatements(query)
        }
    }
    
    func fetchDataForQuery(query:String) -> Array<Dictionary<String,String>> {
        defer {
            closeConnection()
        }
        var resultArray:Array<Dictionary<String,String>> = Array()
        do {
            if openConnection() {
                let resultSet       =  try db?.executeQuery(query, values: nil)
                if let rs = resultSet {
                    let count:Int32     = rs.columnCount
                    while rs.next() {
                        var resultDictionary:Dictionary<String,String> = Dictionary()
                        for i in 0 ..< count {
                            let name  = rs.columnName(for: i)
                            let value = rs.string(forColumnIndex: i)
                            if let columnValue = value {
                                resultDictionary[name!] = columnValue
                            }
                        }
                        resultArray.append(resultDictionary)
                    }
                }
            }
        } catch {
            print("error = \(error)")
        }
        return resultArray
    }
}

