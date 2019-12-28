//
//  GameDataTypes.swift
//  SetbackScorekeeper3
//
//  Created by Derek Shore on 12/27/19.
//  Copyright © 2019 Luxumbra. All rights reserved.
//

import Foundation
class GameType {
	var teamList: [TeamType]
	var currentBid: Int
	var currentBidder: Team {
		teamList.filter {$0.isCurrentBidder == true}.first!.team
	}
	enum Team: Int, CaseIterable {
		case team1, team2, team3
	}
	
//	INIT
	init(team1Name: String, team2Name: String, team3Name: String = "", currentBid: Int = 1) {
		teamList = [TeamType(name: team1Name, team: .team1), TeamType(name: team2Name, team: .team2)]
		if team3Name != "" {
			teamList.append(TeamType(name: team3Name, team: .team3))
		}
		self.currentBid = currentBid
	}
	
//	FUNCTIONS
	func updateScore(for team: Team, with score: Int){
		teamList[team.rawValue].score += score
	}
	func selectBidder(at index: Int){
		for team in teamList {
			team.isCurrentBidder = false
		}
		teamList[index].toggleBidder()
	}
	func teamNames() -> [String]{
		var nameList: [String] = []
		for team in teamList {
			nameList.append(team.name)
		}
		return nameList
	}
	func checkForWinner(){
		for team in teamList {
			team.isWinner = (team.score >= 11)
		}
		let winnerList = teamList.filter({$0.isWinner == true})
		if winnerList.count > 1 {
			for team in winnerList {
				team.isWinner = team.isCurrentBidder
			}
		}
	}
	
}

class TeamType {
	var name: String
	var score: Int
	var isCurrentBidder: Bool
	var isWinner: Bool
	var team: GameType.Team
	init(name: String, team: GameType.Team) {
		self.name = name
		self.score = 0
		self.isCurrentBidder = false
		self.team = team
		self.isWinner = false
	}
	func toggleBidder() {
		isCurrentBidder = !isCurrentBidder
	}
}







