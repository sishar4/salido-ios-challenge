//
//  SWRegistrationViewController.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWRegistrationViewController.h"
#import "SWUser.h"
#import "SWRegistrationOperation.h"
#import "SWPinFormatCheckerHelper.h"
#import "SWAlertHelper.h"
#import "SWCatalogViewController.h"

@interface SWRegistrationViewController ()

@end

@implementation SWRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)validateForm {
    
    if (self.pinTextField.text.length < 4 || self.firstNameTextField.text.length == 0 || self.lastNameTextField.text.length == 0) {
        return NO;
    }
    if (![SWPinFormatCheckerHelper validateFormatOfPinWithString:self.pinTextField.text]) {
        return NO;
    }
    
    return YES;
}

- (IBAction)registerClicked:(id)sender {
    //Check if pin format and input is acceptable
    if ([self validateForm]) {
        [self registerUser];
    } else {
        //Display alert telling user to make sure to enter pin in textfield using only numbers
        [SWAlertHelper presentAlertFromViewController:self
                                            withTitle:@"Invalid Input"
                                           andMessage:@"Pin can only contain numeric (0-9) values."];
    }
}

- (void)registerUser {
    
    SWUser *userObj = [[SWUser alloc] initWithFirstName:self.firstNameTextField.text
                                            andLastName:self.lastNameTextField.text];
    if (self.emailAddressTextField.text.length > 0) {
        userObj.emailAddress = self.emailAddressTextField.text;
    }
    
    SWRegistrationOperation *registrationOperation = [[SWRegistrationOperation alloc] initWithUser:userObj
                                                                                            andPin:self.pinTextField.text];
    [registrationOperation setCompletionBlock:^{
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //Load Home.storyboard
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
            SWCatalogViewController *vc = [sb instantiateInitialViewController];
            [self presentViewController:vc animated:YES completion:NULL];
        }];    
    }];
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:registrationOperation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
