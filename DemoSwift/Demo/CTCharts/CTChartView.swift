//
//  CTChartView.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/8/13.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

/// 数据和哪个Y轴对应。Y轴的最大值是所给数据最大值 * 1.2
///
/// - left: 左边的Y轴
/// - right: 右边的Y轴
/// - none: 无
public enum YAxisDependency: Int {
    case left
    case right
    case none
}

/// 图表类型
///
/// - curve: 曲线图
/// - bar: 柱状图
public enum CTChartType: Int {
    case curve
    case bar
}

public struct CTChartViewData {
    /// 名字
    var name = ""
    /// 使用哪边的Y轴
    var yAxis = YAxisDependency.left
    /// y轴上的数据
    var yAxisData = [Double]()
    /// 曲线颜色
    var lineColor = UIColor.black
    /// 单位
    var unit: String? = nil
    /// Y轴最大值，不设的话Y轴的最大值是所给数据最大值 * 1.2
    var yAxisMax: Double? = nil
    /// Y轴最小值，比最小值小时按最小值计算
    var yAxisMin: Double = 0
}

class CTChartView: UIView, NibLoadable {
    // MARK: - 对外数据
    /// 图表类型
    var type: CTChartType = .curve {
        didSet {
            switch type {
            case .curve:
                verticalLineNumber = 4
            case .bar:
                verticalLineNumber = 2
            }
        }
    }
    /// 要展示的数据
    var data: Array<CTChartViewData>?
    /// x轴上的数据
    var xAxisData = [String]()
    /// 表格中线条的颜色
    var tableShapLayerLineColor = UIColor.lightGray
    /// 表格中文字的颜色
    var textLayersTextColor = UIColor.rgb(78, 78, 78, 1.0)
    /// 点击表格出现的十字线和信息label的背景色
    var infoLableBackgroundColor = UIColor.rgb(233, 73, 28, 1.0)
    /// 点击表格出现的信息label的前景色
    var infoLabelForegroundColor = UIColor.white
    
    // MARK: - 私有数据
    @IBOutlet private weak var buttonView: UIView!
    @IBOutlet private weak var chartView: UIView!
    
    /// x轴上的刻度。只有左右两头各一个
    private var xAxisScaleData = [String]()
    /// 左边y轴上的刻度
    private var yLeftAxisScaleData = [Double]()
    /// 右边y轴上的刻度
    private var yRightAxisScaleData = [Double]()
    /// 是否显示左边的y轴刻度
    private var isShowYLeftAxis = false
    /// 是否显示右边y轴刻度
    private var isShowYRightAxis = false
    /// 和左右刻度均无关的隐形刻度最大值
    private var yAxisNoneMax: Double = 0
    /// 图表到view的边距
    private let chartEdgeInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    
    /// 垂直方向4条线，最左边一条是y轴，是实线，其它是虚线
    private var verticalLineNumber = 4
    /// 水平方向5条线，最下边一枚是x轴，是实线，其它是虚线
    private let horizontalLineNumber = 5
    
    /// 背景表格layer
    private var tableShapLayer = [CAShapeLayer]()
    /// 左边Y轴的刻度layer
    private var yLeftAxisScaleLayer = [CATextLayer]()
    /// 右边Y轴的刻度layer
    private var yRightAxisScaleLayer = [CATextLayer]()
    /// X轴的刻度layer
    private var xAxisScaleLayer = [CATextLayer]()
    /// 所有曲线/柱状图的layer。和data的顺序一致
    private var curvesAndBarsLayers = [[CAShapeLayer]]()

    /// 所有曲线点的集合/所有柱状图x轴上中间的点
    private var allLinesPoints = [[CGPoint]]()
    /// 文字的大小
    private var textFont = UIFont.systemFont(ofSize: 12)
    /// 柱状图的宽度
    private let barWidth: CGFloat = 12
    lazy private var maskBarLay = CAShapeLayer()
    /// 与左边Y轴刻度关联的曲线条件。为0时不显示左边的刻度
    private var yLeftAxisCurveCount = 0 {
        didSet {
            if yLeftAxisCurveCount == 0 {
                for layer in yLeftAxisScaleLayer {
                    layer.removeFromSuperlayer()
                }
            } else {
                for layer in yLeftAxisScaleLayer {
                    if layer.superlayer == nil {
                        chartView.layer.addSublayer(layer)
                    }
                }
            }
        }
    }
    /// 与右边Y轴刻度关联的曲线条件。为0时不显示边右的刻度
    private var yRightAxisCurveCount = 0 {
        didSet {
            if yRightAxisCurveCount == 0 {
                for layer in yRightAxisScaleLayer {
                    layer.removeFromSuperlayer()
                }
            } else {
                for layer in yRightAxisScaleLayer {
                    if layer.superlayer == nil {
                        chartView.layer.addSublayer(layer)
                    }
                }
            }
        }
    }

