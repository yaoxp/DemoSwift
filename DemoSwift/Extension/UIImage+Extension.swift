//
//  UIImage+Extension.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/3/19.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit
import ImageIO
import QuartzCore

extension UIImage {
    class func createImage(color: UIColor, frame: CGRect) -> UIImage? {
        UIGraphicsBeginImageContext(frame.size)

        if let context = UIGraphicsGetCurrentContext() {

            context.setFillColor(color.cgColor)

            context.fill(frame)

            let theImage = UIGraphicsGetImageFromCurrentImageContext()

            UIGraphicsEndImageContext()

            return theImage
        }

        UIGraphicsEndImageContext()

        return nil

    }

    class func createImage(color: UIColor) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 10, height: 10)

        UIGraphicsBeginImageContext(frame.size)

        if let context = UIGraphicsGetCurrentContext() {

            context.setFillColor(color.cgColor)

            context.fill(frame)

            let theImage = UIGraphicsGetImageFromCurrentImageContext()

            UIGraphicsEndImageContext()

            return theImage
        }

        UIGraphicsEndImageContext()

        return nil

    }

    class func downsample(data: Data, to pointSize: CGSize, scale: CGFloat) -> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions) else { return nil }

        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        let downsampleOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
                                 kCGImageSourceShouldCacheImmediately: true,
                                 kCGImageSourceCreateThumbnailWithTransform: true,
                                 kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels] as CFDictionary
        guard let downsampleImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else { return nil }
        return UIImage(cgImage: downsampleImage, scale: scale, orientation: .up)
    }

    func resizeUI(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)

        draw(in: CGRect(origin: .zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return newImage
    }

    func resizeCG(_ size: CGSize) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        let scale: CGFloat = UIScreen.main.scale
        let bitsPerComponent = cgImage.bitsPerComponent
        let bytesPerRow = cgImage.bytesPerRow
        let colorSpace = cgImage.colorSpace
        let bitmapInfo = cgImage.bitmapInfo

        guard let context = CGContext(data: nil,
                                      width: Int(size.width * scale),
                                      height: Int(size.height * scale),
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace!,
                                      bitmapInfo: bitmapInfo.rawValue) else { return nil }

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width * scale, height: size.height * scale))

        let resizedImage = context.makeImage().flatMap {
            UIImage(cgImage: $0)
        }

        return resizedImage
    }

    func resizeIO(_ size: CGSize) -> UIImage? {
        guard let data = self.pngData() else { return nil }
        
        let maxPixelSize = max(size.width, size.height)

        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }

        let options: [CFString: Any] = [kCGImageSourceThumbnailMaxPixelSize: maxPixelSize,
                                      kCGImageSourceCreateThumbnailFromImageAlways: true]
        let newImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary).flatMap {
            UIImage(cgImage: $0)
        }

        return newImage
    }

    func resizeCI(_ size: CGSize) -> UIImage? {

        guard  let cgImage = self.cgImage else { return nil }

        let widthScale = (Double)(size.width * UIScreen.main.scale) / (Double)(self.size.width)
        let heightScale = (Double)(size.height * UIScreen.main.scale) / (Double)(self.size.height)
        let scale = max(widthScale, heightScale)

        let image = CIImage(cgImage: cgImage)

        let filter = CIFilter(name: "CILanczosScaleTransform")!
        filter.setValue(image, forKey: kCIInputImageKey)
        filter.setValue(NSNumber(value: Float(scale)), forKey: kCIInputScaleKey)
        filter.setValue(1.0, forKey: kCIInputAspectRatioKey)

        guard let outputImage = filter.value(forKey: kCIOutputImageKey) as? CIImage else { return nil}

        let context = CIContext(options: convertToOptionalCIContextOptionDictionary([convertFromCIContextOption(CIContextOption.useSoftwareRenderer): false]))

        let resizedImage = context.createCGImage(outputImage, from: outputImage.extent).flatMap {
            UIImage(cgImage: $0)
        }
        return resizedImage
    }

}

// Helper function inserted by Swift 4.2 migrator.
private func convertToOptionalCIContextOptionDictionary(_ input: [String: Any]?) -> [CIContextOption: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (CIContextOption(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromCIContextOption(_ input: CIContextOption) -> String {
	return input.rawValue
}
