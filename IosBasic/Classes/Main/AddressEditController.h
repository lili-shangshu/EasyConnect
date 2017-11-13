//
//  AddressEditController.h
//  IosBasic
//
//  Created by li jun on 17/4/22.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "NARootController.h"

@interface AddressEditController : NARootController


@property(nonatomic,assign)BOOL isEdit;
@property(strong,nonatomic) ECAddress * editAddress ;

@property(nonatomic)BOOL isChina;

@property (nonatomic, strong) void(^addNewAddressResultBlock)(BOOL isChina);

@end
