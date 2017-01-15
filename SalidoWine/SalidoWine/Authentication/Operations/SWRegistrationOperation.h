//
//  SWRegistrationOperation.h
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWUser.h"

@interface SWRegistrationOperation : NSOperation

@property (strong, nonatomic) SWUser *user;
@property (strong, nonatomic) NSString *userPin;
- (id)initWithUser:(SWUser *)user andPin:(NSString *)userPin;

@end
