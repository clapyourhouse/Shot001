//
//  AppDelegate.h
//  BigShot
//
//  Created by KitamuraShogo on 13/04/16.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class RootViewController;
//@class MYIntroductionView;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
  //  MYIntroductionView *myIntroductionView;
}

@property (nonatomic, retain) UIWindow *window;

@end
