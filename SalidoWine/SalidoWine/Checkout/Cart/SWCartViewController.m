//
//  SWCartViewController.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWCartViewController.h"
#import "SWShoppingCart.h"

@interface SWCartViewController ()

@property (strong, nonatomic) SWShoppingCart *shoppingCart;
@end

@implementation SWCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.shoppingCart = [SWShoppingCart sharedInstance];
    [self addObserver:self.shoppingCart forKeyPath:@"totalItems" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"From KVO");
    
    if([keyPath isEqualToString:@"totalItems"])
    {
        id val = [change objectForKey:NSKeyValueChangeNewKey];
        NSLog(@"New total = %@", val);
        [self.totalItemsLabel setText:[NSString stringWithFormat:@"%@", val]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
