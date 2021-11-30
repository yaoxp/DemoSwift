//
//  NinePatchImageFactory.swift
//  PaperSDK-Basic-CN-Demo-UI
//
//  Created by yaoxp on 2021/7/22.
//

import Foundation
import Accelerate

/*
 安卓.9图本质就是普通图片。.9图四周有四条1像素宽度的黑线。
 上面和左面的黑线表示可以拉伸的区域
 下面和右面的黑线表示可以写入文字的区域

 iOS拉伸图片只需要用到上面和左面的黑线

 用CGImageGetDataProvider获取像素数据
 */

/// 从安卓.9图，生成ios可用的可伸缩的图片
class NinePatchImageFactory {

    fileprivate typealias ColorRGBA = (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)

    /// 基于安卓的.9图，生成iOS可用的可伸缩的图片
    /// - Parameter image: 安卓.9图
    /// - Returns: 生成的可伸缩的图片，失败返回nil
    class func createStretchableImage(with image: UIImage) -> UIImage? {
        // 1. 先把image转换成1倍图
        let oneScaleImage = scaleOneImage(with: image)

        // 2. 获取上面黑线开始和结束的坐标，左面黑线开始和结束的坐标
        guard let points = topAndLeftBlackLinePoint(with: oneScaleImage) else { return nil }
        // 3. 剪掉黑线
        guard let cropImage = crop(oneScaleImage, rect: CGRect(x: 1, y: 1, width: oneScaleImage.size.width - 2, height: oneScaleImage.size.height - 2)),
              let cropImageRef = cropImage.cgImage else { return nil }

        // 4. 生成scale和mainscreen一致的图片，然后生成可伸缩图片
        let newCropImage = UIImage(cgImage: cropImageRef, scale: image.scale, orientation: image.imageOrientation)
        let topInset = CGFloat(points.leftTop - 1) / image.scale
        let leftInset = CGFloat(points.topLeft - 1) / image.scale
        let bottomInset = (newCropImage.size.height - CGFloat(points.leftBottom - 1)) / image.scale
        let rightInset = (newCropImage.size.width - CGFloat(points.topRight - 1)) / image.scale
        if topInset < 0 || bottomInset < 0 ||
            leftInset < 0 || rightInset < 0 {
            assert(false, "The 9-patch PNG format is not correct.")
            return nil
        }
        let inset = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        return newCropImage.resizableImage(withCapInsets: inset)
    }

    /// 基于安卓的.9图，生成iOS可用的可伸缩的图片
    /// - Parameter image: 安卓.9图
    /// - Returns: 生成的可伸缩的图片，失败返回nil
    class func createStretchableImage2(with image: UIImage) -> UIImage? {
        // 1. 先把image转换成1倍图
        let oneScaleImage = scaleOneImage(with: image)

        // 2. 获取上面黑线开始和结束的坐标，左面黑线开始和结束的坐标
        guard let points = topAndLeftBlackLinePoint2(with: oneScaleImage) else { return nil }
        // 3. 剪掉黑线
        guard let cropImage = crop(oneScaleImage, rect: CGRect(x: 1, y: 1, width: oneScaleImage.size.width - 2, height: oneScaleImage.size.height - 2)),
              let cropImageRef = cropImage.cgImage else { return nil }

        // 4. 生成scale和mainscreen一致的图片，然后生成可伸缩图片
        let newCropImage = UIImage(cgImage: cropImageRef, scale: image.scale, orientation: image.imageOrientation)
        let topInset = CGFloat(points.leftTop - 1) / image.scale
        let leftInset = CGFloat(points.topLeft - 1) / image.scale
        let bottomInset = (newCropImage.size.height - CGFloat(points.leftBottom - 1)) / image.scale
        let rightInset = (newCropImage.size.width - CGFloat(points.topRight - 1)) / image.scale
        if topInset < 0 || bottomInset < 0 ||
            leftInset < 0 || rightInset < 0 {
            assert(false, "The 9-patch PNG format is not correct.")
            return nil
        }
        let inset = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        return newCropImage.resizableImage(withCapInsets: inset)
    }

    /// 生成scale == 1 的图片
    /// - Parameter image: 需要转换的图片
    /// - Returns: 转换后的图片
    fileprivate class func scaleOneImage(with image: UIImage) -> UIImage {
        guard image.scale != 1, image.cgImage != nil else {
            return image
        }

        return UIImage(cgImage: image.cgImage!, scale: 1, orientation: image.imageOrientation)
    }

    fileprivate class func crop(_ image: UIImage, rect: CGRect) -> UIImage? {
        let rect = CGRect(x: rect.origin.x * image.scale,
                          y: rect.origin.y * image.scale,
                          width: rect.width * image.scale,
                          height: rect.height * image.scale)
        guard let imageRef = image.cgImage?.cropping(to: rect) else { return nil }
        return UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
    }

