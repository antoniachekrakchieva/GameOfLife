//
//  GameOfLifeHelper.swift
//  GameOfLife
//
//  Created by Antonia Chekrakchieva on 9/18/16.
//  Copyright © 2016 Antonia Chekrakchieva. All rights reserved.
//

import Foundation

enum State{
    case Active
    case Unactiv
    
    var opossite: State {
        switch self {
        case .Active:
            return .Unactiv
        default:
            return .Active
        }
    }
}

struct BoardState{
    var state: State
    var position: Int
    
    init(position: Int){
        state = .Unactiv
        self.position = position
    }
    
    mutating func changeState(){
        state = state.opossite
    }
    
    func isActive() -> Bool{
        return state == .Active
    }
}

class GameOfLifeHelper{
    
    private var boardValues: [BoardState] = []
    private var numberOfCells: Int = 0
    var activeItemsExist: Bool = false

    func setUp(numberOfCells: Int){
        self.numberOfCells = numberOfCells
        setUpEmptyGeneration()
        
    }
    
    func numberOfItems() -> Int{
        return boardValues.count
    }
    
    func changeState(index: Int){
        boardValues[index].changeState()

    }
    
    func stateForIndex(index: Int) -> State{
        return boardValues[index].state
    }
    
    func removeGeneration(){
        setUpEmptyGeneration()
    }
    
    func createNewGeneration(){
        activeItemsExist = false
        var newBoardValues: [BoardState] = boardValues
        for el in 0..<boardValues.count{
            if boardValues[el].isActive(){
                newBoardValues[el].state = changeActiveElementStateDependsOnNeigbours(el)
                
            } else {
                newBoardValues[el].state = changeUnactiveElementStateDependsOnNeigbours(el)
            }

        }
        
        boardValues = newBoardValues
    }
    
    private func setUpEmptyGeneration(){
        boardValues = []
        for i in 0..<numberOfCells{
            boardValues.append(BoardState(position: i))
        }
    }
    
    private func changeUnactiveElementStateDependsOnNeigbours(index: Int) -> State{
        guard numberOfLiveNeighbours(index) == 3 else{
            return .Unactiv
        }
        activeItemsExist = true
        return .Active
    }
    
    private func changeActiveElementStateDependsOnNeigbours(index: Int) -> State{
        guard numberOfLiveNeighbours(index) < 2 || numberOfLiveNeighbours(index) > 3 else{
            activeItemsExist = true
            return .Active
        }
        return .Unactiv
    }
    
    private func numberOfLiveNeighbours(index: Int) -> Int{
        var liveCells: Int = 0
        liveCells += checkLeftTopNeigbour(index)
        liveCells += checkLeftNeigbour(index)
        liveCells += checkLeftDownNeigbour(index)
        
        liveCells += checkRightTopNeigbour(index)
        liveCells += checkRightNeigbour(index)
        liveCells += checkRightDownNeigbour(index)
        
        liveCells += checkTopNeigbour(index)
        liveCells += checkDownNeigbour(index)
        
        return liveCells
    }
    
    private func checkLeftTopNeigbour(index: Int) -> Int{
        let neighbourIndex = index - GameOfLifeUIHelper.cellPerRow - 1
        return checkNeighbour(index, neighbourIndex: neighbourIndex) & isNotInTheEndOfTheBoard(neighbourIndex)
        
    }
    
    private func checkLeftDownNeigbour(index: Int) -> Int{
        let neighbourIndex = index + GameOfLifeUIHelper.cellPerRow - 1
        return checkNeighbour(index, neighbourIndex: neighbourIndex) & isNotInTheEndOfTheBoard(neighbourIndex)
        
    }
    
    private func checkLeftNeigbour(index: Int) -> Int{
        let neighbourIndex = index - 1
        return checkNeighbour(index, neighbourIndex: neighbourIndex) & isNotInTheEndOfTheBoard(neighbourIndex)
        
    }
    
    private func checkTopNeigbour(index: Int) -> Int{
        let neighbourIndex = index - GameOfLifeUIHelper.cellPerRow
        return checkNeighbour(index, neighbourIndex: neighbourIndex)
    }
    
    private func checkDownNeigbour(index: Int) -> Int{
        let neighbourIndex = index + GameOfLifeUIHelper.cellPerRow
        return checkNeighbour(index, neighbourIndex: neighbourIndex)
    }
    private func checkRightTopNeigbour(index: Int) -> Int{
        let neighbourIndex = index - GameOfLifeUIHelper.cellPerRow + 1
        return checkNeighbour(index, neighbourIndex: neighbourIndex) & isNotInTheBeginOfTheBoard(neighbourIndex)
    }
    
    private func checkRightDownNeigbour(index: Int) -> Int{
        let neighbourIndex = index + GameOfLifeUIHelper.cellPerRow + 1
        return checkNeighbour(index, neighbourIndex: neighbourIndex) & isNotInTheBeginOfTheBoard(neighbourIndex)
    }
    
    private func checkRightNeigbour(index: Int) -> Int{
        let neighbourIndex = index + 1
        return checkNeighbour(index, neighbourIndex: neighbourIndex) & isNotInTheBeginOfTheBoard(neighbourIndex)
    }
    
    private func checkNeighbour(index: Int, neighbourIndex: Int) -> Int{
        guard isValidIndex(neighbourIndex) && boardValues[neighbourIndex].isActive() else{
            return 0
        }
        return  1
    }
    
    private func isNotInTheBeginOfTheBoard(index: Int) -> Int{
        return index % GameOfLifeUIHelper.cellPerRow == 0 ? 0 : 1
        
    }
    
    private func isNotInTheEndOfTheBoard(index: Int) -> Int{
        return index % GameOfLifeUIHelper.cellPerRow == GameOfLifeUIHelper.cellPerRow - 1 ? 0 : 1
    }
    
    private func isValidIndex(index: Int) -> Bool{
        return index >= 0 && index < boardValues.count
    }

}
