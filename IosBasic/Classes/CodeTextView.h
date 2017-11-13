//
//  CodeView.h
//  testLable
//
//  Created by Star on 2017/6/22.
//  Copyright © 2017年 Star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeTextView : UIView

@property (nonatomic, retain) NSArray *changeArray;
@property (nonatomic, retain) NSMutableString *changeString;
@property (nonatomic, retain) UILabel *codeLabel;

-(void)changeCode;
@end
