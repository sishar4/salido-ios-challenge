//
//  SWFilterOperation.h
//  SalidoWine
//
//  Created by Sahil Ishar on 1/18/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWFilterOperation : NSOperation

@property (strong, nonatomic) NSArray *namesArray;
@property (strong, nonatomic) NSArray *categoriesArray;
@property (assign, nonatomic) BOOL filterByWinery;

@property (copy, nonatomic) void(^completionHandler)(NSArray *results, NSSet *wineriesResults, BOOL success);

- (id)initWithNameQuery:(NSArray *)nameQuery categoryFilter:(NSArray *)categoryFilter byWinery:(BOOL)byWinery andCompletionHandler:(void (^)(NSArray *results, NSSet *wineriesResults, BOOL success))completionHandler;

@end
