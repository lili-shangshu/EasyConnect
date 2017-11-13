//
//  FGNickNameEditorController.h
//  FlyGift
//
//  Created by Nathan Ou on 14/12/31.
//  Copyright (c) 2014年 CRZ. All rights reserved.
//

#import "NARootController.h"

@interface FGNickNameEditorController : NARootController

@property (nonatomic, strong) void(^doneWithString)(NSString *nickName);
@property (nonatomic, strong) void(^completion)(BOOL success);
//@property (nonatomic, assign) BOOL isForPost;

@property (nonatomic, assign) BOOL isEmail;

@end
