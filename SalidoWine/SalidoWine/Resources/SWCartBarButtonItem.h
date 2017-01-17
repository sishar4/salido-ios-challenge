//
//  SWCartBarButtonItem.h
//  SalidoWine
//
//  Created by Sahil Ishar on 1/16/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWCartBarButtonItem : UIBarButtonItem

@property (nonatomic, weak) UIViewController *vc;
- (id)initFromViewController:(UIViewController *)viewController;

@end
