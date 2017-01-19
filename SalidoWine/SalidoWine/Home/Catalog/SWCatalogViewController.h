//
//  SWCatalogViewController.h
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWFilterListViewController.h"

@interface SWCatalogViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, SWFilterCatalogProtocol>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
