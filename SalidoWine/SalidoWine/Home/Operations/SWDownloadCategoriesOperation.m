//
//  SWDownloadCategoriesOperation.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/18/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWDownloadCategoriesOperation.h"
#import "defines.h"

@implementation SWDownloadCategoriesOperation

- (id)initWithCompletionHandler:(void (^)(NSArray *, BOOL))completionHandler {
    
    self = [super init];
    if (self) {
        self.completionHandler = completionHandler;
    }
    
    return self;
}

- (void)main {
    
    if ([self isCancelled]) {
        NSLog(@"DownloadCategories Operation cancelled");
    }
    
    NSURLSessionConfiguration *urlSessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:urlSessionConfig delegate:nil delegateQueue:nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@categorymap?filter=categories(490)&apikey=%@", kBaseUrl, kApiKey];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [urlRequest setHTTPMethod:@"GET"];
    
    //Make GET Request and handle response
    NSURLSessionDataTask *downloadCategoriesTask =
    [urlSession dataTaskWithRequest:urlRequest
                  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                      
                      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                      NSLog(@"RESPONSE >>>>>> %@", response);
                      
                      if (!error && httpResponse.statusCode == 200) {
                          NSError *localError;
                          NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
                          
                          NSArray *categories = [parsedObject valueForKey:@"Categories"];
                          NSDictionary *categoryDict = [categories objectAtIndex:0];
                          NSArray *refinementsArray = [categoryDict valueForKey:@"Refinements"];
                          
                          NSMutableArray *resultsArray = [[NSMutableArray alloc] initWithArray:refinementsArray];
                          self.completionHandler([resultsArray copy], YES);
                      }
                      else {
                          self.completionHandler(nil, NO);
                      }
                  }];
    
    if ([self isCancelled]) {
        NSLog(@"DownloadCategories Operation cancelled");
    }
    
    [downloadCategoriesTask resume];
}

@end
