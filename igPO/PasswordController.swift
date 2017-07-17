import UIKit

class PasswordController : UIViewController{
    
    //-------------Variables-----------------
    @IBOutlet weak var labelMotPasse: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var fieldMotPasse: UITextField!
    //------------------------------
    var defaults = UserDefaults.standard
    var password: String!
    let passwordMaster = "dicareis"
    //------------------------------
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabelAndButton() //---------appel de methode qui rafraîchit les elements textuels
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //---------Methode qui valide le mot de passe
    @IBAction func validerMotPasse(_ sender: UIButton) {
        
        if fieldMotPasse.text == passwordMaster{ //---------Mot de passe master pour reinitialiser le mot de passe
            defaults.removeObject(forKey: "PASSWORD")
            setLabelAndButton()
        }
        else if defaults.object(forKey: "PASSWORD") == nil{ //---------Pour la premiere utilisation (ou apres une reinitialisation)
            defaults.set(fieldMotPasse.text, forKey: "PASSWORD")
            setLabelAndButton()
        } else{
            password = defaults.object(forKey: "PASSWORD") as! String //---------Mot de passe d'utilisateur valide
            if password == fieldMotPasse.text!{
                performSegue(withIdentifier: "seg", sender: nil)
            }
            else { //---------Mot de passe d'utilisateur invalide
                let refreshAlert = UIAlertController(title: "Message...", message: "Mot de passe invalide!\nEssayez de nouveau", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                refreshAlert.addAction(OKAction)
                present(refreshAlert, animated: true){}
            }
        }
    }
    
    //---------Methode qui rafraîchit les elements textuels
    private func setLabelAndButton (){
        if defaults.object(forKey: "PASSWORD") == nil{ //---------Pour creer un nouveau mot de passe
            labelMotPasse.text = "Creer un nouveau mot de passe"
            button.setTitle("CREER", for: .normal)
            fieldMotPasse.text = ""
            fieldMotPasse.isSecureTextEntry = false
        } else{ //---------Pour inserer le mot de passe enregistré
            labelMotPasse.text = "Inserer mot de passe"
            button.setTitle("VALIDER", for: .normal)
            fieldMotPasse.text = ""
            fieldMotPasse.isSecureTextEntry = true
        }
    }
    
    
      

    


}
