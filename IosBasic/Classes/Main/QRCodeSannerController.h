//
//  QRCodeSannerController.h
//  IosBasic
//
//  Created by junshi on 16/8/23.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "NARootController.h"


@interface QRCodeSannerController : NARootController

@property (nonatomic, strong) void(^getResultBlock)(NSString *qrCode);

@end
