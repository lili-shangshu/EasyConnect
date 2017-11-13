//
//  InvoiceController.h
//  IosBasic
//
//  Created by li jun on 16/10/17.
//  Copyright © 2016年 CRZ. All rights reserved.
//

#import "NARootController.h"

@protocol InvoiceControllerDelegate <NSObject>

- (void)selectInvoiceType:(NSString *)string;

@end


@interface InvoiceController : NARootController
@property(weak,nonatomic)id<InvoiceControllerDelegate> delegate;
@end
