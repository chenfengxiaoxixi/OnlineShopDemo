//
//  CFSegmentedControl.swift
//  SwiftOnlineShopDemo
//
//  Created by chenfeng on 2019/4/26.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import UIKit

typealias completeClosure = () -> Void

extension String{
    
    func sizeWithText(font: UIFont, size: CGSize) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = self.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect.size;
    }
    
}

@objc protocol CFSegmentedControlDataSource {
    
    func getSegmentedControlTitles() -> Array<Any>
}

@objc protocol CFSegmentedControlDelegate {
    
    func control(_ control: CFSegmentedControl ,didSelectAt Index: Int) -> ()

}


class CFSegmentedControl: UIView {

    weak open var delegate: CFSegmentedControlDelegate?
    //weak open var dataSource: CFSegmentedControlDataSource?
    weak open var dataSource: CFSegmentedControlDataSource? {
        //外部设置完之后调用这个方法
        didSet { self.setDataSource() }
    }
    
    let bottomLineEdge:CGFloat = 15
    var numOfMenu:Int!
    var tapIndex:Int!
    var titles:Array<Any>!
    var bgLayers:Array<Any>!
    var bottomLine:UIView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(menuTapped(sender:)))
        self.addGestureRecognizer(tapGesture)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDataSource(){
      
        titles = dataSource?.getSegmentedControlTitles()
        
        numOfMenu = titles.count
        
        let textLayerInterval = self.frame.size.width / CGFloat((numOfMenu * 2))
        let bgLayerInterval = self.frame.size.width / CGFloat(numOfMenu)
        
        titles = [Any]()
        bgLayers = [Any]()

        for i in 0..<numOfMenu {
            //背景
            let bgLayerPosition = CGPoint(x: (CGFloat(i) + 0.5)*bgLayerInterval, y: self.frame.size.height/2)
            let bgLayer = self.createBgLayerWith(color: UIColor.clear, position: bgLayerPosition)
            self.layer.addSublayer(bgLayer)
            bgLayers.append(bgLayer)
            //title
            let titlePosition = CGPoint(x: (CGFloat(i) * 2 + 1) * textLayerInterval, y: self.frame.size.height / 2)
            let titleString = dataSource?.getSegmentedControlTitles()[i]
            let titleLayer = self.createTextLayerWith(string: titleString as! String, color: UIColor.black, position: titlePosition)
            self.layer.addSublayer(titleLayer)
            titles.append(titleLayer)
            
        }

        bottomLine = UIView.init(frame: CGRect(x: bottomLineEdge, y: self.mj_h - 4, width: self.mj_w/CGFloat(numOfMenu) - bottomLineEdge*2, height: 4))
        bottomLine.backgroundColor = UIColor.orange
        bottomLine.layer.contents = 2
        self.addSubview(bottomLine)
        
    }
   
    
    func createBgLayerWith(color: UIColor, position: CGPoint) -> CALayer {
        
        let layer = CATextLayer.init()
        
        layer.position = position;
        layer.bounds = CGRect(x: 0, y: 0, width: self.frame.size.width/CGFloat(numOfMenu), height: self.frame.size.height-1)
        layer.backgroundColor = color.cgColor
        
        return layer
    }
    
    func createTextLayerWith(string: String, color: UIColor, position: CGPoint) -> CATextLayer {

        let size = self.calculateTitleSizeWith(string: string, font: UIFont.systemFont(ofSize: 16))
        
        let layer = CATextLayer.init()
        let sizeWidth = (size.width < (self.frame.size.width / CGFloat(numOfMenu)) - 25) ? size.width : self.frame.size.width / CGFloat(numOfMenu) - 25;
        layer.bounds = CGRect(x: 0, y: 0, width: sizeWidth, height: size.height)
        layer.string = string
        layer.alignmentMode = .center
        layer.foregroundColor = color.cgColor

        layer.contentsScale = UIScreen.main.scale
        
        layer.position = position
        layer.fontSize = 16
        
        return layer

    }
    
    func calculateTitleSizeWith(string: String, font: UIFont) -> CGSize {

        let size = string.sizeWithText(font: font, size: CGSize(width: 280, height: 0))
        
        return size
    }
    
    @objc func menuTapped(sender: UITapGestureRecognizer) {
        
        let touchPoint = sender.location(in: self)
        
        if numOfMenu == 0 {
            return;
        }
        
        tapIndex = Int(touchPoint.x / (self.frame.size.width / CGFloat(numOfMenu)));
        
        for i in 0..<numOfMenu  {
            if i != tapIndex {
                self.animate(titleLayer: titles?[i] as! CATextLayer, isSelect: false) {
                    
                }
            }
        }
        
        self.animate(bottomLine: bottomLine) {
            self.animate(titleLayer: titles?[tapIndex] as! CATextLayer, isSelect: true, complete: {
                
            })
        }
        
        delegate?.control(self, didSelectAt: tapIndex)
    }
    
    //BottomLine左右移动
    func animate(bottomLine: UIView, complete: completeClosure) {
        
        UIView.animate(withDuration: 0.3) {
            bottomLine.mj_x = self.bottomLineEdge + (self.frame.size.width / CGFloat(self.numOfMenu)) * CGFloat(self.tapIndex);
        }
        
        complete()
    }
    
    //字体颜色改变
    func animate(titleLayer: CATextLayer, isSelect: Bool, complete: completeClosure) {
        
        let size = self.calculateTitleSizeWith(string: titleLayer.string as! String, font: UIFont.systemFont(ofSize: 16))
        
        let sizeWidth = (size.width < (self.frame.size.width / CGFloat(numOfMenu)) - 25) ? size.width : self.frame.size.width / CGFloat(numOfMenu) - 25;
        
        titleLayer.bounds = CGRect(x: 0, y: 0, width: sizeWidth, height: size.height)
        
        if isSelect
        {
            titleLayer.foregroundColor = UIColor.orange.cgColor;
        }
        else
        {
            titleLayer.foregroundColor = UIColor.black.cgColor;
        }
        
        complete()
    }
    
    func didSelect(index: Int) {
        
        tapIndex = index
        
        for i in 0..<numOfMenu
        {
            if i != tapIndex
            {
                self.animate(titleLayer: titles?[i] as! CATextLayer, isSelect: false) {
                    
                }
            }
        }
     
        self.animate(bottomLine: bottomLine) {
            self.animate(titleLayer: titles?[tapIndex] as! CATextLayer, isSelect: true, complete: {

            })
        }
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
