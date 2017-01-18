//
//  SWCatalogCollectionViewCell.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/17/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWCatalogCollectionViewCell.h"
#import "SWCartDataController.h"

@implementation SWCatalogCollectionViewCell

- (IBAction)addToCartPressed:(id)sender {
    
    NSLog(@"PRESSED ADD TO CART");\
    
    SWCartDataController *dataController = [[SWCartDataController alloc] init];
    dispatch_queue_t addItemQueue = dispatch_queue_create("com.salidowine.addcell", DISPATCH_QUEUE_SERIAL);
    
    [dataController addItemToCart:self.product
                     withQuantity:1
                            queue:addItemQueue
             andCompletionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"SUCCESSFULLY ADDED TO CART");
        }
    }];
}

@end
