//
//  LSAvatarImagePicker.m
//  Lifesense
//
//  Created by Nathan Ou on 9/23/13.
//  Copyright (c) 2013 Xtreme Programming Group. All rights reserved.
//

#import "OTAvatarImagePicker.h"

#define TAKE_PHOTO_VIEW 666

@implementation OTAvatarImagePicker

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)getImageFromCameraInIphone:(UIViewController *)controller
{
    self.rootViewController = controller;
    [self loadImagePick:UIImagePickerControllerSourceTypeCamera];
}

- (void)getImageFromAlbumInIphone:(UIViewController *)controller
{
    self.rootViewController = controller;
    [self loadImagePick:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)getImageFromCameraInIphone:(UIViewController *)controller isback:(BOOL)isback{
    self.rootViewController = controller;
    self.isback = isback;
    [self loadImagePick:UIImagePickerControllerSourceTypeCamera];
    
}
- (void)getImageFromAlbumInIphone:(UIViewController *)controller isback:(BOOL)isback{
    self.rootViewController = controller;
    self.isback = isback;
    [self loadImagePick:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (UIView *)findView:(UIView *)aView withName:(NSString *)name
{
    Class cl = [aView class];
    NSString *desc = [cl description];

    if ([name isEqualToString:desc])
        return aView;

    for (NSUInteger i = 0; i < [aView.subviews count]; i++) {
        UIView *subView = [aView.subviews objectAtIndex:i];
        subView = [self findView:subView withName:name];
        if (subView)
            return subView;
    }
    return nil;
}

- (void)loadImagePick:(UIImagePickerControllerSourceType)sourceType
{
//    applySystemDefaultApprence();
    
    if (!self.picker) {
        self.picker = [[UIImagePickerController alloc] init];
        self.picker.allowsEditing = YES;
        [self.picker setDelegate:self];
    }

    //需要检测  flash 能否用， 有没相机。。。
    if (UIImagePickerControllerSourceTypeCamera == sourceType) {
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            [self.picker setSourceType:sourceType];
            [self.picker setAllowsEditing:YES];
            self.picker.view.top = 64.f;
            [self.rootViewController presentViewController:self.picker animated:YES completion:^{}];
        }
    } else {
        [self.picker setSourceType:sourceType];
        [self.picker setAllowsEditing:YES];
        [self.rootViewController presentViewController:self.picker animated:YES completion:^{}];
       // [UINavigationController setToDefaultApprence];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  //  [UINavigationController applyDefaultApprence];
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
//        if ([self.delegate respondsToSelector:@selector(getImageFromWidget:)]) {
//            [_delegate getImageFromWidget:image];
//        }
        
        [self.delegate getImageFromWidget:image back:_isback];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [UINavigationController applyDefaultApprence];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
