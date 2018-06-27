//
//  BoardView.swift
//  Poketris-1
//
//  Created by Javier on 21/10/16.
//  Copyright © 2016 Javier. All rights reserved.
//

import UIKit

protocol BoardViewDataSource: class {
    func numberOfRows(in: BoardView) -> Int
    func numberOfColumns(in: BoardView) -> Int
    func isSolid(_ blockView: BoardView, atRow row: Int, atColumn column: Int) -> Bool
    func backgroundImageName( in boardView: BoardView, atRow row : Int, atColumn column : Int ) -> UIImage?
    func foregroundImageName( in boardView: BoardView, atRow row : Int, atColumn column : Int ) -> UIImage?
    
}

@IBDesignable
class BoardView: UIView {
    
    weak var dataSource: BoardViewDataSource!
    
    // cambiar por un datasource
    //var board: Board!
    
    @IBInspectable
    var bgColor: UIColor = UIColor.orange
    
    
    
    override func draw(_ rect: CGRect) {
        updateBoxSize()
        drawBackground()
        drawBlocks()
    }
    
    
    private func drawBackground(){
        
        let rows = dataSource.numberOfRows(in: self)
        let columns = dataSource.numberOfColumns(in: self)
        
        
        let canvasX = box2Point(0)
        let canvasY = box2Point(0)
        let canvasWidth = box2Point(columns)
        let canvasHeight = box2Point(rows)
        
        
        let path = UIBezierPath(rect: CGRect(x: canvasX,
                                             y: canvasY,
                                             width: canvasWidth,
                                             height: canvasHeight))
        bgColor.setFill()
        path.fill()
        
    }
    
    private func drawBlocks() {
        //Tamaño del tablero
        let rows = dataSource.numberOfRows(in: self)
        let columns = dataSource.numberOfColumns(in: self)
        
        for r in 0..<rows{
            for c in 0..<columns{
                drawBox(row: r, column: c)
                
            }
        }
    }
    
    
    private func drawBox(row : Int, column : Int){
        let x = box2Point(column)
        let y = box2Point(row)
        let width = box2Point(1)
        let height = box2Point(1)
        
        let rect = CGRect(x: x, y: y, width: width, height: height)
        
        if let bgImg = dataSource.backgroundImageName(in: self, atRow: row, atColumn: column){
            
            bgImg.draw(in: rect)
        }
        
        if let fgImg = dataSource.foregroundImageName(in: self, atRow: row, atColumn: column){
            
            fgImg.draw(in: rect)
        }
    }
    private var boxSize: CGFloat = 0
    
    private func updateBoxSize(){
        let rows = dataSource.numberOfRows(in: self)
        let columns = dataSource.numberOfColumns(in: self)
        
        let boxwidth = bounds.size.width / CGFloat(columns)
        let boxHeight = bounds.size.height / CGFloat(rows)
        
        boxSize = min(boxwidth,boxHeight)
        
        
    }
    
    private func box2Point(_ box: Int) ->CGFloat{
        
        return CGFloat(box)*boxSize
    }
    
    
    
    
    
}
