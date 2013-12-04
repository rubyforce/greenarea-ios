//
//  FTDescriptionViewController.m
//  Green Area 1.0
//
//  Created by DmVolk on 01.11.13.
//  Copyright (c) 2013 ForestTeam. All rights reserved.
//

#import "FTDescriptionViewController.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat ImageHeight  = 320.0;
static CGFloat ImageWidth  = 320.0;

@interface FTDescriptionViewController () <UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIView *mainContentView;

@end

@implementation FTDescriptionViewController

#pragma mark - View lifecycle

-(id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
    self.navigationBarHidden = YES;
    self.toolbarHidden = NO;
    
    [self.toolbar setBackgroundImage:[UIImage imageNamed:@"noise-dark-gray.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    
    //close button
    UIImage *closeImage = [UIImage imageNamed:@"close.png"];
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame = CGRectMake(0.0, 0.0, closeImage.size.width, closeImage.size.height);
    [closeButton setImage:closeImage forState:UIControlStateNormal];
    UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    //donate button
    UIImage *donateImage = [UIImage imageNamed:@"donate.png"];
    UIButton *donateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [donateButton addTarget:self action:@selector(donate) forControlEvents:UIControlEventTouchUpInside];
    donateButton.frame = CGRectMake(0.0, 0.0, donateImage.size.width, donateImage.size.height);
    [donateButton setImage:donateImage forState:UIControlStateNormal];
    UIBarButtonItem *donateBarButton = [[UIBarButtonItem alloc] initWithCustomView:donateButton];
    
    //flexible space
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 40;
    
    NSArray *toolbarButtons = [NSArray arrayWithObjects:closeBarButton, fixedSpace, donateBarButton, nil];
    
    self.toolbar.items = toolbarButtons;
    
    //parallax
    
    //***************Fake Incoming Data******************
    self.descriptionText = @"Square in the centre of the City of Minsk located at the crossing of Independence Avenue and Zakharau Street. The square is located in the historic centre of Minsk nearby with the museum of the 1st Congress of RSDRP, Main offices of National State TV and Radio and City House of Marriages.";
    self.createdBy = @"Christopher Green";
    //***************************************************
    
    self.image = [UIImage imageNamed:@"placeholderDescViewHeader.png"];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, ImageWidth, ImageHeight)];
    self.imageView.image = self.image; //placeholder image
    [self downloadImageFromUrl:self.imageUrl];
    
    //main content view
    //nameLabel
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 10.0, 300.0, 40.0)];
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attributedName = [[NSMutableAttributedString alloc] initWithString:self.name];
    UIColor *nameColor = [UIColor colorWithRed:20.0f/255.0f green:20.0f/255.0f blue:20.0f/255.0f alpha:0.5];
    NSDictionary *nameAttributes =
    @{NSFontAttributeName : [UIFont fontWithName: @"Avenir-Book" size:30.0],
    NSForegroundColorAttributeName : nameColor};
    [attributedName setAttributes:nameAttributes range:NSMakeRange(0, [attributedName length])];
    nameLabel.attributedText = attributedName;
    
    //createdByLabel
    UILabel *createdByLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0,
                                                                        nameLabel.frame.origin.y + nameLabel.frame.size.height + 10,
                                                                        300.0,
                                                                        30)];
    createdByLabel.backgroundColor = [UIColor clearColor];
    createdByLabel.textAlignment = NSTextAlignmentCenter;
    NSString *createdByStr = [NSString stringWithFormat:@"Created by %@", self.createdBy];
    NSMutableAttributedString *attributedcreatedBy = [[NSMutableAttributedString alloc] initWithString:createdByStr];
    UIColor *createdByColor = [UIColor colorWithRed:57.0f/255.0f green:202.0f/255.0f blue:93.0f/255.0f alpha:0.8];
    NSDictionary *createdByAttributes =
    @{NSFontAttributeName : [UIFont fontWithName: @"Avenir-Book" size:14.0],
    NSForegroundColorAttributeName : createdByColor};
    [attributedcreatedBy setAttributes:createdByAttributes range:NSMakeRange(0, [attributedcreatedBy length])];
    createdByLabel.attributedText = attributedcreatedBy;
    
    //descLabel
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0,
                                                                   createdByLabel.frame.origin.y + createdByLabel.frame.size.height + 10,
                                                                   300.0,
                                                                   20.0)];
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attributedDesc = [[NSMutableAttributedString alloc] initWithString:@"Description:"];
    UIColor *descColor = [UIColor colorWithRed:20.0f/255.0f green:20.0f/255.0f blue:20.0f/255.0f alpha:0.5];
    NSDictionary *descAttributes =
    @{NSFontAttributeName : [UIFont fontWithName: @"Avenir-Book" size:14.0],
    NSForegroundColorAttributeName : descColor};
    [attributedDesc setAttributes:descAttributes range:NSMakeRange(0, [attributedDesc length])];
    descLabel.attributedText = attributedDesc;
    
    //textView
    UITextView *textView = [[UITextView alloc] init];
    textView.scrollEnabled = NO;
    textView.editable = NO;
    textView.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attributedDescriptionText = [[NSMutableAttributedString alloc] initWithString:self.descriptionText];
    UIColor *descriptionTextColor = [UIColor colorWithRed:20.0f/255.0f green:20.0f/255.0f blue:20.0f/255.0f alpha:0.5];
    UIFont *descriptionTextFont = [UIFont fontWithName: @"Avenir-Book" size:20.0];
    NSDictionary *descriptionTextAttributes =
    @{NSFontAttributeName : descriptionTextFont,
    NSForegroundColorAttributeName : descriptionTextColor};
    [attributedDescriptionText setAttributes:descriptionTextAttributes range:NSMakeRange(0, [attributedDescriptionText length])];
    [textView setAttributedText:attributedDescriptionText];
    
