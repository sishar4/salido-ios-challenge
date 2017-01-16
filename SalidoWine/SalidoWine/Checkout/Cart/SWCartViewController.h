//
//  SWCartViewController.h
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWCartViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *totalItemsLabel;
@property (weak, nonatomic) IBOutlet UIButton *completePurchaseButton;
- (IBAction)completePurchasePressed:(id)sender;

@end
