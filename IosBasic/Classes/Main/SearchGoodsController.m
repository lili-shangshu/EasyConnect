//
//  SearchGoodsController.m
//  IosBasic
//
//  Created by li jun on 16/10/18.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "SearchGoodsController.h"
#import "ClassifyGoodsController.h"

#define button_height 30
#define lable_height 50

#define vertical_padding 10.f
#define herizon_padding 20.f
#define text_font 15.f

@interface SearchGoodsController ()<UISearchBarDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSString *searchString;

@property(nonatomic,strong)NSMutableArray *recentSearchArray;

@property(nonatomic,strong)NSMutableArray *hotSearchArray;

@property(nonatomic,strong)UIView *recentView;
@property(nonatomic)float recentViewHeight;
@property(nonatomic,strong)UIView *hotView;

@end

@implementation SearchGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor spBackgroundColor];
    _recentSearchArray =  [NSMutableArray arrayWithObjects:@"you",@"眼睛",@"当初不后悔",@"让他听",@"军大衣",@"鸟",@"鞋",@"包",@"眼睛",@"拼拼拼拼拼拼皮",@"冲锋枪",nil];
    _hotSearchArray =  [NSMutableArray arrayWithObjects:@"鞋",@"包", nil];
    [self setreceentView];
    [self sethotttView];
    
    // Do any additional setup after loading the view.
}
- (void)setreceentView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, NAScreenWidth, 200)];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(herizon_padding, 15, 20, 20)];
    imageView.image = [UIImage imageNamed:@"ic_recent"];
    [view addSubview:imageView];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+herizon_padding, 0, NAScreenWidth-3*herizon_padding-imageView.width, lable_height)];
    [lable setLabelWith:@"最近搜索" color:[UIColor blackColor] font:[UIFont defaultTextFontWithSize:text_font] aliment:NSTextAlignmentLeft];
    [view addSubview:lable];
    
    int width = 0;
    int height = 0;
    int number = 0;
    int han = 0;
    NSLog(@"%.1f",NAScreenWidth);
    for (int i = 0; i < _recentSearchArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 300 + i;
        [button setTitleColor:[UIColor spDefaultTextColor] forState:UIControlStateNormal];
        
        CGSize titleSize = [self getSizeByString:_recentSearchArray[i] AndFontSize:text_font];
        han = han +titleSize.width;
        if (han > NAScreenWidth) {
            han = 0;
            han = han + titleSize.width;
            height++;
            width = 0;
            width = width+titleSize.width;
            number = 0;
            button.frame = CGRectMake(10, lable.bottom+40*height, titleSize.width, button_height);
            if (i==_recentSearchArray.count-1) {
                view.height = button.y+button.height+herizon_padding;
            }
            
        }else{
            button.frame = CGRectMake(width+10+(number*10), lable.bottom +40*height, titleSize.width, button_height);
            width = width+titleSize.width;
            han = button.right;
            if (i==_recentSearchArray.count-1) {
                view.height = button.y+button.height+herizon_padding;
            }
        }
        number++;
        button.layer.borderWidth = 1.f;
        button.layer.borderColor = [[UIColor grayColor] CGColor];
        button.titleLabel.font = [UIFont systemFontOfSize:text_font];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:_recentSearchArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    self.recentView = view;
    [self.view addSubview:view];
}

