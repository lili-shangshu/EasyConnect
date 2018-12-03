//
//  ChatRecordController.m
//  IosBasic
//
//  Created by junshi on 2017/8/3.
//  Copyright © 2017年 CRZ. All rights reserved.
//

#import "ChatController.h"
#import "UIScrollView+RefreshControl.h"

// 评论输入框
#import "SPTextView.h"
#import "NAEmotionsView.h"
#import "TQRichTextView.h"
#import "IQKeyboardManager.h"
#import "AppDelegate.h"

#define textSize 15
#define  cell_height 92
#define  bottomView_height 80

#define kupdateChatNum 30.f

@interface ChatController ()<UITableViewDataSource,UITableViewDelegate, NAEmotionsDelegate, UITextViewDelegate>

@property (nonatomic, strong) NSMutableArray *resultArray;

@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) SPTextView *textView;
@property (nonatomic, strong) UIButton *emotionButton;
@property (nonatomic, strong) UIButton *keyBoardButton;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, assign) BOOL isAnimationEmotionView;

@property (nonatomic, assign) BOOL shouldKeyboardAnimatedWithToolbar;
@property (nonatomic, assign) BOOL shouldEmviewAnimatedWithToolbar;

@property(nonatomic,assign)NSNumber *chatNum;
@property (nonatomic,strong) NSTimer *checkDataTimer;
@property(nonatomic)BOOL isScroller;

@property(nonatomic,strong)NSArray *buttonArray;
@end

@implementation ChatController

- (void)viewDidLoad {
    [super viewDidLoad];

    [NADefaults sharedDefaults].cartNumber = 2;
    self.view.backgroundColor = [UIColor spBackgroundColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, NAScreenWidth, NAScreenHeight-kNavigationHeight-kDefautCellHeight-bottomView_height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    self.limits = 7;
    self.filterDictionary = [NSMutableDictionary dictionaryWithDictionary:@{m_id:self.currentMember.id,m_member_user_shell:self.currentMember.memberShell,@"limits":@(self.limits)}];
    __weak typeof(self) weakSelf = self;
    [self.tableView addBottomRefreshControlUsingBlock:^{
        [weakSelf refreshBottomWith:^{
            [weakSelf.tableView bottomRefreshControlStopRefreshing];
        }];
    } refreshControlPullType:RefreshControlPullTypeInsensitive refreshControlStatusType:RefreshControlStatusTypeTextAndArrow];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView bottomRefreshControlStartInitializeRefreshing];
    });
    self.wifiTestTriger = YES;
    [self addBackButton];
    
    
    [self.view addSubview:self.toolBar];
    
    self.shouldKeyboardAnimatedWithToolbar = YES;
    self.shouldEmviewAnimatedWithToolbar = YES;
    
    self.inNavController = YES;
    
    // 处理了  scollreView不滚动的问题。
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    
    // 只有不接受推送的设置----定时刷新数据
    if ([self.currentMember.isAccept intValue]!=1) {
        self.checkDataTimer = [NSTimer scheduledTimerWithTimeInterval:kupdateChatNum target:self selector:@selector(refreshTableWithUpdate) userInfo:nil repeats:YES];
    }
    
//    self.buttonArray =  @[@"Can i contact you later?",@"Will start soon",@"I am on my way",@"Deliveryed",@"Received"];
//    [self setbottomButtonView];
    
    [self getMessageArray];
}

- (void)getMessageArray{
    AppDelegate *myDele = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (myDele.messageArray.count == 0) {
        [[SPNetworkManager sharedClient] getMessageListWithParams:nil completion:^(BOOL succeeded, id responseObject, NSError *error) {
            if (succeeded) {
                self.buttonArray = responseObject;
                myDele.messageArray = responseObject;
                [self setbottomButtonView];
            }
        }];
    }else{
        self.buttonArray = myDele.messageArray;
        [self setbottomButtonView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [NAEmotionsView shareView].delegate = self;
    
    self.title = @"CHAT";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshTableWithUpdate)
                                                 name:kSisChat
                                               object:nil];
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //    [IQKeyboardManager sharedManager].enable = NO;
    //    [NAEmotionsView shareView].delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.checkDataTimer) {
        [self.checkDataTimer invalidate];
        self.checkDataTimer = nil;
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [NADefaults sharedDefaults].cartNumber = 1;
    [NAEmotionsView shareView].delegate = nil;
    [self backgroundTapAction:nil];

}

