//
//  SWCatalogViewController.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWCatalogViewController.h"
#import "SWCartBarButtonItem.h"
#import "SWLogoutBarButtonItem.h"

@interface SWCatalogViewController ()

@end

@implementation SWCatalogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SWCartBarButtonItem *cartBarButton = [[SWCartBarButtonItem alloc] initFromViewController:self];
    self.navigationItem.leftBarButtonItem = cartBarButton;
    SWLogoutBarButtonItem *logoutBarButton = [[SWLogoutBarButtonItem alloc] initFromViewController:self];
    self.navigationItem.rightBarButtonItem = logoutBarButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
