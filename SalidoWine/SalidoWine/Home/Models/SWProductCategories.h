//
//  SWProductCategories.h
//  SalidoWine
//
//  Created by Sahil Ishar on 1/18/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWProductCategories : NSObject

@property (strong, nonatomic) NSMutableArray *categoriesArray;
+ (id)sharedInstance;

@end
