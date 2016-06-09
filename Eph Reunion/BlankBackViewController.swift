//
//  BlankBackViewController.swift
//  EphCatch
//
//  Created by Elliot Schrock on 5/26/16.
//  Copyright © 2016 Julintani LLC. All rights reserved.
//

import UIKit

class BlankBackViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBlankBackButton()
    }
}

extension UIViewController {
    func setBlankBackButton() {
        let backButton = UIBarButtonItem()
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
    }
}
