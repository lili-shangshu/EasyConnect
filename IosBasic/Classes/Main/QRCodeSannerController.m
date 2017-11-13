//
//  QRCodeSannerController.m
//  IosBasic
//
//  Created by junshi on 16/8/23.
//  Copyright © 2016年 CRZ. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "QRCodeSannerController.h"
//#import "PayController.h"
#import "QRCodeReaderView.h"


#define  herizon_padding 20
#define  vertical_padding 30
#define  label_height 65
#define  font_size 17
#define  percent 0.64
#define  title_width 100
#define  title_height 44
#define  title_font_size 17


#define DeviceMaxHeight ([UIScreen mainScreen].bounds.size.height)
#define DeviceMaxWidth ([UIScreen mainScreen].bounds.size.width)
#define widthRate DeviceMaxWidth/320
#define IOS8 ([[UIDevice currentDevice].systemVersion intValue] >= 8 ? YES : NO)

@interface QRCodeSannerController()<QRCodeReaderViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate>
{
    QRCodeReaderView * readview;//二维码扫描对象
    
    BOOL isFirst;//第一次进入该页面
    BOOL isPush;//跳转到下一级页面
}

@property (strong, nonatomic) CIDetector *detector;

@end

@implementation QRCodeSannerController

- (void)viewDidLoad

{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    isFirst = YES;
    isPush = NO;
    
    [self InitScan];
}

    
#pragma mark 初始化扫描
    - (void)InitScan
    {
        if (readview) {
            [readview removeFromSuperview];
            readview = nil;
        }
        
        readview = [[QRCodeReaderView alloc]initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight)];
        readview.is_AnmotionFinished = YES;
        readview.backgroundColor = [UIColor clearColor];
        readview.delegate = self;
        readview.alpha = 0;
        
        [self.view addSubview:readview];
        
        [UIView animateWithDuration:0.5 animations:^{
            readview.alpha = 1;
        }completion:^(BOOL finished) {
            
        }];
        
    }
    
#pragma mark - 相册
    - (void)alumbBtnEvent
    {
        
        self.detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) { //判断设备是否支持相册
            
            if (IOS8) {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未开启访问相册权限，现在去开启！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alert.tag = 4;
                [alert show];
            }
            else{
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持访问相册，请在设置->隐私->照片中进行设置！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
            return;
        }
        
        isPush = YES;
        UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
        mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        mediaUI.mediaTypes = [UIImagePickerController         availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        mediaUI.allowsEditing = NO;
        mediaUI.delegate = self;
        [self presentViewController:mediaUI animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }];
        
        
    }
    
    - (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
    {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (!image){
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
        readview.is_Anmotion = YES;
        
        NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count >=1) {
            
            [picker dismissViewControllerAnimated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                
                CIQRCodeFeature *feature = [features objectAtIndex:0];
                NSString *scannedResult = feature.messageString;
                //播放扫描二维码的声音
                SystemSoundID soundID;
                NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:@"noticeMusic" ofType:@"wav"];
                AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
                AudioServicesPlaySystemSound(soundID);
                
                [self accordingQcode:scannedResult];
            }];
            
        }
        else{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该图片没有包含一个二维码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
            [picker dismissViewControllerAnimated:YES completion:^{
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
                
                readview.is_Anmotion = NO;
                [readview start];
            }];
        }
    }
    
    - (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
    {
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }];
        
    }
    
#pragma mark -QRCodeReaderViewDelegate
    - (void)readerScanResult:(NSString *)result
    {
        readview.is_Anmotion = YES;
        [readview stop];
        
        //播放扫描二维码的声音
        SystemSoundID soundID;
        NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:@"noticeMusic" ofType:@"wav"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
        AudioServicesPlaySystemSound(soundID);
        
        [self accordingQcode:result];
        
        [self performSelector:@selector(reStartScan) withObject:nil afterDelay:1.5];
    }
    
#pragma mark - 扫描结果处理
    - (void)accordingQcode:(NSString *)str
    {
//        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alertView show];
//        PayController *controller = [[PayController alloc] init];
//        controller.mobileNum = str;
//        [self.navigationController pushViewController:controller animated:YES];
        
    }
    
- (void)reStartScan
{
    readview.is_Anmotion = NO;
    
    if (readview.is_AnmotionFinished) {
        [readview loopDrawLine];
    }
    
    [readview start];
}
    
#pragma mark - view
    
- (void)viewDidDisappear:(BOOL)animated
    {
        [super viewDidDisappear:animated];
        
        if (readview) {
            [readview stop];
            readview.is_Anmotion = YES;
        }
        
    }
    
- (void)viewDidAppear:(BOOL)animated
    {
        [super viewDidAppear:animated];
        
        if (isFirst) {
            isFirst = NO;
        }
        if (isPush) {
            isPush = NO;
        }
    }
    

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
//    UIBarButtonItem *backBtn = [UIBarButtonItem NA_BarButtonWithImage:[UIImage imageNamed:@"ic_arrow_left"] width:12 height:22 target:self   action:@selector(backBtnAction)];
//    self.navigationItem.leftBarButtonItem = backBtn;
    
    [self addBackButton];
    
    
    UIBarButtonItem * rbbItem = [[UIBarButtonItem alloc]initWithTitle:@"相册" style:UIBarButtonItemStyleDone target:self action:@selector(alumbBtnEvent)];
    self.navigationItem.rightBarButtonItem = rbbItem;
    
    if (isFirst || isPush) {
        if (readview) {
            [self reStartScan];
        }
    }

    
}

- (void)backBtnAction{
    
    if(self.tabBarController){
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

}


@end