#warning may be incorrect height for big text
    CGSize textSize = [self.descriptionText sizeWithFont:descriptionTextFont
                                       constrainedToSize:CGSizeMake(300.0, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    [textView setFrame:CGRectMake(10.0,
                                  descLabel.frame.origin.y + descLabel.frame.size.height,
                                  textSize.width,
                                  textSize.height + 40)];
    textView.backgroundColor = [UIColor clearColor];
    
    
    CGFloat heightForMainContentView = textView.frame.origin.y + textView.frame.size.height + 10.0;//for scrolling always
    if (heightForMainContentView <= 204) {
        heightForMainContentView = 205;
    }
    
    self.mainContentView = [[UIView alloc] initWithFrame:CGRectMake(0.0,
                                                                    ImageHeight,
                                                                    320,
                                                                    heightForMainContentView)];
    self.mainContentView.backgroundColor = [UIColor clearColor];
    
    [self.mainContentView addSubview:nameLabel];
    [self.mainContentView addSubview:createdByLabel];
    [self.mainContentView addSubview:descLabel];
    [self.mainContentView addSubview:textView];
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.mainContentView.frame.size.height + ImageHeight);
    
    CGRect bounds = CGRectMake(self.view.bounds.origin.x,
                               self.view.bounds.origin.y,
                               self.view.bounds.size.width,
                               self.view.bounds.size.height - 44.0);
    self.scrollView.frame = bounds;
    
    
    [self.scrollView addSubview:self.mainContentView];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.scrollView];
    
}

-(void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)donate
{
    NSLog(@"Donated $5");
}

-(void)downloadImageFromUrl:(NSString *)strUrl
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
    
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request
                                                                              imageProcessingBlock:nil
                                                                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                                                               
                                                                                               self.imageView.image = image;
                                                                                               CATransition *transition = [CATransition animation];
                                                                                               transition.type = kCATransitionFade;
                                                                                               transition.duration = 1.0;
                                                                                               transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                                                                                               [self.imageView.layer addAnimation:transition forKey:nil];
                                                                                               NSLog(@"Image View Frame: %f, %f, %f, %f", self.imageView.frame.origin.x,
                                                                                                     self.imageView.frame.origin.y,
                                                                                                     self.imageView.frame.size.width,
                                                                                                     self.imageView.frame.size.height);
                                                                                               
                                                                                           } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                               NSLog(@"Download Image Error: %@", error);
                                                                                           }];
    [operation start];
}

#pragma mark ScrollView Delegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset = scrollView.contentOffset.y;
    
    if(yOffset < 0){
        
        CGFloat factor = ((ABS(yOffset) + ImageHeight) * ImageWidth)/ImageHeight;
        CGRect f = CGRectMake(-(factor-ImageWidth) / 2, 0, factor, ImageHeight + ABS(yOffset));
        self.imageView.frame = f;
    } else {
        CGRect f = self.imageView.frame;
        f.origin.y = -yOffset;
        self.imageView.frame = f;
    }
}

#pragma mark -

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
