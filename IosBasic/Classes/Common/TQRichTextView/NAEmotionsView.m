//
//  NAEmotionsView.m
//  IosBasic
//
//  Created by Nathan Ou on 15/3/24.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "NAEmotionsView.h"

#define kAnimationDuration 0.3f

#define kImageSize CGSizeMake(30, 30)
#define kRowNumber 8
#define kColumNumber 4

@interface NAEmotionsView () <UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat hiddenHeight;

@property (nonatomic, strong) NSArray *buttonsArray;
@property (nonatomic, strong) NSArray *emotionStringArray;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation NAEmotionsView

- (UIView *)keyWindow
{
    return [UIApplication sharedApplication].keyWindow;
}

+ (instancetype)shareView
{
    static NAEmotionsView *shareView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        CGFloat emotionViewHeight = 200.f;
        
        CGSize emotionViewSize = CGSizeMake(NAScreenWidth, emotionViewHeight);
        
        shareView = [[NAEmotionsView alloc] initWithFrame:CGRectMake(0, NAScreenHeight, emotionViewSize.width, emotionViewSize.height)];
        shareView.backgroundColor = [UIColor whiteColor];
        
        CGFloat padding = 20.f;
        CGFloat pageControlHeight = 10.f;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:shareView.bounds];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = shareView;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        
        NSArray *emotionArray = shareView.emotionArray;
        
        NSMutableArray *emotionButtonArray = [NSMutableArray array];
        for (NSString *emotionStr in emotionArray)
        {
            NACommonButton *button = [NACommonButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:emotionStr] forState:UIControlStateNormal];
            button.size = kImageSize;
            button.buttonTitle = emotionStr;
            [button addTarget:shareView action:@selector(emotionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [emotionButtonArray addObject:button];
        }
        
        // 第一次确认多少页，插入删除按钮
        NSInteger numberInPage = kRowNumber * kColumNumber -1; // 一页的表情数;
        
        NSInteger numberOfEmotions = emotionArray.count;
        NSInteger numberOfPage = 1;
        
        while (numberOfEmotions - numberInPage > 0) {
            UIButton *deleteButton = [NAEmotionsView deleteButton];
            [deleteButton addTarget:shareView action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [emotionButtonArray insertObject:deleteButton atIndex:numberInPage*numberOfPage+numberOfPage-1];
            numberOfEmotions = numberOfEmotions - numberInPage;
            numberOfPage ++;
        }
        
        if (numberOfEmotions > 0) {
            UIButton *deleteButton = [NAEmotionsView deleteButton];
            [deleteButton addTarget:shareView action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [emotionButtonArray addObject:deleteButton];
        }
        
        
        NSMutableArray *emotionViewArray = [NSMutableArray array];
        for (int i = 0; i<numberOfPage; i++) {
            UIView *emotionView = [[UIView alloc] initWithFrame:scrollView.bounds];
            emotionView.left = scrollView.width*i;
            [scrollView addSubview:emotionView];
            [emotionViewArray addObject:emotionView];
            if (i == numberOfPage - 1) {
                scrollView.contentSize = CGSizeMake(emotionView.right, scrollView.height);
            }
        }
        
        CGFloat horizontalPadding = (NAScreenWidth - padding*2-kRowNumber*kImageSize.width)/(kRowNumber-1);
        CGFloat verticalPadding = (emotionViewHeight - padding*2-pageControlHeight-kColumNumber*kImageSize.height)/(kColumNumber-1);
        
        for (UIButton *button in emotionButtonArray)
        {
            NSInteger index = [emotionButtonArray indexOfObject:button];
            NSInteger currentPage = (index/(kRowNumber*kColumNumber));
            NSInteger currentRow = ((index-currentPage*(kRowNumber*kColumNumber))/kRowNumber);
            NSInteger currentColumn = ((index-currentPage*(kRowNumber*kColumNumber))%kRowNumber);
            button.top = currentRow*(kImageSize.height+verticalPadding)+padding;
            button.left = currentColumn*(kImageSize.width+horizontalPadding)+padding;
            
            NALog(@"---> CP :%ld, CR : %ld, CC : %ld, Top : %.1f, Left : %.1f   -- H : %.1f, V : %.1f",currentPage, currentRow,currentColumn,button.top,button.left, horizontalPadding, verticalPadding);
            
            UIView *eView = emotionViewArray[currentPage];
            [eView addSubview:button];
        }
        
        UIPageControl *pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(0, shareView.height-pageControlHeight-(padding)/2.f, shareView.width, pageControlHeight)];
        pageController.numberOfPages = numberOfPage;
        pageController.currentPage = 0;
        [shareView addSubview:pageController];
        shareView.pageControl = pageController;
        pageController.pageIndicatorTintColor = [UIColor spBackgroundColor];
        pageController.currentPageIndicatorTintColor = [UIColor lightGrayColor];
        [shareView addSubview:scrollView];
        
        [[UIApplication sharedApplication].keyWindow addSubview:shareView];
        
    });
    return shareView;
}