-(void)setbottomButtonView{
    
//    10 30 10 30 10
    UIScrollView *bottomView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.tableView.bottom, NAScreenWidth, bottomView_height)];
//    bottomView.backgroundColor = [UIColor blue1];
    [self.view addSubview:bottomView];
    int width = 0;
    int height = 0;
    int number = 0;
    int han = 0;
    float titleOfY = 0;
    for (int n =0; n<self.buttonArray.count; n++) {
        NACommonButton *button = [NACommonButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        CGSize titleSize = [self getSizeByString:self.buttonArray[n] AndFontSize:textSize-2];
        button.buttonTitle = self.buttonArray[n];
        [button setBackgroundImage:[UIImage imageNamed:@"ec_chat_gray"] forState:UIControlStateNormal];
        [button setTitle:self.buttonArray[n] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont defaultTextFontWithSize:textSize-2];
        han = han +titleSize.width;
        if (han > NAScreenWidth) {
            han = 0;
            han = han + titleSize.width;
            height++;
            width = 0;
            width = width+titleSize.width;
            number = 0;
            button.frame = CGRectMake(10, 40*height, titleSize.width, 30);
            if (n==self.buttonArray.count-1) {
                titleOfY = button.y+button.height+5;
            }
        }else{
            button.frame = CGRectMake(width+10+(number*10), 40*height, titleSize.width, 30);
            width = width+titleSize.width;
            han = button.right+10;
            if (n==self.buttonArray.count-1) {
                titleOfY = button.y+button.height+5;
            }
        }
        number++;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = button.height/2;

        [button addTarget:self action:@selector(colorbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:button];
    }
//    NSLog(@"titleOfY===%.1f",titleOfY);
    bottomView.contentSize = CGSizeMake(NAScreenWidth, titleOfY);
}

- (void)colorbuttonClick:(NACommonButton *)button{
   
    // 这个奔溃原因  刚开始的用户不会有，肯定会过界
   NSLog(@"发出信息====%@",button.buttonTitle);
    
//    ChatMessageObject *message2 = [[ChatMessageObject alloc]init];
//    message2.content = button.buttonTitle;
    
    NSDictionary *dict = @{m_id:self.currentMember.id,m_member_user_shell:self.currentMember.memberShell,@"message":button.buttonTitle};
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[SPNetworkManager sharedClient] postSendMessageListWithParams:dict completion:^(BOOL succeeded, id responseObject, NSError *error) {
        if (succeeded) {
            [SVProgressHUD dismiss];
            [self refreshTableWithUpdate];
            [self tableScrollViewToBottom:YES];
            self.textView.text = nil;
        }
    }];
}
- (void)backBarButtonPressed:(id)backBarButtonPressed
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark-----自适应button
//计算文字所占大小
- (CGSize)getSizeByString:(NSString*)string AndFontSize:(CGFloat)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(999, 30) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont defaultTextFontWithSize:font]} context:nil].size;
    size.width += 20;
    if (size.width<50) {
        size.width = 50;
    }
    return size;
}




// tableView停止滚动时调用。
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSLog(@"停止滚动时调用");
    _isScroller = NO;
    [_checkDataTimer setFireDate:[NSDate distantPast]];
    //    [scrollView setContentOffset:CGPointMake(0, 500) animated:YES];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    _isScroller = YES;
//    NSLog(@"开始滚动时调用");
    [_checkDataTimer setFireDate:[NSDate distantFuture]];
}

- (void)checkNewData{
    
    if (_isScroller) {
//        NSLog(@"看时间啊，亲，看时间看时间");
//        NSString *str = [NSString stringWithFormat:@"%@-%@",self.currentMember.id,self.tid];
//        [[SPNetworkManager sharedClient] postMessageNumberWithParams:@{@"id":str} completion:^(BOOL succeeded, id responseObject, NSError *error) {
//            if (succeeded) {
//                NSNumber *selectNum  = responseObject;
//                if (!_chatNum) {
//                    _chatNum = selectNum;
//                }else{
//                    if (![_chatNum isEqualToNumber:selectNum]) {
//                        NSLog(@"更新页面");
//                        [self refreshTableWithUpdate];
//                    }
//                }
//            }
//        }];
        
    }else{
        _isScroller = YES;
    }
    

    
    
    
}

