//
//  RestaurantMenuViewController.m
//  HoldTheAllergen
//
//  Created by lruckman on 8/12/12.
//  Copyright (c) 2012 lruckman. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RestaurantMenuViewController.h"
#import "NSArray+JsonCategories.h"
#import "RestaurantMenuItem.h"  
#import "UIColor-Extended.h"
#import "RestaurantMenuItemViewController.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kSectionHeaderHeight 30
#define kSectionHeaderColorHexString @"33B5E5"
#define kTitleFontSize 15
#define kSubTitleFontSize 11

@implementation RestaurantMenuViewController
@synthesize restaurant;
@synthesize sortedKeys;
@synthesize menuTableView;
@synthesize menuTabBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{	
    self.title = restaurant.name;
    sortedKeys=nil;
        
    menuTabBar.delegate = self;
    [menuTabBar setSelectedItem:[menuTabBar.items objectAtIndex:0]];
        
    //if (restaurant.menu == nil)  {
    restaurant.menu=nil;
        dispatch_async(kBgQueue, ^{
            NSArray* json = [NSArray dictionaryWithContentsOfJSONURLString:
                             [NSURL URLWithString: restaurant.menuDataSource]];
            [self performSelectorOnMainThread:@selector(fetchedData:)
                                   withObject:json waitUntilDone:YES];
        });
    //}
    //else {
    //    if (sortedKeys == nil) {
    //        sortedKeys = [[self.restaurant.menu allKeys]
    //                            sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]; // use these for sections
    //    }
    //    [menuTableView reloadData];
    //}
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.menuTableView=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)fetchedData:(NSArray *)json {
    self.restaurant.menu = [[NSMutableDictionary alloc] initWithCapacity:[json count]];
    
    for (NSDictionary *section in json) {
        
        NSString* key = [section objectForKey:@"CategoryName"];
        NSDictionary* jsonItems = [section objectForKey:@"Items"];
                
        if ([jsonItems count] == 0) {
            continue;
        }
        
        [self.restaurant.menu setValue:[[NSMutableArray alloc] initWithCapacity:[jsonItems count]] forKey:key];
        
        for (NSDictionary *item in jsonItems) {
            RestaurantMenuItem *menuItem = [[RestaurantMenuItem alloc]
                                            initWithMenuItemId:(int)[item objectForKey:@"Id"]
                                                       andName:[item objectForKey:@"Name"]
                                              andAllergenNames:[item objectForKey:@"AllergenNames"]
                                                 andDataSource:[item objectForKey:@"Action"]];
            
            [[self.restaurant.menu objectForKey:key] addObject:menuItem];
        }        
    }
    sortedKeys = [[self.restaurant.menu allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]; // use these for sections
    [menuTableView reloadData];
}

#pragma mark - Tab Bar delegate

- (void)tabBar:(UITabBar *)menuTabBar didSelectItem:(UITabBarItem *)item
{
    restaurant.menu=nil;
    if (item.tag==666) {
        dispatch_async(kBgQueue, ^{
            NSArray* json = [NSArray dictionaryWithContentsOfJSONURLString:
                             [NSURL URLWithString:restaurant.menuDataSource]];
            [self performSelectorOnMainThread:@selector(fetchedData:)
                                   withObject:json waitUntilDone:YES];
        });
    }
    else {
        dispatch_async(kBgQueue, ^{
            NSArray* json = [NSArray dictionaryWithContentsOfJSONURLString:
                             [NSURL URLWithString:restaurant.allergyFreeMenuDataSource]];
            [self performSelectorOnMainThread:@selector(fetchedData:)
                                   withObject:json waitUntilDone:YES];
        });
    }   
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (sortedKeys==nil) {
        return 0;
    }
	return [sortedKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id key = [sortedKeys objectAtIndex:section];
	return [[restaurant.menu objectForKey:key] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id key = [sortedKeys objectAtIndex:section];
    return key;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id key = [sortedKeys objectAtIndex:indexPath.section];
    NSMutableArray* menuSection = [restaurant.menu objectForKey:key];
    RestaurantMenuItem* menuItem = [menuSection objectAtIndex: indexPath.row];
    
    CGSize titleSize = [menuItem.name sizeWithFont:[UIFont systemFontOfSize:kTitleFontSize]
                         constrainedToSize:CGSizeMake(302, 9999)
                             lineBreakMode:UILineBreakModeTailTruncation];
    
    CGSize subTitleSize = [menuItem.allergenNames sizeWithFont:[UIFont systemFontOfSize:kSubTitleFontSize]
                                   constrainedToSize:CGSizeMake(302, 9999)
                                       lineBreakMode:UILineBreakModeTailTruncation];
    
    CGFloat height = titleSize.height+subTitleSize.height+18;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView titleForHeaderInSection:section] != nil) {
        return kSectionHeaderHeight;
    }
    else {
        // If no section header title, no section header needed
        return 0;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 0, 360, 30);
    label.textColor = [UIColor colorWithHexString:kSectionHeaderColorHexString];
    label.font = [UIFont systemFontOfSize:14];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kSectionHeaderHeight)];
    view.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    //view.layer.borderWidth = 1.0f;
    [view addSubview:label];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, kSectionHeaderHeight, 320, 1);
    bottomBorder.backgroundColor = [UIColor colorWithHexString:kSectionHeaderColorHexString].CGColor;
        
    [view.layer addSublayer:bottomBorder];
    
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MenuItemCell";
    int nodeCount = [self.restaurant.menu count];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (nodeCount>0) {
        id key = [sortedKeys objectAtIndex:indexPath.section];
        NSMutableArray* menuSection = [restaurant.menu objectForKey:key];
        RestaurantMenuItem* menuItem = [menuSection objectAtIndex: indexPath.row];
                
        cell.textLabel.text = menuItem.name;
        cell.textLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
        cell.textLabel.numberOfLines=0;
        
        cell.detailTextLabel.text = menuItem.allergenNames;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:kSubTitleFontSize];
        cell.detailTextLabel.numberOfLines=0;
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"MenutoItemSegue"])
    {
        // Get reference to the destination view controller
        RestaurantMenuItemViewController *vc = [segue destinationViewController];
        NSIndexPath *indexPath=[self.menuTableView indexPathForSelectedRow];
        id key = [sortedKeys objectAtIndex:indexPath.section];
        NSMutableArray* menuSection = [restaurant.menu objectForKey:key];
        RestaurantMenuItem* menuItem = [menuSection objectAtIndex: indexPath.row];
        vc.restaurant = restaurant;
        vc.restaurantMenuItem = menuItem;
    }
}

@end
