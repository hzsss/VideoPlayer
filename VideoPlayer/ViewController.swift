//
//  ViewController.swift
//  VideoPlayer
//
//  Created by Acan on 2019/3/21.
//  Copyright © 2019 weiphone. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

let urlStr: String = "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_adv_example_hevc/master.m3u8"
class ViewController: UIViewController {

    var videoView: HZSVideoPlayerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let url = URL(string: urlStr) else { return }
        videoView = HZSVideoPlayerView(url: url)
        view.addSubview(videoView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let width: CGFloat = view.bounds.width
        let height: CGFloat = view.bounds.width * 3 / 4
        videoView.frame = CGRect(x: 0, y: 40, width: width, height: height)
    }
}

extension ViewController {
    
    func defaultPlayer() { // 获取系统默认的 video player
        guard let url = URL(string: urlStr) else { return }
        
        let player = AVPlayer(url: url)
        
        let vc = AVPlayerViewController()
        vc.player = player
        
        present(vc, animated: true) {
            player.play()
        }
    }
}

