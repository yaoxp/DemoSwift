//
//  CTScrollChartView.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/8/23.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

public struct CTScrollBarTimeChartPointInfo {
    /// 开始时间
    var startTime = Date()
    /// 结束时间
    var endTime = Date()
    /// 数值
    var number: Double = 0
    /// 点击柱状图时要显示的信息
    var extensionInfo = [String]()
}

public struct CTScrollBarTimeChartViewData {
    /// y轴上的数据
    var yAxisData = [CTScrollBarTimeChartPointInfo]()
    /// 柱状颜色
    var barColor = UIColor.hexRGB(0xFF5E00, 1.0)
    /// x轴开始时间
    var startTime = Date()
    /// x轴结束时间
    var endTime = Date()
}

class CTScrollBarTimeChartView: UIScrollView {
    // MARK: - 对外公开属性
    /// 要显示的数据
    var data: CTScrollBarTimeChartViewData? {
        didSet {
            showCharts()
        }
    }
    /// 要展示的视觉宽度，默认是屏幕宽度
    var viewWidth: CGFloat = UIScreen.main.bounds.width

    // MARK: - 私有属性
    /// 柱子之前最小间距
    private let minSapcing: Double = 4
    /// 柱子的宽度
    private let barWidth: Double = 12
    /// 图表到view的边距
    private let chartEdgeInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    /// content 的宽度
    private var contentWidth = UIScreen.main.bounds.width {
        didSet {
            contentSize = CGSize(width: contentWidth, height: frame.height)
        }
    }

    /// y轴上的刻度，从下往上，最后一个是最大值
    private var yScaleData = [Int]() {
        didSet {
            if let max = yScaleData.last {
                yMaxNumber = max
            } else {
                yMaxNumber = 100
            }
        }
    }
    /// Y轴的最大值
    private var yMaxNumber = 100
    /// 所有bar的frame
    private var barsFrameArray = [CGRect]()
    /// 背景表格的shapelayer
    private var tableShapeLayers = [CAShapeLayer]()
    /// X,Y轴上刻度
    private var scaleTextLayers = [CATextLayer]()
    /// 柱子layer的集合
    private var barsShapeLayers = [CAShapeLayer]()
    /// 上次点击的 point
    private var lastTapPoint: CGPoint?
    /// 点击图表时，显示信息的layer
    private var tapTextLayer = [CATextLayer]()
    /// 点击柱状图里阴影图
    lazy private var maskBarLay = CAShapeLayer()

    override func awakeFromNib() {
        super.awakeFromNib()

        setupTapGesture()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupTapGesture()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setupTapGesture() {
        /// 点击柱状图时的处理
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizerHandle(tapGesture:)))
        tapGesture.numberOfTapsRequired = 1
        addGestureRecognizer(tapGesture)
    }
}

// MARK: - 数据处理
extension CTScrollBarTimeChartView {
    private func showCharts() {
        deinitData()
        initData()
        drawTable()
        drawBars()
    }

    /// 初始化所有数据
    private func initData() {
        guard let data = data else { return }
        /* 两个柱子中线的间距最小是 barWidth + minSpacing
         * 按两个柱子中线的最小间距计算出chartView的宽度。
         * 如果小于contentWidth，则使用contentWidth当做宽度，不可滚动
         * 否则可以滚动，使用计算出来的宽度
         */
        let timeInterval = minTimeIntervalBetweenBarMid()
        let totalTimeInterval = data.endTime.timeIntervalSince(data.startTime)
        let width = CGFloat(totalTimeInterval / timeInterval * (barWidth + minSapcing))
//        contentWidth = contentWidth > width ? contentWidth : width

        if contentWidth < width {
            contentWidth = width
            showsHorizontalScrollIndicator = true
        } else {
            showsHorizontalScrollIndicator = false
        }

        /*
         * 计算Y轴上的刻度和Y轴最大值,Y轴上从0开始显示5个刻度
         * 最大值是传入数值里最大值的1.2倍
         */
        var numbers = [Double]()
        for item in data.yAxisData {
            numbers.append(item.number)
        }
        var maxNumber = 100
        if let max = numbers.max() {
            maxNumber = Int(max)
        }
        maxNumber = Int(CGFloat(maxNumber) * 1.2)

        yScaleData = (0...4).map { Int(CGFloat(maxNumber) / 4.0 * CGFloat($0)) }

        /*
         * 计算所有bar的frame
         */
        for item in data.yAxisData {
            let startTimeInterval = item.startTime.timeIntervalSince(data.startTime)
            let endTimeInterval = item.endTime.timeIntervalSince(data.startTime)
            let midX = CGFloat((startTimeInterval + endTimeInterval) / 2.0 / totalTimeInterval) * (contentWidth - chartEdgeInset.left - chartEdgeInset.right)
            let barHeight = CGFloat(item.number) / CGFloat(yMaxNumber) * (frame.height - chartEdgeInset.top - chartEdgeInset.bottom)
            let midY = frame.height - chartEdgeInset.bottom - barHeight
            let rect = CGRect(x: midX - CGFloat(barWidth / 2), y: midY, width: CGFloat(barWidth), height: barHeight)
            barsFrameArray.append(rect)
        }
    }

