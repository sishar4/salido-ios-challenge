//
//  SWPurchaseConfirmationViewController.h
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWPurchaseConfirmationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *backToBrowseButton;
- (IBAction)backToBrowsePressed:(id)sender;

@end
