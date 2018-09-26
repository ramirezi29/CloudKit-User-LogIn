//
//  User.swift
//  ckUsersiOS21
//
//  Created by Ivan Ramirez on 9/26/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import Foundation
import CloudKit

class User {
    var username: String
    var email: String
    
    //identify what record they are in CloudKit:var cloudKitRecordID: CKRecord.ID
    var cloudKitRecordID: CKRecord.ID// = CKRecord.ID(recordName: UUID().uuidString) // give it a default UUI
    //let them link their iCLoud Account with the custom user
    let appleUserRefrence: CKRecord.Reference
    
    init(username: String, email: String, ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), appleUserRef: CKRecord.Reference) {
        self.username = username
        self.email = email
        self.cloudKitRecordID = ckRecordID
        self.appleUserRefrence = appleUserRef
    }
    
    // when im pulling from iCloud i want to convert the values to be read on the local device
    convenience init?(cloudKitRecord: CKRecord) {
        //failable initializer
        
        //1) unwrap all your necessary values
        //we put hard brackets after CKRecord bc its a dictionary
        guard let username = cloudKitRecord[Constants.usernameKey] as? String,
            let email = cloudKitRecord[Constants.emailKey] as? String,
            let appleUserRef = cloudKitRecord[Constants.appleUserReKey] as? CKRecord.Reference else {return nil} // if neither of these things are here return nil
        
        //2) initilize the actual object
        self.init(username: username, email: email, ckRecordID: cloudKitRecord.recordID, appleUserRef: appleUserRef)
    }
}

//get your model objects and be able to save it to the cloud

extension CKRecord{
    //crate with init
    //take in a user and build a ckRecord
    convenience init(user: User) {
        let recordID = user.cloudKitRecordID
        //dont really want a deafult icloud id bc you wont know what it means local. create one manually in order to be track
        self.init(recordType: Constants.UserRecordType, recordID: recordID)
        // need to set values in ordr to make this useful
        //self refers to the class youre currentl in
        // user.usernam will change, and the key will stay constant
        self.setValue(user.username, forKey: Constants.usernameKey)
        self.setValue(user.email, forKey: Constants.emailKey)
        self.setValue(user.appleUserRefrence, forKey: Constants.appleUserReKey)
    }
}

struct Constants {
    static let UserRecordType = "User"
    static let usernameKey = "Username"
    static let emailKey = "Email"
    static let appleUserReKey = "AppleUserRefrence"
}
