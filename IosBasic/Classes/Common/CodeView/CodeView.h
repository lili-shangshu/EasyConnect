//
//  CodeView.h
//  BaseProject
//
//  Created by my on 16/3/24.
//  Copyright © 2016年 base. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,CodeViewType) {
    CodeViewTypeCustom,//普通样式
    CodeViewTypeSecret//密码风格
};

@interface CodeView : UIView

@property (nonatomic,strong) NSMutableArray *textArray;

//输入完成回调
@property (nonatomic, copy) void(^EndEditBlcok)(NSString *text);

//样式
@property (nonatomic, assign) CodeViewType codeType;

//是否需要分隔符
@property (nonatomic, assign) BOOL hasSpaceLine;
//是否有下标线
@property (nonatomic, assign) BOOL hasUnderLine;

//是否需要输入之后清空，再次输入使用,默认为NO
@property (nonatomic, assign) BOOL emptyEditEnd;

- (instancetype)initWithFrame:(CGRect)frame
                          num:(NSInteger)num
                    lineColor:(UIColor *)lColor
                    textColor:(UIColor *)tColor
                    lineAnimationColor:(UIColor *)lAColor
                     textFont:(UIFont *)font;

- (void)addUnderLine:(UIColor *)color;

- (void)beginEdit;
- (void)endEdit;

@end