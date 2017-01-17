//
//  SWCartViewController.h
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWCartDataController.h"

@interface SWCartViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) SWCartDataController *dataController;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalItemsLabel;
@property (weak, nonatomic) IBOutlet UIButton *completePurchaseButton;
- (IBAction)completePurchasePressed:(id)sender;

@end