    fileprivate class func topAndLeftBlackLinePoint2(with image: UIImage) -> ((topLeft: Int, topRight: Int, leftTop: Int, leftBottom: Int)?) {
        guard let imageRef = image.cgImage else { return nil }
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitsPerComponent = 8
        let bytesPerRow = 4 * imageRef.width
        let dataPtr = calloc(bytesPerRow, imageRef.height).assumingMemoryBound(to: UInt8.self)
        calloc(bytesPerRow, imageRef.height).bindMemory(to: UInt8.self, capacity: bytesPerRow * imageRef.height)
        defer {
            dataPtr.deallocate()
        }

        guard let context = CGContext(data: dataPtr,
                                width: imageRef.width,
                                height: imageRef.height,
                                bitsPerComponent: bitsPerComponent,
                                bytesPerRow: bytesPerRow,
                                space: colorSpace,
                                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue) else { return nil }
        context.draw(imageRef, in: CGRect(x: 0, y: 0, width: imageRef.width, height: imageRef.height))

        var rowRGBA = [ColorRGBA]()
        for index in stride(from: 0, to: bytesPerRow, by: 4) {
            let pixel: Pixel_8888 = (dataPtr[index], dataPtr[index + 1], dataPtr[index + 2], dataPtr[index + 3])
            let a = CGFloat(pixel.0) / 255.0
            let b = CGFloat(pixel.1) / 255.0
            let g = CGFloat(pixel.2) / 255.0
            let r = CGFloat(pixel.3) / 255.0
            rowRGBA.append((r, g, b, a))
        }

        var columnRGBA = [ColorRGBA]()
        for index in stride(from: 0, to: bytesPerRow * imageRef.height, by: bytesPerRow) {
            let pixel: Pixel_8888 = (dataPtr[index], dataPtr[index + 1], dataPtr[index + 2], dataPtr[index + 3])
            let a = CGFloat(pixel.0) / 255.0
            let b = CGFloat(pixel.1) / 255.0
            let g = CGFloat(pixel.2) / 255.0
            let r = CGFloat(pixel.3) / 255.0
            columnRGBA.append((r, g, b, a))
        }

        var topLeft = -1, topRight = -1, leftTop = -1, leftBottom = -1
        for (index, color) in rowRGBA.enumerated() {
            if color.r == 0, color.g == 0, color.b == 0, color.a == 1 {
                topLeft = index
                break
            }
        }
        assert(topLeft != -1, "The 9-patch PNG format is not correct.")

        for (index, color) in rowRGBA.enumerated().reversed() {
            if color.r == 0, color.g == 0, color.b == 0, color.a == 1 {
                topRight = index
                break
            }
        }
        assert(topRight != -1, "The 9-patch PNG format is not correct.")

        for (index, color) in columnRGBA.enumerated() {
            if color.r == 0, color.g == 0, color.b == 0, color.a == 1 {
                leftTop = index
                break
            }
        }
        assert(leftTop != -1, "The 9-patch PNG format is not correct.")

        for (index, color) in columnRGBA.enumerated().reversed() {
            if color.r == 0, color.g == 0, color.b == 0, color.a == 1 {
                leftBottom = index
                break
            }
        }
        assert(leftBottom != -1, "The 9-patch PNG format is not correct.")

        for index in topLeft..<topRight {
            let color = rowRGBA[index]
            if color.r != 0 ||
                color.g != 0 ||
                color.b != 0 ||
                color.a != 1 {
                assert(false, "The 9-patch PNG format is not correct.")
                return nil
            }
        }

        for index in leftTop..<leftBottom {
            let color = columnRGBA[index]
            if color.r != 0 ||
                color.g != 0 ||
                color.b != 0 ||
                color.a != 1 {
                assert(false, "The 9-patch PNG format is not correct.")
                return nil
            }
        }
        #if DEBUG
        print("orig nine patch image: \(topLeft), \(topRight), \(leftTop), \(leftBottom)")
        #endif
        return (topLeft, topRight, leftTop, leftBottom)
    }

