//
//  SWFilterListViewController.m
//  SalidoWine
//
//  Created by Sahil Ishar on 1/14/17.
//  Copyright © 2017 Sahil Ishar. All rights reserved.
//

#import "SWFilterListViewController.h"
#import "SWCartBarButtonItem.h"
#import "SWLogoutBarButtonItem.h"
#import "Reachability.h"
#import "SWProductCategories.h"

@interface SWFilterListViewController ()

@property (strong, nonatomic) Reachability *hostReachable;
@property (strong, nonatomic) NSMutableArray *categoryFilterQueryArray;
@property (strong, nonatomic) NSMutableArray *categoriesArray;
@end

@implementation SWFilterListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    self.categoryFilterQueryArray = [[NSMutableArray alloc] init];
    SWProductCategories *sharedObj = [SWProductCategories sharedInstance];
    self.categoriesArray = [[NSMutableArray alloc] initWithArray:sharedObj.categoriesArray];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    SWCartBarButtonItem *cartBarButton = [[SWCartBarButtonItem alloc] initFromViewController:self];
    SWLogoutBarButtonItem *logoutBarButton = [[SWLogoutBarButtonItem alloc] initFromViewController:self];
    NSArray *rightButtonsArray = [NSArray arrayWithObjects:logoutBarButton, cartBarButton, nil];
    [self.navigationItem setRightBarButtonItems:rightButtonsArray];
}

- (IBAction)clearButtonPressed:(id)sender {
    
    if (self.nameTextField.text.length > 0) {
        [self.nameTextField setText:nil];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet *blockedCharacters = [[NSCharacterSet whitespaceCharacterSet] invertedSet];
    NSCharacterSet *blockedCharacters2 = [[NSCharacterSet letterCharacterSet] invertedSet];

    return ([string rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound || [string rangeOfCharacterFromSet:blockedCharacters2].location) ;
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.categoriesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *categoryDict = [self.categoriesArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:[categoryDict valueForKey:@"Name"]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *categoryDict = [self.categoriesArray objectAtIndex:indexPath.row];
    NSString *categoryId = [[categoryDict valueForKey:@"Id"] stringValue];
    
    if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        //Remove category id to categoryFilterArray
        [self.categoryFilterQueryArray removeObject:categoryId];
    }else{
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        //Add category id to categoryFilterArray
        [self.categoryFilterQueryArray addObject:categoryId];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSMutableDictionary *searchParams = [[NSMutableDictionary alloc] init];
    //Check if any filter parameters have been chosen
    if (self.nameTextField.text.length > 0) {
        [searchParams setObject:self.nameTextField.text forKey:@"name"];
    }
    
    if (self.categoryFilterQueryArray.count > 0) {
        [searchParams setObject:self.categoryFilterQueryArray forKey:@"category"];
    }
    
    [searchParams setObject:[NSNumber numberWithBool:[self.winerySwitch isOn]] forKey:@"winery"];
    [[NSUserDefaults standardUserDefaults] setObject:searchParams forKey:@"searchParams"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Call delegate on CatalogVC to make new api call with filters
    [self.delegate filterCatalogWithNameQuery:[self.nameTextField.text componentsSeparatedByString:@" "]
                               categoryFilter:self.categoryFilterQueryArray
                                  andByWinery:[self.winerySwitch isOn]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
