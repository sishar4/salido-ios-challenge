//
//  SWCartDataController.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/16/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWCartDataController.h"
#import "SWShoppingCart.h"

@implementation SWCartDataController

- (void)addItemToCart:(NSString *)itemName withQuantity:(NSInteger)quantity Queue:(id)dispatch_queue_t_queue andCompletionHandler:(void (^)(BOOL))completionHandler {
    
    dispatch_block_t addItemBlock = dispatch_block_create_with_qos_class(0, QOS_CLASS_USER_INITIATED, 0, ^{
        
        SWShoppingCart *cart = [SWShoppingCart sharedInstance];
        if ([cart.items objectForKey:itemName]) {
            //Increment number by quantity
            NSInteger numInCart = [[cart.items objectForKey:itemName] integerValue];
            numInCart += quantity;
            //Set as new value
            [cart.items setObject:[NSNumber numberWithInteger:numInCart] forKey:itemName];
        } else {
            //Add item to cart with quantity as {itemName: quantity}
            [cart.items setObject:[NSNumber numberWithInteger:quantity] forKey:itemName];
        }
        
        //Increment cart.totalItems by quantity
        cart.totalItems += quantity;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(YES);
        });
    });
    
    dispatch_sync(dispatch_queue_t_queue, addItemBlock);
}

- (void)removeItemFromCart:(NSString *)itemName withQueue:(id)dispatch_queue_t_queue andCompletionHandler:(void (^)(BOOL))completionHandler {
    
    dispatch_block_t deleteItemBlock = dispatch_block_create_with_qos_class(0, QOS_CLASS_USER_INITIATED, 0, ^{
        
        SWShoppingCart *cart = [SWShoppingCart sharedInstance];
        //Decrement cart.totalItems by quantity for key -> item
        NSInteger numInCart = [[cart.items objectForKey:itemName] integerValue];
        cart.totalItems -= numInCart;
        //Remove object in cart.items
        [cart.items removeObjectForKey:itemName];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(YES);
        });
    });
    
    dispatch_sync(dispatch_queue_t_queue, deleteItemBlock);
}

- (void)emptyCartWithQueue:(id)dispatch_queue_t_queue andCompletionHandler:(void (^)(BOOL))completionHandler {
    
    dispatch_block_t emptyCartBlock = dispatch_block_create_with_qos_class(0, QOS_CLASS_USER_INITIATED, 0, ^{
        
        SWShoppingCart *cart = [SWShoppingCart sharedInstance];
        //Remove all objects in cart.items
        [cart.items removeAllObjects];
        //Set cart.totalItems to 0
        cart.totalItems = 0;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(YES);
        });
    });
    
    dispatch_sync(dispatch_queue_t_queue, emptyCartBlock);
}

@end
