//
//  SWLoginOperation.h
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWLoginOperation : NSOperation

@property (strong, nonatomic) NSString *userPin;
@property (copy, nonatomic) void(^completionHandler)(BOOL success);

- (id)initWithUserPin:(NSString *)userPin andCompletionHandler:(void (^)(BOOL success))completionHandler;

@end
