//
//  BYSearchResultTableViewCell.h
//  bingy
//
//  Created by Dahiri Farid on 4/2/16.
//  Copyright © 2016 Dahiri Farid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYSearchResultTableViewCell : UITableViewCell

+ (instancetype)cell;
+ (NSString *)ID;
+ (CGFloat)height;

- (void)updateWithTitle:(NSString *)aTitle subtitle:(NSString *)aSubtitle imageLink:(NSString *)aImageLink;

@end
