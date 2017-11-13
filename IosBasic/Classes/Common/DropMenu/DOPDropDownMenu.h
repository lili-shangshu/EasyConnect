//
//  DOPDropDownMenu.h
//  DOPDropDownMenuDemo
//
//  Created by Nathan on 9/26/14.
//  Copyright (c) 2014 Nathan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DOPIndexPath : NSObject

@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger row;

- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row;
+ (instancetype)indexPathWithCol:(NSInteger)col row:(NSInteger)row;

@end

#pragma mark - data source protocol
@class DOPDropDownMenu;

@protocol DOPDropDownMenuDataSource <NSObject>

@required
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column tableView:(NSInteger)tableViewNum selectedColumn:(NSInteger)selectedColumn;
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath tableView:(NSInteger)tableViewNum selectedColumn:(NSInteger)selectedColumn;
- (NSString *)menu:(DOPDropDownMenu *)menu detaultTiteInColumn:(NSInteger)column;
- (NSString *)menu:(DOPDropDownMenu *)menu categoryTitleAtIndex:(DOPIndexPath *)indexPath selectedColumn:(NSInteger)selectedColumn;;

@optional
//default value is 1
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu;
- (BOOL)needSecondTableForMenu:(DOPDropDownMenu *)menu inColumn:(NSInteger)column;

@end

#pragma mark - delegate
@protocol DOPDropDownMenuDelegate <NSObject>
@optional
- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath forTableView:(NSInteger)tableViewNum selectedColumn:(NSInteger)selectedColumn;
@end

#pragma mark - interface
@interface DOPDropDownMenu : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <DOPDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id <DOPDropDownMenuDelegate> delegate;

@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *separatorColor;
@property (nonatomic, assign) NSInteger selectedColumn;
@property (nonatomic, assign) BOOL shouldSelectedTitle; // 判断是否直接选择第一个Table的title用的
@property (nonatomic, assign) NSInteger lastSelectedMenuIndexInTableOne;

@property (nonatomic, assign) BOOL show;

- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender;
/**
 *  the width of menu will be set to screen width defaultly
 *
 *  @param origin the origin of this view's frame
 *  @param height menu's height
 *
 *  @return menu
 */
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height andDataSource:(id) dataSource;
//- (NSString *)titleForRowAtIndexPath:(DOPIndexPath *)indexPath;

@end
