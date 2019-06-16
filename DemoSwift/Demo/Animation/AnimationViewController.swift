//
//  ViewController.swift
//  Animation
//
//  Created by yaoxinpan on 2018/1/26.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

class AnimationViewController: PeekViewController {

    @IBOutlet weak var animationView: UIView!
    
    // 1.无动画；2.普通动画；3.从中间开始的动画；4.在2的基础上中间线变宽，最后恢复；
    @IBOutlet weak var animationStyle: UISegmentedControl!
    @IBOutlet weak var skipBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "学习贝塞尔曲线"
        // Do any additional setup after loading the view.
        
        customizedSkipButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - 跳过
    func customizedSkipButton() {
        let centerPoint = CGPoint.init(x: skipBtn.frame.size.width/2.0, y: skipBtn.frame.size.height/2.0)
        let radius = skipBtn.frame.size.width/2.0
        
        let path = UIBezierPath.init(arcCenter: centerPoint, radius: radius, startAngle: CGFloat(-Double.pi*0.5), endAngle: CGFloat(Double.pi*1.5), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.lightGray.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.path = path.cgPath
        
        let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 3.0
        shapeLayer.add(animation, forKey: nil)
        
        skipBtn.layer.addSublayer(shapeLayer);
    }
    
    func resetAnimationView() {
        if let sublayers = animationView.layer.sublayers {
            for layer in sublayers {
                layer.removeFromSuperlayer()
            }
        }

    }

    //MARK: - 折线
    @IBAction func onBrokenLineButton(_ sender: Any) {
        // 折线
        resetAnimationView()
        
        let linePath = UIBezierPath()
        
        // 起点
        linePath.move(to: CGPoint.init(x: 20, y: 20))
        
        // 拐点
        linePath.addLine(to: CGPoint.init(x:160, y:160))

        // 终点
        linePath.addLine(to: CGPoint.init(x: 180, y: 50))
        
        // 画布
        let shapeLayer = CAShapeLayer()
        
        // 画布大小
        shapeLayer.bounds = animationView.bounds
        
        // 画布在画板上的位置。
        // 可以这么理解：用一个图钉将一张画布钉在画板上，
        // postion是图钉在画板上的位置，anchorPoint是图钉在画布上的位置
        shapeLayer.position = CGPoint.zero
        shapeLayer.anchorPoint = CGPoint.zero
        
        // 线的宽度
        shapeLayer.lineWidth = 2.0
        
        // 线终点式样
//        shapeLayer.lineCap = kCALineCapSquare
//        shapeLayer.lineCap = kCALineCapButt
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        
        // 线的颜色
        shapeLayer.strokeColor = UIColor.orange.cgColor
        
        // 线的路径
        shapeLayer.path = linePath.cgPath
        
        // 线围成区域的填充颜色
        shapeLayer.fillColor = nil
        
        // 添加动画效果
        addAnimationTo(layer: shapeLayer)
        
        animationView.layer.addSublayer(shapeLayer)
    }

    // MARK: - 三角形
    @IBAction func onTriangleButton(_ sender: Any) {
        // 三角形
        resetAnimationView()
        
        let linePath = UIBezierPath()
        
        // 起点
        linePath.move(to: CGPoint.init(x: 20, y: 20))
        
        // 拐点
        linePath.addLine(to: CGPoint.init(x:160, y:160))
        
        // 终点
        linePath.addLine(to: CGPoint.init(x: 180, y: 50))
        
        linePath.close()
        
        // 画布
        let shapeLayer = CAShapeLayer()
        
        // 画布大小
        shapeLayer.bounds = animationView.bounds
        
        // 画布在画板上的位置。
        // 可以这么理解：用一个图钉将一张画布钉在画板上，
        // postion是图钉在画板上的位置，anchorPoint是图钉在画布上的位置
        shapeLayer.position = CGPoint.zero
        shapeLayer.anchorPoint = CGPoint.zero
        
        // 线的宽度
        shapeLayer.lineWidth = 2.0
        
        // 线的颜色
        shapeLayer.strokeColor = UIColor.orange.cgColor
        
        // 线拐点式样
//        shapeLayer.lineJoin = kCALineJoinBevel
//        shapeLayer.lineJoin = kCALineJoinMiter
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        // 线的路径
        shapeLayer.path = linePath.cgPath
        
        // 线围成区域的填充颜色
        shapeLayer.fillColor = nil
        
        // 添加动画效果
        addAnimationTo(layer: shapeLayer)
        
        animationView.layer.addSublayer(shapeLayer)
    }
    
    // MARK: - 多边形
    @IBAction func onPolygonButton(_ sender: Any) {
        // 多边形
        resetAnimationView()
        
        let polygonPath = UIBezierPath()
        polygonPath.move(to: CGPoint.init(x: 100, y: 0.0))
        polygonPath.addLine(to: CGPoint.init(x: 200, y: 40))
        polygonPath.addLine(to: CGPoint.init(x: 160, y: 140))
        polygonPath.addLine(to: CGPoint.init(x: 40, y: 140))
        polygonPath.addLine(to: CGPoint.init(x: 0, y: 40))
        polygonPath.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = animationView.bounds
        shapeLayer.position = CGPoint.init(x: 100, y: 100)
        shapeLayer.anchorPoint = CGPoint.zero
        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = UIColor.orange.cgColor
        shapeLayer.fillColor = nil;
        shapeLayer.path = polygonPath.cgPath
        addAnimationTo(layer: shapeLayer)
        animationView.layer.addSublayer(shapeLayer)
    }
    
    // MARK: - 曲面
    @IBAction func onCurveButton(_ sender: Any) {
        // 曲面
        resetAnimationView()
        
        let path = UIBezierPath()
        path.move(to: CGPoint.init(x: 100, y: 100))
        path.addLine(to: CGPoint.init(x: 200, y: 200))
        path.addArc(withCenter: CGPoint.init(x: 200, y: 200), radius: 50, startAngle: 0, endAngle: CGFloat(Double.pi), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.orange.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.fillColor = nil
        shapeLayer.position = CGPoint.zero
        shapeLayer.anchorPoint = CGPoint.zero
        shapeLayer.bounds = animationView.bounds
        addAnimationTo(layer: shapeLayer)
        animationView.layer.addSublayer(shapeLayer)
    }
    
    // MARK: - 空心矩形
    @IBAction func onHollowRectangleButton(_ sender: Any) {
        // 空心矩形
        resetAnimationView()
        
        let path = UIBezierPath.init(rect: CGRect.init(x: 130, y: 10, width: 100, height: 80))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.bounds = animationView.bounds
        shapeLayer.position = CGPoint.zero
        shapeLayer.anchorPoint = CGPoint.zero
        addAnimationTo(layer: shapeLayer)
        animationView.layer.addSublayer(shapeLayer)
    }
    
    // MARK: - 实心矩形
    @IBAction func onSolidRectangleButton(_ sender: Any) {
        // 实心矩形
        resetAnimationView()
        
        let path = UIBezierPath.init(rect: CGRect.init(x: 130, y: 10, width: 100, height: 80))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.bounds = animationView.bounds
        shapeLayer.position = CGPoint.zero
        shapeLayer.anchorPoint = CGPoint.zero
        addAnimationTo(layer: shapeLayer)
        animationView.layer.addSublayer(shapeLayer)
    }
    
    // MARK: - 圆角矩形
    @IBAction func onRoundRectangleButton(_ sender: Any) {
        // 圆角矩形
        resetAnimationView()
        
        let path = UIBezierPath.init(roundedRect: CGRect.init(x: 130, y: 10, width: 100, height: 80), cornerRadius: 10)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.bounds = animationView.bounds
        shapeLayer.position = CGPoint.zero
        shapeLayer.anchorPoint = CGPoint.zero
        addAnimationTo(layer: shapeLayer)
        animationView.layer.addSublayer(shapeLayer)
    }
    
    // MARK: - 单圆角矩形
    @IBAction func onSingleRoundRectButton(_ sender: Any) {
        // 单圆角矩形
        resetAnimationView()
        
        
        let path = UIBezierPath.init(roundedRect: CGRect.init(x: 130, y: 10, width: 100, height: 80), byRoundingCorners: UIRectCorner.topLeft, cornerRadii: CGSize.init(width: 10, height: 10))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.bounds = animationView.bounds
        shapeLayer.position = CGPoint.zero
        shapeLayer.anchorPoint = CGPoint.zero
        addAnimationTo(layer: shapeLayer)
        animationView.layer.addSublayer(shapeLayer)
        
    }
    
    // MARK: - 圆
    @IBAction func onCircularButton(_ sender: Any) {
        // 圆
        resetAnimationView()
        
        let path = UIBezierPath.init(ovalIn: CGRect.init(x: 50, y: 50, width: 200, height: 200))
        let shapLayer = CAShapeLayer()
        shapLayer.path = path.cgPath
        shapLayer.fillColor = nil
        shapLayer.strokeColor = UIColor.red.cgColor
        shapLayer.lineWidth = 2
        shapLayer.bounds = animationView.bounds
        shapLayer.position = CGPoint.zero
        shapLayer.anchorPoint = CGPoint.zero
        
        addAnimationTo(layer: shapLayer)
        animationView.layer.addSublayer(shapLayer)
    }
    
    // MARK: - 椭圆
    @IBAction func onEllipseButton(_ sender: Any) {
        // 椭圆
        resetAnimationView()
        
        let path = UIBezierPath.init(ovalIn: CGRect.init(x: 50, y: 50, width: 300, height: 200))
        let shapLayer = CAShapeLayer()
        shapLayer.path = path.cgPath
        shapLayer.fillColor = nil
        shapLayer.strokeColor = UIColor.red.cgColor
        shapLayer.lineWidth = 2
        shapLayer.bounds = animationView.bounds
        shapLayer.position = CGPoint.zero
        shapLayer.anchorPoint = CGPoint.zero
        
        addAnimationTo(layer: shapLayer)
        animationView.layer.addSublayer(shapLayer)
    }
    
    // MARK: - 圆弧
    @IBAction func onArcButton(_ sender: Any) {
        // 圆弧
        resetAnimationView()

        let path = UIBezierPath.init(arcCenter: CGPoint(x: 100, y: 100), radius: 80, startAngle: 0, endAngle: CGFloat(Double.pi), clockwise: true)
        let shapLayer = CAShapeLayer()
        shapLayer.path = path.cgPath
        shapLayer.fillColor = nil
        shapLayer.strokeColor = UIColor.red.cgColor
        shapLayer.lineWidth = 2
        shapLayer.bounds = animationView.bounds
        shapLayer.position = CGPoint.zero
        shapLayer.anchorPoint = CGPoint.zero
        
        addAnimationTo(layer: shapLayer)
        animationView.layer.addSublayer(shapLayer)
    }
    
    // MARK: - 二次贝塞尔曲线1
    @IBAction func onBezierOne(_ sender: Any) {
        // 二次贝塞尔曲线1
        resetAnimationView()
        
        let path1 = UIBezierPath()
        path1.move(to: CGPoint.init(x: 10, y: 100))
        path1.addQuadCurve(to: CGPoint.init(x: 200, y: 50), controlPoint: CGPoint.init(x: 100, y: 200))
        
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.position = CGPoint.zero
        shapeLayer1.anchorPoint = CGPoint.zero
        shapeLayer1.lineWidth = 2
        shapeLayer1.fillColor = nil
        shapeLayer1.strokeColor = UIColor.green.cgColor
        shapeLayer1.path = path1.cgPath
        shapeLayer1.bounds = animationView.bounds
        addAnimationTo(layer: shapeLayer1)
        animationView.layer.addSublayer(shapeLayer1)
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint.init(x: 10, y: 100))
        path2.addQuadCurve(to: CGPoint.init(x: 100, y: 50), controlPoint: CGPoint.init(x: 100, y: 200))
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.position = CGPoint.zero
        shapeLayer2.anchorPoint = CGPoint.zero
        shapeLayer2.lineWidth = 2
        shapeLayer2.fillColor = nil
        shapeLayer2.strokeColor = UIColor.red.cgColor
        shapeLayer2.path = path2.cgPath
        shapeLayer2.bounds = animationView.bounds
        addAnimationTo(layer: shapeLayer2)
        animationView.layer.addSublayer(shapeLayer2)
    }
    
    // MARK: - 二次贝塞尔曲线2
    @IBAction func onBezierTwo(_ sender: Any) {
        // 二次贝塞尔曲线2
        resetAnimationView()
        
        let path1 = UIBezierPath()
        path1.move(to: CGPoint.init(x: 10, y: 100))
        path1.addQuadCurve(to: CGPoint.init(x: 200, y: 50), controlPoint: CGPoint.init(x: 100, y: 200))
        
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.position = CGPoint.zero
        shapeLayer1.anchorPoint = CGPoint.zero
        shapeLayer1.lineWidth = 2
        shapeLayer1.fillColor = nil
        shapeLayer1.strokeColor = UIColor.green.cgColor
        shapeLayer1.path = path1.cgPath
        shapeLayer1.bounds = animationView.bounds
        addAnimationTo(layer: shapeLayer1)
        animationView.layer.addSublayer(shapeLayer1)
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint.init(x: 10, y: 100))
        path2.addQuadCurve(to: CGPoint.init(x: 200, y: 50), controlPoint: CGPoint.init(x: 100, y: 300))
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.position = CGPoint.zero
        shapeLayer2.anchorPoint = CGPoint.zero
        shapeLayer2.lineWidth = 2
        shapeLayer2.fillColor = nil
        shapeLayer2.strokeColor = UIColor.red.cgColor
        shapeLayer2.path = path2.cgPath
        shapeLayer2.bounds = animationView.bounds
        addAnimationTo(layer: shapeLayer2)
        animationView.layer.addSublayer(shapeLayer2)
    }
    
