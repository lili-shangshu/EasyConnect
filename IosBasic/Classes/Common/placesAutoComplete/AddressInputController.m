//
//  AddressInputController.m
//  SPGooglePlacesAutocomplete
//
//  Created by junshi on 16/3/25.
//  Copyright © 2016年 Stephen Poletto. All rights reserved.
//

#import "AddressInputController.h"
#import "SPCommbox.h"
#import "SPGooglePlacesAutocompleteQuery.h"
#import "SPGooglePlacesAutocompletePlace.h"

@interface AddressInputController()<UITextFieldDelegate>

@property (nonatomic,strong) SPCommbox *commbox;

@end


@implementation AddressInputController

- (void)viewDidLoad{

    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    //*****************************************************************************************************************
    NSMutableDictionary *mulDic = [NSMutableDictionary dictionary];
    [mulDic setObject:[NSArray arrayWithObjects:@"15000000", @"/MHz"    , nil] forKey:@"蜂窝公众通信（全国网）"];
    [mulDic setObject:[NSArray arrayWithObjects:@"15000000", @"/MHz"    , nil] forKey:@"蜂窝公众通信（非全国网）"];
    [mulDic setObject:[NSArray arrayWithObjects:@"50000",    @"每频点"   , nil] forKey:@"集群无线调度系统（全国范围使用）"];
    [mulDic setObject:[NSArray arrayWithObjects:@"10000",    @"每频点"   , nil] forKey:@"集群无线调度系统（省、自治区、直辖市范围使用）"];
    [mulDic setObject:[NSArray arrayWithObjects:@"2000",     @"每频点"   , nil] forKey:@"集群无线调度系统（地、市范围使用）"];
    [mulDic setObject:[NSArray arrayWithObjects:@"2000000",  @"每频点"   , nil] forKey:@"无线寻呼系统（全国范围使用）"];
    [mulDic setObject:[NSArray arrayWithObjects:@"2000000",  @"每频点"   , nil] forKey:@"无线寻呼系统（省、自治区、直辖市范围使用"];
    [mulDic setObject:[NSArray arrayWithObjects:@"40000",    @"每频点"   , nil] forKey:@"无线寻呼系统（地、市范围使用）"];
    [mulDic setObject:[NSArray arrayWithObjects:@"150",      @"每基站"   , nil] forKey:@"无绳电话系统"];
    

    //*****************************************************************************************************************
    searchQuery =  [[SPGooglePlacesAutocompleteQuery alloc] init];;
    searchQuery.radius = 100.0;

//    _commbox = [[SPCommbox alloc] initWithFrame:CGRectMake(70, 10, 140, 100)];
//    _commbox.textField.placeholder = @"点击请选择";
//       _commbox.textField.delegate = self;
    
    
//    NSMutableArray* arr = [[NSMutableArray alloc] init];
//    //*****************************************************************************************************************
//    NSEnumerator *e = [mulDic keyEnumerator];
//    for (NSString *key in e) {
//        //NSLog(@"Key is %@, value is %@", key, [mulDic objectForKey:key]);
//        [arr addObject:key];
//        
//    }
//    //NSLog(@"%@",[arr objectAtIndex:0]);
//    //*****************************************************************************************************************
//    
//    _commbox.tableArray = arr;

 
    
    
    [self.view addSubview:_commbox];

    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(_commbox.frame.origin.x, _commbox.frame.origin.y+_commbox.frame.size.height, 140, 20)];
    label.text = @"1222222";
    label.textColor = [UIColor blueColor];
    label.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label];
    
   }

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *addressStr = textField.text;
   
    searchQuery.input = addressStr;
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    [searchQuery fetchPlaces:^(NSArray *places, NSError *error) {
        if (error) {
            SPPresentAlertViewWithErrorAndTitle(error, @"Could not fetch Places");
            NSLog(@"%@",error);
        } else {
           
            for(int i = 0 ; i < places.count ; i++){
                SPGooglePlacesAutocompletePlace *place =  places[i];
                [arr addObject:place.name];
            }
            _commbox.tableArray = arr;
            [_commbox.tv reloadData];
        }
    }];
    return  YES;
}

@end