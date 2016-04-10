//
//  AppDelegate.m
//  withU
//
//  Created by cby on 16/3/2.
//  Copyright © 2016年 cby. All rights reserved.
//

#import "AppDelegate.h"
#import <MQTTKit.h>
#import "withUNetTool.h"
#import "netWorkTool.h"

@interface AppDelegate ()
{
    
    UIBackgroundTaskIdentifier bgTask;
    NSUInteger counter;
    
}
@property (strong, nonatomic) MQTTClient *client;
@property (strong, nonatomic) id <withUNetTool> delegate;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.delegate = [[netWorkTool alloc] initWithMqttClientId:@"hh"];
     [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil ]];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    application.applicationIconBadgeNumber -= 1;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    
//    BOOL backgroundAccepted = [[UIApplication sharedApplication]setKeepAliveTimeout:600 handler:^{ [self backgroundHandler];}];
//    
//    if (backgroundAccepted){
//        
//        NSLog(@"backgrounding accepted");
//    }
//    
//    [self backgroundHandler];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)backgroundHandler {
    
    NSLog(@"### -->backgroundinghandler");
    
    UIApplication *app = [UIApplication sharedApplication];
    
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        
        [app endBackgroundTask:bgTask];
        
        bgTask = UIBackgroundTaskInvalid;
        
    }];
    
    // Start the long-running task
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            [self.delegate mqttSub];
        NSLog(@"background");
    });
    
}


//- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification{
////      if (application.applicationState != UIApplicationStateActive){
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LocalNotification" message:notification.alertBody delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            
//            [alert show];
//            
//            // 图标上的数字减1
//            application.applicationIconBadgeNumber += 1;
////      }
//}
@end
