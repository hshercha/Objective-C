//
//  ViewController.m
//  Listings
//
//  Created by Himal Sherchan on 8/15/16.
//  Copyright © 2016 Himal Sherchan. All rights reserved.
//

#import "ViewController.h"
#import "AirAPI.h"
#import "ListingCell.h"
#import "SearchResult.h"


@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *listings;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 68.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [[AirAPI sharedInstance] getListing:^(NSArray *values, NSError *error) {
        if (error == nil)
        {
            _listings = values;
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return _listings.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    ListingCell *viewCell = [tableView dequeueReusableCellWithIdentifier:@"ListingCell"];
    
    SearchResult *result = (SearchResult*)_listings[indexPath.row];
    viewCell.nameLabel.text = result.listing.name;
    
    if (result.listing.neighborhood == nil)
    {
    viewCell.descriptionLabel.text = [NSString stringWithFormat:@"%@", result.listing.roomType];
    }
    else
    {
    viewCell.descriptionLabel.text = [NSString stringWithFormat:@"%@ - %@", result.listing.neighborhood, result.listing.roomType];
    }
    
    return viewCell;
}


@end
