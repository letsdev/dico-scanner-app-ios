//
//  DCSAppDelegate.m
//  DiCoScanner
//
//  Created by Fabian Köbel on 19.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

#import "DCSAppDelegate.h"
#import "DCSStartVC.h"

@interface DCSAppDelegate ()

@end

@implementation DCSAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_window makeKeyAndVisible];
    
    UINavigationController *navigationController = UINavigationController.alloc.init;
    DCSStartVC *startVc = [DCSStartVC.alloc initWithNibName:NSStringFromClass(DCSStartVC.class) bundle:nil];
    [navigationController pushViewController:startVc animated:YES];
    _window.rootViewController = navigationController;
    
    // Override point for customization after application launch.
    return YES;
}


@end