    // MARK: - 曲面
    @IBAction func onCamberButton(_ sender: Any) {
        // 曲面
        resetAnimationView()
        
        let path = UIBezierPath()
        path.move(to: CGPoint.init(x: 50, y: 100))
        path.addLine(to: CGPoint.init(x: 50, y: 200))
        path.addLine(to: CGPoint.init(x: 200, y: 200))
        path.addLine(to: CGPoint.init(x: 200, y: 100))
        path.addQuadCurve(to: CGPoint.init(x: 50, y: 100), controlPoint: CGPoint.init(x: 125, y: 0))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.position = CGPoint.zero
        shapeLayer.anchorPoint = CGPoint.zero
        shapeLayer.lineWidth = 2
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.path = path.cgPath
        shapeLayer.bounds = animationView.bounds
        addAnimationTo(layer: shapeLayer)
        animationView.layer.addSublayer(shapeLayer)
    }
    
    // MARK: - 单控制点曲线
    @IBAction func onSingleCurveButton(_ sender: Any) {
        // 单控制点曲线
        resetAnimationView()
        
        let startPoint = CGPoint.init(x: 50, y: 100)
        let controlPoint = CGPoint.init(x: 175, y: 10)
        let endPoint = CGPoint.init(x: 300, y: 100)
        
        let startLayer = CALayer()
        startLayer.frame = CGRect.init(origin: startPoint, size: CGSize.init(width: 3, height: 3))
        startLayer.backgroundColor = UIColor.red.cgColor
        
        let controlLayer = CALayer()
        controlLayer.frame = CGRect.init(origin: controlPoint, size: CGSize.init(width: 3, height: 3))
        controlLayer.backgroundColor = UIColor.purple.cgColor
        
        let endLayer = CALayer()
        endLayer.frame = CGRect.init(origin: endPoint, size: CGSize.init(width: 3, height: 3))
        endLayer.backgroundColor = UIColor.blue.cgColor
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addQuadCurve(to: endPoint, controlPoint: controlPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.position = CGPoint.zero
        shapeLayer.anchorPoint = CGPoint.zero
        shapeLayer.bounds = animationView.bounds
        
        addAnimationTo(layer: shapeLayer)
        animationView.layer.addSublayer(shapeLayer)
        animationView.layer.addSublayer(startLayer)
        animationView.layer.addSublayer(controlLayer)
        animationView.layer.addSublayer(endLayer)
    }
    
    // MARK: - 双控制点曲线
    @IBAction func onTwoCurveButton(_ sender: Any) {
        // 双控制点曲线
        resetAnimationView()
        
        let startPoint = CGPoint.init(x: 50, y: 70)
        let controlPoint1 = CGPoint.init(x: 112.5, y: 10)
        let controlPoint2 = CGPoint.init(x: 237.5, y: 130)
        let endPoint = CGPoint.init(x: 300, y: 70)
        
        let startLayer = CALayer()
        startLayer.frame = CGRect.init(origin: startPoint, size: CGSize.init(width: 3, height: 3))
        startLayer.backgroundColor = UIColor.red.cgColor
        
        let controlLayer1 = CALayer()
        controlLayer1.frame = CGRect.init(origin: controlPoint1, size: CGSize.init(width: 3, height: 3))
        controlLayer1.backgroundColor = UIColor.purple.cgColor
        
        let controlLayer2 = CALayer()
        controlLayer2.frame = CGRect.init(origin: controlPoint2, size: CGSize.init(width: 3, height: 3))
        controlLayer2.backgroundColor = UIColor.black.cgColor
        
        let endLayer = CALayer()
        endLayer.frame = CGRect.init(origin: endPoint, size: CGSize.init(width: 3, height: 3))
        endLayer.backgroundColor = UIColor.blue.cgColor
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 2
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.position = CGPoint.zero
        shapeLayer.anchorPoint = CGPoint.zero
        shapeLayer.bounds = animationView.bounds
        
        addAnimationTo(layer: shapeLayer)
        animationView.layer.addSublayer(shapeLayer)
        animationView.layer.addSublayer(startLayer)
        animationView.layer.addSublayer(controlLayer1)
        animationView.layer.addSublayer(controlLayer2)
        animationView.layer.addSublayer(endLayer)
    }
    
    // MARK: - 三次贝塞尔曲线
    @IBAction func onBeaierThree(_ sender: Any) {
        // 三次贝塞尔曲线
        resetAnimationView()
        
        let path = UIBezierPath()
        path.move(to: CGPoint.init(x: 20, y: 100))
        path.addCurve(to: CGPoint.init(x: 220, y: 100), controlPoint1: CGPoint.init(x: 50, y: 75), controlPoint2: CGPoint.init(x: 150, y: 125))
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.bounds = animationView.bounds
        shapeLayer.position = CGPoint.zero
        shapeLayer.anchorPoint = CGPoint.zero
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = 2
        addAnimationTo(layer: shapeLayer)
        animationView.layer.addSublayer(shapeLayer)
    }
    
    // MARK: - 优酷
    @IBAction func onYouKuButton(_ sender: Any) {
        // 优酷
        resetAnimationView()
        
        let duration: CGFloat = 0.5  // 动画持续时间
        
        // 添加基础layer
        let baseLayer = CALayer()
        baseLayer.frame = CGRect.init(x: 50, y: 50, width: 200, height: 200);
        baseLayer.backgroundColor = animationView.backgroundColor!.cgColor
        animationView.layer.addSublayer(baseLayer)
        
        // 初始状态是暂停
        
        // 左边竖线
        let leftLineEndPoint = CGPoint.init(x: 70, y: 60)
        let leftLineStartPoint = CGPoint.init(x: 70, y: 140)
        let leftLinePath = UIBezierPath()
        leftLinePath.move(to: leftLineStartPoint)
        leftLinePath.addLine(to: leftLineEndPoint)
        let leftLineShape = CAShapeLayer()
        leftLineShape.path = leftLinePath.cgPath
        leftLineShape.lineWidth = 18
        leftLineShape.strokeColor = UIColor.hexRGB(0x46A1FB, 1.0).cgColor
        leftLineShape.fillColor = nil
        leftLineShape.lineCap = CAShapeLayerLineCap.round
        leftLineShape.lineJoin = CAShapeLayerLineJoin.round
        
        // 右边竖线
        let rightLineEndPoint = CGPoint.init(x: 130, y: 140)
        let rightLineStartPoint = CGPoint.init(x: 130, y: 60)
        let rightLinePath = UIBezierPath()
        rightLinePath.move(to: rightLineStartPoint)
        rightLinePath.addLine(to: rightLineEndPoint)
        let rightLineShape = CAShapeLayer()
        rightLineShape.path = rightLinePath.cgPath
        rightLineShape.lineWidth = 18
        rightLineShape.strokeColor = UIColor.hexRGB(0x46A1FB, 1.0).cgColor
        rightLineShape.fillColor = nil
        rightLineShape.lineCap = CAShapeLayerLineCap.round
        rightLineShape.lineJoin = CAShapeLayerLineJoin.round
        
        
        // 圆弧的圆点和半径
        let centerPoint = CGPoint.init(x: (leftLineStartPoint.x + rightLineEndPoint.x)/2, y: (leftLineStartPoint.y + leftLineEndPoint.y)/2)
        let radius = sqrt(pow(rightLineEndPoint.x - leftLineEndPoint.x, 2) + pow(rightLineEndPoint.y - rightLineStartPoint.y, 2)) / 2
        
        // 下边的圆弧
        let undersideCirclePath = UIBezierPath()
        undersideCirclePath.move(to: leftLineStartPoint)
        undersideCirclePath.addArc(withCenter: centerPoint, radius: radius, startAngle: CGFloat(Double.pi)/2.0 + asin((rightLineEndPoint.x - leftLineEndPoint.x)/2.0/radius), endAngle: CGFloat(Double.pi)*1.5 + asin((rightLineEndPoint.x - leftLineEndPoint.x)/2.0/radius), clockwise: false)
        let undersideCircleShape = CAShapeLayer()
        undersideCircleShape.path = undersideCirclePath.cgPath
        undersideCircleShape.fillColor = nil
        undersideCircleShape.strokeColor = UIColor.hexRGB(0x5BBCF9, 1.0).cgColor
        undersideCircleShape.lineWidth = 18
        undersideCircleShape.lineCap = CAShapeLayerLineCap.round
        undersideCircleShape.lineJoin = CAShapeLayerLineJoin.round
        undersideCircleShape.strokeEnd = 0
        
        // 上边的圆弧
        let aboveCirclePath = UIBezierPath()
        aboveCirclePath.move(to: rightLineStartPoint)
        aboveCirclePath.addArc(withCenter: centerPoint, radius: radius, startAngle: CGFloat(Double.pi)*1.5 + asin((rightLineEndPoint.x - leftLineEndPoint.x)/2.0/radius), endAngle: CGFloat(Double.pi)/2.0 + asin((rightLineEndPoint.x - leftLineEndPoint.x)/2.0/radius), clockwise: false)

        let aboveCircleShape = CAShapeLayer()
        aboveCircleShape.path = aboveCirclePath.cgPath
        aboveCircleShape.fillColor = nil
        aboveCircleShape.strokeColor = UIColor.hexRGB(0x5BBCF9, 1.0).cgColor
        aboveCircleShape.lineWidth = 18
        aboveCircleShape.lineCap = CAShapeLayerLineCap.round
        aboveCircleShape.lineJoin = CAShapeLayerLineJoin.round
        aboveCircleShape.strokeEnd = 0

        // 红色三角形
        let triangleLeftPoint = CGPoint.init(x: (rightLineStartPoint.x - leftLineStartPoint.x)/4 + leftLineStartPoint.x, y: (leftLineStartPoint.y - leftLineEndPoint.y)/3+leftLineEndPoint.y)
        let triangleRightPoint = CGPoint.init(x:rightLineStartPoint.x - (rightLineStartPoint.x - leftLineStartPoint.x)/4 , y: (leftLineStartPoint.y - leftLineEndPoint.y)/3+leftLineEndPoint.y )
        let triangleCenterPoint = CGPoint.init(x:(leftLineEndPoint.x + rightLineEndPoint.x) / 2 , y: rightLineEndPoint.y - (rightLineEndPoint.y - rightLineStartPoint.y)/3)
        
        // 左边红线
        let triangleLeftLine = UIBezierPath()
        triangleLeftLine.move(to: triangleCenterPoint)
        triangleLeftLine.addLine(to: triangleLeftPoint)
        let triangleLeftShape = CAShapeLayer()
        triangleLeftShape.path = triangleLeftLine.cgPath
        triangleLeftShape.fillColor = nil
        triangleLeftShape.strokeColor = UIColor.hexRGB(0xE74F4C, 1.0).cgColor
        triangleLeftShape.lineWidth = 18
        triangleLeftShape.lineCap = CAShapeLayerLineCap.round
        triangleLeftShape.lineJoin = CAShapeLayerLineJoin.round
        triangleLeftShape.opacity = 0
        baseLayer.addSublayer(triangleLeftShape)
        
        // 右边红线
        let triangleRightLine = UIBezierPath()
        triangleRightLine.move(to: triangleCenterPoint)
        triangleRightLine.addLine(to: triangleRightPoint)
        let triangleRightShape = CAShapeLayer()
        triangleRightShape.path = triangleRightLine.cgPath
        triangleRightShape.fillColor = nil
        triangleRightShape.strokeColor = UIColor.hexRGB(0xE74F4C, 1.0).cgColor
        triangleRightShape.lineWidth = 18
        triangleRightShape.lineCap = CAShapeLayerLineCap.round
        triangleRightShape.lineJoin = CAShapeLayerLineJoin.round
        triangleRightShape.opacity = 0
        baseLayer.addSublayer(triangleRightShape)
        
        baseLayer.addSublayer(undersideCircleShape)
        baseLayer.addSublayer(aboveCircleShape)
        baseLayer.addSublayer(leftLineShape)
        baseLayer.addSublayer(rightLineShape)
        
        Timer.scheduledTimer(withTimeInterval: Double(duration), repeats: false, block: {(timer) in
            // 1s后重暂停到播放按钮
            self.strokeEndAnimation(fromValue: 1.0, toValue: 0.0, layer: leftLineShape, duration: duration/2)
            self.strokeEndAnimation(fromValue: 1.0, toValue: 0.0, layer: rightLineShape, duration: duration/2)
            self.strokeEndAnimation(fromValue: 0.0, toValue: 1.0, layer: undersideCircleShape, duration: duration)
            self.strokeEndAnimation(fromValue: 0.0, toValue: 1.0, layer: aboveCircleShape, duration: duration)
            self.actionRotateAnimationClockwise(layer: baseLayer, duration: duration, clockwise: false)
            let time:TimeInterval = Double(duration/2)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: {
                self.actionTriangleOpacityAnimation(frome: 0, to: 0.8, layer: triangleLeftShape, duration: duration/2)
                self.actionTriangleOpacityAnimation(frome: 0, to: 0.8, layer: triangleRightShape, duration: duration/2)
            })
        })
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {(timer) in
            // 4s后重播放到暂停按钮
            self.strokeEndAnimation(fromValue: 1.0, toValue: 0.0, layer: undersideCircleShape, duration: duration)
            self.strokeEndAnimation(fromValue: 1.0, toValue: 0.0, layer: aboveCircleShape, duration: duration)
            self.actionTriangleOpacityAnimation(frome: 0.8, to: 0, layer: triangleLeftShape, duration: duration/2)
            self.actionTriangleOpacityAnimation(frome: 0.8, to: 0, layer: triangleRightShape, duration: duration/2)
            self.actionRotateAnimationClockwise(layer: baseLayer, duration: duration, clockwise: true)
            let time:TimeInterval = Double(duration/2)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: {
                self.strokeEndAnimation(fromValue: 0.0, toValue: 1.0, layer: leftLineShape, duration: duration/2)
                self.strokeEndAnimation(fromValue: 0.0, toValue: 1.0, layer: rightLineShape, duration: duration/2)
            })
        })

    }

    // MARK: - 打下班卡
    @IBAction func onClockOffButton(_ sender: Any) {
        let vc = ClockOffViewController()
        navigationController!.pushViewController(vc, animated: true)
    }
    
}

