//
//  SWAlertHelper.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/15/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWAlertHelper.h"

@implementation SWAlertHelper

+ (void)presentAlertFromViewController:(UIViewController *)viewController withTitle:(NSString *)title andMessage:(NSString *)message {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *removeAlert = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
    [alert addAction:removeAlert];
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

+ (void)presentAlertFromViewController:(UIViewController *)viewController withTitle:(NSString *)title message:(NSString *)message andOkBlock:(void (^)())okBlock {
    
    //Create UIAlertController with custom action handler
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:okBlock];
    [alert addAction:okAlertAction];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

@end