// 未执行，，，没找到原因
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.checkDataTimer) {
        [self.checkDataTimer invalidate];
        self.checkDataTimer = nil;
    }
}

// 评论的输入框
- (UIView *)toolBar
{
    if (!_toolBar) {
        
        CGFloat padding = 7.f;
        
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(-1, self.view.height-kNavigationHeight-kDefautCellHeight, self.view.width+2, kDefautCellHeight)];
        _toolBar.backgroundColor = [UIColor colorWithWhite:0.960 alpha:1.000];
        _toolBar.layer.borderWidth = 0.5f;
        _toolBar.layer.borderColor = [UIColor spLineColor].CGColor;
        _toolBar.userInteractionEnabled = YES;
        
        // emotionButton
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10.f, padding+1.f, _toolBar.height-padding*2.f, _toolBar.height-padding*2.f);
        [button addTarget:self action:@selector(emotionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"emotion"] forState:UIControlStateNormal];
        self.emotionButton = button;
        [_toolBar addSubview:button];
        
        // 键盘按钮-（默认隐藏）
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame = CGRectMake(10.f, padding+1.f, _toolBar.height-padding*2.f, _toolBar.height-padding*2.f);
        [button2 addTarget:self action:@selector(keyboardButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button2 setImage:[UIImage imageNamed:@"keyboard"] forState:UIControlStateNormal];
        button2.hidden = YES;
        self.keyBoardButton = button2;
        [_toolBar addSubview:button2];
        
        //发送按钮
        UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button3 setTitle:@"发送" forState:UIControlStateNormal];
        button3.titleLabel.font = [UIFont defaultTextFontWithSize:16.f];
        [button3 setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [button3 setTitleColor:[UIColor blueIOSColor] forState:UIControlStateNormal];
        [button3 sizeToFit];
        [button3 addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button3.right = _toolBar.width - 10.f;
        button3.top = padding+1.f;
        self.sendButton = button3;
        [_toolBar addSubview:button3];
        
        self.textView.frame = CGRectMake(button.right+10.f, padding, _toolBar.width-10.f*2-button.right-button3.width-10.f, _toolBar.height-padding*2);
        self.textView.delegate = self;
        [_toolBar addSubview:self.textView];
    }
    return _toolBar;
}

// 基本的设置--评论输入框
- (SPTextView *)textView
{
    if (!_textView) {
        _textView = [[SPTextView alloc] init];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.layer.borderColor = [UIColor spLineColor].CGColor;
        _textView.layer.borderWidth = 0.6f;
        _textView.layer.cornerRadius = kNARoundRectRadius;
        _textView.layer.masksToBounds = YES;
        _textView.font = [UIFont defaultTextFontWithSize:15.f];
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.placeholder = @"";
        _textView.enablesReturnKeyAutomatically = YES;
        _textView.scrollsToTop = NO;
    }
    return _textView;
}

- (void)tableScrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Keyborad Notification
////////////////////////////////////////////////////////////////////////////////////

- (void)keyboardWillShow:(NSNotification *)notification {
    
    [[NAEmotionsView shareView] hideBottomBarWithAnimation:YES];
    self.emotionButton.hidden = NO;
    self.keyBoardButton.hidden = YES;
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         if (self.shouldKeyboardAnimatedWithToolbar) {
                             self.toolBar.bottom = self.view.height - keyboardRect.size.height+0.5f;
                             
//                             self.tableView.height = NAScreenHeight-kNavigationHeight - kDefautCellHeight - keyboardRect.size.height+0.5f;
                             
                              self.tableView.height = NAScreenHeight-kNavigationHeight - kDefautCellHeight - keyboardRect.size.height+0.5f-bottomView_height;
                             
                             // tableview 滑动到底部
                             [self tableScrollViewToBottom:YES];
                         }
                     } completion:^(BOOL finish){
                         self.shouldKeyboardAnimatedWithToolbar = YES;
                     }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    if (self.isAnimationEmotionView) return;
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         if (self.shouldKeyboardAnimatedWithToolbar)self.toolBar.top = self.view.height-kDefautCellHeight;
                     } completion:^(BOOL finish){
                         self.shouldKeyboardAnimatedWithToolbar = YES;
                     }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.textView isFirstResponder] || [NAEmotionsView shareView].isShown) {
        [self backgroundTapAction:nil];
    }
}



