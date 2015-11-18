//
//  HONHomeViewCell.h
//  HotOrNot
//
//  Created by BIM  on 7/29/15.
//  Copyright (c) 2015 Built in Menlo, LLC. All rights reserved.
//

#import "TableViewCell.h"
#import "ChannelVO.h"

@class HomeViewCell;
@protocol HomeViewCellDelegate <TableViewCellDelegate>
@optional
- (void)homeViewCell:(HomeViewCell *)cell didSelectChannel:(ChannelVO *)channelVO;
@end

@interface HomeViewCell : TableViewCell
+ (NSString *)cellReuseIdentifier;

- (void)populateFields:(NSDictionary *)dictionary;

@property (nonatomic, assign) id <HomeViewCellDelegate> delegate;

@end
