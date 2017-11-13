//
//  UIView+NATools.m
//  MyCollections
//
//  Created by Nathan on 14-11-9.
//  Copyright (c) 2014年 Nathan. All rights reserved.
//

#import "UIView+NATools.h"
#import "NATools+Headers.h"

@implementation UIView (NATools)

+ (instancetype)NA_ItemsViewWithPadding:(CGFloat)padding Views:(UIView *)firstView, ...
{
    va_list args;
    va_start(args, firstView);
    
    UIView *itemView = [[UIView alloc] init];
    
    CGFloat Xpoint = 0;
    
    NSMutableArray *viewsArray = [NSMutableArray array];
    
    for (UIView *view = firstView; view != nil; view = va_arg(args, UIView*)) {
        [viewsArray addObject:view];
    }
    
    CGFloat maxHeight = [[viewsArray valueForKeyPath:@"@max.height"] floatValue];
    
    itemView.height = maxHeight;
    
    for (UIView *view in viewsArray)
    {
        NSInteger index = [viewsArray indexOfObject:view];
        
        view.left = Xpoint + index==0?padding:0;
        
        Xpoint = padding + view.width + Xpoint;
        
        // 纵向居中
        [view centerAlignVerticalForView:itemView];
        
        [itemView addSubview:view];
    }
    
    va_end(args);
    
    return itemView;

}

- (void)hideExtraCellHide
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    ((UITableView *)self).tableFooterView = view;
}

- (void)addCornerRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
    self.clipsToBounds = YES;
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Draw Line
////////////////////////////////////////////////////////////////////////////////////

+ (UIImageView *)lineWithHeight:(CGFloat)height xPoint:(CGFloat)xPoint withColor:(UIColor *)color
{
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(xPoint, 0, 0.5f, height)];
    
    UIGraphicsBeginImageContext(imageView1.frame.size);
    [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    
    CGContextRef line = UIGraphicsGetCurrentContext();
    UIColor *lineColor = [UIColor lightGrayColor];
    if (color) lineColor = color;
    CGContextSetStrokeColorWithColor(line, lineColor.CGColor);
    
    CGContextSetLineWidth(line, 1);
    CGContextMoveToPoint(line, 0.5, 0.0);
    CGContextAddLineToPoint(line, 0.5, imageView1.height);
    CGContextStrokePath(line);
    
    imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
    
    return imageView1;
}

+ (UIImageView *)lineViewWithWidth:(CGFloat)width yPoint:(CGFloat)yPoint withColor:(UIColor *)color
{
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, yPoint, width, 0.5f)];
    
    UIGraphicsBeginImageContext(imageView1.frame.size);
    [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    
    CGContextRef line = UIGraphicsGetCurrentContext();
    UIColor *lineColor = [UIColor lightGrayColor];
    if (color) lineColor = color;
    CGContextSetStrokeColorWithColor(line, lineColor.CGColor);
    
    CGContextSetLineWidth(line, 1);
    CGContextMoveToPoint(line, 0.0, 0.5);
    CGContextAddLineToPoint(line, imageView1.width, 0.5);
    CGContextStrokePath(line);
    
    imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
    
    return imageView1;
}

+ (UIImageView *)lineDashTypeWithWidth:(CGFloat)width yPoint:(CGFloat)yPoint withColor:(UIColor *)color
{
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, yPoint, width, 0.5f)];
    
    UIGraphicsBeginImageContext(imageView1.frame.size);
    [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    
    
    CGFloat lengths[] = {3,1};
    CGContextRef line = UIGraphicsGetCurrentContext();
    UIColor *lineColor = [UIColor lightGrayColor];
    if (color) lineColor = color;
    CGContextSetStrokeColorWithColor(line, lineColor.CGColor);
    
    CGContextSetLineWidth(line, 1);
    CGContextSetLineDash(line, 0, lengths, 1);
    CGContextMoveToPoint(line, 0.0, 0.4);
    CGContextAddLineToPoint(line, imageView1.width, 0.4);
    CGContextStrokePath(line);
    
    imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
    
    return imageView1;
}

+ (UIImageView *)dashlineWithHeight:(CGFloat)height xPoint:(CGFloat)xPoint withColor:(UIColor *)color
{
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(xPoint, 0, 1.f, height)];
    
    UIGraphicsBeginImageContext(imageView1.frame.size);
    [imageView1.image drawInRect:CGRectMake(0, 0, imageView1.frame.size.width, imageView1.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    
    
    CGFloat lengths[] = {8,4};
    CGContextRef line = UIGraphicsGetCurrentContext();
    UIColor *lineColor = [UIColor lightGrayColor];
    if (color) lineColor = color;
    CGContextSetStrokeColorWithColor(line, lineColor.CGColor);
    
    CGContextSetLineWidth(line, 1);
    CGContextSetLineDash(line, 0, lengths, 1);
    CGContextMoveToPoint(line, 0.5, 0.0);
    CGContextAddLineToPoint(line, 0.5, imageView1.height);
    CGContextStrokePath(line);
    
    imageView1.image = UIGraphicsGetImageFromCurrentImageContext();
    
    return imageView1;
}

+ (UIView *)shadowLineViewWidth:(CGFloat)width yPoint:(CGFloat)yPoint
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, yPoint, width, 1.f)];
    view.backgroundColor = [UIColor lightGrayColor];
    
    return view;
}

- (void)tableviewSetZeroInsets
{
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [(UITableView *)self setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)cellSetZeroInsets
{
    ((UITableViewCell *)self).separatorInset = UIEdgeInsetsZero;
    
    if ([(UITableViewCell *)self respondsToSelector:@selector(setLayoutMargins:)]) {
        [(UITableViewCell *)self setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
