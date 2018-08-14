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
public enum YAxisDependency: Int
{
    case left
    case right
    case none
}

public struct CTChartViewData {
    /// 名字
    var name = ""
    /// 使用哪边的Y轴
    var yAxis = YAxisDependency.left
    /// y轴上的数据
    var yAxisData = [Double]()
    /// x轴上的数据，所有数据x轴的坐标必须相同
    var xAxisData = [String()]
    /// 曲线颜色
    var lineColor = UIColor.black
    /// 单位
    var unit: String? = nil
    /// Y轴最大值，不设的话Y轴的最大值是所给数据最大值 * 1.2
    var yAxisMax: Double? = nil
}

class CTChartView: UIView, NibLoadable {
    // MARK: - 对外数据
    /// 要展示的数据
    var data: Array<CTChartViewData>?
    /// 表格中线条的颜色
    var tableShapLayerLineColor = UIColor.rgb(210, 210, 210, 1.0)
    /// 表格中文字的颜色
    var textLayersTextColor = UIColor.rgb(78, 78, 78, 1.0)
    
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
    /// 和左右刻度均无关的曲线最大值
    private var yAxisNoneMax: Double = 0
    /// 曲线图到view的边距
    private let chartEdgeInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    
    /// 垂直方向4条线，最左边一条是y轴，是实线，其它是虚线
    private let verticalLineNumber = 4
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
    /// 所有曲线的layer。和data的顺序一致
    private var curvesLayer = [CAShapeLayer]()
    /// 所有曲线点的集合
    private var allLinesPoints = [[CGPoint]]()
    
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
//    private var noneCurveCount = 0
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

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
        
        xAxisScaleData = [data[0].xAxisData.first!, data[0].xAxisData.last!]
        
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
    
    
}

// MARK: - 绘制图表
extension CTChartView {
    private func drawChart() {
        drawTable()
        drawCurves()
    }
    
}
// MARK: - 绘制背景表格和刻度
extension CTChartView {
    /// 绘制表格
    private func drawTable() {
        for layer in tableShapLayer {
            layer.removeFromSuperlayer()
        }
        
        for layer in yLeftAxisScaleLayer {
            layer.removeFromSuperlayer()
        }
        
        for layer in yRightAxisScaleLayer {
            layer.removeFromSuperlayer()
        }
        
        for layer in xAxisScaleLayer {
            layer.removeFromSuperlayer()
        }
        
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
                addYLeftAxisLabel(point: startPoint, text: String(yLeftAxisScaleData[index]))
            }
            
