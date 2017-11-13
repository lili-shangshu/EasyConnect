//
//  SPWebController.h
//  IosBasic
//
//  Created by Nathan Ou on 15/3/10.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "NARootController.h"
#import "NAShareManager.h"

@interface SPWebController : NARootController

@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *htmlString;

@property (nonatomic, strong) ShareItem *item;

@property (nonatomic, assign) BOOL hideShareButton;

@end
