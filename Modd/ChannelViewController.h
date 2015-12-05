//
//  ChannelViewController.h
//  Modd
//
//  Created on 11/17/15.
//  Copyright © 2015. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChannelVO.h"

@interface ChannelViewController : UIViewController <UIGestureRecognizerDelegate, UIScrollViewDelegate, UITextFieldDelegate>
- (id)initFromDeepLinkWithChannelName:(NSString *)channelName;
- (id)initWithChannel:(ChannelVO *)channelVO;
- (id)initWithChannel:(ChannelVO *)channelVO asTwitchUser:(NSDictionary *)twitchUser;
@end
