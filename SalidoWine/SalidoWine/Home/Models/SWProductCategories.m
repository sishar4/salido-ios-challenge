//
//  SWProductCategories.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/18/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWProductCategories.h"

@implementation SWProductCategories

+ (id)sharedInstance
{
    static SWProductCategories *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.categoriesArray = [[NSMutableArray alloc] init];
    });
    
    return sharedInstance;
}

@end