    /// 点击图表时，十字线
    private var tapShapeLayer = [CAShapeLayer]()
    /// 点击图表时，显示信息的layer
    private var tapTextLayer = [CATextLayer]()
    /// 上次点击的 point
    private var lastTapPoint: CGPoint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /// 点击时以最近的数据点画十字线，并显示Y轴上所有的数据信息
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerHandle(tapGesture:)))
        tapGesture.numberOfTapsRequired = 1
        addGestureRecognizer(tapGesture)
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longGestureRecognizerHandle(longGesture:)))
        longGesture.minimumPressDuration = 0.3
        addGestureRecognizer(longGesture)
    }
    
    private func showCharts() {
        initData()
        drawChart()
        showButtons()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print(self.frame)
        guard self.data != nil else { return }
        showCharts()
    }

}

// MARK: - 数据处理
extension CTChartView {
    func initData() {
        guard let data = self.data else { return }
        deinitData()
        
        switch type {
        case .curve:
            xAxisScaleData = [xAxisData.first!, xAxisData.last!]
        case .bar:
            xAxisScaleData = xAxisData
        }
        
        
        var yLeftMax: Double = 0
        var yRightMax: Double = 0
        var yNonoMax: Double = 0
        for value in data {
            switch value.yAxis {
            case .left:
                yLeftAxisCurveCount += 1
                isShowYLeftAxis = true
                if let max = value.yAxisMax {
                    yLeftMax = max
                    break
                }
                
                let max = value.yAxisData.sorted(by: >).first!
                yLeftMax = (yLeftMax < max) ? max : yLeftMax
                
            case .right:
                yRightAxisCurveCount += 1
                isShowYRightAxis = true
                if let max = value.yAxisMax {
                    yRightMax = max
                    break
                }
                
                let max = value.yAxisData.sorted(by: >).first!
                yRightMax = (yRightMax < max) ? max : yRightMax
                
            case .none:
                if let max = value.yAxisMax {
                    yNonoMax = max
                    break
                }
                
                let max = value.yAxisData.sorted(by: >).first!
                yNonoMax = (yNonoMax < max) ? max : yNonoMax

            }
        }
        
        yLeftMax = yLeftMax * 1.2
        yRightMax = yRightMax * 1.2
        yAxisNoneMax = (yNonoMax * 1.2 > 100) ? 100 : yNonoMax * 1.2
        
        var index = 0
        while index < horizontalLineNumber {
            if isShowYLeftAxis {
                yLeftAxisScaleData.append(yLeftMax * Double(index) / Double(horizontalLineNumber - 1))
            }
            if isShowYRightAxis {
                yRightAxisScaleData.append(yRightMax * Double(index) / Double(horizontalLineNumber - 1))
            }
            index += 1
        }
    }

    private func deinitData() {
        xAxisScaleData = [String]()
        yLeftAxisScaleData = [Double]()
        yRightAxisScaleData = [Double]()
        isShowYLeftAxis = false
        isShowYRightAxis = false
        yAxisNoneMax = 0
        for layer in tableShapLayer {
            layer.removeFromSuperlayer()
        }
        tableShapLayer = [CAShapeLayer]()
        
        for layer in yLeftAxisScaleLayer {
            layer.removeFromSuperlayer()
        }
        yLeftAxisScaleLayer = [CATextLayer]()
        
        for layer in yRightAxisScaleLayer {
            layer.removeFromSuperlayer()
        }
        yRightAxisScaleLayer = [CATextLayer]()
        
        for layer in xAxisScaleLayer {
            layer.removeFromSuperlayer()
        }
        xAxisScaleLayer = [CATextLayer]()
        
        for layers in curvesAndBarsLayers {
            for layer in layers {
                layer.removeFromSuperlayer()
            }
        }
        curvesAndBarsLayers = [[CAShapeLayer]]()
        
        allLinesPoints = [[CGPoint]]()
        
        for layer in tapShapeLayer {
            layer.removeFromSuperlayer()
        }
        tapShapeLayer = [CAShapeLayer]()
        
        for layer in tapTextLayer {
            layer.removeFromSuperlayer()
        }
        tapTextLayer = [CATextLayer]()
        
        lastTapPoint = nil
        
        maskBarLay.removeFromSuperlayer()
    }
}

