//
//  SWLoginViewController.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWLoginViewController.h"
#import "SWLoginOperation.h"
#import "SWPinFormatCheckerHelper.h"
#import "SWAlertHelper.h"
#import "SWCatalogViewController.h"

@interface SWLoginViewController ()

@end

@implementation SWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)validateForm {
    
    if (self.pinTextField.text.length < 4) {
        return NO;
    }
    if (![SWPinFormatCheckerHelper validateFormatOfPinWithString:self.pinTextField.text]) {
        return NO;
    }
    
    return YES;
}

- (IBAction)loginClicked:(id)sender {
    //Check if pin format and input is acceptable
    if ([self validateForm]) {
        [self loginUser];
    } else {
        //Display alert telling user to make sure to enter pin in textfield using only numbers
        [SWAlertHelper presentAlertFromViewController:self
                                            withTitle:@"Invalid Input"
                                           andMessage:@"Pin must be 4 digits and can only contain numeric (0-9) values."];
    }
}

- (void)loginUser {
    
    SWLoginOperation *loginOperation = [[SWLoginOperation alloc] initWithUserPin:self.pinTextField.text
                                                            andCompletionHandler:^(BOOL success) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (success) {
                //Load Home.storyboard
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
                SWCatalogViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SWCatalogViewController"];
                [self presentViewController:vc animated:YES completion:NULL];
            } else {
                //Display alert that Login failed
                [SWAlertHelper presentAlertFromViewController:self
                                                    withTitle:@"Invalid Pin"
                                                   andMessage:@"Incorrect pin entered. Please try again."];
            }
        }];
    }];

    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:loginOperation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
