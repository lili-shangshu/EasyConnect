//
//  FGDropDownCell.m
//  FlyGift
//
//  Created by Nathan Ou on 15/1/4.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "FGDropDownCell.h"

@implementation FGDropDownCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"xuanzhong"] imageWithColor:[UIColor spBigRedColor]]];
        self.accessoryView = imageView;
    }
    return self;
}

- (void)setSelectedCell:(BOOL)selectedCell
{
    _selectedCell = selectedCell;
    self.accessoryView.hidden = !selectedCell;
}

@end
