//
//  SWLoginViewController.h
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWLoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *pinTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginClicked:(id)sender;
- (void)loginUser;

@end
