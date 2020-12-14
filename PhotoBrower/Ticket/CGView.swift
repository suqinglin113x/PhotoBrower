//
//  CGView.swift
//  PhotoBrower
//
//  Created by 苏庆林 on 2020/12/11.
//  Copyright © 2020 苏庆林. All rights reserved.
//

import UIKit

class CGView: UILabel {

    override init(frame: CGRect) {
            super.init(frame: frame)
            self.backgroundColor = UIColor.clear
        }
         
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
         
        override func draw(_ rect: CGRect) {
            super.draw(rect)
            //获取绘图上下文
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            
            //设置描线颜色
            context.setStrokeColor(UIColor.orange.cgColor)
            //设置线宽
            context.setLineWidth(1)
            
            let h: CGFloat = rect.height/3.0
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 1, y: 1))
            path.addLine(to: CGPoint(x: 1, y: rect.height/3.0))
            path.addArc(center: CGPoint(x: 1, y: rect.height/2.0), radius: h/2.0, startAngle: -(.pi/2), endAngle: .pi/2, clockwise: false)
            path.addLine(to: CGPoint(x: 1, y: rect.height-1))
            path.addLine(to: CGPoint(x: rect.width-1, y: rect.height-1))
            path.addLine(to: CGPoint(x: rect.width-1, y: h*2))
            
            path.addArc(center: CGPoint(x: rect.width-1, y: rect.height/2.0), radius: h/2.0, startAngle: .pi/2, endAngle: -.pi/2, clockwise: false)
            path.addLine(to: CGPoint(x: rect.width-1, y: 1))
            path.closeSubpath()
            
            //将路径添加到上下文
            context.addPath(path)
            //开始绘制路径
            context.strokePath()
            
        }}
