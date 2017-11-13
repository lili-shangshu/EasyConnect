//
//  SPCommbox.h
//  SPGooglePlacesAutocomplete
//
//  Created by junshi on 16/3/25.
//  Copyright © 2016年 Stephen Poletto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPCommbox : UIView<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tv;//下拉列表
    NSMutableArray *tableArray;//下拉列表数据
  //  UITextField *textField;//文本输入框
    UITextView *textView;//文本输入框
    BOOL showList;//是否弹出下拉列表
    CGFloat tabheight;//table下拉列表的高度
    CGFloat frameHeight;//frame的高度
}

@property (nonatomic,retain) UITableView *tv;
@property (nonatomic,retain) NSArray *tableArray;
//@property (nonatomic,retain) UITextView *textView;
@property (nonatomic,retain) UITextView *textView;
-(void)dropdown;
- (void)hideList;

@end
