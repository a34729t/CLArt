//
//  ViewController.m
//  BTGlassScrollViewExample
//
//  Created by Byte on 10/18/13.
//  Copyright (c) 2013 Byte. All rights reserved.
//

#define SIMPLE_SAMPLE NO


#import "GlassViewController.h"

@interface GlassViewController ()

@property (nonatomic, strong) BeaconManager *beaconManager;
@property (nonatomic, strong) UIBarButtonItem *rightButton;
@property (nonatomic) long count;

@end

@implementation GlassViewController
{
    BTGlassScrollView *_glassScrollView;
    
    UIScrollView *_viewScroller;
    BTGlassScrollView *_glassScrollView1;
    BTGlassScrollView *_glassScrollView2;
    BTGlassScrollView *_glassScrollView3;
    int _page;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _page = 0;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    self.beaconManager = [BeaconManager sharedInstance];
    self.beaconManager.delegate = self;
    
    //showing white status
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //preventing weird inset
    [self setAutomaticallyAdjustsScrollViewInsets: NO];
    
    // HACK ALERT: Right bar button
//    self.rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Foo" style:UIBarButtonSystemItemAdd target:self action:@selector(addNewGlassyView)];
//    [self.navigationItem setRightBarButtonItem:self.rightButton];
    
    //navigation bar work
    NSShadow *shadow = [[NSShadow alloc] init];
    [shadow setShadowOffset:CGSizeMake(1, 1)];
    [shadow setShadowColor:[UIColor blackColor]];
    [shadow setShadowBlurRadius:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSShadowAttributeName: shadow};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.title = @"Awesome App";

    //background
    self.view.backgroundColor = [UIColor blackColor];
    
#warning Toggle this to see the more complex build of this version
    if (SIMPLE_SAMPLE) {
        //create your custom info views
        UIView *view = [self customView];
        
        _glassScrollView = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"background3"] blurredImage:nil viewDistanceFromBottom:120 foregroundView:view];
        
        [self.view addSubview:_glassScrollView];
    }else{
        CGFloat blackSideBarWidth = 2;
        
        _viewScroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width + 2*blackSideBarWidth, self.view.frame.size.height)];
        [_viewScroller setPagingEnabled:YES];
        [_viewScroller setDelegate:self];
        [_viewScroller setShowsHorizontalScrollIndicator:NO];
        [self.view addSubview:_viewScroller];
        
        _glassScrollView1 = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"background3"] blurredImage:nil viewDistanceFromBottom:120 foregroundView:[self customView]];
        _glassScrollView2 = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"background2"] blurredImage:nil viewDistanceFromBottom:120 foregroundView:[self customView]];
        _glassScrollView3 = [[BTGlassScrollView alloc] initWithFrame:self.view.frame BackgroundImage:[UIImage imageNamed:@"background"] blurredImage:nil viewDistanceFromBottom:120 foregroundView:[self customView]];
        
        [_viewScroller addSubview:_glassScrollView1];
//        [_viewScroller addSubview:_glassScrollView2];
//        [_viewScroller addSubview:_glassScrollView3];
    }
}


bool flag = 1;

-(void)discoveredBeacon:(NSString *)key distance:(NSString *)distanceStr
{
    NSString *assPath = [[NSBundle mainBundle] pathForResource:@"Ass" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:assPath];
    NSDictionary *root = [NSDictionary dictionaryWithDictionary:[dict objectForKey:@"Root"]];
    // Have we already seen this beacon? Needs to be persistent.
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *seenPath = [[paths objectAtIndex:0]
                      stringByAppendingPathComponent:@"Seen.plist"];
    NSMutableDictionary *seenDict = [[NSMutableDictionary alloc] initWithContentsOfFile:seenPath];
    // does the path exist?
    if (seenPath) {
        NSLog(@"seenDict exists, setting art as seen");
        [seenDict setValue:@"1" forKey:key];
    }
    // the path does not exist, create the file
    else {
        NSLog(@"seenDict not found, setting art as seen and writing to file");
        seenDict = [[NSMutableDictionary alloc] init];
        [seenDict setValue:@"1" forKey:key];
    }
    
    // Is this beacon in blacklist? if so, return
    NSDictionary *blacklist = [NSDictionary dictionaryWithDictionary:root[@"blacklist"]];
    if (blacklist[key]) {
        NSLog(@"blacklisted beacon found: %@", key);
        return;
    }
    
    // Is this beacon in beacon2art? if not, return
    NSDictionary *beacon2art = [NSDictionary dictionaryWithDictionary:root[@"beacon2art"]];
    if (!beacon2art[key]) {
        NSLog(@"beacon %@ not found in plist", key);
        return;
    }
    
    NSLog(@"found beacon: %@", key);
    [seenDict writeToFile:seenPath atomically:YES];
    
    // Add the corresponding glassview to _viewscroller
    if ([key isEqualToString:@"4556564072"]) {
        [self addNewGlassyView:_glassScrollView2];
    }
    else if ([key isEqualToString:@"6046356367"]) {
        [self addNewGlassyView:_glassScrollView3];
    }
    
    /*
    if (flag) {
        [self addNewGlassyView];
    }
    flag = 0;
     */
}

