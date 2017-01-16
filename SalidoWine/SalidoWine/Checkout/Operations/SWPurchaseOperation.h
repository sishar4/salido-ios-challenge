//
//  SWPurchaseOperation.h
//  SalidoWine
//
//  Created by Sahil Ishar on 1/16/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWCartDataController.h"

@interface SWPurchaseOperation : NSOperation

@property (strong, nonatomic) SWCartDataController *dataController;
@property (strong, nonatomic) NSArray *itemsToPurchase;
@property (copy, nonatomic) void(^completionHandler)(BOOL success);

- (id)initWithItems:(NSArray *)items andCompletionHandler:(void (^)(BOOL success))completionHandler;

@end
