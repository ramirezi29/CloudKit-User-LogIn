//
//  WelcomeViewController.swift
//  ckUsersiOS21
//
//  Created by Ivan Ramirez on 9/26/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // know you have a user
        guard let currentUser = UserController.shared.currentUser else {return}
        welcomeLabel.text = "welcome \(currentUser.username)"
    }


}
