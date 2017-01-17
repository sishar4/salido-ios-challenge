//
//  SWLoginOperation.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWLoginOperation.h"
#import "KeychainWrapper.h"
#import "SWUser.h"

@implementation SWLoginOperation

- (id)initWithUserPin:(NSString *)userPin andCompletionHandler:(void (^)(BOOL))completionHandler {
    
    self = [super init];
    if (self) {
        self.userPin = userPin;
        self.completionHandler = completionHandler;
    }
    
    return self;
}

- (void)main {
    
    if ([self isCancelled]) {
        NSLog(@"Login Operation cancelled");
    }
    
    self.completionHandler([self validateUserWithPin:self.userPin]);
}

- (BOOL)validateUserWithPin:(NSString *)pin {

    KeychainWrapper *keychain = [[KeychainWrapper alloc] init];
    if ([[keychain myObjectForKey:(id)kSecValueData] isEqualToString:pin]) {
        
        
        SWUser *sharedInstance = [SWUser sharedInstance];
        sharedInstance.firstName = [keychain myObjectForKey:(id)kSecAttrLabel];
        sharedInstance.lastName = [keychain myObjectForKey:(id)kSecAttrComment];
        
        return YES;
    }
    
    return NO;
}

@end
