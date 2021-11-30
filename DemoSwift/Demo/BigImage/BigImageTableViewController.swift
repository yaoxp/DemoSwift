//
//  BigImageTableViewController.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/9/9.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

struct ImageSource {
    static let bigImageName = "IMG_001.png"
    static let bigTransparentImageName = "transparent_001.png"
}

class BigImageTableViewController: UITableViewController {

    let bigImageDemo = [Demo(title: "不处理",
                             subtitle: "imageView.image = image",
                             class: OriginImageViewController.self),
                        Demo(title: "Apple method", subtitle: "CGImageSourceCreateThumbnailAtIndex", class: AppleDownsampleViewController.self),
                        Demo(title: "UIKit",
                             subtitle: "UIGraphicsBeginImageContextWithOptions & UIImage -drawInRect:",
                             class: UIKitBigImageViewController.self),
                        Demo(title: "CoreGraphics",
                             subtitle: "CGBitmapContextCreate & CGContextDrawImage",
                             class: CoreGraphicsBigImageViewController.self),
                        Demo(title: "Core Image",
                             subtitle: "CIImage & CIFilter",
                             class: CoreImageBigImageViewController.self),
                        Demo(title: "Image IO",
                             subtitle: "CGImageSourceCreateThumbnailAtIndex",
                             class: ImageIOBigImageViewController.self)]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bigImageDemo.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
        }

        let demo = bigImageDemo[indexPath.row]

        cell!.textLabel?.text = demo.title
        cell!.detailTextLabel?.text = demo.subtitle

        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let demo = bigImageDemo[indexPath.row]

        if let vcClass = demo.class as? UIViewController.Type {
            let vc = vcClass.init()
            navigationController!.pushViewController(vc, animated: true)
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
