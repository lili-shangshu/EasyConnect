//
//  AdressViewController.h
//  IosBasic
//
//  Created by li jun on 16/10/12.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "NARootController.h"


@protocol AdressViewControllerDelegate <NSObject>

- (void)addressSleclcted:(ECAddress *)selectAddress isChina:(BOOL)isChina;

@end


@interface AdressViewController : NARootController

@property (nonatomic,assign) NSString *isChange;  // 1 国内的 2 澳洲的
    
@property (nonatomic) BOOL isFromMine;  // 1 国内的 2 澳洲的
    
@property (nonatomic, strong) NSMutableDictionary *filterDictionary;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger limits;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property(weak,nonatomic)id<AdressViewControllerDelegate>delegate;


@end
