//
//  SWProduct.h
//  SalidoWine
//
//  Created by Sahil Ishar on 1/17/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWProduct : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *productDescription;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *wineryName;

@property (strong, nonatomic) NSMutableArray *productsArray;

+ (id)sharedInstance;
- (id)initWithName:(NSString *)name description:(NSString *)description andImageURL:(NSString *)imageURL;

@end