- (void)textViewDidChange:(UITextView *)textView {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CGSize size = self.textView.contentSize;
        self.sendButton.enabled = ![self.textView.text isEmptyString];
        //        CGSize fitSize = [self.textView sizeThatFits:CGSizeMake(self.textView.width, MAXFLOAT)];
        //        NALog(@"-----> Fit Size : %@", NSStringFromCGSize(fitSize));
        
        size.height -= 2;
        if ( size.height >= 60 ) {
            
            size.height = 60;
        }
        else if ( size.height <= 30 ) {
            
            size.height = 30;
        }
        
        if ( size.height != self.textView.frame.size.height ) {
            
            CGFloat span = size.height - self.textView.frame.size.height;
            
            CGRect frame = self.toolBar.frame;
            frame.origin.y -= span;
            frame.size.height += span;
            self.toolBar.frame = frame;
            
            CGFloat centerY = frame.size.height / 2;
            
            frame = self.textView.frame;
            frame.size = size;
            self.textView.frame = frame;
            
            CGPoint center = self.textView.center;
            center.y = centerY;
            self.textView.center = center;
        }
    });
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    BOOL isPressedBackspaceAfterSingleSpaceSymbol = [text isEqualToString:@""] && range.length == 1;
    if (isPressedBackspaceAfterSingleSpaceSymbol) {
        //  your actions for deleteBackward actions
        
        __block BOOL isAEmotion = NO;;
        __block NSRange emotionRange;
        
        [[NAEmotionsView shareView] isEmotionStringAtLastWithString:textView.text withDetectBlock:^(BOOL isEmotion, NSRange currentRange, NSString *emotionStr){
            if (isEmotion) {
                isAEmotion = isEmotion;
                emotionRange = currentRange;
            }
            
        }];
        
        if (isAEmotion) {
            NSMutableString *mulString = [NSMutableString stringWithString:textView.text];
            [mulString deleteCharactersInRange:emotionRange];
            textView.text = mulString;
            [self textViewDidChange:nil];
            return NO;
        }
        return YES;
    }
    
    
    if([text isEqualToString:@"\n"]) {
        [self sendButtonAction:nil];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
//    if (self.currentCell) {
//        self.currentCell.userInteractionEnabled = YES;
//    }
}
#pragma mark----- 发表评论的请求
- (void)sendButtonAction:(id)sender
{
    
    
    
    if([self.textView.text isEmptyString]){
        [SVProgressHUD showInfoWithStatus:@"不可发送空消息"];
        return;
    }
    
//    ChatMessageObject *message2 = [[ChatMessageObject alloc]init];
//    message2.content = self.textView.text;
//    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
//    message2.sendTime = @(interval);
//    message2.isSelf = @(1);
//    [ self.dataArray addObject:message2];
//    [self.tableView reloadData];
////    [self.tableView removeTopRefreshControl];
////    self.view.top = 64;
////    self.view.height = NAScreenHeight;
//    [self tableScrollViewToBottom:YES];
//    self.textView.text = nil;
    
   
    
    NSDictionary *dict = @{m_id:self.currentMember.id,m_member_user_shell:self.currentMember.memberShell,@"message":self.textView.text,};
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[SPNetworkManager sharedClient] postSendMessageListWithParams:dict completion:^(BOOL succeeded, id responseObject, NSError *error) {
        if (succeeded) {
            [SVProgressHUD dismiss];
            [self refreshTableWithUpdate];
            [self tableScrollViewToBottom:YES];
            self.textView.text = nil;
        }
    }];

}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Button Action
////////////////////////////////////////////////////////////////////////////////////

- (void)backgroundTapAction:(id)sensor
{
    [self.textView resignFirstResponder];
    self.emotionButton.hidden = NO;
    self.keyBoardButton.hidden = YES;
    [[NAEmotionsView shareView] hideBottomBarWithAnimation:YES];
    
    self.tableView.height = NAScreenHeight - kDefautCellHeight-kNavigationHeight-bottomView_height;
    
    [self tableScrollViewToBottom:YES];
}

