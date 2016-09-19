//
//  ViewController.swift
//  GameOfLife
//
//  Created by Antonia Chekrakchieva on 9/15/16.
//  Copyright © 2016 Antonia Chekrakchieva. All rights reserved.
//

import UIKit

class GameOfLifeViewController: UIViewController {

    private var gameOfLife: GameOfLifeHelper = GameOfLifeHelper()
    private var cellSize: CGSize = CGSize.zero
    private var timer: NSTimer = NSTimer()
    private var isGameRunning: Bool = false
    
    @IBOutlet weak var board: UICollectionView! {
        didSet {
            board.delegate = self
            board.dataSource = self
            board.scrollEnabled = false
            board.pagingEnabled = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cellSize = CGSizeMake(board.frame.width / CGFloat(GameOfLifeUIHelper.cellPerRow), board.frame.width / CGFloat(GameOfLifeUIHelper.cellPerRow))
        
        let numberOfCells: Int = Int(GameOfLifeUIHelper.cellPerRow) * Int(board.frame.height / cellSize.height)
        gameOfLife.setUp(numberOfCells)

    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        stopCurrentGame()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

//MARK: UBAction
extension GameOfLifeViewController{
    @IBAction func refreshGeneration(sender: AnyObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.gameOfLife.createNewGeneration()
            
            if !self.gameOfLife.activeItemsExist {
                self.stopCurrentGame()
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.board.reloadData()
            }
        }
    }
    
    @IBAction func runGame(sender: AnyObject) {
        
        guard !isGameRunning else{
            return
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: #selector(GameOfLifeViewController.refreshGeneration(_:)), userInfo: nil, repeats: true)
        isGameRunning = true
    }
    
    @IBAction func stopGame(sender: AnyObject) {
        stopCurrentGame()
    }
    
    @IBAction func restartGame(sender: AnyObject) {
        stopCurrentGame()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.gameOfLife.removeGeneration()
            
            dispatch_async(dispatch_get_main_queue()) {
                self.board.reloadData()
            }
        }
    }
}

//MARK: Private
extension GameOfLifeViewController{
    private func changeState(cell: UICollectionViewCell, indexPath: NSIndexPath){
        gameOfLife.changeState(indexPath.row)
        cell.changeBackground(gameOfLife.stateForIndex(indexPath.row))
        
    }
    
    private func stopCurrentGame(){
        isGameRunning = false
        timer.invalidate()
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension GameOfLifeViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return cellSize
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) else {
            return
        }
        changeState(cell, indexPath: indexPath)

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return GameOfLifeUIHelper.spacingBetweenCells
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return GameOfLifeUIHelper.spacingBetweenCells
    }
}

//MARK: UICollectionViewDataSource
extension GameOfLifeViewController: UICollectionViewDataSource{
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameOfLife.numberOfItems()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(GameOfLifeUIHelper.cellIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        cell.setUpBorder()
        cell.changeBackground(gameOfLife.stateForIndex(indexPath.row))
        return cell
    }
    
    
}
