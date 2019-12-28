//
//  ScoreMenuTVC.swift
//  SetbackScorekeeper3
//
//  Created by Derek Shore on 12/27/19.
//  Copyright © 2019 Luxumbra. All rights reserved.
//

import UIKit
protocol ScoreMenuDelegate {
	func scoreMenuDelegate(_ round: RoundMenu)
}
class ScoreMenuTVC: UITableViewController {

	var currentGame: GameType?
	var roundMenu = RoundMenu()
	var delegate: ScoreMenuDelegate?
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		roundMenu.resetSelections()
    }
	override func viewWillDisappear(_ animated: Bool) {
		delegate?.scoreMenuDelegate(roundMenu)
	}

	
//	MARK: - FUNCTIONS
	func updateScores() {
		for section in currentGame!.teamList {
			roundMenu.teamScoreForRound(at: section.team.rawValue)
		}
	}
	
	func configureCell(for cell: UITableViewCell, with item: PointType ){
		cell.textLabel!.text = item.name
		if item.isSelected {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}
	}
	
	func configureHeader(section: Int) -> String {
		let teamScore = roundMenu.teamScores[section]
		let teamName = currentGame?.teamNames()[section]
		var header = ""
		if teamScore > 5 {
			header = teamName! + ": 5 (Shot the moon!)"
		} else {
			header = teamName! + ": " + String(teamScore)
		}
		print(header)
		return header
	}
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
		if let gameData = currentGame {
			return gameData.teamList.count
		} else {
			return 0
		}
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let currentBid = currentGame?.currentBid, let currentBidder = currentGame?.currentBidder.rawValue {
			if currentBid == 6 && currentBidder == section {
				return 6
			} else {
				return 5
			}
		} else {
			return 0
		}
		
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath)
		configureCell(for: cell, with: roundMenu.cellData(indexPath: indexPath))
        return cell
    }
    
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return configureHeader(section: section)
	}
	
//	 MARK - TABLE ACTIONS
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		roundMenu.select(pointAt: indexPath)
		updateScores()

		tableView.reloadData()
	}


}
