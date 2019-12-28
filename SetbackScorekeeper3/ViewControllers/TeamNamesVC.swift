//
//  TeamNamesVC.swift
//  SetbackScorekeeper3
//
//  Created by Derek Shore on 12/27/19.
//  Copyright © 2019 Luxumbra. All rights reserved.
//

import UIKit
protocol TeamNameDelegate {
	func teamNameDelegateUpdateNames(team1Name: String, team2Name: String, team3Name: String)
}
class TeamNamesVC: UIViewController {
	
	var delegate: TeamNameDelegate?
	var names: [String]?
	
	@IBOutlet weak var team1TextField: UITextField!
	@IBOutlet weak var team2TextField: UITextField!
	@IBOutlet weak var team3TextField: UITextField!
	
	
	@IBOutlet weak var doneButton: UIButton!
	@IBAction func doneAction(_ sender: UIButton) {
		delegate?.teamNameDelegateUpdateNames(team1Name: team1TextField.text!, team2Name: team2TextField.text!, team3Name: team3TextField.text!)
		dismiss(animated: true)
	}
	
	@IBAction func textFieldCheck(_ sender: UITextField) {
		if (team1TextField.text!.isEmpty || team1TextField.text == "") || (team2TextField.text!.isEmpty || team2TextField.text == "") {
			doneButton.isEnabled = false
		} else {
			doneButton.isEnabled = true
		}
	}
	
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		if names == nil {
			doneButton.isEnabled = false
		} else {
			doneButton.isEnabled = true
		}
		if let filler = names {
			team1TextField.text = filler[0]
			team2TextField.text = filler[1]
			if filler.count == 3 {
				team3TextField.text = filler[2]
			}
		}
        // Do any additional setup after loading the view.
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
