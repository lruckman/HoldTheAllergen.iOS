//
//  RestaurantMenuItemViewController.m
//  HoldTheAllergen
//
//  Created by lruckman on 8/18/12.
//  Copyright (c) 2012 lruckman. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "RestaurantMenuItemViewController.h"
#import "NSArray+JsonCategories.h"
#import "RestaurantMenuItem.h"
#import "RestaurantMenuItemIngredient.h"
#import "Restaurant.h"
#import "UIColor-Extended.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kSectionHeaderHeight 30
#define kSectionHeaderColorHexString @"33B5E5"
#define kImportantColorHexString @"FF0000"
#define kTitleFontSize 15
#define kSubTitleFontSize 11

@implementation RestaurantMenuItemViewController

@synthesize restaurant;
@synthesize restaurantMenuItem;
@synthesize ingredientTableView;
@synthesize logoImageView;
@synthesize restaurantNameLabel;
@synthesize menuItemNameLabel;

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
    [super viewDidLoad];
	
    self.title = restaurantMenuItem.name;
    
    menuItemNameLabel.text = restaurantMenuItem.name;
    menuItemNameLabel.numberOfLines=0;
    [menuItemNameLabel sizeToFit];
    
    restaurantNameLabel.text = restaurant.name;
    restaurantNameLabel.numberOfLines =0;
    [restaurantNameLabel sizeToFit];
    
    logoImageView.image = restaurant.logoIcon;
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if (restaurantMenuItem.ingredients == nil)  {
        dispatch_async(kBgQueue, ^{
            NSArray* json = [NSArray dictionaryWithContentsOfJSONURLString:
                             [NSURL URLWithString: restaurantMenuItem.dataSource]];
            [self performSelectorOnMainThread:@selector(fetchedData:)
                                   withObject:json waitUntilDone:YES];
        });
    }
    else {
        [ingredientTableView reloadData];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.ingredientTableView=nil;
    self.logoImageView=nil;
    self.restaurantNameLabel=nil;
    self.menuItemNameLabel=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)fetchedData:(NSArray *)json {
    self.restaurantMenuItem.ingredients = [[NSMutableDictionary alloc] initWithCapacity:[json count]];
    
    for (NSDictionary *section in json) {
        
        NSString* key = [section objectForKey:@"Key"];
        NSDictionary* jsonItems = [section objectForKey:@"Value"];
        
        [self.restaurantMenuItem.ingredients setValue:[[NSMutableArray alloc] initWithCapacity:[json count]] forKey:key];
        
        for (NSDictionary *item in jsonItems) {
            RestaurantMenuItemIngredient *ingredient = [[RestaurantMenuItemIngredient alloc]
                                            initWithName:[item objectForKey:@"Name"]
                                            andAllergenNames:[item objectForKey:@"AllergenNames"]
                                            andDescription:[item objectForKey:@"Description"]];
            
            [[self.restaurantMenuItem.ingredients objectForKey:key] addObject:ingredient];
        }
    }
    
    [ingredientTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [self.restaurantMenuItem.ingredients count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id key = [[self.restaurantMenuItem.ingredients allKeys] objectAtIndex:section];
	return [[self.restaurantMenuItem.ingredients objectForKey:key] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    id key = [[self.restaurantMenuItem.ingredients allKeys] objectAtIndex:section];
    return key;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id key = [[self.restaurantMenuItem.ingredients allKeys] objectAtIndex:indexPath.section];
    NSMutableArray* ingredients = [self.restaurantMenuItem.ingredients objectForKey:key];
    RestaurantMenuItemIngredient* ingredient = [ingredients objectAtIndex: indexPath.row];
    
    CGSize titleSize = [ingredient.name sizeWithFont:[UIFont systemFontOfSize:kTitleFontSize]
                                 constrainedToSize:CGSizeMake(302, 9999)
                                     lineBreakMode:UILineBreakModeTailTruncation];
    
    CGSize subTitleSize = [ingredient.allergenNames sizeWithFont:[UIFont systemFontOfSize:kSubTitleFontSize]
                                             constrainedToSize:CGSizeMake(302, 9999)
                                                 lineBreakMode:UILineBreakModeTailTruncation];
    
    CGSize descriptionSize = [ingredient.description sizeWithFont:[UIFont systemFontOfSize:kSubTitleFontSize]
                                               constrainedToSize:CGSizeMake(302, 9999)
                                                   lineBreakMode:UILineBreakModeTailTruncation];
    
    //todo: add description
    
    CGFloat height = titleSize.height+subTitleSize.height+descriptionSize.height+18;
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
    static NSString *CellIdentifier = @"IngredientCell";
    int nodeCount = [self.restaurantMenuItem.ingredients count];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (nodeCount>0) {
        
        id key = [[self.restaurantMenuItem.ingredients allKeys] objectAtIndex:indexPath.section];
        NSMutableArray* ingredients = [self.restaurantMenuItem.ingredients objectForKey:key];
        RestaurantMenuItemIngredient* ingredient = [ingredients objectAtIndex: indexPath.row];
        
        UILabel *menuItemName = (UILabel *)[cell viewWithTag:10];
        UILabel *allergenNames = (UILabel *)[cell viewWithTag:11];
        UILabel *ingredientDescription = (UILabel *)[cell viewWithTag:12];
        
        menuItemName.text = ingredient.name;
        menuItemName.font = [UIFont systemFontOfSize:kTitleFontSize];
        menuItemName.lineBreakMode = UILineBreakModeTailTruncation;
        menuItemName.numberOfLines=0;
        menuItemName.frame = CGRectMake(10, 4, 302, 22);
        
        [menuItemName sizeToFit];
        
        int yOffset = [ingredient.name sizeWithFont:[UIFont systemFontOfSize:kTitleFontSize]
                                        constrainedToSize:CGSizeMake(302, 9999)
                                            lineBreakMode:UILineBreakModeTailTruncation].height+4;
                
        if (ingredient.allergenNames == nil || [ingredient.allergenNames length] == 0) {
            [allergenNames setHidden:TRUE];
            
            ingredientDescription.frame = CGRectMake(10, yOffset, 302, 18);
            
        } else {
            [allergenNames setHidden:FALSE];
                        
            allergenNames.text = ingredient.allergenNames;
            allergenNames.font = [UIFont systemFontOfSize:kSubTitleFontSize];
            allergenNames.textColor = [UIColor colorWithHexString:kImportantColorHexString];
            allergenNames.lineBreakMode = UILineBreakModeTailTruncation;
            allergenNames.numberOfLines=0;
            allergenNames.frame = CGRectMake(10, yOffset, 302, 18);
            
            [allergenNames sizeToFit];
            
            yOffset = yOffset + [ingredient.allergenNames sizeWithFont:[UIFont systemFontOfSize:kSubTitleFontSize] constrainedToSize:CGSizeMake(302, 9999)
                                                         lineBreakMode:UILineBreakModeTailTruncation].height;
            
            ingredientDescription.frame = CGRectMake(10, yOffset, 302, 18);
        }
        
        if (ingredient.description == nil || [ingredient.description length]==0) {
            [ingredientDescription setHidden:TRUE];
        }
        else {
            [ingredientDescription setHidden:FALSE];
            
            ingredientDescription.text = ingredient.description;
            ingredientDescription.font = [UIFont systemFontOfSize:kSubTitleFontSize];
            ingredientDescription.lineBreakMode = UILineBreakModeTailTruncation;
            ingredientDescription.numberOfLines=0;
            
            [ingredientDescription sizeToFit];
        }
        
        cell.userInteractionEnabled = NO;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


@end