// MARK: - 绘制图表
extension CTChartView {
    private func drawChart() {
        drawTable()
        switch type {
        case .curve:
            drawCurves()
        case .bar:
            drawBars()
        }
    }
    
}
// MARK: - 绘制背景表格和刻度
extension CTChartView {
    /// 绘制表格
    private func drawTable() {
        var index = 0
        let height = (chartView.frame.height - chartEdgeInset.top - chartEdgeInset.bottom) / CGFloat(horizontalLineNumber - 1)
        // 水平线, 重下往上画
        while index < horizontalLineNumber {
            let pointY = chartView.frame.maxY - height * CGFloat(index) - chartEdgeInset.bottom
            let startPoint = CGPoint(x: chartEdgeInset.left, y: pointY)
            let endPoint = CGPoint(x: chartView.frame.width - chartEdgeInset.right, y: pointY)
            drawTableShapLayer(point: startPoint, point: endPoint, isDottedLine: index != 0)
            
            if isShowYLeftAxis {
                // 给左边y轴加 text
                addYLeftAxisLabel(point: startPoint, text: String(Int(yLeftAxisScaleData[index])))
            }
            
            if isShowYRightAxis {
                // 给右边y轴加 text
                addYRightAxisLabel(point: endPoint, text: String(Int(yRightAxisScaleData[index])))
            }
            
            index += 1
        }
        
        let width = (chartView.frame.width - chartEdgeInset.left - chartEdgeInset.right) / CGFloat(verticalLineNumber - 1)
        index = 0
        // 垂直线, 重左往右画
        while index < verticalLineNumber {
            let pointX = width * CGFloat(index) + chartEdgeInset.left
            let startPoint = CGPoint(x: pointX, y: chartEdgeInset.bottom)
            let endPoint = CGPoint(x: pointX, y: chartView.frame.height - chartEdgeInset.top)
            drawTableShapLayer(point: startPoint, point: endPoint, isDottedLine: true)
            
            index += 1
        }
        
        addXAxisLabel(texts: xAxisScaleData)
 
    }
    
    private func drawTableShapLayer(point from: CGPoint, point to: CGPoint, isDottedLine: Bool) {
        let linePath = UIBezierPath()
        // 起点
        linePath.move(to: from)
        // 终点
        linePath.addLine(to: to)
        // 画布
        let shapeLayer = CAShapeLayer()
        // 画布大小
        shapeLayer.bounds = chartView.bounds
        // 画布在画板上的位置。
        // 可以这么理解：用一个图钉将一张画布钉在画板上，
        // postion是图钉在画板上的位置，anchorPoint是图钉在画布上的位置
        shapeLayer.position = CGPoint.zero
        shapeLayer.anchorPoint = CGPoint.zero
        // 线的宽度
        shapeLayer.lineWidth = 0.5
        // 线终点式样
        shapeLayer.lineCap = kCALineCapRound
        // 线的颜色
        shapeLayer.strokeColor = tableShapLayerLineColor.cgColor
        // 线的路径
        shapeLayer.path = linePath.cgPath
        // 线围成区域的填充颜色
        shapeLayer.fillColor = nil
        // 虚线
        if isDottedLine {
            shapeLayer.lineDashPattern = [1, 1]
        }
        
        chartView.layer.addSublayer(shapeLayer)
        tableShapLayer.append(shapeLayer)
    }
    
