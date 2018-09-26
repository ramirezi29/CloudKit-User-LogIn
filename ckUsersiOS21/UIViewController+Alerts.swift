//
//  UIViewController+Alerts.swift
//  ckUsersiOS21
//
//  Created by Ivan Ramirez on 9/26/18.
//  Copyright © 2018 ramcomw. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentAlertControllerWith(title: String, message: String ){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true)
    }
}
