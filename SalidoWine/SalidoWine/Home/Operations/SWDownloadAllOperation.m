//
//  SWDownloadAllOperation.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/17/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWDownloadAllOperation.h"
#import "SWProduct.h"
#import "defines.h"

@implementation SWDownloadAllOperation

- (id)initWithCompletionHandler:(void (^)(NSArray *, BOOL))completionHandler {
    
    self = [super init];
    if (self) {
        self.completionHandler = completionHandler;
    }
    
    return self;
}

- (void)main {
    
    if ([self isCancelled]) {
        NSLog(@"DownloadAll Operation cancelled");
    }
    
    NSURLSessionConfiguration *urlSessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:urlSessionConfig delegate:nil delegateQueue:nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@catalog?apikey=%@", kBaseUrl, kApiKey];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [urlRequest setHTTPMethod:@"GET"];
    
    //Make GET Request and handle response
    NSURLSessionDataTask *downloadAllTask =
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
                                              for (NSDictionary *product in list) {
                                                  NSString *name = [product valueForKey:@"Name"];
                                                  NSString *description = [product valueForKey:@"Description"];
                                                  NSDictionary *labelsDict = [product valueForKey:@"Labels"];
                                                  NSString *imageURL = [[labelsDict valueForKey:@"Url"] objectAtIndex:0];
                                                  
                                                  SWProduct *productToAdd = [[SWProduct alloc] initWithName:name
                                                                                                description:description
                                                                                                andImageURL:imageURL];
                                                  [resultsArray addObject:productToAdd];
                                              }
                                              
                                              //App flag which Catalog VC uses to determine if it needs to call this operation again
                                              [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"downloadCompleted"];
                                              [[NSUserDefaults standardUserDefaults] synchronize];
                                              
                                              self.completionHandler([resultsArray copy], YES);
                                          }
                                          else {
                                              self.completionHandler(nil, NO);
                                          }
                                      }];
    
    if ([self isCancelled]) {
        NSLog(@"DownloadAll Operation cancelled");
    }
    
    [downloadAllTask resume];
}

@end
