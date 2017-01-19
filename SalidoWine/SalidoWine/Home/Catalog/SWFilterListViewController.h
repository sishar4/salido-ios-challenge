//
//  SWFilterListViewController.h
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SWFilterCatalogProtocol <NSObject>

- (void)filterCatalogWithNameQuery:(NSArray *)nameQuery categoryFilter:(NSArray *)categoryFilter andByWinery:(BOOL)sortByWinery;

@end

@interface SWFilterListViewController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) id <SWFilterCatalogProtocol> delegate;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UISwitch *winerySwitch;

- (IBAction)clearButtonPressed:(id)sender;

@end