    /// 给左边y轴加 text
    private func addYLeftAxisLabel(point: CGPoint, text: String) {
        let width = (chartView.frame.width - chartEdgeInset.left - chartEdgeInset.right) / CGFloat(verticalLineNumber - 1)
        let rect = CGRect(x: point.x + 1, y: point.y - 15, width: width - 2, height: 14)
        let textLayer = drawTextLayer(text: text, rect: rect, alignmentModel: kCAAlignmentLeft)
        
        chartView.layer.addSublayer(textLayer)
        yLeftAxisScaleLayer.append(textLayer)
        
        
    }
    /// 给右边y轴加 text
    private func addYRightAxisLabel(point: CGPoint, text: String) {
        let width = (chartView.frame.width - chartEdgeInset.left - chartEdgeInset.right) / CGFloat(verticalLineNumber - 1)
        let rect = CGRect(x: point.x - width, y: point.y - 15, width: width - 1, height: 14)
        let textLayer = drawTextLayer(text: text, rect: rect, alignmentModel: kCAAlignmentRight)
        chartView.layer.addSublayer(textLayer)
        yRightAxisScaleLayer.append(textLayer)
    }
    /// 给x轴加 text
    private func addXAxisLabel(texts: Array<String>) {
        guard texts.count > 0 else { return }
        let height: CGFloat = 14
        let originY = chartView.frame.size.height - chartEdgeInset.bottom
        
        switch type {
        case .curve:
            if texts.count == 1 {
                let width = widthFor(text: texts[0], height: height, font: textFont) + 1
                let centerX = chartView.frame.width / 2.0
                let rect = CGRect(x: centerX - (width / 2.0), y: originY, width: width, height: height)
                let textLayer = drawTextLayer(text: texts[0], rect: rect, alignmentModel: kCAAlignmentCenter)
                chartView.layer.addSublayer(textLayer)
                xAxisScaleLayer.append(textLayer)
                allLinesPoints.append([CGPoint(x: centerX, y: originY)])
            } else {
                let spacing = (chartView.frame.width - chartEdgeInset.left - chartEdgeInset.right) / CGFloat(texts.count - 1)
                for (index, value) in texts.enumerated() {
                    var textLayer: CATextLayer
                    let width = widthFor(text: value, height: height, font: textFont) + 1
                    if index == 0 {
                        let rect = CGRect(x: chartEdgeInset.left, y: originY, width: width, height: height)
                        textLayer = drawTextLayer(text: value, rect: rect, alignmentModel: kCAAlignmentLeft)
                    } else if index == texts.count - 1 {
                        let rect = CGRect(x: chartView.frame.width - chartEdgeInset.right - width, y: originY, width: width, height: height)
                        textLayer = drawTextLayer(text: value, rect: rect, alignmentModel: kCAAlignmentRight)
                    } else {
                        let rect = CGRect(x: spacing * CGFloat(index) - (width / 2.0), y: originY, width: width, height: height)
                        textLayer = drawTextLayer(text: value, rect: rect, alignmentModel: kCAAlignmentCenter)
                    }
                    chartView.layer.addSublayer(textLayer)
                    xAxisScaleLayer.append(textLayer)
                }
            }
        case .bar:
            let spacing = (chartView.frame.width - chartEdgeInset.left - chartEdgeInset.right) / CGFloat(texts.count + 1)
            for (index, value) in texts.enumerated() {
                let width = widthFor(text: value, height: height, font: textFont) + 1
                let rect = CGRect(x: spacing * CGFloat(index + 1) - (width / 2.0), y: originY, width: width, height: height)
                let textLayer = drawTextLayer(text: value, rect: rect, alignmentModel: kCAAlignmentCenter)
                chartView.layer.addSublayer(textLayer)
                xAxisScaleLayer.append(textLayer)
                allLinesPoints.append([CGPoint(x: spacing * CGFloat(index + 1), y: originY)])
            }

        }
        
    }
    
    private func drawTextLayer(text: String, rect: CGRect, alignmentModel: String) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.string = text
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.foregroundColor = textLayersTextColor.cgColor
        textLayer.font = CGFont(textFont.fontName as CFString)
        textLayer.fontSize = textFont.pointSize
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.alignmentMode = alignmentModel
        textLayer.frame = rect
        return textLayer
    }
}

// MARK: - 绘制曲线
extension CTChartView {
    private func drawCurves() {
        guard let data = self.data else { return }
        
        for item in data {
            guard let lineInfo = drawBezierPath(item: item) else { continue }
            // 画布
            let shapeLayer = CAShapeLayer()
            shapeLayer.bounds = chartView.bounds
            shapeLayer.position = CGPoint.zero
            shapeLayer.anchorPoint = CGPoint.zero
            shapeLayer.lineWidth = 2.0
            shapeLayer.lineCap = kCALineCapRound
            shapeLayer.strokeColor = item.lineColor.cgColor
            shapeLayer.path = lineInfo.bezierPath.cgPath
            shapeLayer.fillColor = nil
            chartView.layer.addSublayer(shapeLayer)
            curvesAndBarsLayers.append([shapeLayer])
            allLinesPoints.append(lineInfo.points)
        }
    }
    
    private func drawBezierPath(item: CTChartViewData) -> (points: Array<CGPoint>, bezierPath: UIBezierPath)? {
        guard let points = allPointsOfLine(item: item) else { return nil}
        
        let bezierPath = UIBezierPath()
        var prePoint = points[0]
        bezierPath.move(to: prePoint)
        
        for (index, point) in points.enumerated() {
            if index == 0 {
//                bezierPath.addArc(withCenter: point, radius: 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
                continue
            }
            let midPoint = midPointBetween(point1: prePoint, point2: point)
            bezierPath.addQuadCurve(to: midPoint, controlPoint: controlPointBetween(point1: midPoint, point2: prePoint))
            bezierPath.addQuadCurve(to: point, controlPoint: controlPointBetween(point1: midPoint, point2: point))
//            bezierPath.addArc(withCenter: point, radius: 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            prePoint = point
        }
        
        return (points, bezierPath)
    }
    
