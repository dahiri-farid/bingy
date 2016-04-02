//
//  BYWebPreviewController.m
//  bingy
//
//  Created by Dahiri Farid on 4/2/16.
//  Copyright © 2016 Dahiri Farid. All rights reserved.
//

#import "BYWebPreviewController.h"

@interface BYWebPreviewController ()

@property (nonatomic, strong)   IBOutlet UIWebView* webView;

@end

@implementation BYWebPreviewController

+ (instancetype)vc
{
     BYWebPreviewController* vc = [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
