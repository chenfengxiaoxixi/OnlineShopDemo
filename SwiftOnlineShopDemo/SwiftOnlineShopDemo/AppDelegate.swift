//
//  AppDelegate.swift
//  SwiftOnlineShopDemo
//
//  Created by chenfeng on 2019/4/23.
//  Copyright © 2019年 chenfeng. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    struct Person : Codable{
        var name: String?
        var age: String?
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let tabbar = CFTabBarController()
        self.window?.rootViewController = tabbar
        
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
        //字典转模型列子，数组转模型列子
        let dic = ["name":"乘风","age":"19"]
        let dic2 = ["name":"乘风2","age":"20"]
        let array = [dic,dic2]

        let model = ModelTool.dicToJSONModel(Person.self, withKeyValues: dic)

        print(model)

        print(dic)

        let modelArray = ModelTool.arrayToJSONModel(Person.self, withKeyValuesArray: array)

        print(modelArray)
        
        //Moya请求例子
        provider.request(MoyaApi.categoryList(categoryId: "0")) { (result) in
        
        switch result {
        case let .success(result):
            do {
                try print("result.mapJSON() = \(result.mapJSON())")
            } catch {
                print("MoyaError.jsonMapping(result) = \(result)")
            }
            default:
                break
            }
            print("result = \(result.description)")
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


}

