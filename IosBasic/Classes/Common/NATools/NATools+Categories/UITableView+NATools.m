//
//  UITableView+NATools.m
//  MyCollections
//
//  Created by Nathan on 14-11-3.
//  Copyright (c) 2014年 Nathan. All rights reserved.
//

#import "UITableView+NATools.h"

@implementation UITableView (NATools)

- (void)NA_HideExtraCellHide
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableFooterView = view;
}

@end