- (void)sethotttView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, self.recentView.bottom, NAScreenWidth, 200)];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(herizon_padding, 15, 20, 20)];
    imageView.image = [UIImage imageNamed:@"ic_hot"];
    [view addSubview:imageView];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(imageView.right+herizon_padding, 0, NAScreenWidth-3*herizon_padding-imageView.width, lable_height)];
    [lable setLabelWith:@"热门搜索" color:[UIColor blackColor] font:[UIFont defaultTextFontWithSize:text_font] aliment:NSTextAlignmentLeft];
    [view addSubview:lable];
    
    int width = 0;
    int height = 0;
    int number = 0;
    int han = 0;
    for (int i = 0; i < _hotSearchArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 300 + i;
        [button setTitleColor:[UIColor spDefaultTextColor] forState:UIControlStateNormal];
        
        CGSize titleSize = [self getSizeByString:_hotSearchArray[i] AndFontSize:text_font];
        han = han +titleSize.width;
        if (han > NAScreenWidth) {
            han = 0;
            han = han + titleSize.width;
            height++;
            width = 0;
            width = width+titleSize.width;
            number = 0;
            button.frame = CGRectMake(10, lable.bottom+40*height, titleSize.width, button_height);
            if (i==_hotSearchArray.count-1) {
                view.height = button.y+button.height+herizon_padding;
            }
            
        }else{
            button.frame = CGRectMake(width+10+(number*10), lable.bottom +40*height, titleSize.width, button_height);
            width = width+titleSize.width;
            han = button.right;
            if (i==_hotSearchArray.count-1) {
                view.height = button.y+button.height+herizon_padding;
            }
        }
        number++;
        button.layer.borderWidth = 1.f;
        button.layer.borderColor = [[UIColor grayColor] CGColor];
        button.titleLabel.font = [UIFont systemFontOfSize:text_font];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:_hotSearchArray[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    self.hotView = view;
    [self.view addSubview:view];
}

- (void)viewWillAppear:(BOOL)animated{

//    UIBarButtonItem *cancelItem = [UIBarButtonItem NA_BarButtonWithtitile:@"取消" titleColor:[UIColor whiteColor] target:self action:@selector(cancelItemClicked:)];
//    [(UIButton *)cancelItem.customView titleLabel].font = [UIFont defaultTextFontWithSize:14.f];
//    self.navigationItem.rightBarButtonItem = cancelItem;
    // 未生效
//  self.navigationItem.leftBarButtonItem = nil;
    self.tabBarController.navigationItem.leftBarButtonItems = nil;
    [self addBackButton];
    
    self.tabBarController.title = @"";
    self.navigationItem.titleView = self.searchBar;
    // 获取热门搜索
    [self initHotData];
}

- (void)initHotData{
    [[SPNetworkManager sharedClient] getHotSearchWithParams:nil completion:^(BOOL succeeded, id responseObject, NSError *error) {
         dispatch_async(dispatch_get_main_queue(), ^{
            if (succeeded) {
                NSLog(@"%@",responseObject);
                _hotSearchArray = [[NSMutableArray alloc]initWithArray:responseObject];
                NSArray *subView = [self.hotView subviews];
                for (UIView *obj in subView) {
                    [obj removeFromSuperview];
                }
                [self sethotttView];
            }
         });
    }];
}
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width-30.f, 40.f)];
        searchBar.barTintColor = [UIColor whiteColor];
        searchBar.tintColor = [UIColor spThemeColor];
        searchBar.barStyle = UISearchBarStyleDefault;
        searchBar.backgroundColor = [UIColor clearColor];
        searchBar.showsCancelButton = NO;
        searchBar.placeholder = @"请输入您要搜索的商品";
        searchBar.delegate = self;
        [[searchBar.subviews objectAtIndex:0] setBackgroundColor:[UIColor clearColor]];
        UITextField *txfSearchField = [searchBar valueForKey:@"_searchField"];
        if (txfSearchField && [txfSearchField isKindOfClass:[UITextField class]]) {
            txfSearchField.backgroundColor = [UIColor spBackgroundColor];
        }
        _searchBar = searchBar;
    }
    
    return _searchBar;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Search Bar Delegate
////////////////////////////////////////////////////////////////////////////////////

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    __weak typeof(self) weakSelf = self;
    [self.view addShadowCoverWithAlpha:0.3 withTouchAction:^{
        [weakSelf.searchBar resignFirstResponder];
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchString = @"";
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    [self.view hideShadow];
    self.searchBar.text = self.searchString;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view hideShadow];
    self.searchString = searchBar.text;
    NSLog(@"搜索的内容是：%@",self.searchString);
    if (![searchBar.text isEmptyString]) {
        [self.recentSearchArray addObject:searchBar.text];
        [self setreceentView];
        self.hotView.top = self.recentView.bottom;
        ClassifyGoodsController *classGoods = [[ClassifyGoodsController alloc]init];
        classGoods.searchWord = searchBar.text;
        [self.navigationController pushViewController:classGoods animated:YES];
        
    }
//    [self refreshTableWithUpdate];
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
}

#pragma mark-----自适应button
//计算文字所占大小
- (CGSize)getSizeByString:(NSString*)string AndFontSize:(CGFloat)font
{
    CGSize size = [string boundingRectWithSize:CGSizeMake(999, 25) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    size.width +=10;
    if (size.width<60) {
        size.width = 60;
    }
    return size;
}

- (void)handleButton:(UIButton *)button{
  
    ClassifyGoodsController *classGoods = [[ClassifyGoodsController alloc]init];
    classGoods.searchWord = [button currentTitle];
    [self.navigationController pushViewController:classGoods animated:YES];
    
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
