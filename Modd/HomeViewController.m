//
//  ViewController.m
//  Modd
//
//  Created on 11/18/15.
//  Copyright © 2015. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewCell.h"
#import "ChannelViewController.h"

@interface HomeViewController () <HomeViewCellDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *composeButton;
@property (nonatomic, strong) UIImageView *tutorialImageView;
@property (nonatomic, strong) NSArray *channelNames;
@property (nonatomic, strong) UIView *loadingView;
@end

@implementation HomeViewController
- (id)init {
	if ((self = [super init])) {
		
		_channelNames = @[@{@"title"		: @"Music",
							@"channel"	: @"79cd5259-a571-44e5-8d9d-32ac2fa11dab_1439925535",
							@"url"		: @"http://pp1.link/5gvGQn",
							@"timestamp"	: [NSDate date],
							@"occupants"	: @"1"},
						  @{@"title"		: @"Games",
							@"channel"	: @"79cd5259-a571-44e5-8d9d-32ac2fa11dab_1439925562",
							@"url"		: @"http://pp1.link/SCcYIQ",
							@"timestamp"	: [NSDate date],
							@"occupants"	: @"1"},
						  @{@"title"		: @"Explore",
							@"channel"	: @"79cd5259-a571-44e5-8d9d-32ac2fa11dab_1439925586",
							@"url"		: @"http://pp1.link/URXK7m",
							@"timestamp"	: [NSDate date],
							@"occupants"	: @"1"}];
		
	}
	
	return (self);
}


