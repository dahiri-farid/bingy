//
//  BYTextResult.h
//  bingy
//
//  Created by Dahiri Farid on 4/2/16.
//  Copyright © 2016 Dahiri Farid. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, BYSearchType)
{
    BYSearchTextObject,
    BYSearchImageObject,
    BYSearchNoResults,
};

@class HTMLElement;

@interface BYTextResult : NSObject

@property (nonatomic, assign, readonly) BYSearchType searchType;

@property (nonatomic, strong, readonly) NSString* titleLink;
@property (nonatomic, strong, readonly) NSString* subtitle;
@property (nonatomic, strong, readonly) NSString* imageLink;
@property (nonatomic, strong, readonly) NSString* infoLink;

+ (instancetype)textResultsWithHTMLElement:(HTMLElement *)aElement type:(BYSearchType)aSearchType;
+ (instancetype)noResultsObject;

@end
