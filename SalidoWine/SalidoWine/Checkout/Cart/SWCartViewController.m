//
//  SWCartViewController.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWCartViewController.h"
#import "SWCartTableViewCell.h"
#import "SWShoppingCart.h"
#import "SWLoginOperation.h"
#import "SWAlertHelper.h"
#import "SWPinFormatCheckerHelper.h"
#import "SWPurchaseOperation.h"
#import "SWProductDetailViewController.h"
#import "SWLogoutBarButtonItem.h"

@interface SWCartViewController ()

@property (strong, nonatomic) SWShoppingCart *shoppingCart;
@property (strong, nonatomic) NSString *pinCopy;
@property (strong, nonatomic) NSMutableArray *purchaseItemsArray;
@property (strong, nonatomic) NSOperationQueue *purchaseOperationQueue;
@end

@implementation SWCartViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.purchaseItemsArray.count > 0) {
        [self.purchaseItemsArray removeAllObjects];
    }
    
    [self.purchaseItemsArray addObjectsFromArray:self.shoppingCart.itemsArray];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.shoppingCart = [SWShoppingCart sharedInstance];
    [self addObserver:self.shoppingCart forKeyPath:@"totalItems" options:NSKeyValueObservingOptionNew context:nil];
    self.dataController = [[SWCartDataController alloc] init];
    self.purchaseItemsArray = [[NSMutableArray alloc] init];
    self.purchaseOperationQueue = [[NSOperationQueue alloc] init];
    [self.tableView registerClass:[SWCartTableViewCell class] forCellReuseIdentifier:@"CartTableViewCell"];
    
    //Nav Bar setup
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismissCart:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    SWLogoutBarButtonItem *logoutBarButton = [[SWLogoutBarButtonItem alloc] initFromViewController:self];
    self.navigationItem.rightBarButtonItem = logoutBarButton;
    self.navigationItem.title = @"Shopping Cart";
}

- (IBAction)dismissCart:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)completePurchasePressed:(id)sender {
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Confirm Purchase"
                                                                              message: @"Please validate your account pin to complete this purchase. Thank you."
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"PIN";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.secureTextEntry = YES;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField *pinTextField = textfields[0];
        //Check if pin format and input is acceptable
        if (pinTextField.text.length == 4 && ![SWPinFormatCheckerHelper validateFormatOfPinWithString:pinTextField.text]) {
            self.pinCopy = pinTextField.text;
            [self confirmPurchase];
        } else {
            //Display alert telling user to make sure to enter pin in textfield using only numbers
            [SWAlertHelper presentAlertFromViewController:self
                                                withTitle:@"Invalid Input"
                                               andMessage:@"Pin can only contain numeric (0-9) values."];
        }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)confirmPurchase {
    
    SWLoginOperation *loginOperation = [[SWLoginOperation alloc] initWithUserPin:self.pinCopy
                                                            andCompletionHandler:^(BOOL success) {
        
        if (!success) {
            //Display alert that Login failed
            [SWAlertHelper presentAlertFromViewController:self
                                                withTitle:@"Invalid Pin"
                                               andMessage:@"Incorrect pin entered. Please try again."];
            //Cancel purchase
            [self.purchaseOperationQueue cancelAllOperations];
        }
    }];
    
    SWPurchaseOperation *purchaseOperation = [[SWPurchaseOperation alloc] initWithItems:self.purchaseItemsArray
                                                                   andCompletionHandler:^(BOOL success) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (success) {
                [self performSegueWithIdentifier:@"confirmPurchase" sender:nil];
            } else {
                //Display alert that Purchase failed
                [SWAlertHelper presentAlertFromViewController:self
                                                    withTitle:@"Unable to Purchase"
                                                   andMessage:@"Purchase was not able to be completed. Please try again."];
            }
        }];
    }];
    
    [purchaseOperation addDependency:loginOperation];
    [self.purchaseOperationQueue addOperation:loginOperation];
    [self.purchaseOperationQueue addOperation:purchaseOperation];
}

- (void)cellShowDetailButtonPressed:(UIButton *)sender {
    
    SWProductDetailViewController *productDetailVC = [[SWProductDetailViewController alloc] initWithNibName:@"SWProductDetailViewController" bundle:nil];
    //Set productDetailVC.product
    [self presentViewController:productDetailVC animated:YES completion:nil];
}

- (void)cellDeleteButtonPressed:(UIButton *)sender {
    
    dispatch_queue_t removeItemQueue = dispatch_queue_create("com.salidowine.remove", DISPATCH_QUEUE_SERIAL);
    [self.dataController removeItemFromCart:@"Stub" withQueue:removeItemQueue andCompletionHandler:^(BOOL success) {
        
        if (success) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationTop];
        }
    }];
}

#pragma UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.purchaseItemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cartCellIdentifier = @"CartTableViewCell";
    
    SWCartTableViewCell *cell = (SWCartTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cartCellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SWCartTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //set cell.productImageView
    //set cell.productNameLabel
    //set cell.quantityLabel
    cell.showDetailButton.tag = indexPath.row;
    [cell.showDetailButton addTarget:self action:@selector(cellShowDetailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleteButton.tag = indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(cellDeleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"From KVO");
    
    if([keyPath isEqualToString:@"totalItems"])
    {
        id val = [change objectForKey:NSKeyValueChangeNewKey];
        NSLog(@"New total = %@", val);
        [self.totalItemsLabel setText:[NSString stringWithFormat:@"%@", val]];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self removeObserver:self.shoppingCart forKeyPath:@"totalItems"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
