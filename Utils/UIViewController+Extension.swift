//
//  UIViewController+Extension.swift
//  Sleepy-time
//
//  Created by Michael Sidoruk on 06.12.2019.
//  Copyright © 2019 Michael Sidoruk. All rights reserved.
//

import UIKit
import MediaPlayer

extension UIViewController {
    func createSimpleAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        return alert
    }
    
    func createAttentionAlert() -> UIAlertController {
        let alert = createSimpleAlert(title: "Attention", message: "Unfortunately, the application cannot support iCloud Media Library and Apple Music because of copyright issues. However, you still have possibility to upload your own music to iTunes throught Music App.\nThank's for your understanding.")
        let defaults = UserDefaults.standard
        let neverShow = UIAlertAction(title: "Never show", style: .cancel) { (_) in
            defaults.set(true, forKey: "neverShow")
        }
        alert.addAction(neverShow)
        return alert
    }
}

extension WakeUpTimeViewController {
    func createAlarmTimeAlert(date: Date) -> UIAlertController {
        let alert = UIAlertController(title: "Alarm", message: "Do you really want to set the alarm\n at \(date.shortStyleString())?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "OK", style: .default) { (_) in
            self.interactor?.makeRequest(request: .setWakeUpTime(date: date))
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        return alert
    }
}
