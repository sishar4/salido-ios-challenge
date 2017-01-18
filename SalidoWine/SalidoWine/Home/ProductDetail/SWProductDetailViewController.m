//
//  SWProductDetailViewController.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWProductDetailViewController.h"

@interface SWProductDetailViewController ()
@property (strong, nonatomic) NSOperationQueue *operationQueue;

@end

@implementation SWProductDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.productNameLabel setText:self.product.name];
    
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:self.scrollView.bounds];
    [descriptionLabel setNumberOfLines:0];
    
    NSBlockOperation *textFormatBlock = [NSBlockOperation blockOperationWithBlock:^{
        
        NSAttributedString *descriptionString = [[NSAttributedString alloc] initWithData:[self.product.productDescription dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            [descriptionLabel setText:[descriptionString string]];
            [descriptionLabel sizeToFit];
            [self.scrollView addSubview:descriptionLabel];
            [self.scrollView setContentSize:CGSizeMake(self.scrollView.bounds.size.width, descriptionLabel.frame.size.height)];
        }];
    }];
    
    NSBlockOperation *downloadImageBlock = [NSBlockOperation blockOperationWithBlock:^{
        
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.product.imageURL]]];
        
        if (img) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [self.productImageView setImage:img];
            }];
        }
    }];
    
    [self.operationQueue addOperation:textFormatBlock];
    [self.operationQueue addOperation:downloadImageBlock];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.operationQueue = [[NSOperationQueue alloc] init];
}

- (IBAction)dismissDetailView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.operationQueue cancelAllOperations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
