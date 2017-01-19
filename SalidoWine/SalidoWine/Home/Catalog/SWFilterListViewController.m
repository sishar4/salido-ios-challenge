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
@property (strong, nonatomic) NSMutableArray *categoryFilterQueryArray; //Stores selected categories from tableview
@property (strong, nonatomic) NSMutableArray *categoriesArray;

//Previous filter values to compare against
@property (strong, nonatomic) NSString *previousNameSearchString;
@property (strong, nonatomic) NSArray *previousCategorySearchArray;
@property (assign, nonatomic) BOOL previousByWinerySearch;
@end

@implementation SWFilterListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"searchParams"]) {
        //Else, check if there is a previous filter, and apply it
        NSDictionary *searchDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchParams"];
        NSString *namesString = [searchDict objectForKey:@"name"];
        NSArray *categoryArray = [searchDict objectForKey:@"category"];
        NSNumber *byWineryNum = [searchDict objectForKey:@"winery"];
        BOOL sortByWinery = [byWineryNum boolValue];
        
        self.previousNameSearchString = namesString ? namesString : @"";
        self.previousCategorySearchArray = [[NSArray alloc] initWithArray:categoryArray];
        self.previousByWinerySearch = sortByWinery;
        
        [self.nameTextField setText:namesString];
        [self.categoryFilterQueryArray addObjectsFromArray:categoryArray];
        [self.winerySwitch setOn:sortByWinery];
    }
}

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
    
    NSString *categoryId = [[categoryDict valueForKey:@"Id"] stringValue];
    if ([self.categoryFilterQueryArray containsObject:categoryId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *categoryDict = [self.categoriesArray objectAtIndex:indexPath.row];
    NSString *categoryId = [[categoryDict valueForKey:@"Id"] stringValue];
    
    if ([self.categoryFilterQueryArray containsObject:categoryId]) {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        //Remove category id to categoryFilterArray
        [self.categoryFilterQueryArray removeObject:categoryId];
    } else {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        //Add category id to categoryFilterArray
        [self.categoryFilterQueryArray addObject:categoryId];
    }
//    if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
//        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
//        //Remove category id to categoryFilterArray
//        [self.categoryFilterQueryArray removeObject:categoryId];
//    }else{
//        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
//        //Add category id to categoryFilterArray
//        [self.categoryFilterQueryArray addObject:categoryId];
//    }
}

- (BOOL)filterFieldsNotChanged {
    //Checks to see if filter fields are the same as when VC was loaded
    if (self.nameTextField.text.length > 0 && ![self.nameTextField.text isEqualToString:self.previousNameSearchString]) {
        return NO;
    } else if (self.nameTextField.text.length == 0 && self.previousNameSearchString.length > 0) {
        return NO;
    }
    
    if ([self.winerySwitch isOn] != self.previousByWinerySearch) {
        return NO;
    }
    
    if (![self.categoryFilterQueryArray isEqualToArray:self.previousCategorySearchArray]) {
        return NO;
    }
    
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (![self filterFieldsNotChanged]) {
        
        NSMutableDictionary *searchParams = [[NSMutableDictionary alloc] init];
        NSMutableArray *namesArray = [[NSMutableArray alloc] init];
        
        //Check if any filter parameters have been chosen
        if (self.nameTextField.text.length > 0) {
            [searchParams setObject:self.nameTextField.text forKey:@"name"];
            [namesArray addObjectsFromArray:[self.nameTextField.text componentsSeparatedByString:@" "]];
        }
        
        if (self.categoryFilterQueryArray.count > 0) {
            [searchParams setObject:self.categoryFilterQueryArray forKey:@"category"];
        }
        
        [searchParams setObject:[NSNumber numberWithBool:[self.winerySwitch isOn]] forKey:@"winery"];
        [[NSUserDefaults standardUserDefaults] setObject:searchParams forKey:@"searchParams"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //Call delegate on CatalogVC to make new api call with filters
        [self.delegate filterCatalogWithNameQuery:namesArray
                                   categoryFilter:self.categoryFilterQueryArray
                                      andByWinery:[self.winerySwitch isOn]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
