//
//  LaunchViewController.swift
//  Alto
//
//  Created by Jaypreet on 22/10/21.
//

import UIKit
import LocalAuthentication

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        let when = DispatchTime.now() + 1.7
        DispatchQueue.main.asyncAfter(deadline: when)
        {

            print( DataManager.CurrentUserData)
            if DataManager.CurrentUserData != nil{
                self.TouchFaceID()
                

//                self.PresentViewController(identifier: "TabViewController")
            }
            else{
                self.PushToSetLanguageViewController()
            }
        }
    }
    func TouchFaceID() {
        let myContext = LAContext()
        let myLocalizedReasonString = "Please wait...."
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    
                    DispatchQueue.main.async {
                        if success {
                            // User authenticated successfully, take appropriate action
                            Constants.Toast.MyToast(message: "User authenticated successfully", image: Constants.AppLogo)
                            self.authenticatedSuccessfully()

                        } else {
                            // User did not authenticate successfully, look at error and take appropriate action
                            Constants.Toast.MyToast(message: "Sorry!!... User did not authenticate successfully", image: Constants.AppLogo)
                            
                                let err = (evaluateError as! LAError).code
                                
                                switch err {
                                case .appCancel:
                                    print("Authentication cancel by app")
                                    // Toast(text: "Authentication cancel by app").show()
                                    break
                                    
                                case .authenticationFailed:
                                    print("Authentication failed")
                                    // Toast(text: "Authentication failed").show()
                                    break
                                    
                                case .invalidContext:
                                    print("Authentication failed due to invaild context")
                                    // Toast(text: "Authentication failed due to invaild context").show()
                                    break
                                    
                                case .passcodeNotSet:
                                    print("Passcode not set yet")
                                    // Toast(text: "Passcode not set yet").show()
                                    break
                                    
                                case .systemCancel:
                                    print("Authentication cancel by system")
                                    // Toast(text: "Authentication cancel by system").show()
                                    break
                                    
                                case .touchIDLockout:
                                    print("Touch ID lockout")
                                    // Toast(text: "Touch ID lockout").show()
                                    break
                                    
                                case .touchIDNotAvailable:
                                    print("Touch ID not available")
                                    // Toast(text: "Touch ID not available").show()
                                    break
                                    
                                case .touchIDNotEnrolled:
                                    print("Touch ID not enrolled yet")
                                    // Toast(text: "Touch ID not enrolled yet").show()
                                    break
                                    
                                case .userCancel:
                                    print("Authentication cancel by user")
                                    // Toast(text: "Authentication cancel by user").show()
                                    break
                                    
                                case .userFallback:
                                    print("Authentication cancel due to user pressed fallback option")
                                    // Toast(text: "Authentication cancel due to user pressed fallback option").show()
                                    break
                                 default:
                                    print("notInteractive")
                                    break
                                    // Toast(text: "notInteractive").show()
                                }
                            
                            self.PushToSetLanguageViewController()

                         
                        }
                    }
                }
            } else {
                // Could not evaluate policy; look at authError and present an appropriate message to user
                Constants.Toast.MyToast(message: "Sorry!!.. Could not evaluate policy.", image: Constants.AppLogo)
            
                authenticatedSuccessfully()
                


            }
        } else {

            authenticatedSuccessfully()

            Constants.Toast.MyToast(message: "Ooops!!.. This feature is not supported.", image: Constants.AppLogo)
        }
        
        
    
    }
    func authenticatedSuccessfully()  {
        Constants.CurrentUserData = DataManager.CurrentUserData
        if DataManager.CurrentUserRole == UserRole.Senior.get(){
           
                self.PresentViewController(identifier: "TabSeniorViewController")
           

        }
        else{
            
                
                
                
                self.PresentViewController(identifier: "TabCompanionViewController")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
