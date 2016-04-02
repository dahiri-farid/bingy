//
//  BYSearchViewController.m
//  bingy
//
//  Created by Dahiri Farid on 4/1/16.
//  Copyright © 2016 Dahiri Farid. All rights reserved.
//

#import "BYSearchViewController.h"
#import "BYTextResult.h"
#import "HTMLParser.h"
#import <UIImageView+AFNetworking.h>
#import "BYSearchResultTableViewCell.h"
#import "BYWebPreviewController.h"

@interface BYSearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong)   IBOutlet    UITableView* tableView;
@property (nonatomic, strong)   IBOutlet    UISearchBar* searchBar;
@property (nonatomic, strong)   IBOutlet    UISegmentedControl* segmentedCotrol;
@property (nonatomic, strong)               NSArray* bingSearchResults;
@property (nonatomic, strong)               NSTimer* searchTimer;
@property (nonatomic, strong)               NSURLSessionDataTask* searchTask;

@end

@implementation BYSearchViewController

+ (instancetype)vc
{
    return [[self alloc] initWithNibName:(NSStringFromClass([self class])) bundle:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"BINGY";
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)setupTimer
{
    [self.searchTimer invalidate];
    
    self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performSearch:) userInfo:nil repeats:NO];
}

- (void)performSearch:(NSTimer *)aTimer
{
    [self searchRequest];
}

- (void)searchRequest
{
    [self.searchTask cancel];
    
    NSString* urlStr = nil;
    
    if (self.segmentedCotrol.selectedSegmentIndex == 0)
    {
        urlStr = [NSString stringWithFormat:@"https://www.bing.com/search?q=%@&FORM=HDRSC1",
                  self.searchBar.text];
    }
    else
    {
        urlStr = [NSString stringWithFormat:@"https://www.bing.com/images/search?q=%@&FORM=HDRSC2",
                  self.searchBar.text];
    }
    
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLSession *session = [NSURLSession sharedSession];
    
    __weak typeof (self)weakSelf = self;
    
    self.searchTask = [session dataTaskWithURL:URL completionHandler:
      ^(NSData *data, NSURLResponse *response, NSError *error) {
         
          NSString *contentType = nil;
          if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
              NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
              contentType = headers[@"Content-Type"];
          }
          HTMLDocument *home = [HTMLDocument documentWithData:data
                                            contentTypeHeader:contentType];
          
          if (weakSelf.segmentedCotrol.selectedSegmentIndex == 0)
          {
              weakSelf.bingSearchResults = [weakSelf parseTextSearchWithHTMLDocument:home];
          }
          else if (weakSelf.segmentedCotrol.selectedSegmentIndex == 1)
          {
              weakSelf.bingSearchResults = [weakSelf parseImageSearchWithHTMLDocument:home];
          }
          
          if ([weakSelf.bingSearchResults count] == 0)
          {
              BYTextResult* textResult = [BYTextResult noResultsObject];
              weakSelf.bingSearchResults = @[textResult];
          }
         
          dispatch_async(dispatch_get_main_queue(), ^{
              [weakSelf.tableView reloadData];
          });
      }];
    
    [self.searchTask resume];
}

#pragma mark - Actions

- (IBAction)segmentedControlAction:(id)sender
{
    if ([self.searchBar.text length])
        [self searchRequest];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.bingSearchResults count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BYSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BYSearchResultTableViewCell.ID];
    
    if (cell == nil)
    {
        cell = [BYSearchResultTableViewCell cell];
    }
    
    BYTextResult* textResult = self.bingSearchResults[indexPath.row];
    
    [cell updateWithTitle:textResult.titleLink
                 subtitle:textResult.subtitle
                imageLink:textResult.imageLink];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BYTextResult* textResult = self.bingSearchResults[indexPath.row];
    if (textResult.searchType == BYSearchNoResults)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
    BYWebPreviewController* vc = [BYWebPreviewController vc];
    
    [vc setURL:[NSURL URLWithString:textResult.infoLink]];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length != 0)
        [self setupTimer];
}

- (NSArray *)parseTextSearchWithHTMLDocument:(HTMLDocument *)aHTMLDocument
{
    NSParameterAssert(aHTMLDocument);
    
    NSMutableArray* datasource = [NSMutableArray array];
    if ([[[aHTMLDocument bodyElement] children] count] >= 6)
    {
        NSArray* elements =  [[[[[[[aHTMLDocument bodyElement] children] objectAtIndex:5] children] objectAtIndex:1] children] array];
        
        for (HTMLElement* element in elements)
        {
            if ([element hasClass:@"b_algo"])
            {
                BYTextResult* textResult = [BYTextResult textResultsWithHTMLElement:element type:BYSearchTextObject];
                [datasource addObject:textResult];
            }
        }
    }
    return datasource;
}

- (NSArray *)parseImageSearchWithHTMLDocument:(HTMLDocument *)aHTMLDocument
{
    NSParameterAssert(aHTMLDocument);
    
    NSMutableArray* datasource = [NSMutableArray array];
    
    if ([[[aHTMLDocument bodyElement] children] count] >= 6)
    {
        NSArray* elements =  [[[[[[[[[[aHTMLDocument bodyElement] children] objectAtIndex:5] children] firstObject] childElementNodes] firstObject] childElementNodes] firstObject] childElementNodes];
        
        for (HTMLElement* element in elements)
        {
            if ([element hasClass:@"row"])
            {
                NSArray* imagesElements = [element childElementNodes];
                for (HTMLElement* imageElement in imagesElements)
                {
                    NSLog(@"%@", imageElement);
                    
                    BYTextResult* textResult = [BYTextResult textResultsWithHTMLElement:imageElement type:BYSearchImageObject];
                    [datasource addObject:textResult];
                }
            }
        }
    }
    
    return datasource;
}

@end
