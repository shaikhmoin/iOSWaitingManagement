//
//  DBClass.swift
//  iOSWaitingManagement
//
//  Created by Akash on 12/28/18.
//  Copyright © 2018 Moin. All rights reserved.
//

import Foundation
import SQLite3

var obj = DBClass()

class DBClass: NSObject {
    
    //MARK:- Insert,Update,Delete
    func dboperation(query:String) -> Bool {
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true);
        let dbpath :String =  path[0] as String
        
        let fullpath = dbpath.appending("/iOSPOS.sqlite");
        print(fullpath)
        
        var status :Bool = false
        var db: OpaquePointer? = nil
        
        if sqlite3_open(fullpath, &db) == SQLITE_OK {
            
            //comes when database path is improper
            var statements :OpaquePointer? = nil
            print(query)
            
            if sqlite3_prepare_v2(db, query, -1, &statements, nil) != SQLITE_OK
            {
                sqlite3_step(statements)
                status = false
            } else {
                sqlite3_step(statements)
                status = true
            }
            sqlite3_finalize(statements)
            sqlite3_close(db)
        }
        return status
    }
    
    //MARK:- Get ALL TABLES DYNAMIC DATA
    func getDynamicTableData(query:String) -> [AnyObject] {
        
        var num_cols: Int = 0
        //var i: Int = 0
        var type: Int32 = 0
        var obj: Any = ""
        var key = ""
        var result = [AnyObject]()
        var row = [String:AnyObject]()
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let dbpath :String =  path[0] as String
        
        let fullpath = dbpath.appending("/iOSPOS.sqlite")
        print(fullpath)
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(fullpath, &db) == SQLITE_OK {
            
            var statements :OpaquePointer? = nil
            
            if sqlite3_prepare_v2(db, query, -1, &statements, nil) == SQLITE_OK
            {
                while sqlite3_step(statements) == SQLITE_ROW {
                    
                    num_cols = Int(sqlite3_data_count(statements))
                    
                    for i in 0..<num_cols {
                        obj = ""
                        type = sqlite3_column_type(statements, Int32(i))
                        
                        switch type {
                        case SQLITE_INTEGER:
                            obj = sqlite3_column_int64(statements, Int32(i))
                        case SQLITE_FLOAT:
                            obj = sqlite3_column_double(statements, Int32(i))
                        case SQLITE_TEXT:
                            obj = String(cString: sqlite3_column_text(statements, Int32(i)))
                        case SQLITE_NULL:
                            obj = NSNull()
                            
                        default:
                            break
                        }
                        key = String(utf8String: sqlite3_column_name(statements, Int32(i)))!
                        row[key] = obj as AnyObject
                        print(row)
                    }
                    result.append(row as AnyObject)
                }
                
            } else {
                print("Something wrong")
            }
            sqlite3_finalize(statements)
            sqlite3_close(db)
        }
        return result
    }
}
