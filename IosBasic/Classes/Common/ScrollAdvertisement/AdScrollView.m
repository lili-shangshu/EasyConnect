//
//  AdScrollView.m
//  广告循环滚动效果
//
//  Created by QzydeMac on 14/12/20.
//  Copyright (c) 2014年 Qzy. All rights reserved.
//

#import "AdScrollView.h"
#import "ViewUtils.h"

#define UISCREENWIDTH  self.bounds.size.width//广告的宽度
#define UISCREENHEIGHT  self.bounds.size.height//广告的高度
//#define InsetScale 2.5f/5.f
//#define ScreenInset UISCREENWIDTH*(1-InsetScale)
#define InsetScale 0.2f
#define ScreenInset UISCREENWIDTH*(1-InsetScale)

#define HIGHT self.bounds.origin.y //由于_pageControl是添加进父视图的,所以实际位置要参考,滚动视图的y坐标

static CGFloat const chageImageTime = 4.0;
static NSUInteger currentImage = 0;//记录中间图片的下标,开始总是为1

@interface AdScrollView ()

{
    //广告的label
    UILabel * _adLabel;
    //循环滚动的三个视图
    UIImageView * _leftImageView;
    UIImageView * _centerImageView;
    UIImageView * _rightImageView;
    //循环滚动的周期时间
    //用于确定滚动式由人导致的还是计时器到了,系统帮我们滚动的,YES,则为系统滚动,NO则为客户滚动(ps.在客户端中客户滚动一个广告后,这个广告的计时器要归0并重新计时)
    BOOL _isTimeUp;
    //为每一个图片添加一个广告语(可选)
    UILabel * _leftAdLabel;
    UILabel * _centerAdLabel;
    UILabel * _rightAdLabel;
}

@property (retain,nonatomic,readonly) UIImageView * leftImageView;
@property (retain,nonatomic,readonly) UIImageView * centerImageView;
@property (retain,nonatomic,readonly) UIImageView * rightImageView;

@property (nonatomic, assign) BOOL shoulAnimated;

@end

@implementation AdScrollView

