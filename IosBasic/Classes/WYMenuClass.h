//
//  WYMenuClass.h
//  WYMenu
//
//  Created by Admin on 16/9/3.
//  Copyright © 2016年 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define theme_Color RGB(47,165,145)

#define theme_grayColor UIColorFromRGB(0xf2f2f2)

#define TELColor RGB(58, 134, 255)
#define Font(x) [UIFont systemFontOfSize:x]
#define Frame(x,y,w,h) CGRectMake(x, y, w, h)
#define Size(w,h) CGSizeMake(w, h)
#define Point(x,y) CGPointMake(x, y)
#define ZeroRect CGRectZero
#define TouchUpInside UIControlEventTouchUpInside
#define NormalState UIControlStateNormal
#define SelectedState UIControlStateSelected

#define WH(x) (x)*SCREEN_WIDTH/375.0
#define BlackFontColor RGB(34,34,34)
#define WhiteColor RGB(255,255,255)
#define ContentBackGroundColor RGB(238,238,238)





@class WYMenuClass;
@protocol WYMenuClassDelegate <NSObject>
-(void)segmentView:(WYMenuClass *)segmentView didSelectIndex:(NSInteger)index;
@end




@interface WYMenuClass : UIView

/*!@brief 分别为:选中cell的text、cell的index、cell对应的Button。 */
@property (nonatomic) void (^handleSelectDataBlock) (NSString *selectTitle, NSUInteger selectIndex ,NSUInteger selectButtonTag);

@property (nonatomic) UIButton  *tempButton;

/*!@brief 二维数组，存放每个Button对应下的TableView数据。。 */
@property (nonatomic) NSMutableArray *menuDataArray;

- (instancetype)initWithFrame:(CGRect)frame menuTitleArray:(NSArray *)titleArray leftTitleArr:(NSArray*)leftTitleArr selectColor:(UIColor *)selectColor nomolColor:(UIColor *)nomolColor;

/*!@brief 数据源如果改变的话需调用此方法刷新数据。 */
-(void)setDefauldSelectedCell;



@property (nonatomic) id <WYMenuClassDelegate>delegate;
@property (nonatomic) NSArray * titles;
//非选中状态下标签字体颜色
@property (nonatomic, strong) UIColor *titleColor;
//选中标签字体颜色
@property (nonatomic, strong) UIColor *titleSelectedColor;
@property (nonatomic) UIColor * titleBackgroundColor;//标题背景颜色
@property (nonatomic) int selectIndex;
@property (nonatomic) UIFont * titleFont;
@property (nonatomic) UIView * dotView;
@end



@interface downMenuCell : UITableViewCell

@property (nonatomic) UIImageView  *selectImageView;

@property (nonatomic) BOOL  isSelected;

@end




//@interface UIView (Category)
////@property (nonatomic,assign) CGFloat x;
////@property (nonatomic,assign) CGFloat y;
////@property (nonatomic,assign) CGFloat w;
////@property (nonatomic,assign) CGFloat h;
//@end