extension AnimationViewController {
    func addAnimationTo(layer: CAShapeLayer) {
        let animationIndex = animationStyle.selectedSegmentIndex
        switch animationIndex {
        case 1:
            addOneAnimation(layer: layer, duration: 1.5)
        case 2:
            addTwoAnimation(layer: layer, duration: 1.5)
        case 3:
            addThreeAnimation(layer: layer, duration: 1.5)
        default:
            print(" ")
        }
    }
    
    
    func addOneAnimation(layer: CAShapeLayer, duration: CFTimeInterval) {
        let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        layer.add(animation, forKey: nil)
    }
    
    func addTwoAnimation(layer: CAShapeLayer, duration: CFTimeInterval) {
        let animationBegin = CABasicAnimation.init(keyPath: "strokeStart")
        animationBegin.fromValue = 0.5
        animationBegin.toValue = 0
        animationBegin.duration = duration
        let animationEnd = CABasicAnimation.init(keyPath: "strokeEnd")
        animationEnd.fromValue = 0.5
        animationEnd.toValue = 1
        animationEnd.duration = duration
        layer.add(animationBegin, forKey: nil)
        layer.add(animationEnd, forKey: nil)
    }
    
    func addThreeAnimation(layer: CAShapeLayer, duration: CFTimeInterval) {
        let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = duration
        let animationWidth = CABasicAnimation.init(keyPath: "lineWidth")
        animationWidth.fromValue = 1
        animationWidth.toValue = 10
        animationWidth.duration = 1.5
        layer.add(animation, forKey: nil)
        layer.add(animationWidth, forKey: nil)
    }
    
