//
//  SWLogoutBarButtonItem.h
//  SalidoWine
//
//  Created by Sahil Ishar on 1/17/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWLogoutBarButtonItem : UIBarButtonItem

@property (nonatomic, weak) UIViewController *vc;
- (id)initFromViewController:(UIViewController *)viewController;

@end
