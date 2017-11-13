//
//  FGAreaPicker.m
//  FlyGift
//
//  Created by Nathan Ou on 15/1/18.
//  Copyright (c) 2015年 CRZ. All rights reserved.
//

#import "FGAreaPicker.h"

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

@interface FGAreaPicker () <UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIButton *button;
    
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    
    NSString *selectedProvince;
}


@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSString *provinceStr;

@property (nonatomic, strong) NSString *cityStr;

@property (nonatomic, strong) NSString *countyStr;

@end


@implementation FGAreaPicker

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = [FGAreaPicker keyWindow].bounds;
        // 默认
        self.dateType = AreaStyleShowProvinceCityCounty;
    }
    return self;
}

+ (UIWindow *)keyWindow
{
    return [UIApplication sharedApplication].keyWindow;
}

- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.backgroundColor = [UIColor grayColor];
        _backgroundView.alpha = 0.2f;
        [self addSubview:_backgroundView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonAction)];
        [_backgroundView addGestureRecognizer:tap];
    }
    return _backgroundView;
}

- (UIView *)contentView
{
    if (!_contentView) {
        UIWindow *window = [FGAreaPicker keyWindow];
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, window.height, window.width, 200)];
        _contentView.backgroundColor = [UIColor clearColor];
        
        UIView *groundView = [[UIView alloc] initWithFrame:_contentView.bounds];
        groundView.backgroundColor = [UIColor whiteColor];
        //  groundView.alpha = 0.85f;
        [_contentView addSubview:groundView];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.backgroundColor = [UIColor clearColor];
        cancelButton.frame = CGRectMake(0, _contentView.height-65.f, _contentView.width, 65.f);
        [cancelButton setTitleColor:[UIColor cancelButton] forState:UIControlStateNormal];
        [cancelButton setTitle:@"确定" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(returnResult) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:cancelButton];
        
        CGFloat paddingHeight = 10.f;
        _contentView.height = cancelButton.height+200+paddingHeight; // 设置contentView高度
        cancelButton.top = _contentView.height - cancelButton.height;
        groundView.height = _contentView.height;
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, NAScreenWidth, 200)];
        
        [_contentView addSubview:_pickerView];
        
        [self addSubview:_contentView];
        
        // Line View
        UIView *lineView = [UIView lineViewWithWidth:_contentView.width-20.f*2 yPoint:cancelButton.top+1.f withColor:[UIColor spLineColor]];
        lineView.left = 20.f;
        [_contentView addSubview:lineView];
        
        [self initData];
        [self changeSpearatorLineColor];
    }
    return _contentView;
}

#pragma mark - 改变分割线的颜色
- (void)changeSpearatorLineColor
{
    for(UIView *speartorView in self.pickerView.subviews)
    {
        if (speartorView.frame.size.height < 1)//取出分割线view
        {
            speartorView.backgroundColor = [UIColor spThemeColor];//设置分割线颜色
        }
    }
}

- (void)initData
{

    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"area2" ofType:@"plist"];
    if (_isChina) {
        plistPath = [bundle pathForResource:@"area" ofType:@"plist"];
    }
    areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSArray *components = [areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    province = [[NSArray alloc] initWithArray: provinceTmp];
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    city = [[NSArray alloc] initWithArray: [cityDic allKeys]];
    
    
    NSString *selectedCity = [city objectAtIndex: 0];
    district = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];
    
    self.provinceStr = [province objectAtIndex:0];
    self.cityStr = [city objectAtIndex: 0];
    self.countyStr = [district objectAtIndex:0];
    
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self.pickerView selectRow: 0 inComponent: 0 animated: YES];
    
    selectedProvince = [province objectAtIndex: 0];
    
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Button Actions
////////////////////////////////////////////////////////////////////////////////////

- (void)cancelButtonAction
{
    [self hide];
}

- (void)returnResult{

    if (self.selectResultBlock) {
        self.selectResultBlock(self.provinceStr, self.cityStr, self.countyStr);
    }
    
    [self hide];
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Actions
////////////////////////////////////////////////////////////////////////////////////

- (void)show
{
    [self showWithCompletion:nil];
}

- (void)showWithCompletion:(void (^)())block
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[FGAreaPicker keyWindow] addSubview:self];
        self.backgroundView.hidden = NO;
        self.backgroundView.alpha = 0;
        self.contentView.top = self.height;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.alpha = 0.2f;
            self.contentView.top = self.height - self.contentView.height;
        } completion:^(BOOL finish){
            if (block) {
                block();
            }
        }];
    });
}

