#import "HBSSRespringAlertItem.h"
#import <SpringBoard/SpringBoard.h>
#import <SpringBoard/SBAppSliderController.h>

SBAppSliderController *controller;

%subclass HBSSRespringAlertItem : SBUserNotificationAlert

%new - (id)initWithController:(SBAppSliderController *)controller_ {
	self = [self init];

	if (self) {
		controller = controller_;
	}

	return self;
}

- (void)alertView:(id)alertView clickedButtonAtIndex:(int)index {
	if (index == 1) {
		[(SpringBoard *)[UIApplication sharedApplication] relaunchSpringBoard];
	} else {
		[UIView animateWithDuration:0.3f animations:^{
			for (UIScrollView *scrollView in controller.contentScrollView.subviews) {
				if ([scrollView isKindOfClass:UIScrollView.class]) {
					scrollView.contentOffset = CGPointZero;
				}
			}
		}];
	}
}

- (BOOL)allowMenuButtonDismissal {
	return YES;
}

%end
