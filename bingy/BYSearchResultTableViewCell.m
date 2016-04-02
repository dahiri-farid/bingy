//
//  BYSearchResultTableViewCell.m
//  bingy
//
//  Created by Dahiri Farid on 4/2/16.
//  Copyright © 2016 Dahiri Farid. All rights reserved.
//

#import "BYSearchResultTableViewCell.h"
#import <UIKit+AFNetworking.h>

@interface BYSearchResultTableViewCell ()

@property (nonatomic, strong) IBOutlet    UILabel* ibTitle;
@property (nonatomic, strong) IBOutlet    UILabel* ibSubtitle;
@property (nonatomic, strong) IBOutlet    UIImageView* ibImageView;


@end

@implementation BYSearchResultTableViewCell

+ (instancetype)cell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
}

+ (NSString *)ID
{
    return NSStringFromClass([self class]);
}

+ (CGFloat)height
{
    return 44.0f;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)updateWithTitle:(NSString *)aTitle subtitle:(NSString *)aSubtitle imageLink:(NSString *)aImageLink
{
    self.ibTitle.text = aTitle;
    self.ibSubtitle.text = aSubtitle;
    [self.ibImageView setImageWithURL:[NSURL URLWithString:aImageLink]];
}

@end
