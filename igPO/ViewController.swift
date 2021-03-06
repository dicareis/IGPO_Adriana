//=================================
import UIKit
//=================================
class ViewController: UIViewController
{
    /* ---------------FIELDS------------------------*/
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    /* ---------------BUTTONS------------------------*/
    @IBOutlet weak var amis: UIButton!
    @IBOutlet weak var radio: UIButton!
    @IBOutlet weak var pub_internet: UIButton!
    @IBOutlet weak var journaux: UIButton!
    @IBOutlet weak var moteur: UIButton!
    @IBOutlet weak var sociaux: UIButton!
    @IBOutlet weak var tv: UIButton!
    @IBOutlet weak var autres: UIButton!
    /* --------------AUTRES VARIABLES-------------------------*/
    var pickerChoice: String = ""
    var arrMediaButtons:[UIButton]!
    var mediaSelected = false
    /* -------------ARRAY DE BOUTONS--------------------------*/
    var arrForButtonManagement: [Bool] = []
    /* ----------ARRAY DE COURS-----------------------------*/
    let arrProgramNames: [String] = [
        "DEC - Techniques de production et postproduction télévisuelles (574.AB)",
        "AEC - Production télévisuelle et cinématographique (NWY.15)",
        "AEC - Techniques de montage et d’habillage infographique (NWY.00)",
        "DEC - Techniques d’animation 3D et synthèse d’images (574.BO)",
        "AEC - Production 3D pour jeux vidéo (NTL.12)",
        "AEC - Animation 3D et effets spéciaux (NTL.06)",
        "DEC - Techniques de l’informatique, programmation nouveaux médias (420.AO)",
        "DEC - Technique de l’estimation en bâtiment (221.DA)",
        "DEC - Techniques de l’évaluation en bâtiment (221.DB)",
        "AEC - Techniques d’inspection en bâtiment (EEC.13)",
        "AEC - Métré pour l’estimation en construction (EEC.00)",
        "AEC - Sécurité industrielle et commerciale (LCA.5Q)"]
    
    //Recuperation de la base de données
    let jsonManager = JsonManager(urlToJsonFile: "http://www.igweb.tv/ig_po/json/data.json")
    /* ---------------------------------------*/
    override func viewDidLoad()
    {
        super.viewDidLoad()
        arrMediaButtons = [amis, radio, pub_internet, journaux, moteur, sociaux, tv, autres] //liason avec les boutons
        jsonManager.importJSON() //recuperation du fichier json
        fillUpArray()
    }
    /* ---------------------------------------*/
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    /* -------------Initialisation de l'array avec falses--------------------------*/
    func fillUpArray()
    {
        for _ in 0...11
        {
            arrForButtonManagement.append(false)
        }
    }
    
    
    
