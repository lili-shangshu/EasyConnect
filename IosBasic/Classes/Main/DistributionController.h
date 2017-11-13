//
//  DistributionController.h
//  IosBasic
//
//  Created by li jun on 16/10/17.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "NARootController.h"

@protocol DistributionControllerDelegate <NSObject>

- (void)distributonSelected:(DistributionModel *)model;

@end


@interface DistributionController : NARootController
@property(strong,nonatomic) DistributionModel * selectedDistributon ;
@property(strong,nonatomic) NSString * selecdName ;
@property(weak,nonatomic)id<DistributionControllerDelegate> delegate;
@end