    /// 计算一条线上所有的点
    private func allPointsOfLine(item: CTChartViewData) -> Array<CGPoint>? {
        guard item.yAxisData.count > 0 else { return nil }
        
        var max: Double = 0
        switch item.yAxis {
        case .left:
            if let leftMax = yLeftAxisScaleData.last {
                max = leftMax
            }
        case .right:
            if let rightMax = yRightAxisScaleData.last {
                max = rightMax
            }
        case .none:
            max = yAxisNoneMax
        }
        
        var points = [CGPoint]()
        /// 图表的高度
        let tableHeight = chartView.frame.height - chartEdgeInset.top - chartEdgeInset.bottom
        /// 图表的宽度
        let tableWidth = chartView.frame.width - chartEdgeInset.left - chartEdgeInset.right
        /// x轴的y点
        let xAxisYPoint = chartView.frame.height - chartEdgeInset.bottom
        /// y轴的x点
        let yAxisXpoint = chartEdgeInset.left
        
        for (index, value) in item.yAxisData.enumerated() {
            var y = xAxisYPoint
            if value < item.yAxisMin {
                y = chartView.frame.height - chartEdgeInset.bottom
            } else if value > max {
                y = chartEdgeInset.top
            } else if max != 0 {
                y -= CGFloat(value / max) * tableHeight
            }
            
            var x = yAxisXpoint
            if item.yAxisData.count == 1 {
                x += tableWidth / 2.0
            } else {
                x += tableWidth / CGFloat(item.yAxisData.count - 1) * CGFloat(index)
            }
            
            points.append(CGPoint(x: x, y: y))
        }
        
        return points
    }

    /// 两点的中间点
    private func midPointBetween(point1: CGPoint, point2: CGPoint) -> CGPoint {
        return CGPoint(x: (point1.x + point2.x) / 2, y: (point1.y + point2.y) / 2)
    }
    
    /// 两点的控制点
    private func controlPointBetween(point1: CGPoint, point2: CGPoint) -> CGPoint {
        var controlPoint = midPointBetween(point1: point1, point2: point2)
        let diffY = CGFloat(abs(Int(point2.y - controlPoint.y)))
        if (point1.y < point2.y) {
            controlPoint.y += diffY
        } else if (point1.y > point2.y) {
            controlPoint.y -= diffY
        }
        return controlPoint
    }
}

// MARK: - 画柱状图
extension CTChartView {
    private func drawBars() {
        guard let data = self.data, data.count > 0 else { return }
        
        /// x轴的y坐标
        let xAxisY = chartView.frame.size.height - chartEdgeInset.bottom
        
        for (i, item) in data.enumerated() {
            for (j, value) in item.yAxisData.enumerated() {
                let centerXPoint = allLinesPoints[j][0]
                let orignX = centerXPoint.x - (CGFloat(data.count) / 2.0 - CGFloat(i)) * barWidth
                var height: CGFloat = 0
                switch item.yAxis {
                case .left:
                    height = (chartView.frame.height - chartEdgeInset.top - chartEdgeInset.bottom) * (CGFloat(value) / CGFloat(yLeftAxisScaleData.last!))
                    
                case .right:
                    height = (chartView.frame.height - chartEdgeInset.top - chartEdgeInset.bottom) * (CGFloat(value) / CGFloat(yRightAxisScaleData.last!))
                    
                default:
                    break
                    
                }
                let rect = CGRect(x: orignX, y: xAxisY - height, width: barWidth, height: height)
                let shapeLayer = drawOneBar(rect: rect, fillColor: item.lineColor)
                if i >= curvesAndBarsLayers.count {
                    curvesAndBarsLayers.append([shapeLayer])
                } else {
                    curvesAndBarsLayers[i] = curvesAndBarsLayers[i] + [shapeLayer]
                }
                
                chartView.layer.addSublayer(shapeLayer)
            }
        }
    }
    
    private func drawOneBar(rect: CGRect, fillColor: UIColor) -> CAShapeLayer {
        let path = UIBezierPath.init(rect: rect)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 0
        shapeLayer.bounds = chartView.bounds
        shapeLayer.position = CGPoint.zero
        shapeLayer.anchorPoint = CGPoint.zero
        return shapeLayer
    }
}

// MARK: - 底部button
extension CTChartView {

