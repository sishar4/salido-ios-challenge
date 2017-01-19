//
//  SWCatalogViewController.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWCatalogViewController.h"
#import "SWCartBarButtonItem.h"
#import "SWLogoutBarButtonItem.h"
#import "SWDownloadAllOperation.h"
#import "SWDownloadCategoriesOperation.h"
#import "SWFilterOperation.h"
#import "SWProduct.h"
#import "SWProductCategories.h"
#import "SWAlertHelper.h"
#import "SWCatalogCollectionViewCell.h"
#import "SWProductDetailViewController.h"
#import "Reachability.h"

@interface SWCatalogViewController ()

@property (strong, nonatomic) Reachability *hostReachable;
@property (strong, nonatomic) NSMutableArray *productsArray;
@property (strong, nonatomic) NSMutableArray *wineriesArray; //If filtering by winery, this will be populated
@property (strong, nonatomic) NSOperationQueue *catalogOperationQueue;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) NSCache *imageCache;
@end

@implementation SWCatalogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.catalogOperationQueue = [[NSOperationQueue alloc] init];
    self.productsArray = [[NSMutableArray alloc] init];
    self.wineriesArray = [[NSMutableArray alloc] init];
    self.imageCache = [[NSCache alloc] init];
    [self.collectionView registerClass:[SWCatalogCollectionViewCell class] forCellWithReuseIdentifier:@"catalogCollectionCell"];
    UINib *cellNib = [UINib nibWithNibName:@"SWCatalogCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"catalogCollectionCell"];
    
    SWCartBarButtonItem *cartBarButton = [[SWCartBarButtonItem alloc] initFromViewController:self];
    self.navigationItem.leftBarButtonItem = cartBarButton;
    SWLogoutBarButtonItem *logoutBarButton = [[SWLogoutBarButtonItem alloc] initFromViewController:self];
    self.navigationItem.rightBarButtonItem = logoutBarButton;
    
    self.hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    //Check if download operation has not been completed yet since login
    BOOL alreadyDownloaded = [[NSUserDefaults standardUserDefaults] boolForKey:@"downloadCompleted"];
    if (!alreadyDownloaded) {
        [self startDownload];
    } else {
        //If not, reload collectionview with current list of products
        SWProduct *sharedObj = [SWProduct sharedInstance];
        [self.productsArray removeAllObjects];
        [self.productsArray addObjectsFromArray:sharedObj.productsArray];
        [self.collectionView reloadData];
    }
}

- (void)displayLoadingIndicator {
    
    if (_spinner == nil) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _spinner.center = self.view.center;
    }
    
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
}

- (void)startDownload {
    
    //Check to see if network connection available
    if ([self.hostReachable currentReachabilityStatus] != NotReachable) {
        [self displayLoadingIndicator];
        [self downloadWineList];
        [self downloadCategories];
    } else {
        //If not, display alert that download failed, give option to retry
        [SWAlertHelper presentAlertFromViewController:self
                                            withTitle:@"No Connection"
                                              message:@"Unable to download. Would you like to try again?"
                                           andOkBlock:^{
                                               //Try download once more
                                               [self startDownload];
                                           }];
    }
}

- (void)downloadWineList {
    
    SWDownloadAllOperation *downloadOperation = [[SWDownloadAllOperation alloc] initWithCompletionHandler:^(NSArray *results, BOOL success) {
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [_spinner stopAnimating];
            
            if (success && results.count > 0) {
                SWProduct *sharedObj = [SWProduct sharedInstance];
                [sharedObj.productsArray removeAllObjects];
                [sharedObj.productsArray addObjectsFromArray:results];
                [self.productsArray removeAllObjects];
                [self.productsArray addObjectsFromArray:results];
                [self.collectionView reloadData];
            } else {
                //Display alert that download failed, give option to retry
                [SWAlertHelper presentAlertFromViewController:self
                                                    withTitle:@"Download Failed"
                                                      message:@"Unable to retrieve data. Would you like to try again?"
                                                   andOkBlock:^{
                                                       //Display spinner again, and add operation to queue once more
                                                       [self startDownload];
                                                   }];
            }
        }];
    }];
    
    [self.catalogOperationQueue addOperation:downloadOperation];
}

- (void)downloadCategories {
    
    SWDownloadCategoriesOperation *downloadCategoriesOperation = [[SWDownloadCategoriesOperation alloc] initWithCompletionHandler:^(NSArray *results, BOOL success) {
        
        if (success && results.count > 0) {
            //Store categories for use in Filter VC
            SWProductCategories *sharedObj = [SWProductCategories sharedInstance];
            [sharedObj.categoriesArray removeAllObjects];
            [sharedObj.categoriesArray addObjectsFromArray:results];
        } else {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                //Display alert that download failed, give option to retry
                [SWAlertHelper presentAlertFromViewController:self
                                                    withTitle:@"Download Failed"
                                                      message:@"Unable to retrieve categories. Would you like to try again?"
                                                   andOkBlock:^{
                                                       //Download categories once more
                                                       [self downloadCategories];
                                                   }];
            }];
        }
    }];
    
    [self.catalogOperationQueue addOperation:downloadCategoriesOperation];
}

