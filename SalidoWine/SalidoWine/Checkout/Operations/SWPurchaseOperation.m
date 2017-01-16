//
//  SWPurchaseOperation.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/16/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWPurchaseOperation.h"

@implementation SWPurchaseOperation

- (id)initWithItems:(NSArray *)items andCompletionHandler:(void (^)(BOOL))completionHandler {
    
    self = [super init];
    if (self) {
        self.itemsToPurchase = items;
        self.completionHandler = completionHandler;
    }
    
    return self;
}

- (void)main {
    
    if ([self isCancelled]) {
        NSLog(@"Purchase Operation cancelled");
    }
    
    dispatch_queue_t purchaseQueue = dispatch_queue_create("com.salidowine.purchase", DISPATCH_QUEUE_SERIAL);
    self.dataController = [[SWCartDataController alloc] init];
    
    if ([self isCancelled]) {
        NSLog(@"Purchase Operation cancelled");
    }
    
    [self.dataController emptyCartWithQueue:purchaseQueue andCompletionHandler:^(BOOL success) {
        
        self.completionHandler(success);
    }];
}

@end
