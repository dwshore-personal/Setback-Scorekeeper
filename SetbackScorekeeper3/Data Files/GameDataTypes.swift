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
	var currentBidder: Team
	enum Team: Int, CaseIterable {
		case team1, team2, team3
	}
	
	init(team1Name: String, team2Name: String, team3Name: String = "", currentBid: Int = 1) {
		teamList = [TeamType(name: team1Name), TeamType(name: team2Name)]
		if team3Name != "" {
			teamList.append(TeamType(name: team3Name))
		}
		self.currentBid = currentBid
		currentBidder = .team1
	}
	
	func updateScore(for team: Team, with score: Int){
		teamList[team.rawValue].score += score
	}
	func selectBidder(at index: Int){
		for team in teamList {
			team.isCurrentBidder = false
		}
		teamList[index].toggleBidder()
		currentBidder = Team(rawValue: index)!
	}
	func teamNames() -> [String]{
		var nameList: [String] = []
		for team in teamList {
			nameList.append(team.name)
		}
		return nameList
	}
	
}

class TeamType {
	var name: String
	var score: Int
	var isCurrentBidder: Bool
	init(name: String, score: Int = 0, isCurrentBidder: Bool = false) {
		self.name = name
		self.score = score
		self.isCurrentBidder = isCurrentBidder
	}
	func toggleBidder() {
		isCurrentBidder = !isCurrentBidder
	}
}


class PointType {
	var name: String
	var isSelected: Bool = false
	init(name: String, isSelected: Bool = false) {
		self.name = name
		self.isSelected = isSelected
	}
	func toggleSelection(){
		isSelected = !isSelected
	}
}

class PointList {
	var list: [PointType]
	init() {
		self.list = [
		PointType(name: "High"),
		PointType(name: "Low"),
		PointType(name: "Jack"),
		PointType(name: "Joker"),
		PointType(name: "Game"),
		PointType(name: "Shot the moon")
		]
	}
	func toggleSelection(at index: Int){
		list[index].toggleSelection()
	}
}

class Round {
	var pointList = [PointList.init().list, PointList.init().list, PointList.init().list]
	var teamScores: [Int] = [0,0,0]
	
	func pointMenu(for section: Int) -> [PointType]{
		return pointList[section]
	}
	
	func cellData(indexPath: IndexPath) -> PointType {
		return pointList[indexPath.section][indexPath.row]
	}
	
	func select(pointAt indexPath: IndexPath){
		let team = indexPath.section
		let point = indexPath.row
		pointList[team][point].toggleSelection()
		switch team {
		case 0:
			pointList[1][point].isSelected = false
			pointList[2][point].isSelected = false
		case 1:
			pointList[0][point].isSelected = false
			pointList[2][point].isSelected = false
		default:
			pointList[1][point].isSelected = false
			pointList[0][point].isSelected = false
		}
	}
	
	func teamScoreForRound(at section: Int){
		let teamPointList = pointList[section]
		let score = teamPointList.filter {$0.isSelected == true}.count
		if teamPointList.last!.isSelected {
			teamScores[section] = 22
		} else {
			teamScores[section] = score
		}
	}
	
	func resetSelections() {
		for team in pointList {
			for item in team {
				item.isSelected = false
			}
		}
	}
}
