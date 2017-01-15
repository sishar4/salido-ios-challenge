//
//  SWLoginViewController.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWLoginViewController.h"
#import "SWLoginOperation.h"

@interface SWLoginViewController ()

@end

@implementation SWLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)validateEnteredPinFormat {
    
    if (self.pinTextField.text.length < 4) {
        return NO;
    }
    
    //check if only numbers, no letters or punctuation
    
    return YES;
}

- (IBAction)loginClicked:(id)sender {
    
    if ([self validateEnteredPinFormat]) {
        [self loginUser];
    } else {
        //Display alert telling user to make sure to enter pin in textfield using only numbers
    }
    
}

- (void)loginUser {
    
    SWLoginOperation *loginOperation = [[SWLoginOperation alloc] initWithUserPin:self.pinTextField.text];
    [loginOperation setCompletionBlock:^{
        BOOL success = [[NSUserDefaults standardUserDefaults] boolForKey:@"didValidateUserSuccessfully"];
        if (success) {
            //Load Home.storyboard
        } else {
            //Display alert that Login failed
        }
    }];
    
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:loginOperation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
