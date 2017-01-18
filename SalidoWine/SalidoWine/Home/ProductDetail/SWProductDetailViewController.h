//
//  SWProductDetailViewController.h
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWProduct.h"

@interface SWProductDetailViewController : UIViewController

@property (strong, nonatomic) SWProduct *product;
@property (assign, nonatomic) UIImage *productImage;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;

- (IBAction)dismissDetailView:(id)sender;

@end
