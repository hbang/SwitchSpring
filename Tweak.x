#import <SpringBoard/SBAlertItemsController.h>
#import "HBSSRespringAlertItem.h"

@class SBAppSliderScrollingViewController;

%hook SBAppSliderController

- (BOOL)sliderScroller:(SBAppSliderScrollingViewController *)scroller isIndexRemovable:(NSUInteger)index {
	return index == 0 ? YES : %orig;
}

- (void)sliderScroller:(SBAppSliderScrollingViewController *)scroller itemWantsToBeRemoved:(NSUInteger)index {
	if (index != 0) {
		%orig;
		return;
	}

	HBSSRespringAlertItem *alert = [[[%c(HBSSRespringAlertItem) alloc] initWithController:self] autorelease];
	[(SBAlertItemsController *)[%c(SBAlertItemsController) sharedInstance] activateAlertItem:alert];
}

%end
