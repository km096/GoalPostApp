//
//  UIViewControllerExt.swift
//  GoalPostApp
//
//  Created by ME-MAC on 2/4/23.
//

import UIKit

extension UIViewController {
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transtion = CATransition()
        transtion.duration = 0.3
        transtion.type = .push
        transtion.subtype = .fromRight
        self.view.window?.layer.add(transtion, forKey: kCATransition)
        
        present(viewControllerToPresent, animated: false)
    }
    
    func presentSecondaryDetail(_ viewControllerToPresent: UIViewController) {
        let transtion = CATransition()
        transtion.duration = 0.3
        transtion.type = .push
        transtion.subtype = .fromRight
        
        guard let presentedViewController = presentedViewController else { return }
        presentedViewController.dismiss(animated: false) {
            self.view.window?.layer.add(transtion, forKey: kCATransition)
            self.present(viewControllerToPresent, animated: false)
        }
    }
    
    func dismissDetail() {
        let transtion = CATransition()
        transtion.duration = 0.3
        transtion.type = .push
        transtion.subtype = .fromLeft
        self.view.window?.layer.add(transtion, forKey: kCATransition)
        
        dismiss(animated: false)
    }
}
