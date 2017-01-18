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
#import "SWProduct.h"
#import "SWAlertHelper.h"
#import "SWCatalogCollectionViewCell.h"

@interface SWCatalogViewController ()

@property (strong, nonatomic) NSMutableArray *productsArray;
@property (strong, nonatomic) NSOperationQueue *catalogOperationQueue;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@end

@implementation SWCatalogViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    //Check if download operation has not been completed yet since login
//    BOOL alreadyDownloaded = [[NSUserDefaults standardUserDefaults] boolForKey:@"downloadCompleted"];
//    if (!alreadyDownloaded) {
//        [self displayLoadingIndicator];
//        [self downloadWineList];
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.catalogOperationQueue = [[NSOperationQueue alloc] init];
    self.productsArray = [[NSMutableArray alloc] init];
    [self.collectionView registerClass:[SWCatalogCollectionViewCell class] forCellWithReuseIdentifier:@"catalogCollectionCell"];
    UINib *cellNib = [UINib nibWithNibName:@"SWCatalogCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"catalogCollectionCell"];
    
    SWCartBarButtonItem *cartBarButton = [[SWCartBarButtonItem alloc] initFromViewController:self];
    self.navigationItem.leftBarButtonItem = cartBarButton;
    SWLogoutBarButtonItem *logoutBarButton = [[SWLogoutBarButtonItem alloc] initFromViewController:self];
    self.navigationItem.rightBarButtonItem = logoutBarButton;
    
    [self displayLoadingIndicator];
    [self downloadWineList];
}

- (void)displayLoadingIndicator {
    
    if (_spinner == nil) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _spinner.center = self.view.center;
    }
    
    [self.view addSubview:_spinner];
    [_spinner startAnimating];
}

- (void)downloadWineList {
    
    SWDownloadAllOperation *downloadOperation = [[SWDownloadAllOperation alloc] initWithCompletionHandler:^(NSArray *results, BOOL success) {
        
        [_spinner stopAnimating];
        
        if (success && results.count > 0) {
            NSLog(@"Results Array == %@", results);
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
                [self displayLoadingIndicator];
                [self.catalogOperationQueue addOperation:downloadOperation];
            }];
        }
    }];
    
    [self.catalogOperationQueue addOperation:downloadOperation];
}

#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.productsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *catalogCellIdentifier = @"catalogCollectionCell";
    
    SWCatalogCollectionViewCell *cell = (SWCatalogCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:catalogCellIdentifier forIndexPath:indexPath];
    
    SWProduct *product = (SWProduct *)[self.productsArray objectAtIndex:indexPath.row];
    [cell.nameLabel setText:product.name];
    [cell setProduct:product];
    
    return cell;
}
    
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
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
