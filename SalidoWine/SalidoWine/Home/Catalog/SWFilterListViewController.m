//
//  SWFilterListViewController.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWFilterListViewController.h"
#import "SWCartBarButtonItem.h"
#import "SWLogoutBarButtonItem.h"

@interface SWFilterListViewController ()

@end

@implementation SWFilterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SWCartBarButtonItem *cartBarButton = [[SWCartBarButtonItem alloc] initFromViewController:self];
    SWLogoutBarButtonItem *logoutBarButton = [[SWLogoutBarButtonItem alloc] initFromViewController:self];
    NSArray *rightButtonsArray = [NSArray arrayWithObjects:logoutBarButton, cartBarButton, nil];
    [self.navigationItem setRightBarButtonItems:rightButtonsArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
