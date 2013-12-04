//
//  FTProfileViewController.m
//  Green Area 1.0
//
//  Created by DmVolk on 20.10.13.
//  Copyright (c) 2013 ForestTeam. All rights reserved.
//

#import "FTProfileViewController.h"
#import "FTShadowView.h"
#import "FTAboutViewController.h"
#import <Social/Social.h>

static NSString *CellIdentifier = @"CellIdentifier";
static CGFloat kTableViewOffset = 160;
static CGFloat kNameViewOffset = 20;

@implementation FTProfileViewController

{
    CGFloat _headerImageYOffset;
}

-(id) init
{
    self = [super init];
    if (self) {
        self.title = @"Profile";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIColor *tableBackgroundColor = [UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:1];
    self.view.backgroundColor = tableBackgroundColor;
    
    //table view
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x,
                                                               self.view.bounds.origin.y,
                                                               self.view.bounds.size.width,
                                                               self.view.bounds.size.height - 44.0 /*height nav bar*/ - 50.0f /*height tab bar*/) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.view addSubview:_tableView];
    
    //***parallax***
    
    //configure _secondParaView
    _secondParaView = [[UIView alloc] initWithFrame:CGRectMake(0, kTableViewOffset, self.view.bounds.size.width, self.view.bounds.size.height)];
    _secondParaView.backgroundColor = tableBackgroundColor;
    [self.view insertSubview:_secondParaView belowSubview:_tableView];
    
    //configure _headerImageView
    _headerImageYOffset = -80.0;
    _headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chgreen.png"]];
    CGRect headerImageFrame = _headerImageView.frame;
    headerImageFrame.origin.y = _headerImageYOffset;
    _headerImageView.frame = headerImageFrame;
    [self.view insertSubview:_headerImageView belowSubview:_secondParaView];
    
    _tableView.backgroundView.backgroundColor = [UIColor clearColor];
    
    //configure _nameView
    _nameView = [[UIView alloc] initWithFrame:CGRectMake(0.0, kNameViewOffset, self.view.bounds.size.width, kTableViewOffset-kNameViewOffset)];
    _nameView.backgroundColor = [UIColor clearColor];
    FTShadowView *shadowView = [[FTShadowView alloc] initWithFrame:CGRectMake(0.0, 0.0, _nameView.frame.size.width, _nameView.frame.size.height)];
    [_nameView addSubview:shadowView];
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, _nameView.frame.size.height - 45.0, _nameView.frame.size.width - 40.0, 40.0)];
    NSMutableAttributedString *attributedName = [[NSMutableAttributedString alloc] initWithString:@"Christopher Green"];
    UIColor *nameColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
    NSDictionary *nameAttributes = @{NSFontAttributeName : [UIFont fontWithName: @"Avenir-Book" size:30.0],
    NSForegroundColorAttributeName : nameColor};
    [attributedName setAttributes:nameAttributes range:NSMakeRange(0, [attributedName length])];
    nameLabel.attributedText = attributedName;
    nameLabel.backgroundColor = [UIColor clearColor];
    [_nameView addSubview:nameLabel];
    
    [self.view insertSubview:_nameView belowSubview:_tableView];
}

#pragma mark Table View DataSource Methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 0;
    if (section == 0) {
        result = 2;
    } else if (section == 1){
        result = 1;
    } else if (section == 2){
        result = 1;
    }
    return result;
}

