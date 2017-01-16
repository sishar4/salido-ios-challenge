//
//  SWCartDataController.h
//  SalidoWine
//
//  Created by Sahil Ishar on 1/16/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWCartDataController : NSObject

- (void)addItemToCart:(NSString *)itemName withQuantity:(NSInteger)quantity Queue:(id)dispatch_queue_t_queue andCompletionHandler:(void (^)(BOOL))completionHandler;
- (void)removeItemFromCart:(NSString *)itemName withQueue:(id)dispatch_queue_t_queue andCompletionHandler:(void (^)(BOOL))completionHandler;
- (void)emptyCartWithQueue:(id)dispatch_queue_t_queue andCompletionHandler:(void (^)(BOOL))completionHandler;

@end