    /// 重置所有数据
    private func deinitData() {
        contentWidth = UIScreen.main.bounds.width
        yScaleData = [Int]()
        barsFrameArray = [CGRect]()

        for layer in tableShapeLayers {
            layer.removeFromSuperlayer()
        }
        tableShapeLayers = [CAShapeLayer]()

        for layer in scaleTextLayers {
            layer.removeFromSuperlayer()
        }
        scaleTextLayers = [CATextLayer]()

        for layer in barsShapeLayers {
            layer.removeFromSuperlayer()
        }
        barsShapeLayers = [CAShapeLayer]()
    }

    /// 计算柱子中线之间最小的时间间隔，返回单位是秒.返回值一定大于0
    private func minTimeIntervalBetweenBarMid() -> Double {
        guard let data = data else { return 0 }

        var timeIntervals = [Double]()
        var preTimeIntervar: Double = 0
        for item in data.yAxisData {
            let startTimeInterval = item.startTime.timeIntervalSince(data.startTime)
            let endTimeInterval = item.endTime.timeIntervalSince(data.startTime)
            let timeInterval = (startTimeInterval + endTimeInterval) / 2.0
            timeIntervals.append(timeInterval - preTimeIntervar)
            preTimeIntervar = timeInterval
        }
        guard let min = timeIntervals.min() else { return 1 }

        return min > 0 ? min : 1
    }
}

// MARK: - 画背景表格
extension CTScrollBarTimeChartView {
    /// 绘制表格
    private func drawTable() {
        guard let data = data else { return }

        /// 表格左边的竖线
        let leftStartPoint = CGPoint(x: chartEdgeInset.left, y: chartEdgeInset.top)
        let leftEndPoint = CGPoint(x: chartEdgeInset.left, y: frame.height - chartEdgeInset.bottom)
        drawTableShapLayer(point: leftStartPoint, point: leftEndPoint, isDottedLine: true)

        /// 表格右边竖线
        let rightStartPoint = CGPoint(x: contentWidth - chartEdgeInset.right, y: chartEdgeInset.top)
        let rightEndPoint = CGPoint(x: contentWidth - chartEdgeInset.right, y: frame.height - chartEdgeInset.bottom)
        drawTableShapLayer(point: rightStartPoint, point: rightEndPoint, isDottedLine: true)

        /// x轴开始和结尾刻度
        let dateFormatter = "yyyy-MM-dd HH:mm:ss"
        let leftText = data.startTime.toString(dateFormatter)
        let leftTextWidth = leftText.width(height: 14, font: UIFont.systemFont(ofSize: 12))
        let leftTextRect = CGRect(x: chartEdgeInset.left, y: frame.height - chartEdgeInset.bottom - 1, width: leftTextWidth, height: 14)
        drawTextLayer(text: leftText, rect: leftTextRect, alignmentModel: .left)
        let rightText = data.endTime.toString(dateFormatter)
        let rightTextWidth = rightText.width(height: 14, font: UIFont.systemFont(ofSize: 12))
        let rightTextRect = CGRect(x: contentWidth - chartEdgeInset.right - rightTextWidth, y: frame.height - chartEdgeInset.bottom - 1, width: rightTextWidth, height: 14)
        drawTextLayer(text: rightText, rect: rightTextRect, alignmentModel: .right)

        /// 水平线和Y刻度
        let leftX = chartEdgeInset.left
        let rightX = contentWidth - chartEdgeInset.right
        for (index, value) in yScaleData.enumerated() {
            let height = (frame.height - chartEdgeInset.top - chartEdgeInset.bottom) / CGFloat(yScaleData.count - 1) * CGFloat(index)
            let y = frame.height - chartEdgeInset.bottom - height
            let leftPoint = CGPoint(x: leftX, y: y)
            let rightPoint = CGPoint(x: rightX, y: y)
            drawTableShapLayer(point: leftPoint, point: rightPoint, isDottedLine: index != 0) // 水平线

            /// Y刻度
            let textHeight: CGFloat = 14
            let textWidth = String(value).width(height: textHeight, font: UIFont.systemFont(ofSize: 12))
            let textRect = CGRect(x: leftX, y: y - textHeight - 1, width: textWidth, height: textHeight)
            drawTextLayer(text: String(value), rect: textRect, alignmentModel: .left)
        }

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
        shapeLayer.bounds = CGRect(origin: CGPoint.zero, size: contentSize)
        // 画布在画板上的位置。
        // 可以这么理解：用一个图钉将一张画布钉在画板上，
        // postion是图钉在画板上的位置，anchorPoint是图钉在画布上的位置
        shapeLayer.position = CGPoint.zero
        shapeLayer.anchorPoint = CGPoint.zero
        // 线的宽度
        shapeLayer.lineWidth = 0.5
        // 线终点式样
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        // 线的颜色
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        // 线的路径
        shapeLayer.path = linePath.cgPath
        // 线围成区域的填充颜色
        shapeLayer.fillColor = nil
        // 虚线
        if isDottedLine {
            shapeLayer.lineDashPattern = [1, 1]
        }

        layer.addSublayer(shapeLayer)
        tableShapeLayers.append(shapeLayer)
    }

