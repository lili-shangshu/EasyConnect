//
//  WYMenuClass.m
//  WYMenu
//
//  Created by Admin on 16/9/3.
//  Copyright © 2016年 Admin. All rights reserved.
//

#import "WYMenuClass.h"
#define BTag 10000
#import <objc/runtime.h>

#define Kscreen_width  [UIScreen mainScreen].bounds.size.width
#define Kscreen_height [UIScreen mainScreen].bounds.size.height
#define KTitleButtonHeight 40

// 格式 0xff3737
#define RGBHexAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#define KDefaultColor RGBHexAlpha(0x189cfb, 1)

#define KmaskBackGroundViewColor  [UIColor colorWithRed:40/255 green:40/255 blue:40/255 alpha:.2]
#define kCellBgColor [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:.7]

#define KTableViewCell @"downMenuCell"

#define KTableViewCellHeight 44

#define KDisplayMaxCellOfNumber  5

#define KTitleButtonTag 1000


#define KOBJCSetObject(object,value)  objc_setAssociatedObject(object,@"title" , value, OBJC_ASSOCIATION_RETAIN_NONATOMIC)

#define KOBJCGetObject(object) objc_getAssociatedObject(object, @"title")

@interface WYMenuClass () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) NSArray *titleArray ;


@property (nonatomic)UITableView *tableView;
@property (nonatomic)NSMutableArray *tableDataArray;

@property (nonatomic) CGFloat selfOriginalHeight ;
@property (nonatomic) CGFloat tableViewMaxHeight ;

@property (nonatomic) NSMutableArray *buttonArray;
@property (nonatomic) NSMutableArray *buttons;

@property (nonatomic) UIView  *maskBackGroundView;

@end

@implementation WYMenuClass


- (instancetype)initWithFrame:(CGRect)frame menuTitleArray:(NSArray *)titleArray leftTitleArr:(NSArray*)leftTitleArr selectColor:(UIColor *)selectColor nomolColor:(UIColor *)nomolColor
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.tableViewMaxHeight = KTableViewCellHeight * KDisplayMaxCellOfNumber;
        self.selfOriginalHeight =frame.size.height;
        self.titleArray =titleArray;
        self.titles=leftTitleArr;
        self.titleColor=nomolColor;
        self.titleSelectedColor=selectColor;

        [self addSubview:self.maskBackGroundView];
        [self addSubview:self.tableView];
        self.backgroundColor=[UIColor clearColor];
        [self configBaseInfo];
    }
    return self;
}

-(void)configBaseInfo
{
      //右边按钮
    UIButton *titleButton=[UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.frame= CGRectMake(0, 0, Kscreen_width/3, self.height);
    titleButton.backgroundColor =WhiteColor;
    [titleButton setTitle:[NSString stringWithFormat:@"%@",self.titleArray[0]] forState:0];
    [titleButton setTitleColor:self.titleColor forState:0];
    titleButton.tag =KTitleButtonTag   ;
    [titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [titleButton setTitleColor:self.titleColor forState:UIControlStateSelected];
    [titleButton setImage:[UIImage imageNamed:@"jiantou_down"] forState:0];
    [titleButton setImage:[UIImage imageNamed:@"jiantou_up"] forState:UIControlStateSelected];
    titleButton.imageEdgeInsets = UIEdgeInsetsMake(0,  Kscreen_width/3-20, 0, 0);
    titleButton.titleEdgeInsets = UIEdgeInsetsMake(0,  -30, 0, 0);
    [self addSubview:titleButton];
    [self.buttonArray addObject:titleButton];
    
    
    //左边两个按钮
    for (int i = 0; i < _titles.count; i++) {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake((i+1) * self.width/3, 0, self.width/3, self.height)];
        [btn setTitle:_titles[i] forState:NormalState];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:_titleColor forState:NormalState];
//        btn.titleLabel.font=_titleFont;
        btn.tag = BTag + i;
        [btn addTarget:self action:@selector(segmentIndexSelected:) forControlEvents:TouchUpInside];
        [self addSubview:btn];
//        if (i == 0) {
////            btn.selected = YES;
//        }
        [_buttons addObject:btn];
        btn.backgroundColor= WhiteColor;
    }
    _dotView = [[UIView alloc]initWithFrame:Frame(0, self.height-1, self.width/3, 2)];
    _dotView.backgroundColor = TELColor;
    [self addSubview:_dotView];
    
}
#pragma mark --button方法--
- (void)segmentIndexSelected:(UIButton *)button{
    
    [self takeBackTableView];
    
    self.selectIndex = (int)button.tag -BTag;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        _dotView.frame=Frame(button.left, _dotView.top, _dotView.width, _dotView.height);
    }];
    
    if (self.delegate &&[self.delegate respondsToSelector:@selector(segmentView:didSelectIndex:)]) {
        [self.delegate segmentView:self didSelectIndex:self.selectIndex];
    }
}

