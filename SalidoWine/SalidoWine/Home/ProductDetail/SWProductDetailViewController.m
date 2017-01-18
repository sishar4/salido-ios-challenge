//
//  SWProductDetailViewController.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWProductDetailViewController.h"

@interface SWProductDetailViewController ()

@end

@implementation SWProductDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.productNameLabel setText:self.product.name];
    [self.productImageView setImage:self.productImage];
    
    UILabel *descriptionLabel = [[UILabel alloc] init];
    [descriptionLabel setNumberOfLines:0];
    [descriptionLabel setText:self.product.productDescription];
    [descriptionLabel sizeToFit];
    [self.scrollView addSubview:descriptionLabel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)dismissDetailView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
