//
//  AuthViewController.m
//  Modd
//
//  Created on 12/1/15.
//  Copyright © 2015. All rights reserved.
//

#import "AFNetworking.h"

#import "AuthViewController.h"

@interface AuthViewController ()
@property (nonatomic) int twitchID;
@property (nonatomic, strong) NSDictionary *twitchUser;
@end

@implementation AuthViewController
@synthesize delegate = _delegate;
@synthesize twitchName = _twitchName;

- (id)initWithTwitchOwner:(int)twitchID {
	if ((self = [super init])) {
		_twitchID = twitchID;
	}
	
	return (self);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setTwitchName:(NSString *)twitchName {
	_twitchName = twitchName;
}

#pragma mark - WebView Delegates
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	[super webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
	
	NSString *oauthToken = @"";
	if ([request.URL.absoluteString rangeOfString:@"#access_token"].location != NSNotFound) {
		oauthToken = [[[[[request.URL.absoluteString componentsSeparatedByString:@"/"] lastObject] componentsSeparatedByString:@"&"] firstObject] stringByReplacingOccurrencesOfString:@"#access_token=" withString:@""];
		NSLog(@"OAUTH:[%@]", oauthToken);
		
		NSString *apiPath = @"channel";
		NSDictionary *params = nil;
		
		NSLog(@"_/:[%@]—//%@> (%@/%@) %@\n\n", [[self class] description], @"GET", @"https://api.twitch.tv/kraken", apiPath, params);
		AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.twitch.tv/kraken"]];
		[httpClient setDefaultHeader:@"Authorization" value:[@"OAuth " stringByAppendingString:oauthToken]];
		[httpClient getPath:apiPath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
			NSError *error = nil;
			NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
			
			if (error != nil) {
				NSLog(@"AFNetworking [-] %@: (%@) - Failed to parse JSON: %@", [[self class] description], [[operation request] URL], [error localizedFailureReason]);
				
			} else {
				NSLog(@"AFNetworking [-] %@ |[:]>> RESULT [:]|>>\n%@", [[self class] description], result);
				
				_twitchUser = result;
				
				[[NSUserDefaults standardUserDefaults] setObject:[result objectForKey:@"name"] forKey:@"twitch_name"];
				[[NSUserDefaults standardUserDefaults] synchronize];
				
				if ([[result objectForKey:@"name"] isEqualToString:_twitchName]) {
					[self.navigationController dismissViewControllerAnimated:YES completion:^(void) {
						if ([self.delegate respondsToSelector:@selector(authViewController:didAuthAsOwner:)])
							[self.delegate authViewController:self didAuthAsOwner:_twitchUser];
					}];
				
				} else {
					UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Not Channel Owner!"
																		message:[@"You are logged in as " stringByAppendingString:[result objectForKey:@"display_name"]]
																	   delegate:self
															  cancelButtonTitle:@"OK"
															  otherButtonTitles:nil];
					[alertView setTag:1];
					[alertView show];
				}
			}
			
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			NSLog(@"AFNetworking [-] %@: (%@) Failed Request - (%d) %@", [[self class] description], [[operation request] URL], (int)[operation response].statusCode, [error localizedDescription]);
		}];
	}
	
	return (([[request URL].absoluteString rangeOfString:@"access_token"].location == NSNotFound));
}


#pragma mark - AlertView Delegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 1) {
		[self.navigationController dismissViewControllerAnimated:YES completion:^(void) {
		}];
	}
}
@end
