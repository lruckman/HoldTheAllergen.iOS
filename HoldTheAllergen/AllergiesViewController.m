//
//  AllergiesViewController.m
//  HoldTheAllergen
//
//  Created by lruckman on 9/2/12.
//  Copyright (c) 2012 lruckman. All rights reserved.
//

#import "AllergiesViewController.h"
#import "UIColor-Extended.h"
#import "AppDelegate.h"
#import "NSArray+JsonCategories.h"
#import "Allergen.h"
#import <QuartzCore/QuartzCore.h>

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kSectionHeaderColorHexString @"33B5E5"
#define kTitleFontSize 15

@implementation AllergiesViewController

@synthesize allergyTableView;
@synthesize titleView;
@synthesize allergens;

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
    // Create label with dialog title
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 10, 360, 30);
    label.textColor = [UIColor colorWithHexString:kSectionHeaderColorHexString];
    label.font = [UIFont systemFontOfSize:20];
    label.text = @"Choose your Allergies";
    
    titleView.frame = CGRectMake(0, 0, 320, 50);
    titleView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    [titleView addSubview:label];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, 50, 320, 1);
    bottomBorder.backgroundColor = [UIColor colorWithHexString:kSectionHeaderColorHexString].CGColor;
    
    [titleView.layer addSublayer:bottomBorder];
    
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString * uid = [appDelegate getUid];
    NSString * url = [NSString stringWithFormat:@"http://api.holdtheallergen.com/%@/allergens",uid];
    
    dispatch_async(kBgQueue, ^{
        NSArray* json = [NSArray dictionaryWithContentsOfJSONURLString: [NSURL URLWithString: url]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:json waitUntilDone:YES];
    });
        
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.allergyTableView = nil;
    self.titleView=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)fetchedData:(NSArray *)json {
    self.allergens = [[NSMutableArray alloc] initWithCapacity:[json count]];
    for (NSDictionary *d in json) {
        Allergen * allergen = [[Allergen alloc]initWithAllergenId:(int)[d objectForKey:@"Id"]
                                                                 andName:[d objectForKey:@"Name"]
                                                      andSelected:[[d objectForKey:@"Selected"] boolValue]
                                                  andSelectAction:[d objectForKey:@"SelectAction"]];
        NSLog(@"%@",[d objectForKey:@"Selected"]);
        [allergens addObject:allergen];
    }
    [self.allergyTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.allergens count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Allergen * allergen = [allergens objectAtIndex: indexPath.row];
    
    cell.textLabel.text = allergen.name;
    cell.textLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    cell.accessoryType = (allergen.selected) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

-(IBAction)setAllergiesButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Allergen *allergen = [allergens objectAtIndex: indexPath.row];
    
    allergen.selected = (!allergen.selected);
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = (allergen.selected) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    dispatch_async(kBgQueue, ^{
        NSMutableURLRequest *request = [NSMutableURLRequest
                                        requestWithURL:[NSURL URLWithString:allergen.selectAction]];
        
        if (allergen.selected) {
            [request setHTTPMethod:@"POST"];
        }
        else {
            [request setHTTPMethod:@"DELETE"];
        }
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", 0] forHTTPHeaderField:@"Content-Length"];
        
        __autoreleasing NSError* error = nil;
        NSHTTPURLResponse *response =[[NSHTTPURLResponse alloc]init];
        [NSURLConnection sendSynchronousRequest:request returningResponse:&response
                                                         error:&error];
        if (error != nil) {};
    });
}

@end
