//
//  ScoreDataTypes.swift
//  SetbackScorekeeper3
//
//  Created by Derek Shore on 12/28/19.
//  Copyright © 2019 Luxumbra. All rights reserved.
//

import Foundation


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

}


class RoundMenu {
	var pointList = [PointList.init().list, PointList.init().list, PointList.init().list]
	var teamScores: [Int] = [0,0,0]
	
	func pointMenu(for section: Int) -> [PointType]{
		return pointList[section]
	}
	
	func cellData(indexPath: IndexPath) -> PointType {
		return pointList[indexPath.section][indexPath.row]
	}
	func checkTheMoon() {
		var index = 0
		while index < pointList.count {
				if pointList[index].last!.isSelected && !(pointList[index].filter {$0.isSelected == true}.count > 5) {
					pointList[index].last!.isSelected = false
				}
			index += 1
		}
	}
	
	func shootTheMoon(for team: Int){
		var index = 0
		while index < pointList.count {
			if index == team {
				if pointList[team].last!.isSelected{
						for item in pointList[team]{
						item.isSelected = true
					}
				}
			} else {
				for item in pointList[index]{
					item.isSelected = false
				}
			}
			index += 1
		}
	}
	
	func select(pointAt indexPath: IndexPath){
		let team = indexPath.section
		let point = indexPath.row
		let selectedPoint = pointList[team][point]
		selectedPoint.toggleSelection()
		if point == 5 {
			if selectedPoint.isSelected{
				shootTheMoon(for: team)
			}
		} else {
			var teamIndex = 0
			while teamIndex < pointList.count {
				if teamIndex != team {
					pointList[teamIndex][point].isSelected = false
				}
				teamIndex += 1
			}
		}
		checkTheMoon()
	}
	
	func teamScoreForRound(at section: Int, bidder: Int, bid: Int){
		let teamPointList = pointList[section]
		let score = teamPointList.filter {$0.isSelected == true}.count
		if teamPointList.last!.isSelected {
			teamScores[section] = 22
		} else {
			if section == bidder && (score < bid){
				teamScores[section] = 0-bid
			} else {
				teamScores[section] = score
			}
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
