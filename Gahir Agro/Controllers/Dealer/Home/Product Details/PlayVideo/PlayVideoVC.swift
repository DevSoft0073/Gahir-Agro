//
//  PlayVideoVC.swift
//  Gahir Agro
//
//  Created by Apple on 24/03/21.
//

import UIKit
import AVFoundation
import CoreMedia
import AVKit
import VersaPlayer

class PlayVideoVC: UIViewController {

    @IBOutlet var controls: VersaPlayerControls!
    @IBOutlet weak var playPauseButton: UIButton!
    var videoUrl = String()
    @IBOutlet weak var playVideo: VersaPlayerView!
    var player = AVPlayer()
    var fiestTimeSelect = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playVideos()
    }
    
    func playVideos()  {
        self.playVideo.layer.backgroundColor = UIColor.black.cgColor
        self.playVideo.use(controls: self.controls)
        self.playVideo.controls?.behaviour.shouldShowControls
        if let url = URL.init(string: videoUrl as? String ?? "") {
            let item = VersaPlayerItem(url: url)
            self.playVideo.set(item: item)
        }
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