- (void)addNewGlassyView:(BTGlassScrollView *)newView
{
    NSLog(@"adding new glassy view %@", newView);
    [_viewScroller addSubview:newView];
    [newView setFrame:self.view.frame];
    [newView setFrame:CGRectOffset(newView.bounds, self.count*_viewScroller.frame.size.width, 0)];
    
    self.count++;
    
    [_viewScroller setContentSize:CGSizeMake(self.count*_viewScroller.frame.size.width, self.view.frame.size.height)];
    [_viewScroller setContentOffset:CGPointMake(_page * _viewScroller.frame.size.width, _viewScroller.contentOffset.y)];
    
    [_viewScroller scrollRectToVisible:newView.frame animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!SIMPLE_SAMPLE) {
        int page = _page; // resize scrollview can cause setContentOffset off for no reason and screw things up
        
        CGFloat blackSideBarWidth = 2;
        [_viewScroller setFrame:CGRectMake(0, 0, self.view.frame.size.width + 2*blackSideBarWidth, self.view.frame.size.height)];
        
        
        self.count = 1;
        [_viewScroller setContentSize:CGSizeMake(self.count*_viewScroller.frame.size.width, self.view.frame.size.height)];
        
        [_glassScrollView1 setFrame:self.view.frame];
//        [_glassScrollView2 setFrame:self.view.frame];
//        [_glassScrollView3 setFrame:self.view.frame];
        
//        [_glassScrollView2 setFrame:CGRectOffset(_glassScrollView2.bounds, _viewScroller.frame.size.width, 0)];
//        [_glassScrollView3 setFrame:CGRectOffset(_glassScrollView3.bounds, 2*_viewScroller.frame.size.width, 0)];
        
        [_viewScroller setContentOffset:CGPointMake(page * _viewScroller.frame.size.width, _viewScroller.contentOffset.y)];
        _page = page;
    }
    
    //show animation trick
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
       // [_glassScrollView1 setBackgroundImage:[UIImage imageNamed:@"background"] overWriteBlur:YES animated:YES duration:1];
    });
}

- (void)viewWillLayoutSubviews
{
    // if the view has navigation bar, this is a great place to realign the top part to allow navigation controller
    // or even the status bar
    if (SIMPLE_SAMPLE) {
        [_glassScrollView setTopLayoutGuideLength:[self.topLayoutGuide length]];
    }else{
        [_glassScrollView1 setTopLayoutGuideLength:[self.topLayoutGuide length]];
        [_glassScrollView2 setTopLayoutGuideLength:[self.topLayoutGuide length]];
        [_glassScrollView3 setTopLayoutGuideLength:[self.topLayoutGuide length]];
    }
}

- (UIView *)customView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 705)];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 310, 120)];
    [label setText:[NSString stringWithFormat:@"%i℉",arc4random_uniform(20) + 60]];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120]];
    [label setShadowColor:[UIColor blackColor]];
    [label setShadowOffset:CGSizeMake(1, 1)];
    [view addSubview:label];
    
    UIView *box1 = [[UIView alloc] initWithFrame:CGRectMake(5, 140, 310, 125)];
    box1.layer.cornerRadius = 3;
    box1.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
    [view addSubview:box1];
    
    UIView *box2 = [[UIView alloc] initWithFrame:CGRectMake(5, 270, 310, 300)];
    box2.layer.cornerRadius = 3;
    box2.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
    [view addSubview:box2];
    
    UIView *box3 = [[UIView alloc] initWithFrame:CGRectMake(5, 575, 310, 125)];
    box3.layer.cornerRadius = 3;
    box3.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
    [view addSubview:box3];
    
    return view;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat ratio = scrollView.contentOffset.x/scrollView.frame.size.width;
    _page = (int)floor(ratio);
    NSLog(@"%i",_page);
    if (ratio > -1 && ratio < 1) {
        [_glassScrollView1 scrollHorizontalRatio:-ratio];
    }
    if (ratio > 0 && ratio < 2) {
        [_glassScrollView2 scrollHorizontalRatio:-ratio + 1];
    }
    if (ratio > 1 && ratio < 3) {
        [_glassScrollView3 scrollHorizontalRatio:-ratio + 2];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    BTGlassScrollView *glass = [self currentGlass];
    
    //can probably be optimized better than this
    //this is just a demonstration without optimization
    [_glassScrollView1 scrollVerticallyToOffset:glass.foregroundScrollView.contentOffset.y];
    [_glassScrollView2 scrollVerticallyToOffset:glass.foregroundScrollView.contentOffset.y];
    [_glassScrollView3 scrollVerticallyToOffset:glass.foregroundScrollView.contentOffset.y];
}

- (BTGlassScrollView *)currentGlass
{
    BTGlassScrollView *glass;
    switch (_page) {
        case 0:
            glass = _glassScrollView1;
            break;
        case 1:
            glass = _glassScrollView2;
            break;
        case 2:
            glass = _glassScrollView3;
        default:
            break;
    }
    return glass;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

/*
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self viewWillAppear:YES];
}
 */

@end
