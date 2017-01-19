//
//  SWDownloadCategoriesOperation.h
//  SalidoWine
//
//  Created by Sahil Ishar on 1/18/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWDownloadCategoriesOperation : NSOperation

@property (copy, nonatomic) void(^completionHandler)(NSArray *results, BOOL success);
- (id)initWithCompletionHandler:(void (^)(NSArray *results, BOOL success))completionHandler;

@end
