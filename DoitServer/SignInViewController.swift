//
//  SignInViewController.swift
//  DoitServer
//
//  Created by user on 01.06.17.
//  Copyright © 2017 Yerchick. All rights reserved.
//

import UIKit




class SignInViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!

    @IBAction func onSignInButtonClicked(_ sender: Any) {
        Server.sendSignInRequest(withEmail: email.text!, andPassword: password.text!, completion: {(result) in
                switch result
                {
                case .Success(let respondString):
                    print("Success! " + respondString)
                    Server.token = respondString
                    DispatchQueue.main.async {
                        self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "ImagesViewScene"), animated: true)
                    }
                    
                    break
                case .Failure(let error):
                    print("Failure! " + error!.localizedDescription)
                    break
                    }
            })
        
    }
    
    
    
    override var navigationItem: UINavigationItem{
        super.navigationItem.hidesBackButton = true
        return super.navigationItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
