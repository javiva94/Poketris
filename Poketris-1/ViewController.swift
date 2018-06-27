//
//  ViewController.swift
//  Poketris-1
//
//  Created by Javier on 21/10/16.
//  Copyright © 2016 Javier. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BoardDelegate, BoardViewDataSource{
    
    var board: Board!
    
    @IBOutlet weak var nextBlockView: BoardView!
    @IBOutlet weak var boardView: BoardView!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var lineas: UILabel!
    
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        board.moveRight()
        boardView.setNeedsDisplay()
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        board.moveLeft()
        boardView.setNeedsDisplay()
    }
    
    @IBAction func swipeUp(_ sender: UISwipeGestureRecognizer) {
        board.rotate(toRight: true)
        boardView.setNeedsDisplay()
    }
    
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        board.moveDown()
        boardView.setNeedsDisplay()
    }
    
    @IBAction func tapDown(_ sender: UILongPressGestureRecognizer) {
        board.dropDown()
        boardView.setNeedsDisplay()
    }
    
    
    var contador = 0
    var timer: Timer?
    var gameInProgress = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        board = Board()
        board.delegate = self
        boardView.dataSource = self
        nextBlockView.dataSource = self
        startNewGame()
    }
    
    
    func startNewGame(){
        board.newGame()
        gameInProgress = true
        autoMoveDown()
    }
    
    func autoMoveDown(){
        guard gameInProgress else {return}
        
        board.moveDown(insertNewBlockIfNeeded: true)
        boardView.setNeedsDisplay()
        nextBlockView.setNeedsDisplay()
        
        let interval = 1.0
        
        timer = Timer.scheduledTimer(timeInterval: interval,
                                     target: self,
                                     selector: #selector(autoMoveDown),
                                     userInfo: nil,
                                     repeats: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Controller
    
    
    @IBAction func moveLeft() {
        board.moveLeft()
        boardView.setNeedsDisplay()
    }
    
    
    @IBAction func moveRight() {
        board.moveRight()
        boardView.setNeedsDisplay()
    }
    
    
    @IBAction func rotate() {
        board.rotate(toRight: true)
        boardView.setNeedsDisplay()
    }
    
    
    @IBAction func moveDown() {
        board.moveDown()
        boardView.setNeedsDisplay()
    }
    
    // MARK: - Delegado
    
    func gameOver() {
        print("Game Over")
        gameInProgress = false
        
        // crear un UIAlertController:
        let alert = UIAlertController(title: "GAME OVER",
                                      message: "Pulsa Ok para empezar",
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: . default) {aa in self.startNewGame()})
        
        // presentar el Alert Controller
        present(alert, animated: true, completion: nil)
        contador = 0
        score.text = "Score " + String(contador)
        lineas.text = "Lineas conseguidas" + String(contador)
    }
    
    func rowCompleted() {
        print("Row Completed!")
        contador += 100
        score.text = "Score " + String(contador)
        lineas.text = "Lineas conseguidas " + String(contador / 100)
        score.setNeedsDisplay()
        lineas.setNeedsDisplay()
        
        
        //ponemos un contador que cuando se complete fila aumente en 1 y le ponemos valor con etiqueta
    }
    
    // MARK: - Data Source tablero
    
    func numberOfRows(in boardView: BoardView) -> Int {
        switch boardView {
        case self.boardView:
            return board.rowsCount
        case self.nextBlockView:
            return board.nextBlock?.height ?? 0
        default:
            return 0
        }
    }
    
    func numberOfColumns(in boardView: BoardView) -> Int {
        switch boardView{
        case self.boardView:
            return board.columnsCount
        case self.nextBlockView:
            return board.nextBlock?.width ?? 0
        default:
            return 0
        }
    }
    
    func backgroundImageName(in boardView: BoardView, atRow row: Int, atColumn column: Int) -> UIImage? {
        switch boardView{
        case self.boardView:
            if let texture = board.currentTexture(atRow: row, atColumn: column){
                let imageName = texture.backgroundImageName()
                return cachedImage(name: imageName)
            }
            else {
                return nil
            }
        case self.nextBlockView:
            guard let block = board.nextBlock, block.isSolid(row: row, column: column) else {
                return nil
            }
            let imageName = block.texture.backgroundImageName()
            return cachedImage(name: imageName)
        default:
            return nil
        }
    }
    
    func foregroundImageName(in boardView: BoardView, atRow row: Int, atColumn column: Int) -> UIImage? {
        switch boardView {
        case self.boardView:
            if let texture = board.currentTexture(atRow: row, atColumn: column) {
                let imageName = texture.pokemonImageName()
                return cachedImage(name: imageName)
            } else {
                return nil
            }
        case self.nextBlockView:
            guard let block = board.nextBlock, block.isSolid(row: row, column: column)
                else {
                    return nil
            }
            let imageName = block.texture.pokemonImageName()
            return cachedImage(name: imageName)
        default:
            return nil
        }
    }
    
    /*
     func blockWidth(for: BoardView) -> Int{
     guard let block = board.nextBlock else {
     return false
     }
     return block.isSolid(row: row, column: column)
     }
     */
    func isSolid (_ blockView: BoardView, atRow row: Int, atColumn column: Int) -> Bool {
        guard let block = board.nextBlock else {
            return false
        }
        return block.isSolid(row: row, column: column)
    }
    
    func texture (of: BoardView) -> Texture {
        guard let block = board.nextBlock else {
            return -1
        }
        return block.texture
    }
    
    var imagesCache = [String: UIImage]()
    
    private func cachedImage(name imageName: String) -> UIImage? {
        if let image = imagesCache[imageName] {
            return image
        }
        else if let image = UIImage(named: imageName) {
            imagesCache[imageName] = image
            return image
        }
        return nil
    }
    
    
    
    func texture(in: BoardView, atRow row: Int, atColumn column: Int) -> Texture? {
        let texture = board.currentTexture(atRow: row, atColumn: column)
        return texture
    }
    
}