            if isShowYRightAxis {
                // 给右边y轴加 text
                addYRightAxisLabel(point: endPoint, text: String(yRightAxisScaleData[index]))
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
            if isShowYLeftAxis && index == 0 {
                drawTableShapLayer(point: startPoint, point: endPoint, isDottedLine: false)
            } else if isShowYRightAxis && index == verticalLineNumber - 1 {
                drawTableShapLayer(point: startPoint, point: endPoint, isDottedLine: false)
            } else {
                drawTableShapLayer(point: startPoint, point: endPoint, isDottedLine: true)
            }
            
            index += 1
        }
        addXAxisLabel(leftText: xAxisScaleData[0], rightText: xAxisScaleData[1])
        
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
        shapeLayer.lineWidth = 1.0
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
            shapeLayer.lineDashPattern = [2, 2]
        }
        
        chartView.layer.addSublayer(shapeLayer)
        tableShapLayer.append(shapeLayer)
    }
    
    /// 给左边y轴加 text
    private func addYLeftAxisLabel(point: CGPoint, text: String) {
        let width = (chartView.frame.width - chartEdgeInset.left - chartEdgeInset.right) / CGFloat(verticalLineNumber - 1)
        let textLayer = CATextLayer()
        textLayer.string = text
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.foregroundColor = textLayersTextColor.cgColor
        let font = UIFont.systemFont(ofSize: 12)
        textLayer.font = CGFont(font.fontName as CFString)
        textLayer.fontSize = font.pointSize
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.alignmentMode = kCAAlignmentLeft

        textLayer.frame = CGRect(x: point.x + 1, y: point.y - 15, width: width - 2, height: 14)
        chartView.layer.addSublayer(textLayer)
        yLeftAxisScaleLayer.append(textLayer)
    }
    /// 给右边y轴加 text
    private func addYRightAxisLabel(point: CGPoint, text: String) {
        let width = (chartView.frame.width - chartEdgeInset.left - chartEdgeInset.right) / CGFloat(verticalLineNumber - 1)
        let textLayer = CATextLayer()
        textLayer.string = text
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.foregroundColor = textLayersTextColor.cgColor
        let font = UIFont.systemFont(ofSize: 12)
        textLayer.font = CGFont(font.fontName as CFString)
        textLayer.fontSize = font.pointSize
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.alignmentMode = kCAAlignmentRight
        
        textLayer.frame = CGRect(x: point.x - width, y: point.y - 15, width: width - 1, height: 14)
        chartView.layer.addSublayer(textLayer)
        yRightAxisScaleLayer.append(textLayer)
    }
    /// 给x轴加 text
    private func addXAxisLabel(leftText: String, rightText: String) {
        let width = (chartView.frame.width - chartEdgeInset.left - chartEdgeInset.right) / CGFloat(verticalLineNumber - 1)
        let leftTextLayer = CATextLayer()
        leftTextLayer.string = leftText
        leftTextLayer.backgroundColor = UIColor.clear.cgColor
        leftTextLayer.foregroundColor = textLayersTextColor.cgColor
        let font = UIFont.systemFont(ofSize: 12)
        leftTextLayer.font = CGFont(font.fontName as CFString)
        leftTextLayer.fontSize = font.pointSize
        leftTextLayer.contentsScale = UIScreen.main.scale
        leftTextLayer.alignmentMode = kCAAlignmentLeft
        
        leftTextLayer.frame = CGRect(x: chartEdgeInset.left, y: chartView.frame.size.height - chartEdgeInset.bottom, width: width - 1, height: 14)
        chartView.layer.addSublayer(leftTextLayer)
        xAxisScaleLayer.append(leftTextLayer)
        
        let rightTextLayer = CATextLayer()
        rightTextLayer.string = rightText
        rightTextLayer.backgroundColor = UIColor.clear.cgColor
        rightTextLayer.foregroundColor = textLayersTextColor.cgColor
        rightTextLayer.font = CGFont(font.fontName as CFString)
        rightTextLayer.fontSize = font.pointSize
        rightTextLayer.contentsScale = UIScreen.main.scale
        rightTextLayer.alignmentMode = kCAAlignmentRight
        
        rightTextLayer.frame = CGRect(x: chartView.frame.size.width - chartEdgeInset.right - width, y: chartView.frame.size.height - chartEdgeInset.bottom, width: width - 1, height: 14)
        chartView.layer.addSublayer(rightTextLayer)
        xAxisScaleLayer.append(rightTextLayer)
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
            curvesLayer.append(shapeLayer)
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
                bezierPath.addArc(withCenter: point, radius: 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
                continue
            }
            let midPoint = midPointBetween(point1: prePoint, point2: point)
            bezierPath.addQuadCurve(to: midPoint, controlPoint: controlPointBetween(point1: midPoint, point2: prePoint))
            bezierPath.addQuadCurve(to: point, controlPoint: controlPointBetween(point1: midPoint, point2: point))
            bezierPath.addArc(withCenter: point, radius: 2, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            prePoint = point
        }
        allLinesPoints.append(points)
        
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
            if max != 0 {
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
            button.contentHorizontalAlignment = .leading
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
        
        guard sender.tag < curvesLayer.count else { return }
        let layer = curvesLayer[sender.tag]
        if sender.isSelected {
            if layer.superlayer == nil {
                chartView.layer.addSublayer(layer)
            }
        } else {
            layer.removeFromSuperlayer()
        }
    }
    
}
