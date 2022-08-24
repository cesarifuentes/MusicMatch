//
//  SettingsViewController.swift
//  MusicMatch
//
//  Created by Cesar Fuentes on 8/23/22.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        logOutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
    }

    @objc func logOut() {
        
        self.dismiss(animated: true)
        
        // TODO: Log out of Spotify account
    }
    


}
