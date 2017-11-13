//
//  DropDownMenu.m
//  IosBasic
//
//  Created by junshi on 16/1/26.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "DropDownMenu.h"
#import "CommonDefine.h"

@implementation DropDownMenu

- (id)initDropdownWithButtonTitles:(NSArray*)titles andLeftListArray:(NSArray*)leftArray andRightListArray:(NSArray *)rightArray {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        _button = [[DropDownButton alloc] initDropDownButtonWithTitles:titles];
        _button.delegate = self;
        _tableView = [[ConditionDoubleTableView alloc] initWithFrame:self.bounds andLeftItems:leftArray andRightItems:rightArray];
        _tableView.delegate = self;
        _leftArray = leftArray;
        _rightArray = rightArray;
        
        [self addSubview:_tableView];
        [self addSubview:_button];
        [self initSelectedArray:titles];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reduceBackgroundSize) name:@"hideMenu" object:nil];
        
        _titleArray = titles;
        
      
    }
    return self;
}

- (void)initSelectedArray:(NSArray *)titles {
    _buttonIndexArray = [[NSMutableArray alloc] initWithCapacity:titles.count];
}

//button点击代理
- (void)showMenu:(UIButton *)selectedButton {
    NSInteger index = [selectedButton tag];
    _lastIndex = index;
    [self setFrame:SCREEN_RECT];
    _buttonSelectedIndex = index - 10000;
    NSString *selected = @"0-0";
    if(_buttonIndexArray.count==0){
        for (int i=0; i<_titleArray.count;i++) {
            [_buttonIndexArray addObject:selected];
        }
    }
    
    
//    if (_buttonIndexArray.count > _buttonSelectedIndex){
//        selected = [_buttonIndexArray objectAtIndex:_buttonSelectedIndex];
//    } else {
//        [_buttonIndexArray addObject:selected];
//    }
   
    selected = [_buttonIndexArray objectAtIndex:_buttonSelectedIndex];
    NSArray *selectedArray = [selected componentsSeparatedByString:@"-"];
    NSString *left = [selectedArray objectAtIndex:0];
    NSString *right = [selectedArray objectAtIndex:1];
    [_tableView showTableView:_buttonSelectedIndex WithSelectedLeft:left Right:right];
    _selectedButton = selectedButton;
}


- (void)reduceBackgroundSize {
    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, BUTTON_HEIGHT)];
}

#pragma  ConditionDoubleTableViewDelegate delegate method
- (void)selectedFirstValue:(NSString *)first SecondValue:(NSString *)second{
    NSString *index = [NSString stringWithFormat:@"%@-%@", first, second];
    
    [_buttonIndexArray setObject:index atIndexedSubscript:_buttonSelectedIndex];
    
    NSInteger selectedIndex = [_selectedButton tag] -10000;
    
    NSArray *array = [[NSArray alloc] initWithArray:[_rightArray objectAtIndex:selectedIndex]];
    NSArray *rArray = [[NSArray alloc] initWithArray:[array objectAtIndex:[first intValue]]];
  
    [_selectedButton setTitle:rArray[[second intValue]] forState:UIControlStateNormal];
    
    NSInteger buttonSelectedIndex = [_selectedButton tag] - 10000;
    [self dropdownSelectedFirstIndex:first SelectedSecondIndex:second SelectedButtonIndex:[NSString stringWithFormat:@"%d",buttonSelectedIndex]];
    
}
#pragma  ConditionDoubleTableViewDelegate delegate method
- (void)hideMenu {
    [_tableView hideTableView];
}


#pragma dropdownDelegate  delegate method
- (void)dropdownSelectedFirstIndex:(NSString *)firstIndex SelectedSecondIndex:(NSString *) secondIndex SelectedButtonIndex:(NSString *)buttonIndex;
{
    if (_delegate && [_delegate respondsToSelector:@selector(dropdownSelectedSecondIndex:SelectedButtonIndex:)]) {
        [_delegate performSelector:@selector(dropdownSelectedSecondIndex:SelectedButtonIndex:) withObject:secondIndex withObject:buttonIndex];
    }
}

@end

