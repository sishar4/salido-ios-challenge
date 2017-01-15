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
    
    //check if only numbers, no letters or punctuation
    
    return YES;
}

- (IBAction)registerClicked:(id)sender {
    
    if ([self validateForm]) {
        [self registerUser];
    } else {
        //Display alert telling user to make sure to enter pin in textfield using only numbers
    }
    
}

- (void)registerUser {
    
    SWUser *userObj = [[SWUser alloc] initWithFirstName:self.firstNameTextField.text andLastName:self.lastNameTextField.text];
    if (self.emailAddressTextField.text.length > 0) {
        userObj.emailAddress = self.emailAddressTextField.text;
    }
    
    SWRegistrationOperation *registrationOperation = [[SWRegistrationOperation alloc] initWithUser:userObj andPin:self.pinTextField.text];
    [registrationOperation setCompletionBlock:^{
        //Load Home.storyboard
    }];
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:registrationOperation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end