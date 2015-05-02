//
//  AppDelegate.swift
//  TV
//
//  Created by Francescu on 01/05/2015.
//  Copyright (c) 2015 Francescu. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    var state = DataState.NotYet

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        
//        self.application(UIApplication.sharedApplication(), handleWatchKitExtensionRequest:nil ) { (result) -> Void in
//            if let r = result?["result"] as? FormatedContentType {
//               println(r)
//            }
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
//        var workaround:UIBackgroundTaskIdentifier?
//        
//        workaround = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({ () -> Void in
//            UIApplication.sharedApplication().endBackgroundTask(workaround!)
//        })
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
//            UIApplication.sharedApplication().endBackgroundTask(workaround!)
//        })
//        var bgTask:UIBackgroundTaskIdentifier?
//        bgTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler() {
//            reply(nil)
//            UIApplication.sharedApplication().endBackgroundTask(bgTask!)
//        }
        //1. If we have data just send it
        if let data = self.state.data() {
            println("Send data");
            reply(["result": data])
        } else {
            //GET DATA (from remote or from local)
            println("parsing")
            
            
            
            let filePath = NSBundle.mainBundle().pathForResource("test", ofType: "json")
            
            if let content = parse(filePath!) {
                //                var result = [TVProgram]()
                println("filtering")
                //                for (channel, programs) in content {
                //                    let prog = programNow(programs)
                //                    result.append(prog)
                //                }
                println("Filling data")
//                if let test = content["tf1"] {
//                    NSKeyedArchiver.archivedDataWithRootObject(test)
//                }
//
                reply(["result":NSKeyedArchiver.archivedDataWithRootObject(content)])
            }
            else {
                println("error")
                reply(["error":"error"])
            }
        }
//            UIApplication.sharedApplication().endBackgroundTask(bgTask!)
        
        
        //
//
//
        
    }

}

