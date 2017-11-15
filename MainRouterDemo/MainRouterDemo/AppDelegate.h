//
//  AppDelegate.h
//  MainRouterDemo
//
//  Created by guanglong on 2017/11/15.
//  Copyright © 2017年 lgl. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RouterMakerConfig.h"

#import "ViewC1.h"
#import "ViewC2.h"


RouterMaker_ConfigPath(vc1, ViewC1)
RouterMaker_ConfigPath(vc2, ViewC2)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

