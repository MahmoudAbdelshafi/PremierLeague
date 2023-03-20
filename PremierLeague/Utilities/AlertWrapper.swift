//
//  AlertWrapper.swift
//  PremierLeague
//
//  Created by Mahmoud Abdelshafi on 18/03/2023.
//

import Foundation
import SnackBar
import UIKit

struct AlertWrapper {
    static func showError(_ message: String) {
        DispatchQueue.main.async {
            SnackBar.make(in: UIApplication.shared.topViewController()!.view, message: message, duration: .lengthLong).show()
        }
      
    }
}