    private func showButtons() {
        guard let data = self.data else { return }
        
        for view in buttonView.subviews {
            view.removeFromSuperview()
        }
        
        let selectedTitleColor = UIColor.hexRGB(0x444444, 1.0)
        let titleColor = UIColor.lightGray
        let imgColor = UIColor.lightGray
        
        var leadingOffset: CGFloat = chartEdgeInset.left
        let buttonWidth = (UIScreen.main.bounds.width - 20 - 6 * CGFloat(data.count - 1)) / CGFloat(data.count)
        
        for (index, item) in data.enumerated() {
            let button = UIButton(type: .custom)
            button.isHighlighted = false
            button.contentHorizontalAlignment = .left
            button.tag = index
            button.isSelected = true
            button.backgroundColor = UIColor.rgb(244, 244, 244, 1.0)
            button.setTitle(item.name, for: .normal)
            button.setTitleColor(titleColor, for: .normal)
            button.setTitleColor(selectedTitleColor, for: .selected)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            let selectedImage = UIImage.createImage(color: item.lineColor, frame: CGRect(x: 0, y: 0, width: 12, height: 12))
            let image = UIImage.createImage(color: imgColor, frame: CGRect(x: 0, y: 0, width: 12, height: 12))
            button.setImage(image, for: .normal)
            button.setImage(selectedImage, for: .selected)
            
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: -16)
            
            button.addTarget(self, action: #selector(onShowButtons(sender:)), for: .touchUpInside)
            buttonView.addSubview(button)
            button.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
                $0.leading.equalToSuperview().offset(leadingOffset)
                $0.width.equalTo(buttonWidth)
            }
            
            leadingOffset = leadingOffset + buttonWidth + 6
        }
        
    }
    
    @objc func onShowButtons(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let data = self.data else { return }
        guard sender.tag < data.count else { return }
        
        let item = data[sender.tag]
        switch item.yAxis {
        case .left:
            yLeftAxisCurveCount = yLeftAxisCurveCount + (sender.isSelected ? 1 : -1)
        case .right:
            yRightAxisCurveCount = yRightAxisCurveCount + (sender.isSelected ? 1 : -1)
        default:
            break
        }
        
        guard sender.tag < curvesAndBarsLayers.count else { return }
        let layers = curvesAndBarsLayers[sender.tag]
        for layer in layers {
            if sender.isSelected {
                if layer.superlayer == nil {
                    chartView.layer.addSublayer(layer)
                }
            } else {
                layer.removeFromSuperlayer()
            }
        }
        
        if let point = lastTapPoint {
            actionOnPoint(point: point)
        }
    }
    
}

// MARK: - 点击曲线图的处理
extension CTChartView {
    @objc func tapGestureRecognizerHandle(tapGesture: UITapGestureRecognizer) {
        let tapPoint = tapGesture.location(in: self)
        
        lastTapPoint = tapPoint
        actionOnPoint(point: tapPoint)
    }
    
    private func actionOnPoint(point: CGPoint) {
        for layer in tapTextLayer {
            layer.removeFromSuperlayer()
        }
        tapTextLayer = [CATextLayer]()
        
        /// 是否有显示的曲线/柱状图，如果没有 点击不处理
        let showedCurveIndexs = showedOfCurve()
        guard showedCurveIndexs.count > 0 else { return }
        
        guard let nearestIndex = nearestPointIndex(to: point, in: showedCurveIndexs) else { return }
        
        var nearPoint: CGPoint
        
        switch type {
        case .curve:
            guard let pointTmp = nearestPoint(to: point, Curvers: showedCurveIndexs, index: nearestIndex) else { return }
            nearPoint = pointTmp
            drawCrossLineOn(point: nearPoint)
        case .bar:
            nearPoint = barCenterPoint(index: nearestIndex)
        }

        guard xAxisData.count > nearestIndex else { return }
        let time = xAxisData[nearestIndex]
        drawTimeStamp(time: time, touchPoint: point)
        
        guard let info = showInfoOfShowCurve(showCurve: showedCurveIndexs, index: nearestIndex) else { return }
        var str = ""
        var widthMax: CGFloat = 0
        var lineSpaceCount = 0
        for (index, text) in info.enumerated() {
            let width = widthFor(text: text, height: 17, font: UIFont.systemFont(ofSize: 12))
            widthMax = widthMax > width ? widthMax : width
            if index == 0 {
                str = text
            } else {
                str = str + "\n" + text
                lineSpaceCount += 1
            }
        }
        var height = heightFor(text: str, width: widthMax, font: UIFont.systemFont(ofSize: 12))
        height += CGFloat(4 * lineSpaceCount)
        drawInfoLabel(text: str, size: CGSize(width: widthMax, height: height), tapPoint: point)
        
    }
    
    /// 获取显示的曲线index的集合
    private func showedOfCurve() -> Array<Int> {
        var result = [Int]()
        for (index, layers) in curvesAndBarsLayers.enumerated() {
            if let layer = layers.first, layer.superlayer != nil {
                result.append(index)
            }
        }
        return result
    }

