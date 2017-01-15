//
//  SWLoginOperation.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWLoginOperation.h"
#import "KeychainWrapper.h"

@implementation SWLoginOperation

- (id)initWithUserPin:(NSString *)userPin {
    
    self = [super init];
    if (self) {
        self.userPin = userPin;
    }
    
    return self;
}

- (void)main {
    
    if ([self isCancelled]) {
        NSLog(@"Login Operation cancelled");
    }
    
    BOOL loginAttempt = [self validateUserWithPin:self.userPin];
    [[NSUserDefaults standardUserDefaults] setBool:loginAttempt forKey:@"didValidateUserSuccessfully"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)validateUserWithPin:(NSString *)pin {

    KeychainWrapper *keychain = [[KeychainWrapper alloc] init];
    if ([keychain myObjectForKey:@"PIN"]) {
        return YES;
    }
    
    return NO;
}

@end
