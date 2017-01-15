//
//  SWUser.h
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWUser : NSObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *emailAddress;

+ (id)sharedInstance;
- (id)initWithFirstName:(NSString *)firstName andLastName: (NSString *)lastName;

@end