#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    if (self.wineriesArray.count > 0) {
        return self.wineriesArray.count;
    }
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.wineriesArray.count > 0) {
        return [[self.productsArray objectAtIndex:section] count];
    }
    return self.productsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *catalogCellIdentifier = @"catalogCollectionCell";
    
    SWCatalogCollectionViewCell *cell = (SWCatalogCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:catalogCellIdentifier forIndexPath:indexPath];
    
    SWProduct *product;
    if (self.wineriesArray.count > 0) {
        product = (SWProduct *)[self.productsArray[indexPath.section] objectAtIndex:indexPath.row];
    } else {
        product = (SWProduct *)[self.productsArray objectAtIndex:indexPath.row];
    }
    
    [cell.nameLabel setText:product.name];
    [cell setProduct:product];
    cell.imageView.image = nil;
    
    //Check if product image was previously cached
    if ([self.imageCache objectForKey:product.imageURL]) {
         [cell.imageView setImage:[self.imageCache objectForKey:product.imageURL]];
    } else {
        //If not, asynchronously download image from url
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //Download image asynchronously
            UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:product.imageURL]]];
            [self.imageCache setObject:img forKey:product.imageURL];
            if (img) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    SWCatalogCollectionViewCell *cell = (id)[collectionView cellForItemAtIndexPath:indexPath];
                    if (cell) {
                        [cell.imageView setImage:img];
                    }
                });
            }
        });
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    SWProduct *product = (SWProduct *)[self.productsArray objectAtIndex:indexPath.row];
    
    SWProductDetailViewController *productDetailVC = [[SWProductDetailViewController alloc] initWithNibName:@"SWProductDetailViewController" bundle:nil];
    productDetailVC.product = product;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:productDetailVC];
    [self presentViewController:navController animated:YES completion:nil];
}

#pragma SWFilterCatalogProtocol

- (void)filterCatalogWithNameQuery:(NSArray *)nameQuery categoryFilter:(NSArray *)categoryFilter andByWinery:(BOOL)sortByWinery {
    
    [self filterWithNames:nameQuery categories:categoryFilter andByWinery:sortByWinery];
}

- (void)filterWithNames:(NSArray *)names categories:(NSArray *)categories andByWinery:(BOOL)byWinery {
    
    //Check to see if network connection available
    if ([self.hostReachable currentReachabilityStatus] != NotReachable) {
        
        [self displayLoadingIndicator];
        //Call FilterOperation
        SWFilterOperation *filterOperation = [[SWFilterOperation alloc] initWithNameQuery:names categoryFilter:categories byWinery:byWinery andCompletionHandler:^(NSArray *results, NSSet *wineriesSet, BOOL success) {
            
            if (success && results.count > 0) {
                //Update collectionview
                SWProduct *sharedObj = [SWProduct sharedInstance];
                [sharedObj.productsArray removeAllObjects];
                
                if (byWinery) {
                    NSMutableArray *arr = [NSMutableArray arrayWithArray:[wineriesSet allObjects]];
                    [self.wineriesArray addObjectsFromArray:arr];
                    
                    for (NSString *winery in self.wineriesArray) {
                        NSMutableArray *tempResults = [[NSMutableArray alloc] init];
                        for (SWProduct *product in results) {
                            if ([product.wineryName isEqualToString:winery]) {
                                [tempResults addObject:product];
                            }
                        }
                        [sharedObj.productsArray addObject:tempResults];
                        [self.productsArray addObject:tempResults];
                    }
                } else {
                    [sharedObj.productsArray addObjectsFromArray:results];
                    [self.productsArray addObjectsFromArray:results];
                }
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.spinner stopAnimating];
                    [self.collectionView reloadData];
                }];
            } else if (success && results.count == 0) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.spinner stopAnimating];
                    //Display alert that download returned no results, give option to retry
                    [SWAlertHelper presentAlertFromViewController:self
                                                        withTitle:@"No Result"
                                                       andMessage:@"Your search returned no results. Please try again with a  different filter."];
                }];
            } else {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.spinner stopAnimating];
                    //Display alert that download failed
                    [SWAlertHelper presentAlertFromViewController:self
                                                        withTitle:@"Download Failed"
                                                       andMessage:@"Your search was unable to be completed. Please try again."];
                }];
            }
        }];
        
        [self.catalogOperationQueue addOperation:filterOperation];
        
        [self.productsArray removeAllObjects];
        [self.wineriesArray removeAllObjects];
        [self.collectionView reloadData];
    } else {
        //If not, display alert that download failed, give option to retry
        [SWAlertHelper presentAlertFromViewController:self
                                            withTitle:@"No Connection"
                                           andMessage:@"Unable to download. Please try again."];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showFilter"]) {
        SWFilterListViewController *filterVC = (SWFilterListViewController *)segue.destinationViewController;
        filterVC.delegate = self;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //Cancel download operation if in progress and not completed
    [self.catalogOperationQueue cancelAllOperations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
