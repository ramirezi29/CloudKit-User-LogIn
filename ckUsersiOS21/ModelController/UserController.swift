//
//  UserController.swift
//  ckUsersiOS21
//
//  Created by Ivan Ramirez on 9/26/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import Foundation
import CloudKit

class UserController {
    
    //MARK: Shared Instance
    
    static let shared = UserController()
    private init() {}
    
    //create our schol bell's bell
    let currentUserWasSetNotification = Notification.Name("currentUserSet")
    
    //MARK: Sourceof Truth
    //curent user
    //needs to be optional in case no users are logged in
    var currentUser: User? {
        didSet {
            //ring the bill. default is the school's office
            //bell gets rung every time my current user is set
            //listening well be in viewDid Load of LogInViewController
           NotificationCenter.default.post(name: currentUserWasSetNotification, object: nil)
        }
    }
    
    //CRUD Functions
    // escaping, catch the user info from cloud kit
    //can make this optional and it wont need escaping wrote in
    func createUserWith(username: String, email: String, completion: ((Bool) -> Void)?) {
        // grab the parameter that wasnt put in the parentasis
        // user account and cloudkid account
        CKContainer.default().fetchUserRecordID { (recordID, error) in
            if let error = error {
                print("🚀 There was an error in \(#function); \(error); \(error.localizedDescription) 🚀")
                // if this completion is tehre call it false if not, dont even worry about it
                completion?(false)
                return
            }
            // need to call completion or it wont get hit. need to call it at the end point to avoid that issue
            //recordID represents the ID pointing to their iCloud account
            guard let recordID  = recordID else {completion?(false) ; return}
            // refrence
            //Enumeration CKRecord_Reference_Action means a Constants indicating the behavior when a referenced record is deleted.
            let appleUserRef = CKRecord.Reference(recordID: recordID, action: .deleteSelf)
            //make a user
            //creating a user locally, dont have a recordID at this point so we get a default one under the hood
            let user = User(username: username, email: email, appleUserRef: appleUserRef)
            //2. create userRecord
            let userRecord = CKRecord(user: user)
            //1. have that local user also exist in cloudKit
            CKContainer.default().publicCloudDatabase.save(userRecord, completionHandler: { (record, error) in
                if let error = error {
                    print("🚀 There was an error in \(#function); \(error); \(error.localizedDescription) 🚀")
                    completion?(false)
                    return
                }
                // if you dont get an error do the following. if we get a record back and not nil, it worked
                guard let record = record,
                    //init a user from that record. so our user is in cloudkit
                    let user = User(cloudKitRecord: record) else {completion?(false) ; return }
                self.currentUser = user
                completion?(true)
            })
        }
    }
    func fetchCurrentUser(completion: @escaping (Bool) -> Void) {
        //fetch current iCloud Acount
        CKContainer.default().fetchUserRecordID { (appleUserRecordID, error) in
            if let error = error {
                print("🚀 There was an error in \(#function); \(error); \(error.localizedDescription) 🚀")
                completion(false)
                return
            }
            // unwarp apple user ID
            guard let appleUserRecordID = appleUserRecordID else {completion(false) ; return }
            //lets see if theres a user tied to that reffrence
            //need to match the .delete Self line of code above
            //ckRecords refrences are like a hyperlink to another dictionary
            //in this dictionary i want it to be tied to a dictionary. but i cant put it inside another dictionary so you make a pointer to another dictionary
            let appleUserRefrence = CKRecord.Reference(recordID: appleUserRecordID, action: .deleteSelf)
            
            //%k means key
            let predicate = NSPredicate(format: "%K == %@", Constants.appleUserReKey, appleUserRefrence)
            //2. create queery
            let query = CKQuery(recordType: Constants.UserRecordType, predicate: predicate)
            //1.want to querry in the public database
            CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                if let error = error {
                    print("🚀 There was an error in \(#function); \(error); \(error.localizedDescription) 🚀")
                    completion(false)
                    return
                }
                //give us back the first record, if the users have the same iCloud account, well get the first user. if we do this right, than we should only have one user per specific iCloud account
                guard let record = records?.first else {completion(false) ; return}
                
                let user = User(cloudKitRecord: record)
                
                //assign to current user
                self.currentUser = user
                completion(true)
                
            })
        }
    }
}