    /* ----------------Methode pour faire la list de programmes-----------------------*/
    func manageSelectedPrograms() -> String
    {
        var stringToReturn: String = ". "
        
        for x in 0 ..< arrProgramNames.count
        {
            if arrForButtonManagement[x]
            {
                stringToReturn += arrProgramNames[x] + "\n. "
            }
        }
        
        // Delete 3 last characters of string... Il va effacer le dernier "\n. "
        if stringToReturn != ""
        {
            stringToReturn = stringToReturn.substring(to: stringToReturn.characters.index(before: stringToReturn.endIndex))
            stringToReturn = stringToReturn.substring(to: stringToReturn.characters.index(before: stringToReturn.endIndex))
            stringToReturn = stringToReturn.substring(to: stringToReturn.characters.index(before: stringToReturn.endIndex))
        }
        
        return stringToReturn
    }
    
    
    
    
    /* ---------------Methode pour changer le dessin du bouton et de l'arrForButtonManagement------------------------*/
    @IBAction func buttonManager(_ sender: UIButton)
    {
        let buttonIndexInArray = sender.tag - 100
        
        if !arrForButtonManagement[buttonIndexInArray]
        {
            sender.setImage(UIImage(named: "case_select.png"), for: UIControlState())
            arrForButtonManagement[buttonIndexInArray] = true
        }
        else
        {
            sender.setImage(UIImage(named: "case.png"), for: UIControlState())
            arrForButtonManagement[buttonIndexInArray] = false
        }
    }
    
    
    /* -------------Methode pour reinitialiser les boutons des "programmes" a false et changer le dessin--------------------------*/
    func deselectAllButtons()
    {
        for x in 0 ..< arrForButtonManagement.count
        {
            arrForButtonManagement[x] = false
            let aButton: UIButton = (view.viewWithTag(100 + x) as? UIButton)!
            aButton.setImage(UIImage(named: "case.png"), for: UIControlState())
        }
    }
    
    
    /* ----------------- Sauvegarde d'infos - Controle de champs vides----------------------*/
    @IBAction func saveInformation(_ sender: UIButton)
    {
        if name.text == "" || phone.text == "" || email.text == ""
        {
            alert("Veuillez ne pas laisser aucun champ vide...")
            return
        }
        
        if !mediaSelected
        {
            alert("Veuillez nous indiquer comment vous avez entendu parler de nous...")
            return
        }
        
        if !checkManagementSelection(){
            alert("Veuillez cocher un programme de votre choix...")
            return
        }
        
        let progs = manageSelectedPrograms()
        let stringToSend = "name=\(name.text!)&phone=\(phone.text!)&email=\(email.text!)&how=\(pickerChoice)&progs=\(progs)"
        
        /* -----------------Sauvegarde des nouvelles données dans le serveur----------------------*/
        jsonManager.upload(stringToSend, urlForAdding: "http://www.igweb.tv/ig_po/php/add.php")
        clearFields()
        deselectAllButtons()
        startAllMediaButtonAlphas()
        
        alert("Les données ont été sauvegardées...")
    }
    /* -----------------Methode pour afficher l’alerte après sauvegarder les données----------------------*/
    func alert(_ theMessage: String)
    {
        let refreshAlert = UIAlertController(title: "Message...", message: theMessage, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        refreshAlert.addAction(OKAction)
        present(refreshAlert, animated: true){}
    }
    /* ---------------Methode pour effacer les données rentrées (nome, telephone et courriel) ------------------------*/
    func clearFields()
    {
        name.text = ""
        phone.text = ""
        email.text = ""
    }
    
    /* ----------------Methode pour faire le clavier disparaitre après appuyer dans terminer--------------------*/
            /* ---------------C'est une methode preexistante du "View Controller"--------------------*/
    func textFieldShouldReturn(_ textField: UITextField!) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    /* --------------Méthode que allume et éteindre les boutons de media dès qu'un bouton est sélectionné-------------------------*/
    @IBAction func mediaButtons(_ sender: UIButton)
    {
        resetAllMediaButtonAlphas()
        mediaSelected = true
        pickerChoice = (sender.titleLabel?.text)!
        
        if sender.alpha == 0.5
        {
            sender.alpha = 1.0
        }
        else
        {
            sender.alpha = 0.5
        }
    }
    /* ----------------Methode que éteindre tous les boutons (ajoute une transparence) -----------------------*/
    func resetAllMediaButtonAlphas()
    {
        for index in 0 ..< arrMediaButtons.count
        {
            arrMediaButtons[index].alpha = 0.5
        }
    }
        /* -----------------Mehode qu’allume tous les boutons (retire la transparence)----------------------*/
    func startAllMediaButtonAlphas()
    {
        for index in 0 ..< arrMediaButtons.count
        {
            arrMediaButtons[index].alpha = 1.0
            mediaSelected = false
        }
    }
    /* ----------------Methode que verifie si au moins une programme a été sélectionnée pour l’usager-----------------------*/
    func checkManagementSelection () -> Bool {
        
        for x in 0 ..< arrForButtonManagement.count{
            
            if arrForButtonManagement[x]{
                return true
            }
       }
        return false
    }
    /* ---------------------------------------*/
}
//=================================












