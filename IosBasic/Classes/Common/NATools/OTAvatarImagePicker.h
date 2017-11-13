//
//  LSAvatarImagePicker.h
//  Lifesense
//
//  Created by Nathan Ou on 9/23/13.
//  Copyright (c) 2013 Xtreme Programming Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OTAvatarImagePickerDelegate;

@interface OTAvatarImagePicker : NSObject <UIImagePickerControllerDelegate, UINavigationBarDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) id <OTAvatarImagePickerDelegate> delegate;

@property (nonatomic, strong) UIImage *Image;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) UIButton *takePhotoButton;

@property(nonatomic)BOOL isback;

+ (instancetype)sharedInstance;

- (void)getImageFromCameraInIphone:(UIViewController *)controller;
- (void)getImageFromAlbumInIphone:(UIViewController *)controller;


- (void)getImageFromCameraInIphone:(UIViewController *)controller isback:(BOOL)isback;
- (void)getImageFromAlbumInIphone:(UIViewController *)controller isback:(BOOL)isback;


@end

@protocol OTAvatarImagePickerDelegate <NSObject>

@optional
- (void)getImageFromWidget:(UIImage *)image;
- (void)getImageFromWidget:(UIImage *)image back:(BOOL)isback;
@end