    /// 找到距离点击处最近的显示的数据点的index.即确定x点
    private func nearestPointIndex(to point: CGPoint, in Curvers: Array<Int>) -> Int? {
        guard Curvers.count > 0 else { return nil}
        
        var points = [CGPoint]()
        switch type {
        case .curve:
            points = allLinesPoints[Curvers[0]]

        case .bar:
            for barPoints in allLinesPoints {
                points.append(barPoints.first!)
            }
        }
        
        /// 找到第一个比point.x大的index。如果没找到，返回最后一个index
        guard let firstIndex = points.index(where: { $0.x > point.x }) else { return points.count - 1 }
        
        /// 如果是第一个，则返回0
        if firstIndex == 0 {
            return firstIndex
        }
        
        /// 与前面一个point对比，返回离point更近的index
        let preIndex = firstIndex - 1
        if fabs(Double(point.x - points[preIndex].x)) > fabs(Double(point.x - points[firstIndex].x)) {
            return firstIndex
        } else {
            return preIndex
        }

    }
    
    private func barCenterPoint(index: Int) -> CGPoint {
        maskBarLay.removeFromSuperlayer()
        let centerXPoint = allLinesPoints[index].first!
        let width = barWidth * CGFloat(data!.count + 1)
        let height = chartView.frame.height - chartEdgeInset.top - chartEdgeInset.bottom
        let orignX = centerXPoint.x - (width / 2.0)
        let orignY = chartEdgeInset.top
        
        maskBarLay = drawOneBar(rect: CGRect(x: orignX, y: orignY, width: width, height: height), fillColor: UIColor.rgb(0, 0, 0, 0.1))
        chartView.layer.addSublayer(maskBarLay)
        
        return CGPoint(x: (orignX + width) / 2.0, y: (orignY + height) / 2.0)
    }
    
    /// 找到距离点击处最近的显示的数据点的point。即确定y点
    private func nearestPoint(to point: CGPoint, Curvers: Array<Int>, index: Int) -> CGPoint? {
        guard Curvers.count > 0 else { return nil}
        
        var offsetY = [Double]()
        for indexCurver in Curvers {
            let points = allLinesPoints[indexCurver]
            guard points.count > indexCurver else { return nil}
            offsetY.append(Double(fabs(point.y - points[index].y)))
        }
        
        guard let min = offsetY.min() else { return nil }
        // 曲线的index
        guard let minIndex = offsetY.index(where: { min == $0}) else { return nil }
        
        return allLinesPoints[Curvers[minIndex]][index]
    }

    /// 以某一点画十字线
    private func drawCrossLineOn(point: CGPoint) {
        for layer in tapShapeLayer {
            layer.removeFromSuperlayer()
        }
        tapShapeLayer = [CAShapeLayer]()
        
        /// 水平线
        let startPointH = CGPoint(x: chartEdgeInset.left, y: point.y)
        let endPointH = CGPoint(x: chartView.frame.width - chartEdgeInset.right, y: point.y)
        let bezierPathH = UIBezierPath()
        bezierPathH.move(to: startPointH)
        bezierPathH.addLine(to: endPointH)
        let shapeLayerH = CAShapeLayer()
        shapeLayerH.bounds = chartView.bounds
        shapeLayerH.position = CGPoint.zero
        shapeLayerH.anchorPoint = CGPoint.zero
        shapeLayerH.lineWidth = 0.5
        shapeLayerH.lineCap = kCALineCapRound
        shapeLayerH.strokeColor = infoLableBackgroundColor.cgColor
        shapeLayerH.path = bezierPathH.cgPath
        shapeLayerH.fillColor = nil
        shapeLayerH.lineDashPattern = [2, 2]
        chartView.layer.addSublayer(shapeLayerH)
        tapShapeLayer.append(shapeLayerH)
        
        /// 垂直线
        let startPointV = CGPoint(x: point.x, y: chartEdgeInset.top)
        let endPointV = CGPoint(x: point.x, y: chartView.frame.height - chartEdgeInset.bottom)
        let bezierPathV = UIBezierPath()
        bezierPathV.move(to: startPointV)
        bezierPathV.addLine(to: endPointV)
        let shapeLayerV = CAShapeLayer()
        shapeLayerV.bounds = chartView.bounds
        shapeLayerV.position = CGPoint.zero
        shapeLayerV.anchorPoint = CGPoint.zero
        shapeLayerV.lineWidth = 0.5
        shapeLayerV.lineCap = kCALineCapRound
        shapeLayerV.strokeColor = infoLableBackgroundColor.cgColor
        shapeLayerV.path = bezierPathV.cgPath
        shapeLayerV.fillColor = nil
        shapeLayerV.lineDashPattern = [2, 2]
        chartView.layer.addSublayer(shapeLayerV)
        tapShapeLayer.append(shapeLayerV)
    }
    
