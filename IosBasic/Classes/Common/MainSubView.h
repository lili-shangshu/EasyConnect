//
//  MainSubView.h
//  IosBasic
//
//  Created by li jun on 16/11/24.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MainSubViewDelegate <NSObject>

- (void)clickedGoodsImage:(NSInteger )goodsId;

@end

@interface MainSubView : UIView
@property(weak,nonatomic)id<MainSubViewDelegate> delegate;
@property(strong,nonatomic) NSArray * goodsArray ;
// 传入的arrayy一定是产品的array,是一类的
- (void)updataViewWithArray:(NSArray *)array;
-(id)initHotWithFrame:(CGRect)frame ;
-(id)initNewWithFrame:(CGRect)frame ;
-(id)initOtherWithFrame:(CGRect)frame ;
@end
