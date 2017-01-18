//
//  SWCatalogCollectionViewCell.h
//  SalidoWine
//
//  Created by Sahil Ishar on 1/17/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWProduct.h"

@interface SWCatalogCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) SWProduct *product;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *addToCartButton;
- (IBAction)addToCartPressed:(id)sender;

@end
