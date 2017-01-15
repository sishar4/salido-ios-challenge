//
//  SWUser.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWUser.h"

@implementation SWUser

+ (id)sharedInstance
{
    static SWUser *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)initWithFirstName:(NSString *)firstName andLastName:(NSString *)lastName {
    
    self = [super init];
    if (self) {
        self.firstName = firstName;
        self.lastName = lastName;
    }
    
    return self;
}

@end
