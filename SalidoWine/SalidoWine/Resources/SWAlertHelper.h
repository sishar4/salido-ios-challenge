//
//  SWAlertHelper.h
//  SalidoWine
//
//  Created by Sahil Ishar on 1/15/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SWAlertHelper : NSObject

+ (void)presentAlertFromViewController:(UIViewController *)viewController withTitle:(NSString *)title andMessage:(NSString *)message;
+ (void)presentAlertFromViewController:(UIViewController *)viewController withTitle:(NSString *)title message:(NSString *)message andOkBlock:(void (^)())okBlock;

@end
