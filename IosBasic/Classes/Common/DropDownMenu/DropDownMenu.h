//
//  DropDownMenu.h
//  IosBasic
//
//  Created by junshi on 16/1/26.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropDownButton.h"
#import "ConditionDoubleTableView.h"

@protocol dropdownDelegate <NSObject>

@optional
- (void)dropdownSelectedSecondIndex:(NSString *) secondIndex SelectedButtonIndex:(NSString *)buttonIndex;

@end

@interface DropDownMenu : UIView<showMenuDelegate, ConditionDoubleTableViewDelegate> {
    DropDownButton *_button;
    ConditionDoubleTableView *_tableView;
    NSInteger _lastIndex;
    
    NSInteger _buttonSelectedIndex;
    NSMutableArray *_buttonIndexArray;
    
    NSArray *_titleArray;
    NSArray *_leftArray;
    NSArray *_rightArray;
}

@property (assign, nonatomic) id<dropdownDelegate>delegate;
@property (nonatomic,strong) UIButton *selectedButton;

- (id)initDropdownWithButtonTitles:(NSArray*)titles andLeftListArray:(NSArray*)leftArray andRightListArray:(NSArray *)rightArray;

@end