-(UITableView *)tableView
{
    if (_tableView) {
        return _tableView;
    }
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.frame.size.height, Kscreen_width, 0)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    self.tableView.rowHeight= KTableViewCellHeight;
    
    
    return self.tableView;
}


#pragma mark  --  <代理方法>
#pragma mark  --  <UITableViewDelegate,UITableViewDataSource>

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    downMenuCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell =[[downMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = self.tableDataArray[indexPath.row];
    
    NSString *objcTitle = KOBJCGetObject(self.tempButton);
    
    if ([cell.textLabel.text isEqualToString:objcTitle]) {
        cell.isSelected = YES;
    }
    else
    {
        cell.isSelected=NO;
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    downMenuCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isSelected = YES;
    
    [self.tempButton setTitle:[NSString stringWithFormat:@" %@",cell.textLabel.text] forState:UIControlStateNormal];
    
    KOBJCSetObject(self.tempButton, cell.textLabel.text);
    
    if (self.handleSelectDataBlock) {
        self.handleSelectDataBlock(cell.textLabel.text,indexPath.row,self.tempButton.tag - KTitleButtonTag);
    }
    
    [self takeBackTableView];
    
}



-(void)setDefauldSelectedCell
{
    
    for (int index=0; index<self.buttonArray.count; index++) {
        
        self.tableDataArray =self.menuDataArray[index];
        
        UIButton *button =self.buttonArray[index];
        
        NSString *title = self.tableDataArray.firstObject;
        
        KOBJCSetObject(button, title);
        
    }
    
    [self takeBackTableView];
    
}


-(void)titleButtonClick:(UIButton *)titleButton
{
    
    [UIView animateWithDuration:0.2 animations:^{
        _dotView.frame=Frame(titleButton.left, _dotView.top, _dotView.width, _dotView.height);
    }];
    
    
    NSUInteger index =  titleButton.tag - KTitleButtonTag;
    
    for (UIButton *button in self.buttonArray) {
        if (button == titleButton) {
            button.selected=!button.selected;
            self.tempButton =button;
        }else
        {
            button.selected=NO;
        }
    }
    
    
    if (titleButton.selected) {
        
        self.tableDataArray = self.menuDataArray[index];
        
        //设置默认选中第一项。
        if ([KOBJCGetObject(self.tempButton) length]<1) {
            
            NSString *title = self.tableDataArray.firstObject;
            KOBJCSetObject(self.tempButton, title);
            
        }
        
        [self.tableView reloadData];
        
        CGFloat tableViewHeight =  self.tableDataArray.count * KTableViewCellHeight < self.tableViewMaxHeight ?
        self.tableDataArray.count * KTableViewCellHeight : self.tableViewMaxHeight;
        
        
        [self expandWithTableViewHeight:tableViewHeight];
        
    }else
    {
        [self takeBackTableView];
    }
}



//展开。
-(void)expandWithTableViewHeight:(CGFloat )tableViewHeight
{
    
    self.maskBackGroundView.hidden=NO;
    
    CGRect rect = self.frame;
    rect.size.height = Kscreen_height - self.frame.origin.y;
    self.frame= rect;
    
    [self showSpringAnimationWithDuration:0.3 animations:^{
        
        self.tableView.frame = CGRectMake(0, self.selfOriginalHeight, Kscreen_width, tableViewHeight);
        
        self.maskBackGroundView.alpha =1;
        
    } completion:^{
        
    }];
}

//收起。
-(void)takeBackTableView
{
    for (UIButton *button in self.buttonArray) {
        button.selected=NO;
    }
    
    CGRect rect = self.frame;
    rect.size.height = self.selfOriginalHeight;
    self.frame = rect;
    
    [self showSpringAnimationWithDuration:.3 animations:^{
        
        self.tableView.frame = CGRectMake(0, self.selfOriginalHeight, Kscreen_width,0);;
        self.maskBackGroundView.alpha =0;
        
    } completion:^{
        self.maskBackGroundView.hidden=YES;
    }];
    
}



-(void)showSpringAnimationWithDuration:(CGFloat)duration
                            animations:(void (^)())animations
                            completion:(void (^)())completion
{
    
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:.8 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        if (animations) {
            animations();
        }
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}



-(void)maskBackGroundViewTapClick
{
    [self takeBackTableView];
}

-(NSMutableArray *)menuDataArray
{
    if (_menuDataArray) {
        return _menuDataArray;
    }
    self.menuDataArray =[[NSMutableArray alloc]init];
    
    return self.menuDataArray;
}


-(NSMutableArray *)tableDataArray
{
    if (_tableDataArray) {
        return _tableDataArray;
    }
    self.tableDataArray = [[NSMutableArray alloc]init];
    
    return self.tableDataArray;
}

-(NSMutableArray *)buttons
{
    if (_buttons) {
        return _buttons;
    }
    self.buttons =[[NSMutableArray alloc]init];
    
    return self.buttons;
}
-(NSMutableArray *)buttonArray
{
    if (_buttonArray) {
        return _buttonArray;
    }
    self.buttonArray =[[NSMutableArray alloc]init];
    
    return self.buttonArray;
}

-(UIView *)maskBackGroundView
{
    if (_maskBackGroundView) {
        return _maskBackGroundView;
    }
    self.maskBackGroundView=[[UIView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width, Kscreen_height - self.frame.origin.y)];
    self.maskBackGroundView.backgroundColor=KmaskBackGroundViewColor;
    self.maskBackGroundView.hidden=YES;
    self.maskBackGroundView.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskBackGroundViewTapClick)];
    [self.maskBackGroundView addGestureRecognizer:tap];
    
    return self.maskBackGroundView;
}

