//
//  SPMainTabBarController.h
//  IosBasic
//
//  Created by Nathan Ou on 15/2/28.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPMainTabBarController : UITabBarController

@property (nonatomic, strong) NSDictionary *currentDataDict;
//@property (nonatomic, strong) SPPost *commentPost;
@property (nonatomic, assign) BOOL shouldShowMessagePoint;

//@property (nonatomic, strong) void(^updateNewCommentsBlock)(NSNumber *commentsNum, SPPost *commentPost);

@end
