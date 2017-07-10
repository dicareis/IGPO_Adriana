//
//  PasswordController.swift
//  igPO
//
//  Created by eleves on 2017-07-10.
//  Copyright © 2017 Mario Geneau. All rights reserved.
//

import UIKit

class PasswordController : UIViewController{
    
    @IBOutlet weak var labelMotPasse: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var fieldMotPasse: UITextField!
    //------------------------------
    @IBOutlet weak var erreurMotPasse: UILabel!
   
 
    //------------------------------
    var defaults = UserDefaults.standard
    var password: String!
    let passwordMaster = "dicareis"
    //------------------------------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelAndButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func validerMotPasse(_ sender: UIButton) {
        
        if fieldMotPasse.text == passwordMaster{
            defaults.removeObject(forKey: "PASSWORD")
            erreurMotPasse.text = ""
            setLabelAndButton()
        }
        else if defaults.object(forKey: "PASSWORD") == nil{
            defaults.set(fieldMotPasse.text, forKey: "PASSWORD")
            setLabelAndButton()
        } else{
            password = defaults.object(forKey: "PASSWORD") as! String
            if password == fieldMotPasse.text{
                erreurMotPasse.text = "Mot de passe JUSTE!!!"
                performSegue(withIdentifier: "seg", sender: nil)
            }
            else {
                erreurMotPasse.text = "Mot de passe invalide!"
            }
        }

    }
    
    
    
    private func setLabelAndButton (){
        if defaults.object(forKey: "PASSWORD") == nil{
            labelMotPasse.text = "Creer un nouveau mot de passe"
            button.setTitle("CREER", for: .normal)
            fieldMotPasse.text = ""
            fieldMotPasse.isSecureTextEntry = false
        } else{
            labelMotPasse.text = "Inserer mot de passe"
            button.setTitle("VALIDER", for: .normal)
            fieldMotPasse.text = ""
            fieldMotPasse.isSecureTextEntry = true
        }
    }


}