- (void)emotionButtonAction:(id)sender
{
    self.shouldKeyboardAnimatedWithToolbar = NO;
    [self.textView resignFirstResponder];
    [[NAEmotionsView shareView] showBottomBarWithAnimation:YES completion:^(UIView *bottomBar){
        self.isAnimationEmotionView = NO;
        self.shouldKeyboardAnimatedWithToolbar = YES;
    }];
    self.emotionButton.hidden = YES;
    self.keyBoardButton.hidden = NO;
}

- (void)keyboardButtonAction:(id)sender
{
    self.shouldEmviewAnimatedWithToolbar = NO;
    [self.textView becomeFirstResponder];
    [[NAEmotionsView shareView] hideBottomBarWithAnimation:YES completion:^(UIView *bottomBar){
        self.shouldEmviewAnimatedWithToolbar = YES;
    }];
    self.emotionButton.hidden = NO;
    self.keyBoardButton.hidden = YES;
}


////////////////////////////////////////////////////////////////////////////////////
#pragma mark - EmotionView Delegate
////////////////////////////////////////////////////////////////////////////////////

- (void)emotionViewWillHideWithDruation:(CGFloat)druation
{
    self.isAnimationEmotionView = NO;
    [UIView animateWithDuration:druation
                     animations:^{
                         if (self.shouldEmviewAnimatedWithToolbar) {
                             self.toolBar.top = self.view.height-kDefautCellHeight;
                         
                         }
                     }];
}

- (void)emotionViewWillShowWithHeight:(CGFloat)height animationDruation:(CGFloat)druation
{
    self.isAnimationEmotionView = YES;
    
    [UIView animateWithDuration:druation
                     animations:^{
                         if (self.shouldEmviewAnimatedWithToolbar) {
                             
                             self.toolBar.bottom = self.view.height - height;
                
                             self.tableView.height = NAScreenHeight-kNavigationHeight - kDefautCellHeight - height;
                             // tableview 滑动到底部
                             [self tableScrollViewToBottom:YES];
                         }
                     }];
}

- (void)emotionViewDeleteButtonDidTap:(UIButton *)deleteButton
{
    if ([self.textView.text isEmptyString]) {
        return;
    }
    
    __block BOOL isAEmotion = NO;;
    __block NSRange emotionRange;
    
    [[NAEmotionsView shareView] isEmotionStringAtLastWithString:self.textView.text withDetectBlock:^(BOOL isEmotion, NSRange currentRange, NSString *emotionStr){
        if (isEmotion) {
            isAEmotion = isEmotion;
            emotionRange = currentRange;
        }
        
    }];
    
    if (isAEmotion) {
        NSMutableString *mulString = [NSMutableString stringWithString:self.textView.text];
        [mulString deleteCharactersInRange:emotionRange];
        self.textView.text = mulString;
        [self textViewDidChange:nil];
    }else
    {
        [self.textView deleteBackward];
    }
}

- (void)didAddEmotion:(NSString *)emotion
{
    NSString *string = [NSString stringWithFormat:@"%@%@",self.textView.text,emotion];
    self.textView.text = string;
    [self textViewDidChange:nil];
    NSRange range = NSMakeRange(self.textView.text.length - 1, 1);
    [self.textView scrollRangeToVisible:range];
}




#pragma mark - 泡泡文字的处理

//泡泡文本
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf withPosition:(int)position{
    
    //计算大小
    UIFont *font = [UIFont systemFontOfSize:14];
//    CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(180.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize size = [TQRichTextView sizeWithText:text width:NAScreenWidth - 180 font:font];
    
    // build single chat bubble cell with given text
    UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
    returnView.backgroundColor = [UIColor clearColor];
    
    
    //背影图片
//    UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"ic_chat_right":@"ic_chat_left" ofType:@"png"]];
    
    UIImage *bubble = [[UIImage alloc]init];
    if (fromSelf) {
        bubble = [UIImage imageNamed:@"ec_chat_blue"];
    }else{
        bubble = [UIImage imageNamed:@"ec_chat_gray"];
    }
    
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(bubble.size.height/2)]];
    
    bubbleImageView.layer.masksToBounds = YES;
    bubbleImageView.layer.cornerRadius = 10.f;
    
    
    //箭头图像
