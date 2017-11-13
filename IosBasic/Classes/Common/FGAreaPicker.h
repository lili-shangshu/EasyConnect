//
//  FGAreaPicker.h
//  FlyGift
//
//  Created by Nathan Ou on 15/1/18.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    AreaStyleShowProvinceCityCounty  = 0,
    AreaStyleShowProvinceCity,
    AreaStyleShowProvince
    
}AreaStyle;

@protocol FGAreaPickerDelegate <NSObject>

- (void)pickerViewDidGetProvince:(NSString *)province city:(NSString *)city area:(NSString *)area;

@end

@interface FGAreaPicker : UIView

@property (nonatomic, strong) id <FGAreaPickerDelegate> p_Deleate;

@property (nonatomic, assign) BOOL isShown;

@property (nonatomic,assign)AreaStyle dateType;
    
@property (nonatomic, assign) BOOL isChina;

@property (nonatomic, strong) void(^selectResultBlock)(NSString *province,NSString *city,NSString *county);

- (void)show;
- (void)showWithCompletion:(void(^)())block;
- (void)hide;
- (void)hideWithCompletion:(void(^)())block;

@end
