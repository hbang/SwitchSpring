#import "HBSSRespringAlertItem.h"
#import <SpringBoard/SpringBoard.h>
#import <SpringBoard/SBAppSliderController.h>
#import <UIKit/UIAlertView+Private.h>

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
	if (index == 0) {
		[(SpringBoard *)[UIApplication sharedApplication] relaunchSpringBoard];
		return;
	}

	[UIView animateWithDuration:0.3f animations:^{
		for (UIScrollView *scrollView in controller.contentScrollView.subviews) {
			if ([scrollView isKindOfClass:UIScrollView.class]) {
				scrollView.contentOffset = CGPointZero;
			}
		}
	}];

	if (index == 1) {
		NSUInteger count = [controller sliderScrollerItemCount:controller.pageController];
		NSUInteger current = 1;

		for (NSUInteger i = 1; i < count; i++) {
			if ([controller sliderScroller:controller.pageController isIndexRemovable:current]) {
				[controller sliderScroller:controller.pageController itemWantsToBeRemoved:current];
			} else {
				current++;
			}
		}
	}
}

- (BOOL)allowMenuButtonDismissal {
	return YES;
}

%end