//    UIImage *bubble1 = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fromSelf?@"ic_chat_right1":@"ic_chat_left1" ofType:@"png"]];
    
     UIImage *bubble1 = [[UIImage alloc]init];
    if (fromSelf) {
        bubble1 = [UIImage imageNamed:@"ic_chat_right1"];
    }else{
        bubble1 = [UIImage imageNamed:@"ic_chat_left1"];
    }
    
    UIImageView *bubbleImageView1 = [[UIImageView alloc]initWithImage:bubble1];

 
    //添加文本信息
    TQRichTextView *bubbleText = [[TQRichTextView alloc] initWithFrame:CGRectMake(fromSelf?15.0f:22.0f, 20.0f, size.width+10, size.height+10)];
    bubbleText.backgroundColor = [UIColor clearColor];
    bubbleText.font = font;
    bubbleText.text = text;
    
    bubbleText.top = bubbleText.top+5;

    if (fromSelf) {
        // 自己发出的
         bubbleImageView.frame = CGRectMake(0.0f, 15, bubbleText.frame.size.width+24.0f, bubbleText.frame.size.height+10.0f);
         bubbleImageView1.frame = CGRectMake(bubbleImageView.right-0.5f, bubbleImageView.top+bubbleImageView.height/2-5, 15, 15);
        
        bubbleImageView1.bottom = bubbleImageView.bottom;
        bubbleImageView1.right = bubbleImageView.right+2;
        
        
    }else{
        // 他人的
         bubbleImageView.frame = CGRectMake(5.5f, 15, bubbleText.frame.size.width+24.0f, bubbleText.frame.size.height+10.0f);
         bubbleImageView1.frame = CGRectMake(0, 0, 15, 15);

        bubbleImageView1.bottom = bubbleImageView.bottom;
        bubbleImageView1.left = bubbleImageView.left-2;
        
    }

    
    if(fromSelf)
        returnView.frame = CGRectMake(NAScreenWidth-position-(bubbleText.frame.size.width+30.0f), 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
    else
        returnView.frame = CGRectMake(position, 0.0f, bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+30.0f);
    
    [returnView addSubview:bubbleImageView];
    [returnView addSubview:bubbleImageView1];
    [returnView addSubview:bubbleText];
    
    return returnView;
}



#pragma UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatMessageObject *message = _dataArray[indexPath.row];
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size;
    if (!KIsBlankString(message.content)) {
        size =  [TQRichTextView sizeWithText:message.content width:NAScreenWidth - 180 font:font];
    }
    
//    if(indexPath.row>5)
//        return size.height+44;
//    else
    return size.height+54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatMessageObject *message = _dataArray[indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UILabel *timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, NAScreenWidth, 10)];
    timeLbl.text = message.sendTimeStr;
    timeLbl.font = [UIFont systemFontOfSize:10];
    timeLbl.textColor = [UIColor grayColor];
    timeLbl.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:timeLbl];
    
    //创建头像
//    UIView *whitBg = [[UIView alloc]init];
//    whitBg.backgroundColor = [UIColor whiteColor];
//    UIImageView *photo ;
    if ([message.type intValue]==1) {
        // 自己发出的
//        whitBg.frame = CGRectMake(NAScreenWidth-70, 10, 60, 60);
//        whitBg.layer.cornerRadius = whitBg.width/2;
//        photo = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
//        photo.layer.cornerRadius = photo.width/2;
//        photo.layer.masksToBounds = YES;
//        [whitBg addSubview:photo];
//        [cell addSubview:whitBg];
//        [photo setImageWithURL:[NSURL URLWithString:message.avatar]];
        [cell addSubview:[self bubbleView:message.content from:YES withPosition:10]];
        
    }else{
        // 对方发出的
//        whitBg.frame = CGRectMake(10, 10, 60, 60);
//        whitBg.layer.cornerRadius = whitBg.width/2;
//        photo = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
//        photo.layer.masksToBounds = YES;
//        photo.layer.cornerRadius = photo.width/2;
//        [whitBg addSubview:photo];
//        [cell addSubview:whitBg];
//        [photo setImageWithURL:[NSURL URLWithString:message.avatar]];
        [cell addSubview:[self bubbleView:message.content from:NO withPosition:20]];

    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


#pragma mark - Misc
////////////////////////////////////////////////////////////////////////////////////

- (void)reloadingDataAction:(id)sender
{
    [self refreshTableWithUpdate];
    
}

- (void)refreshTableWithUpdate
{
//    [self showLoadingView:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshBottomWith:^{
//            [self showTipsWithCheckingDataArray:self.dataArray];
        }];
    });
}

