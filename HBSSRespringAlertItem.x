#import "HBSSRespringAlertItem.h"
#import <SpringBoard/SpringBoard.h>
#import <SpringBoard/SBApplication.h>
#import <SpringBoard/SBAppSliderController.h>
#import <SpringBoard/SBMediaController.h>
#import <UIKit/UIAlertView+Private.h>
#import <UIKit/UIViewController+Private.h>

SBAppSliderController *controller;

%subclass HBSSRespringAlertItem : SBAlertItem

%new - (id)initWithController:(SBAppSliderController *)controller_ {
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
	[self reactToOption:(int)index];
	[self dismiss];
}

%new - (void)reactToOption:(int)option {
	void (^resetScrollViews)() = ^{
		for (UIScrollView *scrollView in controller.contentScrollView.subviews) {
			if ([scrollView isKindOfClass:UIScrollView.class]) {
				scrollView.contentOffset = CGPointZero;
			}
		}
	};

	switch(option){
		case 0:
			[(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
			break;

		case 1:
		{
			resetScrollViews();
			[controller sliderScroller:controller.pageController itemTapped:0];

			NSString *nowPlayingApp = ((SBMediaController *)[%c(SBMediaController) sharedInstance]).nowPlayingApplication.bundleIdentifier;

			NSUInteger count = [controller sliderScrollerItemCount:controller.pageController];
			NSUInteger current = 1;

			for (NSUInteger i = 1; i < count; i++) {
				if ([controller sliderScroller:controller.pageController isIndexRemovable:current] && ![[controller _displayIDAtIndex:current] isEqualToString:nowPlayingApp]) {
					[controller sliderScroller:controller.pageController itemWantsToBeRemoved:current];
				} else {
					current++;
				}
			}

			break;
		}

		case 2:
			[UIView animateWithDuration:0.3f animations:resetScrollViews];
			break;
	}
}

%end
