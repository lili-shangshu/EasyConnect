//
//  SPCommbox.m
//  SPGooglePlacesAutocomplete
//
//  Created by junshi on 16/3/25.
//  Copyright © 2016年 Stephen Poletto. All rights reserved.
//



#import "SPCommbox.h"

@implementation SPCommbox
@synthesize tv,tableArray,textView;

- (id)initWithFrame:(CGRect)frame
{
    CGFloat height = frame.size.height;
    
    if (frame.size.height<180) {
        frameHeight = 180;
    }else{
        frameHeight = frame.size.height;
    }
    tabheight = frameHeight-height;
    
    frame.size.height = height;
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //textField.delegate = self;
    }
    
    if(self){
        showList = NO; //默认不显示下拉框
        
        tv = [[UITableView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width , 0)];
        tv.delegate = self;
        tv.dataSource = self;
        tv.backgroundColor = [UIColor whiteColor];
        tv.separatorColor = [UIColor lightGrayColor];
        tv.hidden = YES;
        [self addSubview:tv];
        
//        textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        textField.font = [UIFont systemFontOfSize:8.0f];
//        textField.tag = 1000;
//        //textField.userInteractionEnabled = NO;
//      //  textField.borderStyle=UITextBorderStyleRoundedRect;//设置文本框的边框风格
//       // [textField addTarget:self action:@selector(dropdown) forControlEvents:UIControlEventAllTouchEvents];
//        [self addSubview:textField];
        
        textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        textView.font = [UIFont systemFontOfSize:10.0f];
        textView.tag = 1000;
        [self addSubview:textView];
    }
    return self;
}


-(void)dropdown{

    if (showList) {//如果下拉框已显示，什么都不做
        return;
    }else {//如果下拉框尚未显示，则进行显示
        
        CGRect sf = self.frame;
        sf.size.height = frameHeight;
        
        //把dropdownList放到前面，防止下拉框被别的控件遮住
        [self.superview bringSubviewToFront:self];
        tv.hidden = NO;
        showList = YES;//显示下拉框
        
        CGRect frame = tv.frame;
        frame.size.height = 0;
        tv.frame = frame;
        frame.size.height = tabheight;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.frame = sf;
        tv.frame = frame;
        [UIView commitAnimations];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    cell.textLabel.text = [tableArray objectAtIndex:[indexPath row]];
    cell.textLabel.font = [UIFont systemFontOfSize:9.0f];
    cell.accessoryType  = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 //   textField.text = [tableArray objectAtIndex:[indexPath row]];
    textView.text= [tableArray objectAtIndex:[indexPath row]];

    [self hideList];
}

- (void)hideList{

    showList = NO;
    tv.hidden = YES;
    
    CGRect sf = self.frame;
 //   sf.size.height = textField.height;
    sf.size.height = textView.height;
    self.frame = sf;
    CGRect frame = tv.frame;
    frame.size.height = 0;
    tv.frame = frame;

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end