    func strokeEndAnimation(fromValue: CGFloat, toValue: CGFloat, layer: CALayer, duration: CGFloat) {
        let animation = CABasicAnimation.init(keyPath: "strokeEnd")
        animation.duration = CFTimeInterval.init(duration)
        animation.fromValue = fromValue
        animation.toValue = toValue
        
        //这两个属性设定保证在动画执行之后不自动还原
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        
        layer.add(animation, forKey: nil)
    }
    
    func actionTriangleOpacityAnimation(frome: CGFloat, to: CGFloat, layer: CALayer, duration: CGFloat) {
        let animation = CABasicAnimation.init(keyPath: "opacity")
        animation.duration = CFTimeInterval.init(duration)
        animation.fromValue = frome
        animation.toValue = to
        
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        animation.setValue("animation", forKey: "animationName")
        
        layer.add(animation, forKey: nil)
    }

    func actionRotateAnimationClockwise(layer: CALayer, duration: CGFloat, clockwise: Bool) {
        var start: Double = 0
        var end: Double = -Double.pi / 2
        if clockwise == true {
            start = -Double.pi / 2
            end = 0
        }
        
        let roateAnimation = CABasicAnimation.init(keyPath: "transform.rotation")
        roateAnimation.fromValue = start
        roateAnimation.toValue = end
        roateAnimation.duration = CFTimeInterval.init(duration)
        roateAnimation.fillMode = CAMediaTimingFillMode.forwards;
        roateAnimation.isRemovedOnCompletion = false;
        roateAnimation.setValue("roateAnimation", forKey: "animationName")
        layer.add(roateAnimation, forKey: nil)
    }

}
