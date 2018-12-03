//
//  AppDelegate.h
//  IosBasic
//
//  Created by Nathan Ou on 15/2/27.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NAWindow.h"
#import "SPMainTabBarController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) NAWindow *window;
@property (retain, nonatomic) SPMainTabBarController *mainTabbarController;
@property (strong, nonatomic) NSString *language;

@property (nonatomic,strong) NSArray *messageArray;
@property (nonatomic,strong) NSArray *territoryArray;
@property (nonatomic,strong) NSArray *categoryArray;

@end

