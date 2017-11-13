//
//  HelpDetailController.h
//  IosBasic
//
//  Created by li jun on 16/12/27.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "NARootController.h"

@interface HelpDetailController : NARootController

@property (nonatomic,strong) NSString *selectId;

@property (nonatomic,strong) NSString *titleStr;
@property (nonatomic,strong) NSString *subtitle;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *contentHtml;

@end
