//
//  AutoLogin.swift
//  indeclap
//
//  Created by Huulke on 12/14/17.
//  Copyright © 2017 Huulke. All rights reserved.
//

import UIKit

class AutoLogin: NSObject {

    let dbOperation = DBOperation()
    
    func verifyUser() {
        // Check for version update first
        if isAppVersionUpdated() {
            // Required database change
            let tables = ["user"]
            let dataCollection = createBackUp(tableNames: tables)
            replaceDatabase()
            restoreDatabase(dataCollection: dataCollection)
        }
        else {
            // Copy database
            dbOperation.copyDatabase()
        }
        
        // Verify logged in user and set up intial view controller
        var rootViewController:UIViewController
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        if let _ = User.loggedInUser() {
            // User has already logged in session
            let homeViewController = storyboard.instantiateViewController(withIdentifier: StoryboardIdentifier.home)
            rootViewController     = homeViewController
        }
        else {
            // No user is logged in
            rootViewController = storyboard.instantiateViewController(withIdentifier: StoryboardIdentifier.landing)
        }
        
        if let navigationController = UIApplication.shared.delegate?.window!?.rootViewController as? UINavigationController {
            navigationController.pushViewController(rootViewController, animated: true)
        }
    }
    
    private func isAppVersionUpdated() -> Bool {
        // Check if there is a version update for this app
        let userDefaults = UserDefaults.standard
        var requriesUpdate = true
        if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if let savedVersion = userDefaults.object(forKey: AppVersionKey.appVersion) as? String {
                // Check if version update is updated or not
                requriesUpdate =  currentVersion != savedVersion
            }
            userDefaults.set(currentVersion, forKey: AppVersionKey.appVersion)
        }
        
        // No version history found, go for update anyway
        return requriesUpdate
    }
    
    private func replaceDatabase() {
        // Replace database file
        dbOperation.delteDatabase()
        dbOperation.copyDatabase()
    }
    
    private func createBackUp(tableNames:Array<String>) -> Dictionary<String,Array<Dictionary<String,String>>> {
        // Create backup of this database
        var dataCollection = Dictionary<String,Array<Dictionary<String,String>>>()
        for tableName in tableNames {
            let insertQuery = "SELECT * FROM \(tableName)"
            let rowsArray   = dbOperation.fetchDataForQuery(query: insertQuery)
            if rowsArray.count > 0 {
                dataCollection[tableName] = rowsArray
            }
        }
        return dataCollection
    }
    
    private func restoreDatabase(dataCollection: Dictionary<String,Array<Dictionary<String,String>>>) {
        // Insert all rows to this new copied database again
        let allKeys = dataCollection.keys
        // Iteration for table
        _ = dbOperation.openConnection()
        for table in allKeys {
            if let rows =  dataCollection[table] {
                // Iterate for all rows in table
                for row in rows {
                    var columnString        = "("
                    var placeholderValues   = "("
                    var values:Array<Any>   = Array()
                    let columns             = row.keys
                    // Iterate for all column and values
                    for column in columns {
                        columnString.append("\(column),")
                        placeholderValues.append("?,")
                        values.append(row[column] as Any)
                    }
                    columnString = String(columnString.dropLast())
                    columnString.append(")")
                    placeholderValues = String(placeholderValues.dropLast())
                    placeholderValues.append(")")
                    let insertQuery  = "INSERT INTO " + table + " " + columnString + " VALUES " + placeholderValues
                    print("Insert Query \(insertQuery)")
                    dbOperation.executeBatchInsertUpdate(query: insertQuery, columnValues: values)
                }
            }
        }
        dbOperation.closeConnection()
    }
}

struct AppVersionKey {
    static let appVersion = "AppVersion"
}
