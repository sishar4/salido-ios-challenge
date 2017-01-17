//
//  SWPurchaseConfirmationViewController.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWPurchaseConfirmationViewController.h"
#import "SWUser.h"
#import "SWCatalogViewController.h"
#import "SWLoginViewController.h"

@interface SWPurchaseConfirmationViewController ()

@end

@implementation SWPurchaseConfirmationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    SWUser *sharedUser = [SWUser sharedInstance];
    [self.firstNameLabel setText:[NSString stringWithFormat:@"Thank you %@, for completing you order with us. Your items will arrive shortly.", sharedUser.firstName]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)backToBrowsePressed:(id)sender {
    
    //Load Home.storyboard
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    SWCatalogViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SWCatalogViewController"];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:navController animated:YES completion:NULL];
}

- (IBAction)logoutPressed:(id)sender {
    
    //Load Authentication.storyboard
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Authentication" bundle:nil];
    SWLoginViewController *viewController = [sb instantiateViewControllerWithIdentifier:@"SWLoginViewController"];
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:viewController animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
