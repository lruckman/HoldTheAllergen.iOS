//
//  RootViewController.m
//  HoldTheAllergen
//
//  Created by lruckman on 7/28/12.
//  Copyright (c) 2012 lruckman. All rights reserved.
//

#import "RootViewController.h"
#import "NSArray+JsonCategories.h"
#import "Restaurant.h"
#import "IconDownloader.h"  
#import "RestaurantMenuViewController.h"
#import "AppDelegate.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface RootViewController ()
- (void)startIconDownload:(Restaurant *)restaurant forIndex:(int)itemIndex;
@end

@implementation RootViewController

@synthesize restaurants;
@synthesize appDelegate;
@synthesize selectedIndex;
@synthesize scrollView;

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
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
        
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (![appDelegate hasSeenEULA]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"General Health Disclaimer"
                                                      message:@"The information provided by Hold the Allergen is based upon information published or submitted by third parties (including third party restaurants). HOLD THE ALLERGEN MAKES NO WARRANTIES OR REPRESENTATIONS AS TO THE ACCURACY OR COMPLETENESS OF THE INFORMATION CONTAINED IN THIS APPLICATION OR WHETHER THE INFORMATION CONTAINED IN THIS APPLICATION IS FIT FOR ANY PARTICULAR PURPOSE.\n\nAny guests of a third party restaurant who have food allergies or special dietary needs should consult with a restaurant manager prior to placing an order to ensure the information contained in this Application is accurate.  Furthermore, you should consult with your healthcare practitioner before (i) making any decisions concerning your food allergies or special dietary needs; (ii) following any recipe as part of your diet; and (iii) relying on any information contained in this Application.\n\nHold the Allergen shall have no liability for your medical, health, dietary, or nutritional decisions based upon the content of this Application.  Reliance on any information provided by Hold the Allergen is solely at your own risk."
                                                     delegate:self
                                            cancelButtonTitle:@"I Agree"
                                            otherButtonTitles:nil];
        [message show];
    }
    
    NSString *uid = [appDelegate getUid];
        
    if (restaurants == nil)  {
        NSString *url = [NSString stringWithFormat:@"http://api.holdtheallergen.com/%@/restaurants",uid];
        dispatch_async(kBgQueue, ^{
        NSArray *json = [NSArray dictionaryWithContentsOfJSONURLString: [NSURL URLWithString: url]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:json waitUntilDone:YES];
        });
    }
    
    [super viewDidLoad];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [appDelegate setSeenEULA];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)fetchedData:(NSArray *)json {
    self.restaurants = [[NSMutableArray alloc] initWithCapacity:[json count]];
    for (NSDictionary *d in json) {
        Restaurant *restaurant = [[Restaurant alloc]initWithRestaurantId:(int)[d objectForKey:@"Id"]
                                                                 andLogo:[d objectForKey:@"Logo"]
                                                       andMenuDataSource:[d objectForKey:@"MenuAction"]
                                  andAllergyFreeMenuDataSource:[d objectForKey:@"AllergyFreeMenuAction"]                                                              andName:[d objectForKey:@"Name"]];
        [restaurants addObject:restaurant];
    }
    
    int cellIndex=0;
    const int cellWidth = 100;
    const int cellHeight = 100;
    
    for (Restaurant *r in restaurants) {
        int rowIndex = floor(cellIndex/3);
        int rowCellIndex = rowIndex==0 ? cellIndex : floor(cellIndex%3);
        int x =(cellWidth*rowCellIndex)+6;
        int y = cellHeight*rowIndex;
        
        UIImageView *btn = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, cellWidth, cellHeight)];
        
        btn.tag = cellIndex+100; //not doing this will have us selecting the wrong thing
        UITapGestureRecognizer *myTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restaurantTap:)];
        btn.userInteractionEnabled = YES;
        [btn addGestureRecognizer:myTapGesture];
        
        [self.scrollView addSubview:btn];
        
        [self startIconDownload:r forIndex:btn.tag];
        cellIndex+=1;
    }
    int contentHeight = cellHeight * (ceil(cellIndex/3)+1);
    [self.scrollView setContentSize:CGSizeMake(320,contentHeight)];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"RestaurantToMenuSegue"])
    {
        // Get reference to the destination view controller
        RestaurantMenuViewController *vc = [segue destinationViewController];
        //NSIndexPath *indexPath=[self.restaurantTableView indexPathForSelectedRow];
        vc.restaurant = [self.restaurants objectAtIndex:self.selectedIndex];
    }
}

#pragma mark -
#pragma mark Table cell image support

-(void)restaurantTap:(UITapGestureRecognizer *)gesture {
    self.selectedIndex = ((UIButton *)gesture.view).tag-100;
    [self performSegueWithIdentifier:@"RestaurantToMenuSegue" sender:gesture.view];
}

- (void)startIconDownload:(Restaurant *)restaurant forIndex:(int)itemIndex
{
    IconDownloader *iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.restaurant = restaurant;
        iconDownloader.itemIndex = itemIndex;
        iconDownloader.delegate = self;
        [iconDownloader startDownload];
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(int)itemIndex
{
    Restaurant *restaurant = [self.restaurants objectAtIndex:itemIndex-100];
    UIImageView *btn = (UIImageView *)[self.view viewWithTag:itemIndex];
    [btn setImage:restaurant.logoIcon];
    
    //
}

@end
