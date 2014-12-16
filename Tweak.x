#import <SpringBoard/SBAlertItemsController.h>
#import <SpringBoard/SBDisplayItem.h>
#import <version.h>
#import "HBSSRespringAlertItem.h"

void displayAlert(SBAppSwitcherController *controller) {
	HBSSRespringAlertItem *alert = [[[%c(HBSSRespringAlertItem) alloc] initWithController:controller] autorelease];
	[(SBAlertItemsController *)[%c(SBAlertItemsController) sharedInstance] activateAlertItem:alert];
}

%group JonyIve
%hook SBAppSliderController

- (BOOL)sliderScroller:(id)scroller isIndexRemovable:(NSUInteger)index {
	return index == 0 ? YES : %orig;
}

- (void)sliderScroller:(id)scroller itemWantsToBeRemoved:(NSUInteger)index {
	if (index != 0) {
		%orig;
		return;
	}

	displayAlert((SBAppSwitcherController *)self);
}

%end
%end

%group CraigFederighi
%hook SBAppSwitcherController

- (BOOL)switcherScroller:(id)scroller isDisplayItemRemovable:(SBDisplayItem *)displayItem {
	return [displayItem.displayIdentifier isEqualToString:kHBSSSpringBoardItemIdentifier] ? YES : %orig;
}

- (void)switcherScroller:(id)scroller displayItemWantsToBeRemoved:(SBDisplayItem *)displayItem {
	if (![displayItem.displayIdentifier isEqualToString:kHBSSSpringBoardItemIdentifier]) {
		%orig;
		return;
	}

	displayAlert(self);
}

%end
%end

%ctor {
	if (IS_IOS_OR_NEWER(iOS_8_0)) {
		%init(CraigFederighi);
	} else {
		%init(JonyIve);
	}
}
