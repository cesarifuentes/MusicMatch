//
//  HomeViewController.swift
//  MusicMatch
//
//  Created by Cesar Fuentes on 8/23/22.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    var appRemote: SPTAppRemote?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserName()
        fetchProfileImage()
        
        // Do any additional setup after loading the view.
        settingsButton.addTarget(self, action: #selector(loadSettings), for: .touchUpInside)
    }

    
    

    
    @objc func loadSettings() {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(withIdentifier: "SettingsView") as! SettingsViewController
        self.present(controller, animated: true, completion: nil)
    }
    
    
    var responseCode: String? {
        didSet {
            fetchAccessToken { (dictionary, error) in
                if let error = error {
                    print("Fetching token request error \(error)")
                    return
                }
                let accessToken = dictionary!["access_token"] as! String
                DispatchQueue.main.async {
                    self.appRemote?.connectionParameters.accessToken = accessToken
                    self.appRemote?.connect()
                }
            }
        }
    }
    
    

}

 // MARK: - Networking
 extension HomeViewController {

    func fetchAccessToken(completion: @escaping ([String: Any]?, Error?) -> Void) {
        let url = URL(string: "https://accounts.spotify.com/api/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let spotifyAuthKey = "Basic \((SpotifyClientID + ":" + SpotifyClientSecretKey).data(using: .utf8)!.base64EncodedString())"
        request.allHTTPHeaderFields = ["Authorization": spotifyAuthKey,
                                       "Content-Type": "application/x-www-form-urlencoded"]

        var requestBodyComponents = URLComponents()
        let scopeAsString = stringScopes.joined(separator: " ")

        requestBodyComponents.queryItems = [
            URLQueryItem(name: "client_id", value: SpotifyClientID),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: responseCode!),
            URLQueryItem(name: "redirect_uri", value: SpotifyRedirectURI.absoluteString),
            URLQueryItem(name: "code_verifier", value: ""), // not currently used
            URLQueryItem(name: "scope", value: scopeAsString),
        ]

        request.httpBody = requestBodyComponents.query?.data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,                              // is there data
                  let response = response as? HTTPURLResponse,  // is there HTTP response
                  (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
                  error == nil else {                           // was there no error, otherwise ...
                      print("Error fetching token \(error?.localizedDescription ?? "")")
                      return completion(nil, error)
                  }
            let responseObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            print("Access Token Dictionary=", responseObject ?? "")
            completion(responseObject, nil)
        }
        task.resume()
    }

//    func fetchArtwork(for track: SPTAppRemoteTrack) {
//        appRemote.imageAPI?.fetchImage(forItem: track, with: CGSize.zero, callback: { [weak self] (image, error) in
//            if let error = error {
//                print("Error fetching track image: " + error.localizedDescription)
//            } else if let image = image as? UIImage {
//                self?.imageView.image = image
//            }
//        })
//    }
//
//    func fetchPlayerState() {
//        appRemote.playerAPI?.getPlayerState({ [weak self] (playerState, error) in
//            if let error = error {
//                print("Error getting player state:" + error.localizedDescription)
//            } else if let playerState = playerState as? SPTAppRemotePlayerState {
//                self?.update(playerState: playerState)
//            }
//        })
//    }
     
     
     func fetchUserName() {
         appRemote?.contentAPI?.fetchContentItem(forURI: <#T##String#>, callback: <#T##SPTAppRemoteCallback?##SPTAppRemoteCallback?##(Any?, Error?) -> Void#>)
         
     }
     
     func fetchProfileImage() {
         
//         appRemote?.playerAPI?.getPlayerState({ [weak self] (playerState, error) in
//             if let error = error {
//                 print("Error getting player state:" + error.localizedDescription)
//             } else if let playerState = playerState as? SPTAppRemotePlayerState {
//                 self?.update(playerState: playerState)
//             }
//         })
         
     }
 
     
 }
