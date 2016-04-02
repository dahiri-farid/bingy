//
//  BYTextResult.m
//  bingy
//
//  Created by Dahiri Farid on 4/2/16.
//  Copyright © 2016 Dahiri Farid. All rights reserved.
//

#import "BYTextResult.h"
#import <HTMLElement.h>

@interface BYTextResult ()

@property (nonatomic, assign, readwrite) BYSearchType searchType;
@property (nonatomic, strong, readwrite)HTMLElement* htmlElement;

@end

@implementation BYTextResult

+ (instancetype)textResultsWithHTMLElement:(HTMLElement *)aElement type:(BYSearchType)aSearchType
{
    return [[self alloc] initWithHTMLElement:aElement type:aSearchType];
}

+ (instancetype)noResultsObject
{
    return [[self alloc] initAsNoResult];
}

- (instancetype)initWithHTMLElement:(HTMLElement *)aElement type:(BYSearchType)aSearchType
{
    NSParameterAssert(aElement);
    self = [super init];
    if (self)
    {
        self.htmlElement = aElement;
        self.searchType = aSearchType;
    }
    return self;
}

- (instancetype)initAsNoResult
{
    self = [super init];
    if (self)
    {
        self.searchType = BYSearchNoResults;
    }
    return self;
}

- (NSString *)titleLink
{
    if (self.searchType == BYSearchTextObject)
    {
        NSDictionary* attributes = (NSDictionary *)[[[[[self.htmlElement childElementNodes] objectAtIndex:0] children] firstObject] attributes];
        
        NSLog(@"%@", attributes);
        
        return attributes[@"href"];
    }
    else if (self.searchType == BYSearchImageObject)
    {
        return [[[self.htmlElement childElementNodes] objectAtIndex:1] textContent];
    }
    else
    {
        return @"No Results";
    }
}

- (NSString *)subtitle
{
    if (self.searchType == BYSearchTextObject)
    {
        NSString* text = [[[[[[[self.htmlElement childElementNodes] objectAtIndex:1] children] objectAtIndex:1] children] firstObject] textContent];
        
        NSLog(@"%@", text);
        
        return text;
    }
    else if (self.searchType == BYSearchImageObject)
    {
        return [[[[[self.htmlElement childElementNodes] objectAtIndex:1] childElementNodes] objectAtIndex:1] textContent];
    }
    else
    {
        return @"";
    }
}

- (NSString *)imageLink
{
    if (self.searchType == BYSearchTextObject)
    {
        return nil;
    }
    else if (self.searchType == BYSearchImageObject)
    {
        NSDictionary* attributes = (NSDictionary *)[[[self.htmlElement childElementNodes] firstObject]  attributes];
        return attributes[@"href"];
    }
    else
    {
        return nil;
    }
}

- (NSString *)infoLink
{
    if (self.searchType == BYSearchTextObject)
    {
        NSDictionary* attributes = (NSDictionary*)[[[[[self.htmlElement children] firstObject] children] firstObject] attributes];
        
        return attributes[@"href"];
    }
    else if (self.searchType == BYSearchImageObject)
    {
        NSDictionary* attributes = (NSDictionary*)[[[self.htmlElement children] firstObject] attributes];
        return attributes[@"href"];
    }
    else
    {
        return @"";
    }
}

@end
