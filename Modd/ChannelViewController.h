//
//  ChannelViewController.h
//  Modd
//
//  Created on 11/17/15.
//  Copyright © 2015. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChannelViewController : UIViewController
- (id)initFromDeepLinkWithChannelName:(NSString *)channelName;
- (id)initWithChannelName:(NSString *)channelName;
@end