- (void)addTopRefresh{
    __weak typeof(self) weakSelf = self;
    [self.tableView addTopRefreshControlUsingBlock:^{
        [weakSelf refreshTopWithCompletion:^{
            [weakSelf.tableView topRefreshControlStopRefreshing];
        }];
    }];
}

- (void)addBottomRefresh
{
    __weak typeof(self) weakSelf = self;
    [self.tableView addBottomRefreshControlUsingBlock:^{
        [weakSelf refreshBottomWith:^{
            [weakSelf.tableView bottomRefreshControlStopRefreshing];
        }];
    } ];
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Refresh Delegate
////////////////////////////////////////////////////////////////////////////////////

- (void)refreshTopWithCompletion:(void(^)())completion
{
    [self.filterDictionary setObject:@(self.page) forKey:m_SearchKey_page];
    [[SPNetworkManager sharedClient] getChatListWithParams:self.filterDictionary completion:^(BOOL succeeded, id responseObject ,NSError *error){
        if (succeeded) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (succeeded) {
                    NSMutableArray *array  = responseObject;
                    if ([array count] < self.limits) {
                        [self.tableView removeTopRefreshControl];
                        self.view.top = 64;
                        self.view.height = NAScreenHeight;
                    }else{
                        [self addTopRefresh];
                        self.view.height = NAScreenHeight-kNavigationHeight;
                    }
                    NSMutableArray *data = responseObject;
                    [data addObjectsFromArray:self.dataArray];
                    self.dataArray = data;
                    [self.tableView reloadData];
                }
                if (completion) {
                    completion();
                }

            });
        }else{
            if (completion) {
                completion();
            }
        }
    }];
    
}

- (void)refreshBottomWith:(void(^)())completion
{
    
    [self.filterDictionary setObject:@(1) forKey:m_SearchKey_page];
    [[SPNetworkManager sharedClient] getChatListWithParams:self.filterDictionary completion:^(BOOL succeeded, id responseObject ,NSError *error){
        if (succeeded) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.dataArray = responseObject;
                [self.tableView reloadData];
                NSMutableArray *array  = responseObject;
                if ([array count] < self.limits) {
                    [self.tableView removeTopRefreshControl];
                    self.view.top = 64;
                    self.view.height = NAScreenHeight;
                }else{
                    [self addTopRefresh];
                     self.view.height = NAScreenHeight-kNavigationHeight;

                }
                [self tableScrollViewToBottom:YES];
                if (completion) {
                    completion();
                }
            });
        }else{
            if (completion) {
                completion();
            }
        }
    }];
    
    //    NSMutableArray *dateArray = [NSMutableArray array];
    //    for (int i=0; i<4; i++) {
    //        ChatMessageObject *message1 = [[ChatMessageObject alloc]init];
    //        message1.content = @"氨基酸对方拉简单来说放假啦史蒂芬捡垃圾收到了骄傲了时代峻峰拉聚少离多放假了";
    //        message1.sendTime = @(1509341623);
    //        message1.isSelf = @(1);
    //        [dateArray addObject:message1];
    //
    //        ChatMessageObject *message2 = [[ChatMessageObject alloc]init];
    //        message2.content = @"到了骄傲了时代峻峰拉聚少离多放假了";
    //        message2.sendTime = @(1509341625);
    //        message2.isSelf = @(0);
    //        [dateArray addObject:message2];
    //    }
    
    //    self.dataArray = dateArray;
    //    [self.tableView reloadData];
    ////    [self.tableView removeTopRefreshControl];
    ////    self.view.top = 64;
    ////    self.view.height = NAScreenHeight;
    //    [self tableScrollViewToBottom:YES];
    //    if (completion) {
    //        completion();
    //    }
    //
    
}



- (NSInteger)page
{
    return (self.dataArray.count/self.limits)+1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
