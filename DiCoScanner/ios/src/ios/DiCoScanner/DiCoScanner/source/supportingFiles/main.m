//
//  main.m
//  DiCoScanner
//
//  Created by Fabian Köbel on 19.03.20.
//  Copyright © 2020 let's dev GmbH & Co. KG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DCSAppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([DCSAppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
