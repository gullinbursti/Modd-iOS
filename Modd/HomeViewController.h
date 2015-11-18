//
//  ViewController.h
//  Modd
//
//  Created on 11/18/15.
//  Copyright © 2015. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HomeActionSheetType) {
	HomeActionSheetTypeTermsAgreement = 0
};

@interface HomeViewController : UIViewController <UIActionSheetDelegate, UIAlertViewDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>


@end