@end




@implementation downMenuCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self configCellView];
    }
    
    return self;
}


-(void)configCellView
{
    self.selectImageView.hidden=YES;
    self.textLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.selectImageView];
}


-(UIImageView *)selectImageView
{
    if (_selectImageView) {
        return _selectImageView;
    }
    
    UIImage *image = [UIImage imageNamed:@"ok"];
    self.selectImageView = [[UIImageView alloc]init];
    self.selectImageView.image=image;
    
    self.selectImageView.frame = CGRectMake(0,0,image.size.width,image.size.height);
    
    self.selectImageView.center = CGPointMake(Kscreen_width-40, self.frame.size.height/2);
    
    return self.selectImageView;
}

- (void)setIsSelected:(BOOL)isSelected
{
    _isSelected = isSelected;
    if (isSelected) {
        self.textLabel.textColor = KDefaultColor;
        self.backgroundColor =kCellBgColor;
        self.selectImageView.hidden = NO;
    }else
    {
        self.textLabel.textColor = [UIColor lightGrayColor];
        self.selectImageView.hidden = YES;
        self.backgroundColor=[UIColor groupTableViewBackgroundColor];
    }
}

@end








@implementation UIView (Category)

#pragma mark-- setter,getter方法(深度赋值，取值)--
//- (void) setX:(CGFloat)x{
//    CGRect frame=self.frame;
//    frame=CGRectMake(x, frame.origin.y, frame.size.width, frame.size.height);
//    self.frame=frame;
//}
//- (CGFloat)x{
//    return self.frame.origin.x;
//}
//- (void) setY:(CGFloat)y{
//    CGRect frame=self.frame;
//    frame=CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);
//    self.frame=frame;
//}
//- (CGFloat)y{
//    return self.frame.origin.y;
//}
//- (void) setW:(CGFloat)w{
//    CGRect frame=self.frame;
//    frame=CGRectMake(frame.origin.x, frame.origin.y, w, frame.size.height);
//    self.frame=frame;
//}
//- (CGFloat)w{
//    return self.frame.size.width;
//}
//- (void) setH:(CGFloat)h{
//    CGRect frame=self.frame;
//    frame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, h);
//    self.frame=frame;
//}
//- (CGFloat)h{
//    return self.frame.size.height;
//}

@end