- (void)hide
{
    [self hideWithCompletion:nil];
}

- (void)hideWithCompletion:(void (^)())block
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            self.backgroundView.alpha = 0;
            self.contentView.top = self.height;
        } completion:^(BOOL finish){
            if (block) {
                block();
            }
            self.hidden = YES;
            [self removeFromSuperview];
        }];
    });
}



#pragma mark- Picker Data Source Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if(_dateType == AreaStyleShowProvince)
        return 1;
    else if(_dateType == AreaStyleShowProvinceCity)
        return 2;
    else
        return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province count];
    }
    else if (component == CITY_COMPONENT) {
        return [city count];
    }
    else {
        return [district count];
    }
}


#pragma mark- Picker Delegate Methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return [province objectAtIndex: row];
    }
    else if (component == CITY_COMPONENT) {
        return [city objectAtIndex: row];
    }
    else {
        return [district objectAtIndex: row];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        
        
        selectedProvince = [province objectAtIndex: row];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%ld", (long)row]]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *cityArray = [dic allKeys];
        NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;//递减
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;//上升
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int i=0; i<[sortedArray count]; i++) {
            NSString *index = [sortedArray objectAtIndex:i];
            NSArray *temp = [[dic objectForKey: index] allKeys];
            [array addObject: [temp objectAtIndex:0]];
        }
        
        if(_dateType != AreaStyleShowProvince){
        
            city = [[NSArray alloc] initWithArray: array];
            
            NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
            district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [city objectAtIndex: 0]]];
            [self.pickerView selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
            [self.pickerView selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
            [self.pickerView reloadComponent: CITY_COMPONENT];
            [self.pickerView reloadComponent: DISTRICT_COMPONENT];
        }
        
    }
    else if (component == CITY_COMPONENT) {
        
        
        NSString *provinceIndex = [NSString stringWithFormat: @"%lu", (unsigned long)[province indexOfObject: selectedProvince]];
        NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: provinceIndex]];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
        NSArray *dicKeyArray = [dic allKeys];
        NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
        NSArray *cityKeyArray = [cityDic allKeys];
        
        if(_dateType != AreaStyleShowProvinceCity&&_dateType != AreaStyleShowProvince){
            
            district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
            [self.pickerView selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
            [self.pickerView reloadComponent: DISTRICT_COMPONENT];
        }
    }
    
    NSInteger provinceIndex = [self.pickerView selectedRowInComponent: PROVINCE_COMPONENT];
    
    NSInteger cityIndex =0;
    if(_dateType != AreaStyleShowProvince){
        cityIndex= [self.pickerView selectedRowInComponent: CITY_COMPONENT];
    }
    
    NSInteger districtIndex = 0;
    if(_dateType != AreaStyleShowProvinceCity&&_dateType != AreaStyleShowProvince){
        districtIndex = [self.pickerView selectedRowInComponent: DISTRICT_COMPONENT];
    }

    
    NSString *provinceStr = [province objectAtIndex: provinceIndex];
    NSString *cityStr = [city objectAtIndex: cityIndex];
    NSString *districtStr = [district objectAtIndex:districtIndex];
    
    if ([provinceStr isEqualToString: cityStr] && [cityStr isEqualToString: districtStr]) {
        cityStr = @"";
        districtStr = @"";
    }
    else if ([cityStr isEqualToString: districtStr]) {
        districtStr = @"";
    }else if ([provinceStr isEqualToString:cityStr])
    {
        cityStr = @"";
    }
    
    self.provinceStr = provinceStr ;
    self.cityStr = cityStr;
    self.countyStr = districtStr;
    
    if ([self.p_Deleate respondsToSelector:@selector(pickerViewDidGetProvince:city:area:)]) {
        [self.p_Deleate pickerViewDidGetProvince:provinceStr city:cityStr area:districtStr];
    }
    
}


- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return 115;
    }
    else if (component == CITY_COMPONENT) {
        return 105;
    }
    else {
        return 115;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if (component == PROVINCE_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 115, 40)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [province objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:16];
        myView.backgroundColor = [UIColor clearColor];
    }
    else if (component == CITY_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 105, 40)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [city objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:16];
        myView.backgroundColor = [UIColor clearColor];
    }
    else {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 115, 40)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [district objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:16];
        myView.backgroundColor = [UIColor clearColor];
    }
    
    return myView;
}

@end
