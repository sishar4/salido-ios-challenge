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
    
    KeychainWrapper *keychain = [[KeychainWrapper alloc] init];
    [keychain mySetObject:self.userPin forKey:(id)kSecValueData];
    [keychain mySetObject:self.user.firstName forKey:(id)kSecAttrLabel];
    [keychain mySetObject:self.user.lastName forKey:(id)kSecAttrComment];
}

@end
