//
//  LoginViewController.swift
//  MusicMatch
//
//  Created by Cesar Fuentes on 8/23/22.
//

import UIKit

class LoginViewController: UIViewController, SPTSessionManagerDelegate, SPTAppRemoteDelegate {


    @IBOutlet weak var connectAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        connectAccountButton.addTarget(self, action: #selector(didTapConnect), for: .touchUpInside)
    }
    
    @objc func didTapConnect() {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(withIdentifier: "HomeView") as! HomeViewController
        controller.modalPresentationStyle = .fullScreen
        
        // Spotify
        if #available(iOS 11, *) {
            // Use this on iOS 11 and above to take advantage of SFAuthenticationSession
            sessionManager.initiateSession(with: scopes, options: .clientOnly)
        } else {
            // Use this on iOS versions < 11 to use SFSafariViewController
            sessionManager.initiateSession(with: scopes, options: .clientOnly, presenting: self)
        }

        controller.appRemote = appRemote
        self.present(controller, animated: true, completion: nil)
    }

    
    
    
    
    //let spotifyClientSecretKey = "288a432f88b74e628a83af682e24a27d"

    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURI)
        // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
        // otherwise another app switch will be required
        configuration.playURI = ""

        // Set these url's to your backend which contains the secret to exchange for an access token
        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
        configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
        configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
        return configuration
    }()

    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()

    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    
    
    
    
    
    
    
    // MARK: - SPTAppRemoteDelegate
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
    //        updateViewBasedOnConnected()
    //        appRemote.playerAPI?.delegate = self
    //        appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
    //            if let error = error {
    //                print("Error subscribing to player state:" + error.localizedDescription)
    //            }
    //        })
    //        fetchPlayerState()
    }

    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
    //        updateViewBasedOnConnected()
    //        lastPlayerState = nil
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
    //        updateViewBasedOnConnected()
    //        lastPlayerState = nil
    }
    
    
    
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        appRemote.connectionParameters.accessToken = session.accessToken
        appRemote.connect()
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        presentAlertController(title: "Authorization Failed", message: error.localizedDescription, buttonTitle: "Bummer")
    }
    
    //    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
    //        presentAlertController(title: "Session Renewed", message: session.description, buttonTitle: "Sweet")
    //    }
    
    private func presentAlertController(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
            controller.addAction(action)
            self.present(controller, animated: true)
        }
    }
    
    

    
    
}

