//
//  SWCartBarButtonItem.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/16/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWCartBarButtonItem.h"
#import "SWCartViewController.h"

@implementation SWCartBarButtonItem

- (id)initFromViewController:(UIViewController *)viewController {
    
    self = [super init];
    if (self) {
        self.vc = viewController;
        [self setTitle:@"Cart"];
        [self setAction:@selector(goToShoppingCart)];
    }
    
    return self;
}

- (void)goToShoppingCart {
    
    //Load Cart view
    SWCartViewController *cartVC = [[SWCartViewController alloc] initWithNibName:@"SWCartViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:cartVC];
    [self.vc presentViewController:navController animated:YES completion:nil];
}

@end
