//
//  ListingCell.h
//  Listings
//
//  Created by Himal Sherchan on 8/16/16.
//  Copyright © 2016 Himal Sherchan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListingCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

@end
