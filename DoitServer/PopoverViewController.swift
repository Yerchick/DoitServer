//
//  PopoverViewController.swift
//  DoitServer
//
//  Created by user on 10.06.17.
//  Copyright © 2017 Yerchick. All rights reserved.
//

import UIKit
import FLAnimatedImage

class PopoverViewController: UIViewController {

    var image:FLAnimatedImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let gifView = FLAnimatedImageView(frame: self.view.frame)
        gifView.animatedImage = image
        self.view.addSubview(gifView)
    }
}
