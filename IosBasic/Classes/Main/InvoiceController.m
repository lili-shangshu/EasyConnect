//
//  InvoiceController.m
//  IosBasic
//
//  Created by li jun on 16/10/17.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "InvoiceController.h"

#define k_type @"发票类型"
#define k_emply @"空"
#define k_emply2 @"空2"
#define k_title @"发票抬头"
#define k_info @"发票明细"
#define k_no @"不要发票"
#define k_button @"确定"

#define cell_height 50.f
#define emply_height 15.f
#define button_height 35.f
#define text_font 15.f
// y
#define vertical_padding 10.f
// x
#define herizon_padding 20.f


@interface InvoiceController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,strong)NSArray *titlesArray;
@property(nonatomic,strong)NSArray *infosArray;
@property(nonatomic,strong)UITextField *titleTextField;
@property(nonatomic)NSInteger infotype;
@property(nonatomic)NSInteger invoiceType;
@end

@implementation InvoiceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.invoiceType = 3;
    self.titlesArray = @[k_type,k_emply,k_title,k_emply,k_info,k_emply,k_no,k_emply2,k_button,k_emply2];
    self.infosArray = @[@"办公用品",@"体育用品",@"音乐器材",@"饰品服装"];;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - kNavigationHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // 在最后增加一个按钮
    //    self.tableView.height = self.view.height - kTransulatInset-kTransulatInset;
    self.tableView.backgroundColor = [UIColor spBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView hideExtraCellHide];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"设置发票信息";
    [self addBackButton];
    self.navigationController.navigationBarHidden = NO;
}
#pragma mark------tableVIew delegat
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titlesArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.titlesArray[indexPath.row];
    if ([title isEqualToString:k_type]  ) {
        return 2.6*cell_height;
    }else if([title isEqualToString:k_emply]){
        return emply_height;
    }else if([title isEqualToString:k_title]){
        return cell_height*2+vertical_padding;
    }else if([title isEqualToString:k_info]){
        return cell_height*0.8+self.infosArray.count*button_height;
    }else if([title isEqualToString:k_no]){
        return button_height;
    }else if([title isEqualToString:k_emply2]){
        return emply_height*3;
    }else {
        return cell_height;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     NACommenCell *cell;
    NSString *title = self.titlesArray[indexPath.row];
    if ([title isEqualToString:k_type]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_type];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_type];
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(herizon_padding, 0, self.view.width-2*herizon_padding, cell_height)];
            [lable setLabelWith:k_type color:[UIColor spDefaultTextColor] font:[UIFont systemFontOfSize:text_font] aliment:NSTextAlignmentLeft];
            [cell.contentView addSubview:lable];
            
            UILabel *sublable = [[UILabel alloc]initWithFrame:CGRectMake(lable.left, cell_height*1.6, lable.width, cell_height)];
            [sublable setLabelWith:@"怕纸质发票丢失？试试电子发票吧！" color:[UIColor spDefaultTextColor] font:[UIFont systemFontOfSize:text_font-2] aliment:NSTextAlignmentLeft];
            [cell.contentView addSubview:sublable];
        }
        
            
        NSArray *array = @[@"普通纸质发票",@"增值税发票"];
        float width = (self.view.width-3*herizon_padding)/2;
        for (int i =0; i<2; i++) {
            NACommonButton *button = [[NACommonButton alloc]initWithFrame:CGRectMake(herizon_padding+i*(herizon_padding+width), cell_height, width, cell_height*0.6)];
            
            [button setTitle:array[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor spDefaultTextColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont defaultTextFontWithSize:text_font];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            button.normalColor = [UIColor whiteColor];
            button.layer.borderWidth = 1;
            button.layer.borderColor = [[UIColor blackColor] CGColor];
            button.tag = i;
            if (self.invoiceType == i) {
                button.selected = YES;
            }
            button.selectedColor = [UIColor black1];
            [button addTarget:self action:@selector(typeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button];
        }
    }
    
    if ([title isEqualToString:k_emply]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_emply];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_emply];
        }
        float   heitht = emply_height;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.width, heitht)];
        lineView.backgroundColor = [UIColor spBackgroundColor];
        [cell.contentView addSubview:lineView];
    }
    
    if ([title isEqualToString:k_emply2]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_emply2];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_emply2];
        }
        float   heitht = emply_height*3;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.width, heitht)];
        lineView.backgroundColor = [UIColor spBackgroundColor];
        [cell.contentView addSubview:lineView];
    }

    
    
    
    if ([title isEqualToString:k_title]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_title];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_title];
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(herizon_padding, 0, NAScreenWidth-2*herizon_padding, cell_height)];
            [lable setLabelWith:k_title color:[UIColor spDefaultTextColor] font:[UIFont systemFontOfSize:text_font] aliment:NSTextAlignmentLeft];
            [cell.contentView addSubview:lable];

        }
        
        UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(herizon_padding, cell_height, NAScreenWidth-2*herizon_padding, cell_height)];
        textfield.backgroundColor = [UIColor spSilverGrayColor];
        textfield.font = [UIFont systemFontOfSize:text_font];
        textfield.placeholder = @"个人";
        self.titleTextField = textfield;
        [cell.contentView addSubview:textfield];
    }
    
    if ([title isEqualToString:k_info]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_info];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_info];
         }
        
        for (UIView *view in [cell.contentView subviews]) {
            [view removeFromSuperview];
        }
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(herizon_padding, 0, self.view.width-2*herizon_padding, cell_height*0.8)];
        [lable setLabelWith:k_info color:[UIColor blackColor] font:[UIFont systemFontOfSize:text_font] aliment:NSTextAlignmentLeft];
        [cell.contentView addSubview:lable];
        
        for (int i = 0; i<self.infosArray.count; i++) {
            UIButton *setAddressButton = [[UIButton alloc] initWithFrame:CGRectMake(herizon_padding, cell_height*0.8+i*button_height, NAScreenWidth-2*herizon_padding, button_height)];
            [setAddressButton setImage:[UIImage imageNamed:@"circle_selected"] forState:UIControlStateSelected];
            [setAddressButton setImage:[UIImage imageNamed:@"circle_unselected"] forState:UIControlStateNormal];
            [setAddressButton setTitle:self.infosArray[i] forState:UIControlStateNormal];
            [setAddressButton setTitleColor:[UIColor spDefaultTextColor] forState:UIControlStateNormal];
             [setAddressButton setTitleColor:[UIColor spDefaultTextColor] forState:UIControlStateSelected];
            setAddressButton.titleLabel.font = [UIFont defaultTextFontWithSize:text_font-2];
            setAddressButton.imageEdgeInsets = UIEdgeInsetsMake(8, 10, 8, setAddressButton.width-30);
            setAddressButton.titleEdgeInsets = UIEdgeInsetsMake(0, -setAddressButton.width/3, 0, setAddressButton.width/3);
            
            setAddressButton.tag = i;
            if (self.infotype == i) {
                setAddressButton.selected = YES;
            }
            [setAddressButton addTarget:self action:@selector(infoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:setAddressButton];
        }
      
      
    }
    
    
    if ([title isEqualToString:k_no]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_no];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_no];
        }
        
        for (UIView *view in [cell.contentView subviews]) {
            [view removeFromSuperview];
        }
            UIButton *setAddressButton = [[UIButton alloc] initWithFrame:CGRectMake(herizon_padding, 0, NAScreenWidth-2*herizon_padding, button_height)];
            [setAddressButton setImage:[UIImage imageNamed:@"circle_selected"] forState:UIControlStateSelected];
            [setAddressButton setImage:[UIImage imageNamed:@"circle_unselected"] forState:UIControlStateNormal];
           [setAddressButton setTitleColor:[UIColor spDefaultTextColor] forState:UIControlStateSelected];
            [setAddressButton setTitle:@"不要发票" forState:UIControlStateNormal];
            [setAddressButton setTitleColor:[UIColor spDefaultTextColor] forState:UIControlStateNormal];
            setAddressButton.titleLabel.font = [UIFont defaultTextFontWithSize:text_font-2];
            setAddressButton.imageEdgeInsets = UIEdgeInsetsMake(8, 10, 8, setAddressButton.width-30);
            setAddressButton.titleEdgeInsets = UIEdgeInsetsMake(0, -setAddressButton.width/3, 0, setAddressButton.width/3);
            setAddressButton.tag = self.infosArray.count;
            if (self.infotype == self.infosArray.count) {
                setAddressButton.selected = YES;
            }
            [setAddressButton addTarget:self action:@selector(infoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:setAddressButton];
     
    }
    
    if ([title isEqualToString:k_button]) {
        cell = (NACommenCell *)[tableView dequeueReusableCellWithIdentifier:k_button];
        if (!cell) {
            cell = [[NACommenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:k_button];
            
            UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(herizon_padding, 0, self.view.width-2*herizon_padding, cell_height)];
            [okButton setBackgroundColor:[UIColor blackColor]];
            [okButton setTitle:@"确定" forState:UIControlStateNormal];
            [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [okButton addTarget:self action:@selector(okButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.contentView.backgroundColor = [UIColor spBackgroundColor];
            [cell.contentView addSubview:okButton];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
#pragma mark --- UIbutton
- (void)typeButtonClicked:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        self.invoiceType = button.tag;
        [self.tableView reloadData];
    }else{
        self.invoiceType = 3;
    }
}
- (void)infoButtonAction:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        self.infotype = button.tag;
        [self.tableView reloadData];
    }
    
}
- (void)okButtonAction:(UIButton *)button{
    NSString *stirng  = @"";
    if (self.invoiceType == 0) {
        stirng = @"普通纸质发票";
    }else{
        stirng = @"增值税发票";
    }
    [self.delegate selectInvoiceType:stirng];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