    private func drawTextLayer(text: String, rect: CGRect, alignmentModel: CATextLayerAlignmentMode) {
        let textLayer = CATextLayer()
        textLayer.string = text
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.foregroundColor = UIColor.lightGray.cgColor
        let textFont = UIFont.systemFont(ofSize: 12)
        textLayer.font = CGFont(textFont.fontName as CFString)
        textLayer.fontSize = textFont.pointSize
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.alignmentMode = alignmentModel
        textLayer.frame = rect

        layer.addSublayer(textLayer)
        scaleTextLayers.append(textLayer)
    }
}

// MARK: - 绘制柱状图
extension CTScrollBarTimeChartView {
    private func drawBars() {
        guard let data = data else { return }

        for rect in barsFrameArray {
            drawBar(rect: rect, fillColor: data.barColor)
        }
    }

    private func drawBar(rect: CGRect, fillColor: UIColor) {
        let path = UIBezierPath.init(rect: rect)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 0
        shapeLayer.bounds = CGRect(origin: CGPoint.zero, size: contentSize)
        shapeLayer.position = CGPoint.zero
        shapeLayer.anchorPoint = CGPoint.zero
        layer.addSublayer(shapeLayer)
        barsShapeLayers.append(shapeLayer)
    }
}

// MARK: - 点击柱状图的处理
extension CTScrollBarTimeChartView {
    @objc func tapGestureRecognizerHandle(tapGesture: UITapGestureRecognizer) {
        let tapPoint = tapGesture.location(in: self)

        lastTapPoint = tapPoint
        actionOnPoint(point: tapPoint)
    }

    private func actionOnPoint(point: CGPoint) {
        guard let index = nearestBarIndexTo(point), index < barsFrameArray.count else { return }

        for layer in tapTextLayer {
            layer.removeFromSuperlayer()
        }
        tapTextLayer = [CATextLayer]()

        drawMaskBarLayer(index)
        drawExtensionInfoLayer(index, tapPoint: point)
    }

    /// 距离点击位置最近的柱子index，最近的柱子距离超过 barWidth 时返回nil
    private func nearestBarIndexTo(_ point: CGPoint) -> Int? {
        /// 柱子中点x的值
        let xPoints = barsFrameArray.map {
            $0.origin.x + ($0.size.width / 2)
        }

        let intervals = xPoints.map {
            fabs(Double($0 - point.x))
        }

        guard let min = intervals.min() else { return nil }
        guard min <= barWidth else {
            return nil
        }

        if let index = intervals.firstIndex(where: { $0 == min }) {
            return index
        }

        return nil
    }

