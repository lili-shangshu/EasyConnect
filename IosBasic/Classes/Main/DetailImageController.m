//
//  DetailImageController.m
//  IosBasic
//
//  Created by li jun on 16/10/20.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "DetailImageController.h"
#import "DetailGoodsController.h"
#import <WebKit/WebKit.h>
#define imageHeight 250
#define lableHeight 60
#define paddding 20


@interface DetailImageController ()<WKNavigationDelegate,DetailGoodsControllerDelegate>



@property(nonatomic,strong)WKWebView *webView;
@property(nonatomic,strong)NSString *htmlString;


@end

@implementation DetailImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [SVProgressHUD show];
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, NAScreenWidth, self.view.height  - kNavigationHeight-kTabbarHeight-44)];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://d05.res.meilishuo.net/pic/_o/76/71/fe53f880ea74e3ef2ba84c7b6ed1_640_900.cg.jpg"]];
//    [webView loadRequest:request];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
    
    /*
    // 20 44  49   113
     
    self.dataDic = @{@"images":@[@"http://demo.legendwebdesign.com.au/app_test/data/upload/item/1406/17/53a04f154e138_b.jpg",@"http://demo.legendwebdesign.com.au/app_test/data/upload/item/1406/17/53a04f154e138_b.jpg"],@"detail":@"圆领礼服式外套；无扣式；侍寝前口袋 模特圣奥175，体重65"};
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, NAScreenWidth, NAScreenHeight-113)];
    NSArray *array = _dataDic[@"images"];
    float scroHeight = paddding*2+imageHeight*array.count+lableHeight+10.f;
    scrollView.contentSize = CGSizeMake(NAScreenWidth, scroHeight);
    scrollView.pagingEnabled = NO;
    
    // 图
    for (int i=0; i<array.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(paddding, 20+imageHeight*i, NAScreenWidth-2*paddding, imageHeight)];
        [imageView setImageWithFadingAnimationWithURL:[NSURL URLWithString:array[i]]];
        [scrollView addSubview:imageView];
    }
    
    // 文字
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(paddding, paddding*2+imageHeight*array.count, NAScreenWidth-2*paddding, lableHeight)];
    lable.numberOfLines = 2;
    [lable setLabelWith:_dataDic[@"detail"] color:[UIColor grayColor] font:[UIFont defaultTextFontWithSize:13.f] aliment:NSTextAlignmentLeft];
    [scrollView addSubview:lable];
    
    [self.view addSubview:scrollView];
    
    */
    // Do any additional setup after loading the view.
}
- (void)gethtml:(NSString *)heml{
    self.htmlString = heml;
//    NSLog(@"%@",self.htmlString);
    NSString *sting = @"<head><style>img { width:100%!important; height:auto!important; }</style></head>";
    NSLog(@"%@",[sting stringByAppendingString:heml]);
    [self.webView loadHTMLString:[sting stringByAppendingString:heml] baseURL:nil];
}


- (void)viewWillAppear:(BOOL)animated{
   
}
#pragma mark----Delegate
/// 2 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"开始加载");
}
/// 4 开始获取到网页内容时返回
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
     NSLog(@"开始获取到网页内容");
}
/// 5 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"页面加载完成之后调用");
//    [SVProgressHUD dismiss];
}
/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
      NSLog(@"页面加载失败时调用");
//     [SVProgressHUD dismiss];
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
