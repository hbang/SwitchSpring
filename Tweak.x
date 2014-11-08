#import <SpringBoard/SBAlertItemsController.h>
#import "HBSSRespringAlertItem.h"

@interface SBDisplayItem : NSObject <NSCopying>
@property (nonatomic,readonly) NSString* displayIdentifier;
@end

@interface SpringBoard : NSObject
+ (instancetype)sharedApplication;
- (void)_relaunchSpringBoardNow;
@end

#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 847.20
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_8_0
#define kCFCoreFoundationVersionNumber_iOS_8_0 1140.10
#endif


@class SBAppSliderScrollingViewController;

%group iOS7

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

%end // iOS 7 Group


%group iOS8

%hook SBAppSwitcherController


- (BOOL)switcherScroller:(id)scroller isDisplayItemRemovable:(SBDisplayItem *)removable {
	return [removable.displayIdentifier isEqualToString:@"com.apple.springboard"] ? YES : %orig;
}

- (void)switcherScroller:(id)scroller displayItemWantsToBeRemoved:(SBDisplayItem *)beRemoved {

	if ([beRemoved.displayIdentifier isEqualToString:@"com.apple.springboard"]) {
		[(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
	}

	%orig;
}

%end


%end // iOS 8 Group

%ctor {
	if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0) {
        %init(iOS8);
    } else if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0) {
        %init(iOS7);
    }
}