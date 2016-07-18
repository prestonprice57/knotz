//
//  LoginViewController.swift
//  knotz
//
//  Created by Price,Preston on 7/17/16.
//  Copyright © 2016 prestonwprice. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                print("User signed in")
                self.performSegue(withIdentifier: "toMain", sender: nil)
            } else {
                // No user is signed in.
                print("No user signed in")
            }
        }
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        // Uncomment to automatically sign in the user.
        // GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // ...
        let googleLoginButton = GIDSignInButton()
        googleLoginButton.center.y = 500.0
        
        
        self.view.addSubview(googleLoginButton)
        
        print("Firebase user: ")
        print(FIRAuth.auth()?.currentUser)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if FIRAuth.auth()?.currentUser != nil {
            print("not nil")
            self.performSegue(withIdentifier: "toMain", sender: nil)
        }
    }
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError?) {
        if let error = error {
            print("Signed in")
            return
        }
        print("Authenticated")
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credential(withIDToken: (authentication?.idToken)!,
                                                                     accessToken: (authentication?.accessToken)!)
        // ...
        FIRAuth.auth()?.signIn(with: credential) { _ in
            self.performSegue(withIdentifier: "toMain", sender: nil)
            // ...
        }
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
        print("Sign in presented")
    }
    
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        print("Sign in dismissed")
    }
    
}