+ (UIButton *)deleteButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.size = kImageSize;
//    button.layer.borderWidth = 4.f;
//    button.layer.cornerRadius =  button.size.width/2.f;
//    button.backgroundColor = [UIColor lightGrayColor];
    [button setImage:[UIImage imageNamed:@"deleteButton"] forState:UIControlStateNormal];
    
    return button;
}

- (void)deleteButtonAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(emotionViewDeleteButtonDidTap:)]) {
        [self.delegate emotionViewDeleteButtonDidTap:sender];
    }
}

- (NSArray *)emotionArray
{
    if (!_emotionArray) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EmotionsKey" ofType:@"plist"];
        _emotionArray = [NSArray arrayWithContentsOfFile:plistPath];
    }
    return _emotionArray;
}

- (void)emotionButtonAction:(NACommonButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didAddEmotion:)]) {
        [self.delegate didAddEmotion:button.buttonTitle];
    }
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Misc
////////////////////////////////////////////////////////////////////////////////////

- (void)hideBottomBarWithAnimation:(BOOL)animated
{
    [self hideBottomBarWithAnimation:animated completion:nil];
}

- (void)hideBottomBarWithAnimation:(BOOL)animated completion:(FGBottomBarComplitionBlock)block
{
    NALog(@"-------> Hide Bottom Bar. ");
    [self bottomBarAnimaionWithResult:NO animate:animated completion:block];
}

- (void)showBottomBarWithAnimation:(BOOL)animated
{
    [self showBottomBarWithAnimation:animated completion:nil];
}

- (void)showBottomBarWithAnimation:(BOOL)animated completion:(FGBottomBarComplitionBlock)block
{
    NALog(@"-------> Show Bottom Bar. ");
    [self bottomBarAnimaionWithResult:YES animate:animated completion:block];
}

- (void)bottomBarAnimaionWithResult:(BOOL)show animate:(BOOL)animated completion:(FGBottomBarComplitionBlock)block
{
    //    FGBottomTabBar *bottomBar = [FGBottomTabBar sharedBottomBar];
    
//    [self setupBottomView];
    self.hiddenHeight = [self keyWindow].height;
    if (self.isShown == show) return; // To Make sure the bottomBar is not at a status that is the same of animated reslut;
    
    // Get Result Position
    CGFloat postion = self.hiddenHeight;
    if (show) {
        postion = self.hiddenHeight - self.height;
        if ([self.delegate respondsToSelector:@selector(emotionViewWillShowWithHeight:animationDruation:)]) {
            [self.delegate emotionViewWillShowWithHeight:self.height animationDruation:kAnimationDuration];
        }
    }else {
        if ([self.delegate respondsToSelector:@selector(emotionViewWillHideWithDruation:)]) {
            [self.delegate emotionViewWillHideWithDruation:kAnimationDuration];
        }
    }
    
    if (animated) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.top = postion;
        } completion:^(BOOL finish){
            self.isShown = show;
            if (block) block(self);
        }];
    }else
    {
        self.top = postion;
        self.isShown = show;
        if (block) block(self);
    }
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ScrollView Delegate
////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)getCurrentPageWithScrollView:(UIScrollView *)scrollView
{
    return scrollView.contentOffset.x / scrollView.width;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageNumber = [self getCurrentPageWithScrollView:scrollView];
    self.pageControl.currentPage = pageNumber;
}

- (void)isEmotionStringAtLastWithString:(NSString *)string withDetectBlock:(void(^)(BOOL isEmotion, NSRange currentRange, NSString *emotionStr))block
{
    NSInteger currentStringIndex = string.length-1;
    NSString *lastString = [string substringFromIndex:currentStringIndex];
    
    NSString *emotionStr;
    NSRange emotionRange;
    BOOL isEmotion = NO;
    
    if ([lastString isEqualToString:@"]"]) {
        for (int i = (int)currentStringIndex-1; i >= 0; i--)
        {
            NSString *currentStr = [string substringWithRange:NSMakeRange(i, 1)];
            if ([currentStr isEqualToString:@"["]) {
                emotionRange = NSMakeRange(i, string.length-i);
                emotionStr = [string substringWithRange:emotionRange];
                if ([[NAEmotionsView shareView].emotionArray containsObject:emotionStr]) {
                    isEmotion = YES;
                    break;
                }
            }
        }
    }
    
    if (block) {
        block(isEmotion, emotionRange,emotionStr);
    }
}

@end
