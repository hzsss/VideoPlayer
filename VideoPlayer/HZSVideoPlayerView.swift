

//
//  HZSVideoPlayerView.swift
//  VideoPlayer
//
//  Created by Acan on 2019/3/22.
//  Copyright © 2019 weiphone. All rights reserved.
//

import UIKit
import AVFoundation

/*
 * 全屏切换
 * 快进
 * 调整音量和亮度
 */
class HZSVideoPlayerView: UIView {
    
    var beginLocation: CGPoint = .zero
    var isFullScreen: Bool = false
    
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var playBtn: UIButton = UIButton(type: .custom)
    var fullScreenBtn: UIButton = UIButton(type: .custom)
    var progressView: UIProgressView = UIProgressView(progressViewStyle: .bar)
    
    init(url: URL) {
        super.init(frame: .zero)
        
        backgroundColor = .black
        
        let playerItem: AVPlayerItem = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: playerItem)
        let playerLayer: AVPlayerLayer = AVPlayerLayer(player: player)
        self.player = player
        self.playerLayer = playerLayer
        self.playerItem = playerItem
        layer.addSublayer(playerLayer)
        
        playBtn.setTitle("播放", for: .normal)
        playBtn.backgroundColor = .blue
        playBtn.addTarget(self, action: #selector(playOrPause), for: .touchUpInside)
        addSubview(playBtn)
        
        fullScreenBtn.setTitle("全屏", for: .normal)
        fullScreenBtn.backgroundColor = .red
        fullScreenBtn.addTarget(self, action: #selector(fullScreenPlay), for: .touchUpInside)
        addSubview(fullScreenBtn)
        
        progressView.progressTintColor = .blue
        addSubview(progressView)
        
        let interval = CMTime(seconds: 1.0 / 60, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            guard let sself = self else { return }
            
            let duration = CMTimeGetSeconds(playerItem.duration)
            let currentTime = CMTimeGetSeconds(player.currentTime())
            sself.progressView.setProgress(Float(currentTime / duration), animated: true)
            
//            print(" duration: \(duration) \n currentTime: \(currentTime) \n time: \(time)")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let playerLayer = playerLayer {
            playerLayer.frame = bounds
        }
        
        let padding: CGFloat = 10.0
        let btnSize: CGFloat = 44.0
        playBtn.frame = CGRect(x: padding, y: bounds.height - padding - btnSize, width: btnSize, height: btnSize)
        fullScreenBtn.frame = CGRect(x: padding, y: padding, width: btnSize, height: btnSize)
        
        let progressViewX: CGFloat = playBtn.frame.maxX + padding
        let progressViewY: CGFloat = bounds.height - padding - btnSize / 2
        let progressViewWidth: CGFloat = bounds.width - progressViewX - padding
        progressView.frame = CGRect(x: progressViewX, y: progressViewY, width: progressViewWidth, height: 2)
    }
    
    @objc func playOrPause() { // 播放或者暂停
        guard let player = player else { return }
        
        if player.timeControlStatus == .paused && player.status == .readyToPlay {
            player.play()
            playBtn.setTitle("暂停", for: .normal)
        } else {
            player.pause()
            playBtn.setTitle("播放", for: .normal)
        }
    }
    
    @objc func fullScreenPlay() { // 切换横竖屏，待定
        isFullScreen = !isFullScreen
        UIDevice.current.setValue(NSNumber(value: isFullScreen ? UIInterfaceOrientation.landscapeRight.rawValue : UIInterfaceOrientation.portrait.rawValue), forKey: "orientation")
        
        superview?.layoutIfNeeded()
    }
}

extension HZSVideoPlayerView { // 全屏手势
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        beginLocation = touch.location(in: self)
        print("beginLocationX: \(beginLocation.x)")
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch: UITouch = touches.first, let player = player else { return }

        let location = touch.location(in: self)

        print("beginLocationX: \(beginLocation.x) \n locationX : \(location.x)")
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let changeTime = (location.x - beginLocation.x) * 30 / bounds.width
        let interval = CMTime(seconds: Double(CGFloat(currentTime) + changeTime), preferredTimescale: CMTimeScale(NSEC_PER_SEC))

        print("changeTime:\(changeTime) \n interval:\(CMTimeGetSeconds(interval))")
        player.seek(to: interval)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let player = player else { return }
        
        player.play()
    }
}
