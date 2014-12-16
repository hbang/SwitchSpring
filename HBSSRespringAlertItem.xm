#import "HBSSRespringAlertItem.h"
#import <SpringBoard/SpringBoard.h>
#import <SpringBoard/SBApplication.h>
#import <SpringBoard/SBAppSliderController.h>
#import <SpringBoard/SBAppSwitcherController.h>
#import <SpringBoard/SBAppSwitcherPageViewController.h>
#import <SpringBoard/SBDisplayItem.h>
#import <SpringBoard/SBDisplayLayout.h>
#import <SpringBoard/SBMediaController.h>
#import <UIKit/UIAlertView+Private.h>
#import <UIKit/UIViewController+Private.h>
#import <version.h>

SBAppSwitcherController *controller;

%subclass HBSSRespringAlertItem : SBAlertItem

%new - (id)initWithController:(SBAppSwitcherController *)controller_ {
	self = [self init];

	if (self) {
		controller = controller_;
	}

	return self;
}

- (void)configure:(BOOL)configure requirePasscodeForActions:(BOOL)requirePasscode {
	%orig;

	self.alertSheet.delegate = self;
	self.alertSheet.title = @"Restart SpringBoard?";

	[self.alertSheet addButtonWithTitle:@"Restart"];
	[self.alertSheet addButtonWithTitle:@"Quit Apps"];
	[self.alertSheet addButtonWithTitle:@"Cancel"];

	self.alertSheet.forceHorizontalButtonsLayout = YES;
	self.alertSheet.numberOfRows = 1;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index {
	void (^resetScrollViews)() = ^{
		if (IS_IOS_OR_NEWER(iOS_8_0)) {
			NSDictionary *items = MSHookIvar<NSDictionary *>(controller.pageController, "_items");

			BOOL outerBreak = NO;

			for (SBDisplayLayout *displayLayout in items.allKeys) {
				for (SBDisplayItem *displayItem in displayLayout.displayItems) {
					if ([displayItem.displayIdentifier isEqualToString:kHBSSSpringBoardItemIdentifier]) {
						((UIScrollView *)items[displayLayout]).contentOffset = CGPointZero;
						outerBreak = YES;
						break;
					}
				}

				if (outerBreak) {
					break;
				}
			}
		} else {
			for (UIScrollView *scrollView in controller.contentScrollView.subviews) {
				if ([scrollView isKindOfClass:UIScrollView.class]) {
					scrollView.contentOffset = CGPointZero;
				}
			}
		}
	};

	switch (index) {
		case 0:
			[(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
			break;

		case 1:
		{
			resetScrollViews();

			NSString *nowPlayingApp = ((SBMediaController *)[%c(SBMediaController) sharedInstance]).nowPlayingApplication.bundleIdentifier;

			if (IS_IOS_OR_NEWER(iOS_8_0)) {
				NSDictionary *items = MSHookIvar<NSDictionary *>(controller.pageController, "_items");

				for (SBDisplayLayout *displayLayout in items.allKeys) {
					for (SBDisplayItem *displayItem in displayLayout.displayItems) {
						if ([displayItem.displayIdentifier isEqualToString:kHBSSSpringBoardItemIdentifier]) {
							[controller switcherScroller:controller.pageController itemTapped:displayLayout];
						} else if ([controller switcherScroller:controller.pageController isDisplayItemRemovable:displayItem] && ![displayItem.displayIdentifier isEqualToString:nowPlayingApp]) {
							[controller switcherScroller:controller.pageController displayItemWantsToBeRemoved:displayItem];
						}
					}
				}
			} else {
				SBAppSliderController *legacyController = (SBAppSliderController *)controller;
				[legacyController sliderScroller:legacyController.pageController itemTapped:0];

				NSUInteger count = [legacyController sliderScrollerItemCount:legacyController.pageController];
				NSUInteger current = 1;

				for (NSUInteger i = 1; i < count; i++) {
					if ([legacyController sliderScroller:legacyController.pageController isIndexRemovable:current] && ![[legacyController _displayIDAtIndex:current] isEqualToString:nowPlayingApp]) {
						[legacyController sliderScroller:legacyController.pageController itemWantsToBeRemoved:current];
					} else {
						current++;
					}
				}
			}

			break;
		}

		case 2:
			[UIView animateWithDuration:0.3f animations:resetScrollViews];
			break;
	}

	[self dismiss];
}

%end
