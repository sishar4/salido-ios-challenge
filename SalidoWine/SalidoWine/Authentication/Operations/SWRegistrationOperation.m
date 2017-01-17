//
//  SWRegistrationOperation.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWRegistrationOperation.h"
#import "KeychainWrapper.h"

@implementation SWRegistrationOperation

- (id)initWithUser:(SWUser *)user andPin:(NSString *)userPin {
    
    self = [super init];
    if (self) {
        self.user = user;
        self.userPin = userPin;
    }
    
    return self;
}

- (void)main {
    
    if ([self isCancelled]) {
        NSLog(@"Login Operation cancelled");
    }
    
    [self registerNewUser];
}

- (void)registerNewUser {
    
    SWUser *sharedUser = [SWUser sharedInstance];
    sharedUser.firstName = self.user.firstName;
    sharedUser.lastName = self.user.lastName;
    
    if (self.user.emailAddress.length > 0) {
        sharedUser.emailAddress = self.user.emailAddress;
    }
    
    KeychainWrapper *keychain = [[KeychainWrapper alloc] init];
    [keychain mySetObject:self.userPin forKey:(id)kSecValueData];
}

@end
