#import <SpringBoard/SBAlertItemsController.h>
#import "HBSSRespringAlertItem.h"

@class SBAppSliderScrollingViewController;

%hook SBAppSliderController

-(BOOL)sliderScroller:(SBAppSliderScrollingViewController *)scroller isIndexRemovable:(NSUInteger)index {
	return index == 0 ? YES : %orig;
}

-(void)sliderScroller:(SBAppSliderScrollingViewController *)scroller itemWantsToBeRemoved:(NSUInteger)index {
	if(index == 0) {
		NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/ws.hbang.switchspring.plist"]];
		int swipeUpAction = [[settings objectForKey:@"swipeUpAction"] intValue];

		HBSSRespringAlertItem *alert = [[[%c(HBSSRespringAlertItem) alloc] initWithController:self] autorelease];
		if(swipeUpAction == 0)
			[(SBAlertItemsController *)[%c(SBAlertItemsController) sharedInstance] activateAlertItem:alert];
		else
			[alert reactToOption:(swipeUpAction-1)];

		return;
	}

	%orig();
}

%end