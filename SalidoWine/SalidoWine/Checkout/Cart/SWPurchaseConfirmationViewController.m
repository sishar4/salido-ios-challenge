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

@interface SWPurchaseConfirmationViewController ()

@end

@implementation SWPurchaseConfirmationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    SWUser *sharedUser = [SWUser sharedInstance];
    [self.fullNameLabel setText:[NSString stringWithFormat:@"%@ %@", sharedUser.firstName, sharedUser.lastName]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)backToBrowsePressed:(id)sender {
    
    //Load Home.storyboard
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    SWCatalogViewController *vc = [sb instantiateInitialViewController];
    [self presentViewController:vc animated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
