//
//  SetLanguageViewController.swift
//  Alto
//
//  Created by Jaypreet on 03/11/21.
//

import UIKit

class SetLanguageViewController: UIViewController {

    @IBOutlet weak var BtnGer: UIButton!
    @IBOutlet weak var btnIta: UIButton!
    @IBOutlet weak var btnFre: UIButton!
    @IBOutlet weak var btnEng: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        btnEng.setImage( #imageLiteral(resourceName: "radio_button_on-1"), for: .normal)
        btnFre.setImage( #imageLiteral(resourceName: "radio_button_off"), for: .normal)
        btnIta.setImage( #imageLiteral(resourceName: "radio_button_off"), for: .normal)
        BtnGer.setImage( #imageLiteral(resourceName: "radio_button_off"), for: .normal)
        DataManager.CurrentAppLanguage = "en"

        // Do any additional setup after loading the view.
    }
    @IBAction func Back(_ sender: Any) {
        dismiss()
    }
    @IBAction func Next(_ sender: Any) {
        if DataManager.CurrentUserRole == UserRole.Senior.get(){
            self.PresentViewController(identifier: "SeniorSignup1ViewController")

        }
        else{
            self.PresentViewController(identifier: "CompanionSignUp1ViewController")

        }
    }
    @IBAction func English(_ sender: Any) {
        btnEng.setImage( #imageLiteral(resourceName: "radio_button_on-1"), for: .normal)
        btnFre.setImage( #imageLiteral(resourceName: "radio_button_off"), for: .normal)
        btnIta.setImage( #imageLiteral(resourceName: "radio_button_off"), for: .normal)
        BtnGer.setImage( #imageLiteral(resourceName: "radio_button_off"), for: .normal)
        DataManager.CurrentAppLanguage = "en"
    }
    @IBAction func Franch(_ sender: Any) {
        btnEng.setImage( #imageLiteral(resourceName: "radio_button_off"), for: .normal)
        btnFre.setImage( #imageLiteral(resourceName: "radio_button_on-1"), for: .normal)
        btnIta.setImage( #imageLiteral(resourceName: "radio_button_off"), for: .normal)
        BtnGer.setImage( #imageLiteral(resourceName: "radio_button_off"), for: .normal)
        DataManager.CurrentAppLanguage = "fr"

    }
    @IBAction func Italian(_ sender: Any) {
        btnEng.setImage( #imageLiteral(resourceName: "radio_button_off"), for: .normal)
        btnFre.setImage( #imageLiteral(resourceName: "radio_button_off"), for: .normal)
        btnIta.setImage( #imageLiteral(resourceName: "radio_button_on-1"), for: .normal)
        BtnGer.setImage( #imageLiteral(resourceName: "radio_button_off"), for: .normal)
        DataManager.CurrentAppLanguage = "it"

    }
    @IBAction func German(_ sender: Any) {
        btnEng.setImage( #imageLiteral(resourceName: "radio_button_off"), for: .normal)
        btnFre.setImage( #imageLiteral(resourceName: "radio_button_off"), for: .normal)
        btnIta.setImage( #imageLiteral(resourceName: "radio_button_off"), for: .normal)
        BtnGer.setImage( #imageLiteral(resourceName: "radio_button_on-1"), for: .normal)
        DataManager.CurrentAppLanguage = "de"

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
