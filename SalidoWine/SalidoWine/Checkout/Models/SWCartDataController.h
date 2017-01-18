//
//  SWCartDataController.h
//  SalidoWine
//
//  Created by Sahil Ishar on 1/16/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWProduct.h"

@interface SWCartDataController : NSObject

- (void)addItemToCart:(SWProduct *)product withQuantity:(NSInteger)quantity queue:(id)dispatch_queue_t_queue andCompletionHandler:(void (^)(BOOL))completionHandler;
- (void)removeItemFromCart:(SWProduct *)product withQueue:(id)dispatch_queue_t_queue andCompletionHandler:(void (^)(BOOL))completionHandler;
- (void)emptyCartWithQueue:(id)dispatch_queue_t_queue andCompletionHandler:(void (^)(BOOL))completionHandler;

@end
