//
//  AppDelegate.swift
//  DemoSwift
//
//  Created by yaoxinpan on 2018/3/14.
//  Copyright © 2018年 yaoxp. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    enum ShortcutIdentifier: String {
        case first
        case second
        case third
        case fourth

        init?(fullType: String) {
            guard let last = fullType.components(separatedBy: ".").last else {
                return nil
            }

            self.init(rawValue: last)
        }

        var type: String {
            return Bundle.main.bundleIdentifier! + ".\(self.rawValue)"
        }

    }

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        if let shortcutItems = application.shortcutItems, shortcutItems.isEmpty {
            let shortcut2 = UIApplicationShortcutItem(type: ShortcutIdentifier.second.type,
                                                      localizedTitle: "买单吧",
                                                      localizedSubtitle: nil,
                                                      icon: UIApplicationShortcutIcon(type: .play),
                                                      userInfo: nil)
            let shortcut3 = UIApplicationShortcutItem(type: ShortcutIdentifier.third.type,
                                                      localizedTitle: "跑马灯",
                                                      localizedSubtitle: nil,
                                                      icon: UIApplicationShortcutIcon(type: .pause),
                                                      userInfo: nil)
            let shortCut4 = UIApplicationShortcutItem(type: ShortcutIdentifier.fourth.type,
                                                      localizedTitle: "日期选择器",
                                                      localizedSubtitle: nil,
                                                      icon: UIApplicationShortcutIcon(type: .audio),
                                                      userInfo: nil)
            application.shortcutItems = [shortcut2, shortcut3, shortCut4]
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "animation"), object: nil)

        guard ShortcutIdentifier(fullType: shortcutItem.type) != nil else {
            completionHandler(false)
            return
        }

        guard let shortcutType = shortcutItem.type as String? else {
            completionHandler(false)
            return
        }

        if let navigationController = window!.rootViewController as? UINavigationController {
            switch shortcutType {
            case ShortcutIdentifier.first.type:
                completionHandler(true)
                let vc = AnimationViewController()
                navigationController.pushViewController(vc, animated: true)

            case ShortcutIdentifier.second.type:
                completionHandler(true)
                let vc = PayTheBillViewController()
                navigationController.pushViewController(vc, animated: true)

            case ShortcutIdentifier.third.type:
                completionHandler(true)
                let vc = MarqueeViewController()
                navigationController.pushViewController(vc, animated: true)
            case ShortcutIdentifier.fourth.type:
                let vc = DatePickerDemoViewController()
                navigationController.pushViewController(vc, animated: true)
            default:
                completionHandler(false)
                return
            }

        }

        completionHandler(false)
    }
}
