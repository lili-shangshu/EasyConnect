//
//  NACTPageViewController.m
//  StraightPin
//
//  Created by Nathan Ou on 15/3/13.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "NACTPageViewController.h"

@interface NACTPageViewController ()

@property (nonatomic, strong) NSArray *assets;

@end

@implementation NACTPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem NA_BarButtonWithtitile:@"删除" titleColor:[UIColor blackColor] target:self action:@selector(deleteButtonAction:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setTitleIndex:(NSInteger)index
{
    NSInteger count = self.assets.count;
    self.title  = [NSString stringWithFormat:@"%ld / %ld", index, count];
}

- (void)deleteButtonAction:(id)sender
{
    if (self.deleteButtonAction) {
        self.deleteButtonAction(self.pageIndex);
    }
    
    if (self.pageIndex == 0 && self.assets.count > 0) {
        self.pageIndex = 0;
    }else if (self.pageIndex > 0) {
        self.pageIndex = self.pageIndex-1;
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
