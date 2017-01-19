//
//  SWFilterOperation.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/18/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWFilterOperation.h"
#import "SWProduct.h"
#import "defines.h"

@implementation SWFilterOperation

- (id)initWithNameQuery:(NSArray *)nameQuery categoryFilter:(NSArray *)categoryFilter byWinery:(BOOL)byWinery andCompletionHandler:(void (^)(NSArray *, NSSet *, BOOL))completionHandler {
    
    self = [super init];
    if (self) {
        self.completionHandler = completionHandler;
        self.namesArray = [[NSArray alloc] initWithArray:nameQuery];
        self.categoriesArray = [[NSArray alloc] initWithArray:categoryFilter];
        self.filterByWinery = byWinery;
    }
    
    return self;
}

- (void)main {
    
    if ([self isCancelled]) {
        NSLog(@"Filter Operation cancelled");
    }
    
    NSURLSessionConfiguration *urlSessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:urlSessionConfig delegate:nil delegateQueue:nil];
    
    NSString *urlString = [self formattedParameterString];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [urlRequest setHTTPMethod:@"GET"];
    
    //Make GET Request and handle response
    NSURLSessionDataTask *downloadFilteredProductsTask =
    [urlSession dataTaskWithRequest:urlRequest
                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                      
                      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                      NSLog(@"RESPONSE >>>>>> %@", response);
                      
                      if (!error && httpResponse.statusCode == 200) {
                          NSError *localError;
                          NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
                          
                          NSDictionary *products = [parsedObject valueForKey:@"Products"];
                          NSDictionary *list = [products valueForKey:@"List"];
                          
                          NSMutableArray *resultsArray = [[NSMutableArray alloc] init];
                          NSMutableSet *wineriesSet = [[NSMutableSet alloc] init];
                          for (NSDictionary *product in list) {
                              NSString *name = [product valueForKey:@"Name"];
                              NSString *description = [product valueForKey:@"Description"];
                              NSDictionary *labelsDict = [product valueForKey:@"Labels"];
                              NSString *imageURL = [[labelsDict valueForKey:@"Url"] objectAtIndex:0];
                              
                              SWProduct *productToAdd = [[SWProduct alloc] initWithName:name
                                                                            description:description
                                                                            andImageURL:imageURL];
                              
                              if (self.filterByWinery) {
                                  //Put arrays of products by winery into resultsArray
                                  NSDictionary *winery = [product valueForKey:@"Vineyard"];
                                  NSString *wineryName = [winery valueForKey:@"Name"];
                                  [wineriesSet addObject:[wineryName lowercaseString]];
                                  
                                  productToAdd.wineryName = [wineryName lowercaseString];
                              }
                              
                              [resultsArray addObject:productToAdd];
                          }
                          
                          self.completionHandler([resultsArray copy], [wineriesSet copy], YES);
                      }
                      else {
                          self.completionHandler(nil, nil, NO);
                      }
                  }];
    
    if ([self isCancelled]) {
        NSLog(@"Filter Operation cancelled");
    }
    
    [downloadFilteredProductsTask resume];
}

- (NSString *)formattedParameterString {
    
    //Format URL String
    NSMutableString *mutableString = [NSMutableString stringWithFormat:@"%@catalog?", kBaseUrl];
    
    if (self.namesArray.count > 0) {
        NSMutableString *mutString = [NSMutableString stringWithString:@"search="];
        for (int i = 0; i < self.namesArray.count; i++) {
            [mutString appendString:[self.namesArray objectAtIndex:i]];
            if (i == self.namesArray.count - 1) {
                [mutString appendString:@"&"];
            } else {
                [mutString appendString:@"+"];
            }
        }
        [mutableString appendString:mutString];
    }
    if (self.categoriesArray.count > 0) {
        NSMutableString *mutString = [NSMutableString stringWithString:@"filter=categories(490"];
        for (int i = 0; i < self.categoriesArray.count; i++) {
            [mutString appendString:[NSString stringWithFormat:@"+%@", [self.categoriesArray objectAtIndex:i]]];
            if (i == self.categoriesArray.count - 1) {
                [mutString appendString:@")&"];
            }
        }
        [mutableString appendString:mutString];
    }
    if (self.filterByWinery) {
        [mutableString appendString:@"sortBy=winery&"];
    }
    
    [mutableString appendString:[NSString stringWithFormat:@"apikey=%@", kApiKey]];
    
    return [mutableString copy];
}

@end
