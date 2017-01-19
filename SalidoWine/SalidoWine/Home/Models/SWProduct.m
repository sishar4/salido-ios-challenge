//
//  SWProduct.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/17/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWProduct.h"

@implementation SWProduct

+ (id)sharedInstance
{
    static SWProduct *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.productsArray = [[NSMutableArray alloc] init];
        sharedInstance.wineriesSearchResults = [[NSMutableArray alloc] init];
    });
    
    return sharedInstance;
}

- (id)initWithName:(NSString *)name description:(NSString *)description andImageURL:(NSString *)imageURL {
    
    self = [super init];
    if (self) {
        self.name = name;
        self.productDescription = description;
        self.imageURL = imageURL;
    }
    
    return self;
}

@end