#pragma mark Table View Delegate Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.backgroundColor = [UIColor colorWithRed:16.0f/255.0f green:163.0f/255.0f blue:120.0f/255.0f alpha:1];
    
    NSString *cellText = [NSString string];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cellText = @"Settings";
            cell.imageView.image = [UIImage imageNamed:@"settings.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if (indexPath.row == 1){
            cellText = @"About";
            cell.imageView.image = [UIImage imageNamed:@"about.png"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            cellText = @"Tweet about Green Area";
            cell.imageView.image = [UIImage imageNamed:@"twitter.png"];
        }
    } else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            cellText = @"Privacy Policy";
            cell.imageView.image = [UIImage imageNamed:@"privacy.png"];
        }
    }
    
    NSMutableAttributedString *attributedCellText = [[NSMutableAttributedString alloc] initWithString:cellText];
    UIColor *nameColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8];
    NSDictionary *stringSection1Attributes = @{NSFontAttributeName : [UIFont fontWithName: @"Avenir-Book" size:20.0],
    NSForegroundColorAttributeName : nameColor};
    [attributedCellText setAttributes:stringSection1Attributes range:NSMakeRange(0, [attributedCellText length])];
    cell.textLabel.attributedText = attributedCellText;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"Did select section %d row %d", indexPath.section, indexPath.row);
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //settings
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                         message:@"Setting coming soon..."
                                                        delegate:nil
                                               cancelButtonTitle:@"Ok, bro"
                                               otherButtonTitles:nil];
            [av show];
        } else if (indexPath.row == 1){
            //about
            FTAboutViewController *aboutViewCotroller = [[FTAboutViewController alloc] init];
            [aboutViewCotroller setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:aboutViewCotroller animated:YES];
        }
    } else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            //tweet about green area
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                [tweetSheet setInitialText:@"I'm making the world a better place."];
                [tweetSheet addURL:[NSURL URLWithString:@"http://greenarea.herokuapp.com/"]];
                [self presentViewController:tweetSheet animated:YES completion:nil];
            } else {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                             message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup" delegate:nil
                                                   cancelButtonTitle:@"Ok, bro"
                                                   otherButtonTitles: nil];
                [av show];
            }
        }
    } else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            //privacy policy
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"Oops!"
                                                        message:@"Privacy Policy coming soon..."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok, bro"
                                              otherButtonTitles:nil];
            [av show];
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, kTableViewOffset)];
        tableHeaderView.backgroundColor = [UIColor clearColor];
        return tableHeaderView;
        
    } else if(section == 1){
        
        UIView *tableHeaderViewSection1 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 40)];
        tableHeaderViewSection1.backgroundColor = [UIColor clearColor];
        UILabel *lableSection1 = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 10.0, self.view.frame.size.width - 40, 30)];
        lableSection1.backgroundColor = [UIColor clearColor];
        NSMutableAttributedString *attributedTextSec1 = [[NSMutableAttributedString alloc] initWithString:@"Invite to Green Area"];
        UIColor *nameColor = [UIColor colorWithRed:20.0f/255.0f green:20.0f/255.0f blue:20.0f/255.0f alpha:0.5];
        NSDictionary *stringSection1Attributes = @{NSFontAttributeName : [UIFont fontWithName: @"Avenir-Book" size:18.0],
        NSForegroundColorAttributeName : nameColor};
        [attributedTextSec1 setAttributes:stringSection1Attributes range:NSMakeRange(0, [attributedTextSec1 length])];
        lableSection1.attributedText = attributedTextSec1;
        [tableHeaderViewSection1 addSubview:lableSection1];
        return tableHeaderViewSection1;
        
    } else if (section == 2){
        
        UIView *tableHeaderViewSection2 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 40)];
        tableHeaderViewSection2.backgroundColor = [UIColor clearColor];
        UILabel *lableSection2 = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 10.0, self.view.frame.size.width - 40, 30)];
        lableSection2.backgroundColor = [UIColor clearColor];
        NSMutableAttributedString *attributedTextSec2 = [[NSMutableAttributedString alloc] initWithString:@"Privacy"];
        UIColor *nameColor = [UIColor colorWithRed:20.0f/255.0f green:20.0f/255.0f blue:20.0f/255.0f alpha:0.5];
        NSDictionary *stringSection2Attributes = @{NSFontAttributeName : [UIFont fontWithName: @"Avenir-Book" size:18.0],
        NSForegroundColorAttributeName : nameColor};
        [attributedTextSec2 setAttributes:stringSection2Attributes range:NSMakeRange(0, [attributedTextSec2 length])];
        lableSection2.attributedText = attributedTextSec2;
        [tableHeaderViewSection2 addSubview:lableSection2];
        return tableHeaderViewSection2;
        
    } else
        return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return kTableViewOffset + 20;
    } else if(section == 1){
        return 40;
    } else if (section == 2){
        return 40;
    } else
        return 20;
}

#pragma mark Scroll View Delegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGRect headerImageFrame = _headerImageView.frame;
    CGRect underParaFrame = _secondParaView.frame;
    CGRect nameViewFrame = _nameView.frame;
    
    if (scrollOffset < 0) {
        // Adjust top image proportionally
        if (scrollOffset > -kTableViewOffset) {
            headerImageFrame.origin.y = _headerImageYOffset - (scrollOffset / 2);
            underParaFrame.origin.y = kTableViewOffset - scrollOffset;
            nameViewFrame.origin.y = kNameViewOffset - scrollOffset;
        } else {
            headerImageFrame.origin.y = 0.0;
            underParaFrame.origin.y = kTableViewOffset * 2;
            nameViewFrame.origin.y = kTableViewOffset + kNameViewOffset;
        }
        
    } else {
        // We're scrolling up, return to normal behavior
        headerImageFrame.origin.y = _headerImageYOffset - scrollOffset;
        underParaFrame.origin.y = kTableViewOffset - scrollOffset;
        nameViewFrame.origin.y = kNameViewOffset - scrollOffset;
    }
    //underParaFrame.origin.y = kTableViewOffset - scrollOffset;
    _headerImageView.frame = headerImageFrame;
    _secondParaView.frame = underParaFrame;
    _nameView.frame = nameViewFrame;
}

#pragma mark AKTabBarController
-(NSString *)tabImageName
{
    return @"image-1";
}

-(NSString *)tabTitle
{
    return @"Profile";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
