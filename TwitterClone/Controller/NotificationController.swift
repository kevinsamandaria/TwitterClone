//
//  NotificationController.swift
//  TwitterClone
//
//  Created by Kevin  Sam Andaria on 14/12/22.
//

import UIKit
import SwiftUI

class NotificationController: UIViewController {
    
    // -MARK: Properties
    
    // -MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    // -MARK: Helper
    func configureUI() {
        view.backgroundColor = .white
        
        navigationItem.title = "Notification"
    }
}
