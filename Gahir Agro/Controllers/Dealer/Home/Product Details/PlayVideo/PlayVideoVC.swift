//
//  PlayVideoVC.swift
//  Gahir Agro
//
//  Created by Apple on 24/03/21.
//

import UIKit
import AVFoundation
import CoreMedia

class PlayVideoVC: UIViewController {

    @IBOutlet weak var playPauseButton: UIButton!
    var videoUrl = String()
    @IBOutlet weak var playVideo: PlayerView!
    var player = AVPlayer()
    var fiestTimeSelect = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let url: URL! = URL(string: videoUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        let urlRequest = URLRequest(url: url)
        playPauseButton.isHidden = true
        addVideoPlayer(videoUrl: url, to: playVideo)
    }
    
    
    func addVideoPlayer(videoUrl: URL, to view: UIView) {
        
        player = AVPlayer(url: videoUrl)
        player.automaticallyWaitsToMinimizeStalling = false
        playVideo.player = player
        playVideo.playerLayer.videoGravity = .resize
        playVideo.player?.play()
    }

    @IBAction func playPauseButtonAction(_ sender: Any) {
        if fiestTimeSelect == false {
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            player.pause()
            fiestTimeSelect = true
        }else{
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            player.play()
            fiestTimeSelect = false
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
