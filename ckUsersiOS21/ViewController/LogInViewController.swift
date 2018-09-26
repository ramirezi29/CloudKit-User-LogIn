//
//  LogInViewController.swift
//  ckUsersiOS21
//
//  Created by Ivan Ramirez on 9/26/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //selector is the func you want called
        NotificationCenter.default.addObserver(self, selector: #selector(segueToWelcomeVC), name: UserController.shared.currentUserWasSetNotification, object: nil)
    }
    
    //segue triggered in code
    @objc func segueToWelcomeVC(){
        self.performSegue(withIdentifier: "toWelcomeVC", sender: self)
    }
    
    @IBAction func singUPButtonTapped(_ sender: Any) {
        //when tapped we want to create a user
        // if the fields are blank we dont want to create a user
        
        guard let email = emailTextField.text,
            let username = usernameTextField.text,
            //if email is not emtpy
            !email.isEmpty,
            !username.isEmpty else {return}
        
        //animated activity
        activityIndicator.startAnimating()
        //create user
        UserController.shared.createUserWith(username: username, email: email) { (success) in // whether it succeded or not
            if success {
                DispatchQueue.main.async {
                    
                    self.activityIndicator.stopAnimating()
                }
                //if were not successfull
            } else {
                // notification center will be handled party by UIViewController + Alerts file
                //if something goes wrong
                //want to be on the main thread bc were doing UI stuff
                DispatchQueue.main.async {
                    self.presentAlertControllerWith(title: "Woops Somethign Went Wrong", message: "Please Make sure you are logged into iCloud int your phon's settings.")
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        // see if theres a user in memory
        guard UserController.shared.currentUser == nil else { segueToWelcomeVC() ; return }
        
        UserController.shared.fetchCurrentUser { (success) in
            if !success{
                //UI Stuff needs to be on the main thread
                DispatchQueue.main.async {
                    
                    self.presentAlertControllerWith(title: "No iCloud Account configured", message: "Please sign into your iCloud.")
                    
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
}
