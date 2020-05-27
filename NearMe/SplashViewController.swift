//
//  LaunchScreenViewController.swift
//  FireBase Auth Demo
//
//  Created by Shravan Prasanth on 5/16/20.
//  Copyright © 2020 Shravan Prasanth. All rights reserved.
//

import UIKit
import Lottie

class Splash: UIViewController {
    let animationView = AnimationView()
    var timer = Timer()
    var ye = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        animationView.isHidden = false
        setupAnimation()
        startTimer()
    }
    
    func setupAnimation() {
        animationView.frame = view.bounds
        animationView.animation = Animation.named("globe")
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1.2
        animationView.loopMode = .loop
        animationView.play()
        view.addSubview(animationView)
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
        timer.fire()
    }

    @objc func fire() {
        if ye != "yeye" {
            ye += "ye"
        }
        else {
            animationView.isHidden = true
            animationView.stop()
            timer.invalidate()
            performSegue(withIdentifier: "gohome", sender: self)
        }
        
    }


}
