//
//  NACTPageViewController.h
//  StraightPin
//
//  Created by Nathan Ou on 15/3/13.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "CTAssetsPageViewController.h"

@interface NACTPageViewController : CTAssetsPageViewController

@property (nonatomic, strong) void(^deleteButtonAction)(NSInteger index);

@end
