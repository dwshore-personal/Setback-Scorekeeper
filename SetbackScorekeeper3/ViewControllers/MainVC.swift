//
//  MainVC.swift
//  SetbackScorekeeper3
//
//  Created by Derek Shore on 12/27/19.
//  Copyright © 2019 Luxumbra. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

	var currentGame: GameType?
	
	@IBOutlet weak var team1NameLabel: UILabel!
	@IBOutlet weak var team2NameLabel: UILabel!
	@IBOutlet weak var team3NameLabel: UILabel!
	
	@IBOutlet weak var team1ScoreLabel: UILabel!
	@IBOutlet weak var team2ScoreLabel: UILabel!
	@IBOutlet weak var team3ScoreLabel: UILabel!
	
	@IBOutlet weak var team3Stack: UIStackView!
	
	@IBAction func newGameButton(_ sender: Any) {
		performSegue(withIdentifier: "ShowTeamNames", sender: self)
	}
	
	
	func updateTeamLabels(from game: GameType){
		team1NameLabel.text = game.teamList[0].name
		team2NameLabel.text = game.teamList[1].name
		if game.teamList.count == 3 {
			team3NameLabel.text = game.teamList[2].name
		}
	}
	
	func updateScoreLabels(from game: GameType){
		team1ScoreLabel.text = game.teamList[0].score.description
		team2ScoreLabel.text = game.teamList[1].score.description
		if game.teamList.count == 3 {
			team3ScoreLabel.text = game.teamList[2].score.description
		}
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		team3Stack.isHidden = true
		if (currentGame?.teamList.count ?? 2) > 2 {
			team3Stack.isHidden = false
		}
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		switch segue.identifier {
		case "ShowTeamNames":
			let vc = segue.destination as! TeamNamesVC
			vc.delegate = self
			vc.names = currentGame?.teamNames()
			
			print("show team names")
		default:
			print("Missing proper segue identifier")
		}
    }
    

}

extension MainVC: TeamNameDelegate {
	func teamNameDelegate(team1Name: String, team2Name: String, team3Name: String) {
		currentGame = GameType(team1Name: team1Name, team2Name: team2Name, team3Name: team3Name)
		updateTeamLabels(from: currentGame!)
		team3Stack.isHidden = (team3Name == "")
	}
	
	
}
