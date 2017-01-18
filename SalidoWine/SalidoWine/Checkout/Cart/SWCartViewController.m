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
#import "SWProduct.h"
#import "SWLoginOperation.h"
#import "SWAlertHelper.h"
#import "SWPinFormatCheckerHelper.h"
#import "SWPurchaseOperation.h"
#import "SWProductDetailViewController.h"
#import "SWLogoutBarButtonItem.h"
#import "SWPurchaseConfirmationViewController.h"

@interface SWCartViewController ()

@property (strong, nonatomic) SWShoppingCart *shoppingCart;
@property (strong, nonatomic) NSString *pinCopy;
@property (strong, nonatomic) NSMutableArray *purchaseItemsArray;
@property (strong, nonatomic) NSOperationQueue *purchaseOperationQueue;
@property (strong, nonatomic) NSCache *imageCache;
@end

@implementation SWCartViewController

- (void)updateUI {
    
    [self.tableView reloadData];
    [self.totalItemsLabel setText:[NSString stringWithFormat:@"%ld items", (long)self.shoppingCart.totalItems]];
    
    //Make completePurchaseButton inactive if cart is empty
    if (self.purchaseItemsArray.count == 0) {
        [self.completePurchaseButton setUserInteractionEnabled:NO];
        [self.completePurchaseButton setBackgroundColor:[UIColor lightGrayColor]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Check if there is a difference between global array of items for shopping cart and local array
    if (self.purchaseItemsArray.count != self.shoppingCart.itemsArray.count) {
        [self.purchaseItemsArray removeAllObjects];
        [self.purchaseItemsArray addObjectsFromArray:self.shoppingCart.itemsArray];
    }
    
    [self updateUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.shoppingCart = [SWShoppingCart sharedInstance];
    self.dataController = [[SWCartDataController alloc] init];
    self.purchaseItemsArray = [[NSMutableArray alloc] init];
    self.imageCache = [[NSCache alloc] init];
    self.purchaseOperationQueue = [[NSOperationQueue alloc] init];
    
    //Table View setup
    [self.tableView registerClass:[SWCartTableViewCell class] forCellReuseIdentifier:@"CartTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SWCartTableViewCell" bundle:nil] forCellReuseIdentifier:@"CartTableViewCell"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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
        if (pinTextField.text.length == 4 && [SWPinFormatCheckerHelper validateFormatOfPinWithString:pinTextField.text]) {
            self.pinCopy = pinTextField.text;
            [self confirmPurchase];
        } else {
            //Display alert telling user to make sure to enter pin in textfield using only numbers
            [SWAlertHelper presentAlertFromViewController:self
                                                withTitle:@"Invalid Input"
                                               andMessage:@"Pin must be 4 digits and can only contain numeric (0-9) values."];
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
                //Load ConfirmPurchase view
                SWPurchaseConfirmationViewController *cartVC = [[SWPurchaseConfirmationViewController alloc] initWithNibName:@"SWPurchaseConfirmationViewController" bundle:nil];
                [self presentViewController:cartVC animated:YES completion:nil];
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

- (void)cellDeleteButtonPressed:(UIButton *)sender {
    
    SWProduct *product = (SWProduct *)[self.purchaseItemsArray objectAtIndex:sender.tag];
    dispatch_queue_t removeItemQueue = dispatch_queue_create("com.salidowine.remove", DISPATCH_QUEUE_SERIAL);
    [self.dataController removeItemFromCart:product withQueue:removeItemQueue andCompletionHandler:^(BOOL success) {
        
        if (success) {
            [self.purchaseItemsArray removeObjectAtIndex:sender.tag];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationLeft];
            [self updateUI];
        }
    }];
}

#pragma mark - UITableView Delegate

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
    
    SWProduct *product = (SWProduct *)[self.purchaseItemsArray objectAtIndex:indexPath.row];
    [cell.productNameLabel setText:product.name];
    
    NSNumber *count = [self.shoppingCart.items objectForKey:product.name];
    [cell.quantityLabel setText:[NSString stringWithFormat:@"Quantity: %d", [count intValue]]];
    
    cell.productImageView.image = nil;
    
    //Check if product image was previously cached
    if ([self.imageCache objectForKey:product.imageURL]) {
        [cell.productImageView setImage:[self.imageCache objectForKey:product.imageURL]];
    } else {
        //If not, asynchronously download image from url
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //Download image asynchronously
            UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:product.imageURL]]];
            [self.imageCache setObject:img forKey:product.imageURL];
            if (img) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    SWCartTableViewCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
                    if (cell) {
                        [cell.productImageView setImage:img];
                    }
                });
            }
        });
    }

    cell.deleteButton.tag = indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(cellDeleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SWProduct *product = (SWProduct *)[self.purchaseItemsArray objectAtIndex:indexPath.row];
    
    SWProductDetailViewController *productDetailVC = [[SWProductDetailViewController alloc] initWithNibName:@"SWProductDetailViewController" bundle:nil];
    productDetailVC.product = product;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:productDetailVC];
    [self presentViewController:navController animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 120.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
