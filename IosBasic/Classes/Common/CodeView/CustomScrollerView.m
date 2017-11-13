//
//  CustomScrollerView.m
//  scrollerTest
//
//  Created by  liu.jun on 16/3/4.
//  Copyright © 2016年  liu.jun. All rights reserved.
//

#import "CustomScrollerView.h"



@interface CustomScrollerView ()<UIScrollViewDelegate> {
    NSInteger _itemCount; /**<  Item的个数*/
}

@property (nonatomic,strong)UIScrollView *scrollerView;

@property (nonatomic,assign)NSInteger currentIndex;

@end

@implementation CustomScrollerView


- (void)reloadData {
    
    /**
     * @author 刘俊, 16-03-05 09:03:08
     *
     * 获取Item的个数
     */
    _itemCount = [self.dataSource numberOfItemsForScrllerView:self];
    
    [self creatFirstUI];
    
}

- (void)creatFirstUI {
    
    CGFloat totoTalWidth = self.itemSize.width + self.grapWidth;
    CGFloat leftX = ( self.bounds.size.width - self.itemSize.width) * 0.5 ;
    CGFloat topY = ( self.bounds.size.height - self.itemSize.height ) * 0.5;
    
    self.scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(leftX, topY, totoTalWidth, self.itemSize.height)];
    self.scrollerView.clipsToBounds = NO;
    self.scrollerView.pagingEnabled = YES;
//    self.scrollerView.layer.borderWidth = 2.f;
//    self.scrollerView.layer.borderColor = [UIColor blackColor].CGColor;
    self.scrollerView.delegate = self;

    NSInteger count;
    if (self.shouldHaveBlankPage) {
        _itemCount++;
    }
    if (_itemCount > 5) {
        count = 5;
    }else {
        count = _itemCount;
    }
    
    for (int i = 0; i < count; i++) {
        UIView *view;
        if (self.shouldHaveBlankPage) {
            if (i == 0) {
                view = [UIView new];
            }else {
                view = [self.dataSource scrollerView:self ItemWithIndex:i - 1];
            }
        }else {
          view = [self.dataSource scrollerView:self ItemWithIndex:i];
        }
        view.frame = CGRectMake(i * totoTalWidth, 0, self.itemSize.width, self.itemSize.height);
        [self.scrollerView addSubview:view];
    }
    [self.scrollerView setContentSize:CGSizeMake(count * totoTalWidth, self.itemSize.height)];
    [self addSubview:self.scrollerView];
}

/**
 * @author 刘俊, 16-03-05 11:03:21
 *
 * 主要的逻辑判断区
 *
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x;
    if (_itemCount > 5) {
        if (self.currentIndex < 2) { // 0 | 1
            self.currentIndex = offsetX / scrollView.bounds.size.width;
        }else if (self.currentIndex > _itemCount - 3) {
            
            NSInteger index = offsetX / scrollView.bounds.size.width;
            if (index == 2) {
                self.currentIndex = _itemCount - 3;
                [self updateContent];
            }else if (index == 3){
                self.currentIndex = _itemCount - 2;
            }
            else if (index == 4){
                self.currentIndex = _itemCount - 1;
            }
        
        }else { //那么就是说currentIndex 在中间
            if (offsetX <= scrollView.bounds.size.width ) {
                self.currentIndex--;
                if (self.currentIndex > 1) {
                    [self updateContent];
                }
            }else if (offsetX >= 3 * scrollView.bounds.size.width){
                self.currentIndex++;
                if (self.currentIndex < _itemCount - 2) {
                    [self updateContent];
                }
            }
        }
    }else {
        self.currentIndex = offsetX / scrollView.bounds.size.width;
    }
    //如果需要有空白页
    if (self.shouldHaveBlankPage) {
        if ([self.delegate respondsToSelector:@selector(scrollerView:DidScrollerOffset:CurrentIndex:)]) {
            [self.delegate scrollerView:self DidScrollerOffset:scrollView.contentOffset CurrentIndex:self.currentIndex-1];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(scrollerView:DidScrollerOffset:CurrentIndex:)]) {
            [self.delegate scrollerView:self DidScrollerOffset:scrollView.contentOffset CurrentIndex:self.currentIndex];
        }
    }
}

//更新界面
- (void)updateContent {
    
    CGFloat totoTalWidth = self.itemSize.width + self.grapWidth;
    [self.scrollerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger index = -2;
    
    for (int i = 0; i < 5; i++) {
        UIView *view;
        if (self.shouldHaveBlankPage) {
            if (self.currentIndex + index + i - 1 < 0) {
                view = [UIView new];
            }else {
                view = [self.dataSource scrollerView:self ItemWithIndex:self.currentIndex + index + i - 1];
            }
        }else {
            view = [self.dataSource scrollerView:self ItemWithIndex:self.currentIndex + index + i];
        }
        view.frame = CGRectMake(i * totoTalWidth, 0, self.itemSize.width, self.itemSize.height);
        [self.scrollerView addSubview:view];
    }
    [self.scrollerView setContentOffset:CGPointMake(2 * totoTalWidth, 0)];
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return self.scrollerView;
}

@end
