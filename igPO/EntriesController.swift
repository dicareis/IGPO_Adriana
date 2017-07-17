//=================================
import UIKit
//=================================
class EntriesController: UIViewController
{
    /* ---------------------------------------*/
    //let jsonManager = JsonManager(urlToJsonFile: "http://localhost/xampp/geneau/ig_po/json/data.json")
    /* -----------------Variables----------------------*/
    let jsonManager = JsonManager(urlToJsonFile: "http://www.igweb.tv/ig_po/json/data.json")
    var names: [String] = []
    var phones: [String] = []
    var emails: [String] = []
    var hows: [String] = []
    var progs: [String] = []
    @IBOutlet weak var theTableView: UITableView!
    /* ---------------------------------------*/
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //---------Recuperation des données du json
        self.jsonManager.importJSON()
        self.names = self.jsonManager.returnKeys()
        self.phones = self.jsonManager.returnValues(0)
        self.emails = self.jsonManager.returnValues(1)
        self.hows = self.jsonManager.returnValues(2)
        self.progs = self.jsonManager.returnValues(3)
    }
    /* ---------------------------------------*/
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    /* ---------------------------------------*/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        tableView.backgroundColor = UIColor.clear
        return self.names.count
    }
    /* ---------------------------------------*/
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = (self.theTableView.dequeueReusableCell(withIdentifier: "po")! as UITableViewCell)
        
        if let theLabel = cell.viewWithTag(200) as? UILabel
        {
            theLabel.text = "NOM : \(self.names[indexPath.row])"
        }
        
        if let theLabel = cell.viewWithTag(201) as? UILabel
        {
            theLabel.text = "TÉLÉPHONE : \(self.phones[indexPath.row])"
        }
        
        if let theLabel = cell.viewWithTag(202) as? UILabel
        {
            theLabel.text = "COURRIEL : \(self.emails[indexPath.row])"
        }
        
        if let theLabel = cell.viewWithTag(203) as? UILabel
        {
            theLabel.text = "COMMENT AVOIR ENTENDU PARLÉ DE NOUS : \(self.hows[indexPath.row])"
        }
        
        if let theTextView = cell.viewWithTag(204) as? UITextView
        {
            theTextView.text = "INTÉRESSÉ PAR LES PROGRAMMES : \n\(self.progs[indexPath.row])"
        }
        
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    /* ---------------------------------------*/
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor.lightGray
    }
    /* ---------------------------------------*/
    func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            self.jsonManager.upload("delete=\(self.names[indexPath.row])", urlForAdding: "http://www.igweb.tv/ig_po/php/delete.php")
            
            self.names.remove(at: indexPath.row)
            self.phones.remove(at: indexPath.row)
            self.emails.remove(at: indexPath.row)
            self.hows.remove(at: indexPath.row)
            self.progs.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    /* ---------------------------------------*/
}
//=================================
