#pragma mark - 自由指定广告所占的frame
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounces = NO;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.contentOffset = CGPointMake(UISCREENWIDTH, 0);
        self.contentSize = CGSizeMake(UISCREENWIDTH * 3, UISCREENHEIGHT);
        self.delegate = self;
        
        
        
        _rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UISCREENWIDTH*2, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        _rightImageView.contentMode = UIViewContentModeScaleToFill;
        _rightImageView.layer.masksToBounds = YES;
        _rightImageView.clipsToBounds = YES;
        [self addSubview:_rightImageView];
        
        _leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        _leftImageView.contentMode = UIViewContentModeScaleToFill;
        _leftImageView.layer.masksToBounds = YES;
        _leftImageView.clipsToBounds = YES;
        [self addSubview:_leftImageView];
        
        _centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UISCREENWIDTH, 0, UISCREENWIDTH, UISCREENHEIGHT)];
        _centerImageView.contentMode = UIViewContentModeScaleToFill;
        _centerImageView.layer.masksToBounds = YES;
        _centerImageView.clipsToBounds = YES;
        [self addSubview:_centerImageView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = _centerImageView.bounds;
        [button addTarget:self action:@selector(centerImageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _centerImageView.userInteractionEnabled = YES;
        [_centerImageView addSubview:button];
        
        _moveTime = [NSTimer scheduledTimerWithTimeInterval:chageImageTime target:self selector:@selector(animalMoveImage) userInfo:nil repeats:YES];
        _isTimeUp = YES;
        self.shoulAnimated = NO;
        
    }
    return self;
}

#pragma mark - 设置广告所使用的图片(名字)
- (void)setImageNameArray:(NSArray *)imageNameArray
{
    _imageNameArray = imageNameArray;
    
    _leftImageView.image = [UIImage imageNamed:_imageNameArray[0]];
    _centerImageView.image = [UIImage imageNamed:_imageNameArray[1]];
    _rightImageView.image = [UIImage imageNamed:_imageNameArray[2]];
}

- (void)setImageUrlArray:(NSArray *)imageUrlArray
{
    _imageUrlArray = imageUrlArray;
    _shoulAnimated = YES;
    
    if (imageUrlArray.count == 0) {
        return;
    }
    
    if (imageUrlArray.count == 1) {
        [_centerImageView setImageWithURL:imageUrlArray[0]];
        _shoulAnimated = NO;
        self.scrollEnabled = NO;
    }else if (imageUrlArray.count == 2) {
        [_leftImageView setImageWithURL:imageUrlArray[1]];
        [_centerImageView setImageWithURL:imageUrlArray[0]];
        [_rightImageView setImageWithURL:imageUrlArray[1]];
        self.scrollEnabled = YES;
    }else{
        [_leftImageView setImageWithURL:imageUrlArray.lastObject];
        [_centerImageView setImageWithURL:imageUrlArray[0]];
        [_rightImageView setImageWithURL:imageUrlArray[1]];
        self.scrollEnabled = YES;
    }
    
    _imageUrlArray = imageUrlArray;
    _shoulAnimated = YES;
}

- (void)dealloc
{
    if (_moveTime) {
        [_moveTime invalidate];
        _moveTime = nil;
    }
}

#pragma mark - 设置每个对应广告对应的广告语
- (void)setAdTitleArray:(NSArray *)adTitleArray withShowStyle:(AdTitleShowStyle)adTitleStyle
{
    _adTitleArray = adTitleArray;
    
    if(adTitleStyle == AdTitleShowStyleNone)
    {
        return;
    }
    
    
    _leftAdLabel = [[UILabel alloc]init];
    _centerAdLabel = [[UILabel alloc]init];
    _rightAdLabel = [[UILabel alloc]init];
    
    
    _leftAdLabel.frame = CGRectMake(10, UISCREENHEIGHT - 40, UISCREENWIDTH, 20);
    [_leftImageView addSubview:_leftAdLabel];
    _centerAdLabel.frame = CGRectMake(10, UISCREENHEIGHT - 40, UISCREENWIDTH, 20);
    [_centerImageView addSubview:_centerAdLabel];
    _rightAdLabel.frame = CGRectMake(10, UISCREENHEIGHT - 40, UISCREENWIDTH, 20);
    [_rightImageView addSubview:_rightAdLabel];
    
    if (adTitleStyle == AdTitleShowStyleLeft) {
        _leftAdLabel.textAlignment = NSTextAlignmentLeft;
        _centerAdLabel.textAlignment = NSTextAlignmentLeft;
        _rightAdLabel.textAlignment = NSTextAlignmentLeft;
    }
    else if (adTitleStyle == AdTitleShowStyleCenter)
    {
        _leftAdLabel.textAlignment = NSTextAlignmentCenter;
        _centerAdLabel.textAlignment = NSTextAlignmentCenter;
        _rightAdLabel.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        _leftAdLabel.textAlignment = NSTextAlignmentRight;
        _centerAdLabel.textAlignment = NSTextAlignmentRight;
        _rightAdLabel.textAlignment = NSTextAlignmentRight;
    }
    
    
    _leftAdLabel.text = _adTitleArray[0];
    _centerAdLabel.text = _adTitleArray[1];
    _rightAdLabel.text = _adTitleArray[2];
    
}

- (void)setImageForImageView
{
    if (self.imageUrlArray) {
        NSInteger leftInt = (currentImage-1);
        NSInteger leftIndex = leftInt%_imageUrlArray.count;
        if (leftInt < 0) {
            leftIndex = _imageUrlArray.count-1;
        }
        [_leftImageView setImageWithURL:_imageUrlArray[leftIndex]];
        [_centerImageView setImageWithURL:_imageUrlArray[currentImage%_imageUrlArray.count]];
        NSInteger rightInt = (currentImage+1);
        NSInteger rightIndex = (rightInt)%_imageUrlArray.count;
        if (rightInt >= _imageUrlArray.count) {
            rightIndex = 0;
        }
        [_rightImageView setImageWithURL:_imageUrlArray[rightIndex]];
    }else{
        _leftImageView.image = [UIImage imageNamed:_imageNameArray[(currentImage-1)%_imageNameArray.count]];
        
        //    _leftAdLabel.text = _adTitleArray[(currentImage-1)%_imageNameArray.count];
        
        _centerImageView.image = [UIImage imageNamed:_imageNameArray[currentImage%_imageNameArray.count]];
        
        //    _centerAdLabel.text = _adTitleArray[currentImage%_imageNameArray.count];
        
        _rightImageView.image = [UIImage imageNamed:_imageNameArray[(currentImage+1)%_imageNameArray.count]];
        
        //    _rightAdLabel.text = _adTitleArray[(currentImage+1)%_imageNameArray.count];
    }

}

- (NSInteger)getImagesCount
{
    if (self.imageUrlArray) {
        return self.imageUrlArray.count;
    }else
        return self.imageNameArray.count;
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Button Action
////////////////////////////////////////////////////////////////////////////////////

- (void)centerImageButtonAction:(id)sender
{
    if (self.imageButtonAction) {
        self.imageButtonAction(currentImage);
    }
}


#pragma mark - 创建pageControl,指定其显示样式
- (void)setPageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle
{
    if (PageControlShowStyle == UIPageControlShowStyleNone) {
        return;
    }
    _pageControl = [[PageControlView alloc] initWithNumberOfPages:[self getImagesCount] height:14 width:14 imageStateNormal:[UIImage imageNamed:@"icon_circle_unselected"] imageStateHighlighted:[UIImage imageNamed:@"icon_circle_selected"]];
    
    if (PageControlShowStyle == UIPageControlShowStyleLeft)
    {
        _pageControl.frame = CGRectMake(10, HIGHT+UISCREENHEIGHT - 20, 20*_pageControl.numberOfPages, 20);
    }
    else if (PageControlShowStyle == UIPageControlShowStyleCenter)
    {
        _pageControl.frame = CGRectMake(0, 0, 20*_pageControl.numberOfPages, 20);
        _pageControl.center = CGPointMake(UISCREENWIDTH/2.0, HIGHT+UISCREENHEIGHT - 10);
    }
    else
    {
        _pageControl.frame = CGRectMake( UISCREENWIDTH - 20*_pageControl.numberOfPages, HIGHT+UISCREENHEIGHT - 20, 20*_pageControl.numberOfPages, 20);
    }
    _pageControl.currentPage = 0;
//    _pageControl.currentPageIndicatorTintColor = [UIColor spBigRedColor];
//
//    _pageControl.pageIndicatorTintColor = [UIColor spDarkYellowColor];
    
    
//    _pageControl.enabled = NO;
    
    [self performSelector:@selector(addPageControl) withObject:nil afterDelay:0.1f];
}
//由于PageControl这个空间必须要添加在滚动视图的父视图上(添加在滚动视图上的话会随着图片滚动,而达不到效果)
- (void)addPageControl
{
    [[self superview] addSubview:_pageControl];
}

#pragma mark - 计时器到时,系统滚动图片
- (void)animalMoveImage
{
    if (self.imageUrlArray.count <= 0 ) {
        return;
    }
    if (!self.shoulAnimated) {
        return;
    }
    [UIView animateWithDuration:0.8f animations:^{
        [self setContentOffset:CGPointMake(UISCREENWIDTH * 2, 0)];
    } completion:^(BOOL finish){
        if (finish) {
            _isTimeUp = YES;
            [self scrollViewDidEndDecelerating:self];
        }
    }];
    //    [self setContentOffset:CGPointMake(UISCREENWIDTH * 2, 0) animated:YES];
    //    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
}

#pragma mark - 图片停止时,调用该函数使得滚动视图复用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.imageUrlArray.count <= 0 ) {
        return;
    }
    
    if (self.contentOffset.x == 0)
    {
        NSInteger leftInt = (currentImage-1);
        if (leftInt < 0) currentImage = [self getImagesCount] - 1;
        else
            currentImage = (currentImage-1)%[self getImagesCount];
        if(_pageControl.currentPage ==0)
            _pageControl.currentPage = [self getImagesCount] - 1;
        else
            _pageControl.currentPage = (_pageControl.currentPage - 1)%[self getImagesCount];

    }
    else if(self.contentOffset.x == UISCREENWIDTH * 2)
    {
        
        currentImage = (currentImage+1)%[self getImagesCount];
        _pageControl.currentPage = (_pageControl.currentPage + 1)%[self getImagesCount];
        //        NSInteger rightInt = (currentImage+1);
        //        NSInteger rightIndex = (rightInt)%_imageUrlArray.count;
        //        if (rightInt >= _imageUrlArray.count) currentImage = 0;
    }
    else
    {
       
        return;
    }
    
  //  NALog(@"------> Current Image Index : %d", currentImage);
    
    [self setImageForImageView];
    
    self.contentOffset = CGPointMake(UISCREENWIDTH, 0);
    
    //手动控制图片滚动应该取消那个三秒的计时器
    if (!_isTimeUp) {
        [_moveTime setFireDate:[NSDate dateWithTimeIntervalSinceNow:chageImageTime]];
    }
    _isTimeUp = NO;
}

//增加滑动广告时，两广告图片之间的遮盖效果
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.imageUrlArray.count <= 0 ) {
        return;
    }
    
    CGFloat contentInsetHorizontal = scrollView.contentOffset.x;
    _rightImageView.left = UISCREENWIDTH+ScreenInset+((contentInsetHorizontal-UISCREENWIDTH)/UISCREENWIDTH)*(InsetScale*UISCREENWIDTH);
    
    CGFloat centerLeft = UISCREENWIDTH+((contentInsetHorizontal-UISCREENWIDTH)/UISCREENWIDTH)*(InsetScale*UISCREENWIDTH);
    if (centerLeft > UISCREENWIDTH) {
        centerLeft = UISCREENWIDTH;
    }
    [self bringSubviewToFront:_leftImageView];
    _centerImageView.left = centerLeft;
}

@end