    /// 画阴影柱子
    private func drawMaskBarLayer(_ index: Int) {
        let barFrame = barsFrameArray[index]

        let maskBarFrame = CGRect(x: barFrame.origin.x - CGFloat(minSapcing), y: chartEdgeInset.top, width: barFrame.width + CGFloat(minSapcing * 2.0), height: frame.height - chartEdgeInset.top - chartEdgeInset.bottom)
        drawMaskBar(rect: maskBarFrame, fillColor: UIColor.hexRGB(0x000000, 0.1))
    }

    /// 显示extension info 和时间戳
    private func drawExtensionInfoLayer(_ index: Int, tapPoint: CGPoint) {
        guard let data = data, index < data.yAxisData.count else { return }

        let item = data.yAxisData[index]

        let dateFormatter = "yyyy-MM-dd HH:mm:ss"
        let stamp = item.startTime.toString(dateFormatter) + " - " + item.endTime.toString(dateFormatter)
        let stampRect = timeStampRect(tapPoint, stamp: stamp)
        drawExtensionInfoTextLayer(text: stamp, rect: stampRect, alignmentModel: .left)
        drawExtensionInfo(tapPoint, info: item.extensionInfo)
    }

    /// 计算显示time stamp的rect
    private func timeStampRect(_ tapPoint: CGPoint, stamp: String) -> CGRect {
        let textHeight: CGFloat = 17
        let textWidth = stamp.width(height: textHeight, font: UIFont.systemFont(ofSize: 12))

        /// 默认在点击右侧显示信息，如果右侧宽度不够则往左平移

        let leftOffset = tapPoint.x - contentOffset.x
        let rightOffset = frame.width - leftOffset - chartEdgeInset.right

        if rightOffset >= textWidth {
            return CGRect(x: tapPoint.x, y: chartEdgeInset.top - textHeight, width: textWidth, height: textHeight)
        } else {
            return CGRect(x: tapPoint.x - (textWidth - rightOffset), y: chartEdgeInset.top - textHeight, width: textWidth, height: textHeight)
        }

    }

    /// 显示extension
    private func drawExtensionInfo(_ tapPoint: CGPoint, info: [String]) {
        var str = ""
        var widthMax: CGFloat = 0
        var lineSpaceCount = 0
        for (index, text) in info.enumerated() {
            let width = text.width(height: 17, font: UIFont.systemFont(ofSize: 12))
            widthMax = widthMax > width ? widthMax : width
            if index == 0 {
                str = text
            } else {
                str += "\n" + text
                lineSpaceCount += 1
            }
        }
        var height = str.height(width: widthMax, font: UIFont.systemFont(ofSize: 12))
        height += CGFloat(4 * lineSpaceCount)

        /// 优先在点击位置左侧显示
        let leftOffset = tapPoint.x - contentOffset.x - chartEdgeInset.left
        var orignX: CGFloat = 0
        if leftOffset > widthMax {
            orignX = contentOffset.x + chartEdgeInset.left
        } else {
            orignX = contentOffset.x + frame.width - chartEdgeInset.right - widthMax
        }
        let rect = CGRect(x: orignX, y: frame.height - chartEdgeInset.bottom - height, width: widthMax, height: height)
        drawExtensionInfoTextLayer(text: str, rect: rect, alignmentModel: .left)
    }

    private func drawMaskBar(rect: CGRect, fillColor: UIColor) {
        maskBarLay.removeFromSuperlayer()
        let path = UIBezierPath.init(rect: rect)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 0
        shapeLayer.bounds = CGRect(origin: CGPoint.zero, size: contentSize)
        shapeLayer.position = CGPoint.zero
        shapeLayer.anchorPoint = CGPoint.zero
        layer.addSublayer(shapeLayer)
        maskBarLay = shapeLayer
    }

    private func drawExtensionInfoTextLayer(text: String, rect: CGRect, alignmentModel: CATextLayerAlignmentMode) {
        guard let data = data else { return }
        let textLayer = CATextLayer()
        textLayer.string = text
        textLayer.backgroundColor = data.barColor.cgColor
        textLayer.foregroundColor = UIColor.white.cgColor
        let textFont = UIFont.systemFont(ofSize: 12)
        textLayer.font = CGFont(textFont.fontName as CFString)
        textLayer.fontSize = textFont.pointSize
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.alignmentMode = alignmentModel
        textLayer.frame = rect

        layer.addSublayer(textLayer)
        tapTextLayer.append(textLayer)
    }
}