- (void)_registerPushNotifications {
	NSLog(@"%@._registerPushNotifications", self.class);
	
	if ([[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
//if (![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
		[[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
		[[UIApplication sharedApplication] registerForRemoteNotifications];
//}
		
	} else {
//		if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone)
		[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
	}
}


- (void)viewDidLoad {
	[super viewDidLoad];
	
	_scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	_scrollView.backgroundColor = [UIColor colorWithRed:0.396 green:0.596 blue:0.922 alpha:1.00];
	_scrollView.backgroundColor = [UIColor colorWithRed:0.400 green:0.839 blue:0.698 alpha:1.00];
	_scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 3.0, _scrollView.frame.size.height);
	_scrollView.contentInset = UIEdgeInsetsZero;
	_scrollView.alwaysBounceHorizontal = YES;
	_scrollView.pagingEnabled = YES;
	_scrollView.delegate = self;
	[_scrollView setTag:1];
	[self.view addSubview:_scrollView];
	
	UIImageView *tutorial1ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tutorial_01"]];
	[_scrollView addSubview:tutorial1ImageView];
	
	UIImageView *tutorial2ImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tutorial_02"]];
	tutorial2ImageView.frame = CGRectOffset(tutorial2ImageView.frame, _scrollView.frame.size.width, 0.0);
	[_scrollView addSubview:tutorial2ImageView];
	
	_tableView = [[UITableView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width * 2.0, 74.0, _scrollView.frame.size.width, _scrollView.frame.size.height - 74.0) style:UITableViewStylePlain];
	_tableView.backgroundColor = [UIColor whiteColor];
	_tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, _composeButton.frame.size.height, 0.0);
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[_tableView setTag:2];
	_tableView.alwaysBounceVertical = YES;
	_tableView.showsVerticalScrollIndicator = YES;
	[_scrollView addSubview:_tableView];
	
	_composeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_composeButton.frame = CGRectMake(0.0, _scrollView.frame.size.height, _scrollView.frame.size.width, 76.0);
	[_composeButton setBackgroundImage:[UIImage imageNamed:@"composeButton_nonActive"] forState:UIControlStateNormal];
	[_composeButton setBackgroundImage:[UIImage imageNamed:@"composeButton_Active"] forState:UIControlStateHighlighted];
	[_composeButton addTarget:self action:@selector(_goCompose) forControlEvents:UIControlEventTouchUpInside];
	_composeButton.alpha = 1.0;
	[self.view addSubview:_composeButton];
	
	_tutorialImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"createTutorial"]];
	_tutorialImageView.frame = CGRectOffset(_tutorialImageView.frame, 0.0, (_scrollView.frame.size.height + 9.0) - (_composeButton.frame.size.height + _tutorialImageView.frame.size.height));
	_tutorialImageView.hidden = YES;
	_tutorialImageView.alpha = 0.0;
	
	if (![[NSUserDefaults standardUserDefaults] objectForKey:@"home_tutorial"])
		[self.view addSubview:_tutorialImageView];
	
	[[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"home_tutorial"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	
}


#pragma mark - Navigation
- (void)_goCompose {
	_loadingView = [[UIView alloc] initWithFrame:self.view.frame];
	_loadingView.backgroundColor = [UIColor colorWithRed:0.839 green:0.729 blue:0.400 alpha:1.00];
	[self.view addSubview:_loadingView];
	
	UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicatorView.center = CGPointMake(_loadingView.bounds.size.width * 0.5, (_loadingView.bounds.size.height + 20.0) * 0.5);
	[activityIndicatorView startAnimating];
	[_loadingView addSubview:activityIndicatorView];
}


#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return (2);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	//return ((section == 0) ? 1 : (section == 1) ? 3 : [[[NSUserDefaults standardUserDefaults] objectForKey:@"channel_history"] count]);
	return ((section == 0) ? 1 : [[[NSUserDefaults standardUserDefaults] objectForKey:@"channel_history"] count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	HomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
	
	if (cell == nil)
		cell = [[HomeViewCell alloc] init];
	[cell setSize:[tableView rectForRowAtIndexPath:indexPath].size];
	[cell setIndexPath:indexPath];
	cell.delegate = self;
	
	if (indexPath.section == 0) {
		[cell populateFields:@{@"title"		: @"Friends",
							   @"channel"	: @"79cd5259-a571-44e5-8d9d-32ac2fa11dab_1439925679",
							   @"url"		: @"http://pp1.link/7IVlbk",
							   @"timestamp"	: [NSDate date],
							   @"occupants"	: @"1"}];
		
		//	} else if (indexPath.section == 1) {
		//		[cell populateFields:[_appChannels objectAtIndex:indexPath.row]];
		
	} else if (indexPath.section == 1) {
		NSArray *sortedArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"channel_history"] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO]]];
		[cell populateFields:[sortedArray objectAtIndex:indexPath.row]];
	}
	
	
	
	//	[cell populateFields:(indexPath.section == 0) ? [[[NSUserDefaults standardUserDefaults] objectForKey:@"channel_history"] objectAtIndex:indexPath.row] : @{@"name"		: @"Random",
	//																																					   @"timestamp"	: [NSDate date],
	//																																					   @"occupants"	: @(0)}];
	[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
	
	return (cell);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableHeaderBG"]];
	
	//	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12.0, 4.0, tableView.frame.size.width - 30.0, 15.0)];
	//	label.font = [[[HONFontAllocator sharedInstance] avenirHeavy] fontWithSize:13];
	//	label.backgroundColor = [UIColor clearColor];
	//	label.textColor = [[HONColorAuthority sharedInstance] honGreyTextColor];
	//	label.text = (section == 0) ? @"Recent" : @"Older";
	//	[imageView addSubview:label];
	
	return (imageView);
}


#pragma mark - TableView Delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return (74.0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	CGFloat height = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tableHeaderBG"]].frame.size.height;
	return ((section == 0 || section == 1) ? height : ([[[NSUserDefaults standardUserDefaults] objectForKey:@"channel_history"] count] == 0) ? 0.0 : height);
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return (indexPath);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
	//HONHomeViewCell *cell = (HONHomeViewCell *)[tableView cellForRowAtIndexPath:indexPath];
	
	
	if (indexPath.section == 1) {
		_loadingView = [[UIView alloc] initWithFrame:self.view.frame];
		_loadingView.backgroundColor = [UIColor colorWithRed:0.839 green:0.729 blue:0.400 alpha:1.00];
		[self.view addSubview:_loadingView];
		
		UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityIndicatorView.center = CGPointMake(_loadingView.bounds.size.width * 0.5, (_loadingView.bounds.size.height + 20.0) * 0.5);
		[activityIndicatorView startAnimating];
		[_loadingView addSubview:activityIndicatorView];
		
		NSDictionary *dictionary = [[[[[NSUserDefaults standardUserDefaults] objectForKey:@"channel_history"] reverseObjectEnumerator] allObjects] objectAtIndex:indexPath.row];
		
		//[[HONAnalyticsReporter sharedInstance] trackEvent:[kAnalyticsCohort stringByAppendingString:@" - joinPopup"] withProperties:@{@"channel"	: [dictionary objectForKey:@"channel"]}];
		
		ChannelViewController *channelViewController = [[ChannelViewController alloc] initWithChannelName:[dictionary objectForKey:@"channel"]];
		[self.navigationController pushViewController:channelViewController animated:YES];
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
			[_loadingView removeFromSuperview];
			[_tutorialImageView removeFromSuperview];
		});
		
		
	} else if (indexPath.section == 0) {
		//[[HONAnalyticsReporter sharedInstance] trackEvent:[kAnalyticsCohort stringByAppendingString:@" - joinPopup"] withProperties:@{@"channel"	: @"e23d61a9-622c-45c1-b92e-fd7c5d586b3a_1438284321"}];
		
		_loadingView = [[UIView alloc] initWithFrame:self.view.frame];
		_loadingView.backgroundColor = [UIColor		colorWithRed:0.839 green:0.729 blue:0.400 alpha:1.00];
		[self.view addSubview:_loadingView];
		
		UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityIndicatorView.center = CGPointMake(_loadingView.bounds.size.width * 0.5, (_loadingView.bounds.size.height + 20.0) * 0.5);
		[activityIndicatorView startAnimating];
		[_loadingView addSubview:activityIndicatorView];
		
		ChannelViewController *channelViewController = [[ChannelViewController alloc] initWithChannelName:@"79cd5259-a571-44e5-8d9d-32ac2fa11dab_1439925679"];
		[self.navigationController pushViewController:channelViewController animated:YES];
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void) {
			[_loadingView removeFromSuperview];
			[_tutorialImageView removeFromSuperview];
		});
	}
}



@end
