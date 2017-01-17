//
//  SWPurchaseConfirmationViewController.h
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWPurchaseConfirmationViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
- (IBAction)backToBrowsePressed:(id)sender;
- (IBAction)logoutPressed:(id)sender;

@end
