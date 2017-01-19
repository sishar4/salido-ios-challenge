//
//  SWLogoutBarButtonItem.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/17/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWLogoutBarButtonItem.h"
#import "SWLoginViewController.h"

@implementation SWLogoutBarButtonItem

- (id)initFromViewController:(UIViewController *)viewController {
    
    self = [super init];
    if (self) {
        self.vc = viewController;
        [self setTitle:@"Logout"];
        [self setAction:@selector(goToLogin)];
    }
    
    return self;
}

- (void)goToLogin {
    
    //Reset app flags
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"downloadCompleted"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"searchParams"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Load Authentication.storyboard
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Authentication" bundle:nil];
    SWLoginViewController *viewController = [sb instantiateViewControllerWithIdentifier:@"SWLoginViewController"];
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.vc presentViewController:viewController animated:YES completion:NULL];
}

@end
