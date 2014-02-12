#import <SpringBoardUI/SBAlertItem.h>

@class SBAppSliderController;

@interface HBSSRespringAlertItem : SBAlertItem

- (instancetype)initWithController:(SBAppSliderController *)controller;
- (void)reactToOption:(int)option;

@end
