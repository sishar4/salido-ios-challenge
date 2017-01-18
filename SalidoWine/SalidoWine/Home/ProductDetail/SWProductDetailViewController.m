//
//  SWProductDetailViewController.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWProductDetailViewController.h"
#import "SWCartDataController.h"
#import "SWLogoutBarButtonItem.h"
#import "SWCartBarButtonItem.h"

@interface SWProductDetailViewController ()
@property (strong, nonatomic) NSOperationQueue *operationQueue;

@end

@implementation SWProductDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.productNameLabel setText:self.product.name];
    
    if (self.product.productDescription.length > 0) {
        NSBlockOperation *textFormatBlock = [NSBlockOperation blockOperationWithBlock:^{
            
            NSAttributedString *descriptionString = [[NSAttributedString alloc] initWithData:[self.product.productDescription dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:self.scrollView.bounds];
                [descriptionLabel setNumberOfLines:0];
                [descriptionLabel setText:[descriptionString string]];
                [descriptionLabel sizeToFit];
                [self.scrollView addSubview:descriptionLabel];
                [self.scrollView setContentSize:CGSizeMake(self.scrollView.bounds.size.width, descriptionLabel.frame.size.height)];
            }];
        }];
        
        [self.operationQueue addOperation:textFormatBlock];
    }
    
    NSBlockOperation *downloadImageBlock = [NSBlockOperation blockOperationWithBlock:^{
        
        UIImage * img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.product.imageURL]]];
        
        if (img) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                
                [self.productImageView setImage:img];
            }];
        }
    }];
    
    [self.operationQueue addOperation:downloadImageBlock];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    
    //Nav Bar setup
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dismissDetailView:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    SWCartBarButtonItem *cartBarButton = [[SWCartBarButtonItem alloc] initFromViewController:self];
    SWLogoutBarButtonItem *logoutBarButton = [[SWLogoutBarButtonItem alloc] initFromViewController:self];
    NSArray *rightButtonsArray = [NSArray arrayWithObjects:logoutBarButton, cartBarButton, nil];
    [self.navigationItem setRightBarButtonItems:rightButtonsArray];
}

- (IBAction)stepperValueChanged:(UIStepper *)sender {
    
    NSUInteger value = sender.value;
    [self.quantityLabel setText:[NSString stringWithFormat:@"%lu", (unsigned long)value]];
}

- (IBAction)addToCartPressed:(id)sender {
    
    SWCartDataController *dataController = [[SWCartDataController alloc] init];
    dispatch_queue_t addItemQueue = dispatch_queue_create("com.salidowine.addfromdetail", DISPATCH_QUEUE_SERIAL);
    
    [dataController addItemToCart:self.product
                     withQuantity:[self.quantityLabel.text integerValue]
                            queue:addItemQueue
             andCompletionHandler:^(BOOL success) {
                 if (success) {
                     NSLog(@"SUCCESSFULLY ADDED TO CART");
                     [self.quantityLabel setText:@"1"];
                 }
             }];
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
