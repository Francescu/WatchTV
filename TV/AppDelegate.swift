//
//  AppDelegate.swift
//  TV
//
//  Created by Francescu on 01/05/2015.
//  Copyright (c) 2015 Francescu. All rights reserved.
//

import UIKit

func localFilePath() -> String {
    return NSTemporaryDirectory().stringByAppendingPathComponent("\(DataState.dateString()).json")
}


func getJSONData() -> NSData? {
    if let data = NSData(contentsOfFile: localFilePath()) {
        return data
    }
    else {
        let request = NSURLRequest(URL: Config.JSONURL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        var response:NSURLResponse?
        var error:NSError?
        
        if let data = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error: &error) {
           data.writeToFile(localFilePath(), atomically: true)
           return data
        }
    }
    return nil
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    var state = DataState.NotYet

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        
//        self.application(UIApplication.sharedApplication(), handleWatchKitExtensionRequest:nil ) { (result) -> Void in
//               println(result)
//        }
//
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, handleWatchKitExtensionRequest userInfo: [NSObject : AnyObject]?, reply: (([NSObject : AnyObject]!) -> Void)!) {

        if let data = self.state.data() {
            println("Send data");
            reply(["result": data])
        } else {
            //GET DATA (from remote or from local)
            println("parsing")
            
            var task = UIBackgroundTaskInvalid
            UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({ () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(task)
                task = UIBackgroundTaskInvalid
            })
            
            if let data = getJSONData() {
                if let content = parse(data) {
                    self.state = DataState.Data(content, DataState.dateString())
                    reply(["result":NSKeyedArchiver.archivedDataWithRootObject(content)])
                }
                else {
                    println("error")
                    reply(["error":"error"])
                }
            }
            else {
                reply(["error":"No network or server down"])
            }
            UIApplication.sharedApplication().endBackgroundTask(task)
            
            task = UIBackgroundTaskInvalid
        }
    }

}

