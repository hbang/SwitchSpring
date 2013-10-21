#import <SpringBoard/SBAlertItemsController.h>
#import "HBSSRespringAlertItem.h"

@class SBAppSliderScrollingViewController;

%hook SBAppSliderController

- (BOOL)sliderScroller:(SBAppSliderScrollingViewController *)scroller isIndexRemovable:(unsigned)index {
	return index == 0 ? YES : %orig;
}

- (void)sliderScroller:(SBAppSliderScrollingViewController *)scroller itemWantsToBeRemoved:(unsigned)index {
	if (index != 0) {
		%orig;
		return;
	}

	HBSSRespringAlertItem *alert = [[[%c(HBSSRespringAlertItem) alloc] initWithController:self] autorelease];
	alert.alertHeader = @"Restart SpringBoard?";
	alert.defaultButtonTitle = @"Restart";
	alert.otherButtonTitle = @"Cancel";

	[(SBAlertItemsController *)[%c(SBAlertItemsController) sharedInstance] activateAlertItem:alert];
}

%end
