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
	func toggleSelection(at index: Int){
		list[index].toggleSelection()
		if list.last?.isSelected == true && (list.filter { $0.isSelected == true }.count > 5 ) {
			list.last?.isSelected = false
		}
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
		for list in pointList {
			if list.last!.isSelected && !(list.filter {$0.isSelected == true}.count > 5) {
				list.last!.isSelected = false
			}
		}
	}
	func select(pointAt indexPath: IndexPath){
		let team = indexPath.section
		let point = indexPath.row
		let selectedPoint = pointList[team][point]
		if point == 5 {
			for list in pointList {
				for item in list {
					item.isSelected = false
				}
			}
			for item in pointList[team] {
				item.isSelected = true
			}
		} else {
			selectedPoint.toggleSelection()
			var index = 0
			while index < pointList.count {
				if index != team {
					pointList[index][point].isSelected = false
				}
				index += 1
			}
			/*
			switch team {
			case 0:
				pointList[1][point].isSelected = false
				pointList[2][point].isSelected = false
				pointList[1].last!.isSelected = false
				pointList[2].last!.isSelected = false
			case 1:
				pointList[0][point].isSelected = false
				pointList[2][point].isSelected = false
				pointList[0].last!.isSelected = false
				pointList[2].last!.isSelected = false
			default:
				pointList[1][point].isSelected = false
				pointList[0][point].isSelected = false
				pointList[1].last!.isSelected = false
				pointList[0].last!.isSelected = false
			}
			*/
		}
		checkTheMoon()
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