    fileprivate class func topAndLeftBlackLinePoint(with image: UIImage) -> ((topLeft: Int, topRight: Int, leftTop: Int, leftBottom: Int)?) {
        guard let imageRef = image.cgImage,
              let privoder = imageRef.dataProvider,
              let data = privoder.data else { return nil }

        let bitmapInfo = imageRef.bitmapInfo
        let bytesPerRow = imageRef.bytesPerRow
        let dataPtr: UnsafePointer<UInt8> = CFDataGetBytePtr(data)

        var rowRGBA = [ColorRGBA]()
        for index in stride(from: 0, to: bytesPerRow, by: 4) {
            let pixel: Pixel_8888 = (dataPtr[index], dataPtr[index + 1], dataPtr[index + 2], dataPtr[index + 3])
            rowRGBA.append(getRGBAFromPixel(pixel, bitmapInfo: bitmapInfo))
        }

        var columnRGBA = [ColorRGBA]()
        for index in stride(from: 0, to: CFDataGetLength(data), by: bytesPerRow) {
            let pixel: Pixel_8888 = (dataPtr[index], dataPtr[index + 1], dataPtr[index + 2], dataPtr[index + 3])
            columnRGBA.append(getRGBAFromPixel(pixel, bitmapInfo: bitmapInfo))
        }

        var topLeft = -1, topRight = -1, leftTop = -1, leftBottom = -1
        for (index, color) in rowRGBA.enumerated() {
            if color.r == 0, color.g == 0, color.b == 0, color.a == 1 {
                topLeft = index
                break
            }
        }
        assert(topLeft != -1, "The 9-patch PNG format is not correct.")

        for (index, color) in rowRGBA.enumerated().reversed() {
            if color.r == 0, color.g == 0, color.b == 0, color.a == 1 {
                topRight = index
                break
            }
        }
        assert(topRight != -1, "The 9-patch PNG format is not correct.")

        for (index, color) in columnRGBA.enumerated() {
            if color.r == 0, color.g == 0, color.b == 0, color.a == 1 {
                leftTop = index
                break
            }
        }
        assert(leftTop != -1, "The 9-patch PNG format is not correct.")

        for (index, color) in columnRGBA.enumerated().reversed() {
            if color.r == 0, color.g == 0, color.b == 0, color.a == 1 {
                leftBottom = index
                break
            }
        }
        assert(leftBottom != -1, "The 9-patch PNG format is not correct.")

        for index in topLeft..<topRight {
            let color = rowRGBA[index]
            if color.r != 0 ||
                color.g != 0 ||
                color.b != 0 ||
                color.a != 1 {
                assert(false, "The 9-patch PNG format is not correct.")
                return nil
            }
        }

        for index in leftTop..<leftBottom {
            let color = columnRGBA[index]
            if color.r != 0 ||
                color.g != 0 ||
                color.b != 0 ||
                color.a != 1 {
                assert(false, "The 9-patch PNG format is not correct.")
                return nil
            }
        }
        #if DEBUG
        print("orig nine patch image: \(topLeft), \(topRight), \(leftTop), \(leftBottom)")
        #endif
        return (topLeft, topRight, leftTop, leftBottom)
    }

    /// 解析像素点的颜色信息
    fileprivate class func getRGBAFromPixel(_ pixel: Pixel_8888, bitmapInfo: CGBitmapInfo) -> ColorRGBA {
        let alphaInfo = bitmapInfo.rawValue & CGBitmapInfo.alphaInfoMask.rawValue
        let byteOrderInfo = bitmapInfo.rawValue & CGBitmapInfo.byteOrderMask.rawValue
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0

        var byteOrderBig = true
        if byteOrderInfo == CGBitmapInfo.byteOrder32Little.rawValue {
            byteOrderBig = false
        }

        guard let alphaInfoEnum = CGImageAlphaInfo(rawValue: alphaInfo) else { return (r, g, b, a) }
        switch alphaInfoEnum {
        case .first, .premultipliedFirst:
            if byteOrderBig {
                // ARGB_8888
                a = CGFloat(pixel.0) / 255.0
                r = CGFloat(pixel.1) / 255.0
                g = CGFloat(pixel.2) / 255.0
                b = CGFloat(pixel.3) / 255.0
            } else {
                // BGRA_8888
                b = CGFloat(pixel.0) / 255.0
                g = CGFloat(pixel.1) / 255.0
                r = CGFloat(pixel.2) / 255.0
                a = CGFloat(pixel.3) / 255.0
            }
        case .last, .premultipliedLast:
            if byteOrderBig {
                // RGBA_8888
                r = CGFloat(pixel.0) / 255.0
                g = CGFloat(pixel.1) / 255.0
                b = CGFloat(pixel.2) / 255.0
                a = CGFloat(pixel.3) / 255.0
            } else {
                // ABGR_8888
                a = CGFloat(pixel.0) / 255.0
                b = CGFloat(pixel.1) / 255.0
                g = CGFloat(pixel.2) / 255.0
                r = CGFloat(pixel.3) / 255.0
            }
        case .none:
            if byteOrderBig {
                // RGB_888
                r = CGFloat(pixel.0) / 255.0
                g = CGFloat(pixel.1) / 255.0
                b = CGFloat(pixel.2) / 255.0
            } else {
                // BGR_888
                b = CGFloat(pixel.0) / 255.0
                g = CGFloat(pixel.1) / 255.0
                r = CGFloat(pixel.2) / 255.0
            }
        case .noneSkipLast:
            if byteOrderBig {
                // RGBX_8888
                r = CGFloat(pixel.0) / 255.0
                g = CGFloat(pixel.1) / 255.0
                b = CGFloat(pixel.2) / 255.0
            } else {
                // XBGR_8888
                b = CGFloat(pixel.1) / 255.0
                g = CGFloat(pixel.2) / 255.0
                r = CGFloat(pixel.3) / 255.0
            }
        case .noneSkipFirst:
            if byteOrderBig {
                // XRGB_8888
                r = CGFloat(pixel.1) / 255.0
                g = CGFloat(pixel.2) / 255.0
                b = CGFloat(pixel.3) / 255.0
            } else {
                // BGRX_8888
                b = CGFloat(pixel.0) / 255.0
                g = CGFloat(pixel.1) / 255.0
                r = CGFloat(pixel.2) / 255.0
            }
        case .alphaOnly:
            a = CGFloat(pixel.0) / 255.0
        @unknown default:
            break;
        }
        return (r, g, b, a)
    }
}
