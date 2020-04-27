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
	@IBOutlet weak var setupDoneStack: UIStackView!
	@IBOutlet weak var bidderOutlet: UISegmentedControl!
	@IBOutlet weak var scoreRoundOutlet: UIButton!
	@IBOutlet weak var newGameOutlet: UIButton!
	
	
//	MARK: - ACTION OUTLETS
	@IBAction func bidSelect(_ sender: UISegmentedControl) {
		currentGame?.currentBid = sender.selectedSegmentIndex+1
		print("bid: \(String(describing: currentGame?.currentBid.description))")
	}
	
	@IBAction func bidderSelect(_ sender: UISegmentedControl) {
		let index = bidderOutlet.selectedSegmentIndex
		currentGame?.selectBidder(at: index)
	}
	
	
	@IBAction func menuButton(_ sender: Any) {
		performSegue(withIdentifier: "ShowTeamNames", sender: self)
	}
	
	@IBAction func scoreRound(_ sender: UIButton) {
		performSegue(withIdentifier: "ShowScoreMenu", sender: self)
	}
	@IBAction func newGameButton(_ sender: UIButton) {
		currentGame = nil
		performSegue(withIdentifier: "ShowTeamNames", sender: self)
		scoreRoundOutlet.isEnabled = true
	}
	
//	MARK: - FUNCTIONS
	func updateTeamLabels(from game: GameType){
		team1NameLabel.text = game.teamList[0].name
		team2NameLabel.text = game.teamList[1].name
		if game.teamList.count == 3 {
			team3NameLabel.text = game.teamList[2].name
		}
	}
	
	func updateScoreLabels(from game: GameType){
		configureScoreDisplay(team1ScoreLabel, from: game, teamIndex: 0)
		configureScoreDisplay(team2ScoreLabel, from: game, teamIndex: 1)
		if game.teamList.count == 3 {
			configureScoreDisplay(team3ScoreLabel, from: game, teamIndex: 2)
		}
	}

	func configureScoreDisplay(_ label: UILabel, from game: GameType, teamIndex: Int) {
		game.checkForWinner()
		let score = game.teamList[teamIndex].score
		var description: String {
			if game.teamList[teamIndex].isWinner {
				label.textColor = .red
				scoreRoundOutlet.isEnabled = false
				return "Winner"
			} else if score >= 0 {
				label.textColor = .black
				return score.description
			} else {
				label.textColor = .red
				return score.description
			}
			
		}
		label.text = description
	}
	
	func updateBidderOutlet(from game: GameType){
		bidderOutlet.removeAllSegments()
		var index = 0
		while index < (currentGame?.teamList.count)! {
			bidderOutlet.insertSegment(withTitle: currentGame?.teamList[index].name, at: index, animated: true)
			index += 1
		}
		bidderOutlet.selectedSegmentIndex = 0
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
		team3Stack.isHidden = true
		setupDoneStack.isHidden = true
        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
		print("Segue: \(String(describing: segue.identifier?.description))")
		switch segue.identifier {
		case "ShowTeamNames":
			let vc = segue.destination as! TeamNamesVC
			vc.delegate = self
			vc.names = currentGame?.teamNames()
		case "ShowScoreMenu":
			let vc = segue.destination as! ScoreMenuTVC
			vc.delegate = self
			vc.currentGame = currentGame
		default:
			print("Missing proper segue identifier")
		}
    }
    

}

extension MainVC: TeamNameDelegate {
	func teamNameDelegateUpdateNames(team1Name: String, team2Name: String, team3Name: String) {
		currentGame = GameType(team1Name: team1Name, team2Name: team2Name, team3Name: team3Name)
		updateTeamLabels(from: currentGame!)
		team3Stack.isHidden = (team3Name == "")
		currentGame?.selectBidder(at: 0)
		updateBidderOutlet(from: currentGame!)
		setupDoneStack.isHidden = (currentGame == nil)
		updateScoreLabels(from: currentGame!)
	}
}

extension MainVC: ScoreMenuDelegate {
	func scoreMenuDelegateNewRound(_ round: RoundMenu) {
		for player in currentGame!.teamList {
			currentGame?.teamList[player.team.rawValue].score += round.teamScores[player.team.rawValue]
		}
		updateScoreLabels(from: currentGame!)
//		if currentGame?.currentWinner != nil {
//			print("someone won!")
//		}
	}
	
	
}