    /// 点击时在顶部显示X轴的值
    private func drawTimeStamp(time: String, touchPoint: CGPoint) {
        let textWidth = widthFor(text: time, height: 17, font: UIFont.systemFont(ofSize: 12))
        
        /// 要显示内容CGRect的x原点
        var orignX: CGFloat = 0
        /// x中点
        let midX = ((chartView.frame.width - chartEdgeInset.right) + chartEdgeInset.left) / 2.0
        if touchPoint.x < midX {
            orignX = chartEdgeInset.left
            orignX += ((touchPoint.x - orignX) > textWidth) ? (touchPoint.x - textWidth) : 0
        } else {
            orignX = ((chartView.frame.width - chartEdgeInset.right - touchPoint.x) > textWidth) ? touchPoint.x : (chartView.frame.width - chartEdgeInset.right - textWidth)
        }
        
        let rect = CGRect(x: orignX, y: chartEdgeInset.top - 17, width: textWidth, height: 17)
        let layer = drawTapPointInfoLabel(text: time, rect: rect)
        chartView.layer.addSublayer(layer)
        tapTextLayer.append(layer)
    }
    
    /// 显示Y点的信息，隐藏的曲线Y轴信息不显示
    private func drawInfoLabel(text: String, size: CGSize, tapPoint: CGPoint) {
        /// 要显示内容CGRect的原点
        var orignX: CGFloat = 0
        var orignY: CGFloat = 0
        /// x中点
        let midX = ((chartView.frame.width - chartEdgeInset.right) + chartEdgeInset.left) / 2.0
        if tapPoint.x > midX {
            orignX = chartEdgeInset.left
        } else {
            orignX = chartView.frame.width - chartEdgeInset.right - size.width
        }
        
        /// y点
        orignY = tapPoint.y - (size.height / 2.0)
        if orignY < chartEdgeInset.top {
            orignY = chartEdgeInset.top
        } else if orignY > (chartView.frame.height - chartEdgeInset.bottom - size.height) {
            orignY = chartView.frame.height - chartEdgeInset.bottom - size.height
        }
        
        let rect = CGRect(x: orignX, y: orignY, width: size.width, height: size.height)
        let layer = drawTapPointInfoLabel(text: text, rect: rect)
        chartView.layer.addSublayer(layer)
        tapTextLayer.append(layer)
    }
    
    /// 要显示的数据信息
    private func showInfoOfShowCurve(showCurve: Array<Int>, index: Int) -> Array<String>? {
        guard let data = self.data else { return nil }
        var result = [String]()
        
        for dataIndex in showCurve {
            guard data.count > dataIndex else { continue }
            let item = data[dataIndex]
            guard item.yAxisData.count > index else { continue }
            var str = item.name + ": " + String(Int(item.yAxisData[index]))
            if item.unit != nil {
                str = str + item.unit!
            }
            result.append(str)
        }
        return result
    }
    
    private func drawTapPointInfoLabel(text: String, rect: CGRect) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.string = text
        textLayer.backgroundColor = infoLableBackgroundColor.cgColor
        textLayer.foregroundColor = infoLabelForegroundColor.cgColor
        let font = UIFont.systemFont(ofSize: 12)
        textLayer.font = CGFont(font.fontName as CFString)
        textLayer.fontSize = font.pointSize
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.alignmentMode = kCAAlignmentLeft
        textLayer.frame = rect
        return textLayer
    }
    

}

// MARK: - 长按图表滑动
extension CTChartView {
    @objc func longGestureRecognizerHandle(longGesture: UILongPressGestureRecognizer) {
        let point = longGesture.location(in: self)
        
        if lastTapPoint != nil {
            if fabs(Double(point.x - lastTapPoint!.x)) < 3 && fabs(Double(point.y - lastTapPoint!.y)) < 3 {
                // x,y移动距离均小于3时不处理
                return
            }
        }
        
        lastTapPoint = point
        actionOnPoint(point: point)
    }
}

// MARK: - 工具
extension CTChartView {
    /// 字符串的宽度
    private func widthFor(text: String, height: CGFloat, font: UIFont) -> CGFloat {
        let textStr = NSString(string: text)
        let rect = textStr.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: height), options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        return rect.width
    }
    
    private func heightFor(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let textStr = NSString(string: text)
        let rect = textStr.boundingRect(with: CGSize(width:width , height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        return rect.height
    }
}
