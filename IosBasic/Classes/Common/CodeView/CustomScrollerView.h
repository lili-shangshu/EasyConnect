//
//  CustomScrollerView.h
//  scrollerTest
//
//  Created by  liu.jun on 16/3/4.
//  Copyright © 2016年  liu.jun. All rights reserved.
//

/**
 * @author 刘俊, 16-03-05 10:03:33
 *
 * 可以自定义需要滑动的宽度的VIew
 */

#import <UIKit/UIKit.h>

@protocol CustomScrollerViewDataSource;
@protocol CustomScrollerViewDelegate;

@interface CustomScrollerView : UIView

@property (nonatomic,weak)id<CustomScrollerViewDataSource> dataSource;

@property (nonatomic,weak)id<CustomScrollerViewDelegate> delegate;

@property (nonatomic,assign)CGSize itemSize; /**<  cell的宽度*/

@property (nonatomic,assign)CGFloat grapWidth;/**<  间隔宽度*/

@property (nonatomic,assign)BOOL shouldHaveBlankPage;/**<  是否需要一个空白页*/

/**
 * @author 刘俊, 16-03-05 09:03:09
 *
 * 加载数据
 */
- (void)reloadData;

@end


@protocol CustomScrollerViewDataSource <NSObject>

/**
 * @author 刘俊, 16-03-05 09:03:33
 *
 * 第几个View
 *
 * @param scrollerView 当前的view
 * @param index        第几个View
 *
 * @return 返回需要加载的View
 */
- (UIView *)scrollerView:(CustomScrollerView *)scrollerView ItemWithIndex:(NSInteger)index;

/**
 * @author 刘俊, 16-03-05 09:03:22
 *
 * 有几个Item
 *
 * @param scroller 当前的scrollerView
 *
 * @return 返回数量
 */
- (NSInteger)numberOfItemsForScrllerView:(CustomScrollerView *)scroller;

@end


@protocol CustomScrollerViewDelegate <NSObject>

/**
 * @author 刘俊, 16-03-05 11:03:47
 *
 * scroller滑动的参数
 *
 * @param scrollerView scrollerView
 * @param offset       滑动的offset
 * @param index        当前的Index，当需要空白页的时候，index = -1
 */
- (void)scrollerView:(CustomScrollerView *)scrollerView DidScrollerOffset:(CGPoint)offset CurrentIndex:(NSInteger)index;

@end
