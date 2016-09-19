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
    var shouldChangeState: Bool = true
    
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
//        NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: #selector(ViewController.buttonTapped(_:)), userInfo: nil, repeats: true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cellSize = CGSizeMake(board.frame.width / CGFloat(GameOfLifeUIHelper.cellPerRow), board.frame.width / CGFloat(GameOfLifeUIHelper.cellPerRow))
        
        let numberOfCells: Int = Int(GameOfLifeUIHelper.cellPerRow) * Int(board.frame.height / cellSize.height)
        gameOfLife.setUp(numberOfCells)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func refresh(sender: AnyObject) {
        gameOfLife.createNewGeneration()
        board.reloadData()
    }

    func buttonTapped(sender: AnyObject){
        
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        board.reloadData()
    }
}

//MARK: Private
extension GameOfLifeViewController{
    private func changeState(cell: UICollectionViewCell, indexPath: NSIndexPath){
        gameOfLife.changeState(indexPath.row)
        cell.changeBackground(gameOfLife.stateForIndex(indexPath.row))
        
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
