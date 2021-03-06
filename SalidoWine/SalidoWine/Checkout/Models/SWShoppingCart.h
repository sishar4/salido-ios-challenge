//
//  SWShoppingCart.h
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWShoppingCart : NSObject

@property (strong, nonatomic) NSMutableDictionary *items;
@property (strong, nonatomic) NSMutableArray *itemsArray;  //To track order of items added to cart
@property (assign, nonatomic) NSInteger totalItems;

+ (id)sharedInstance;

@end
