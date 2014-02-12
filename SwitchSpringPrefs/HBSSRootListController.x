#import "HBSSRootListController.h"
#include <notify.h>

@implementation HBSSRootListController

#pragma mark - Constants

+(NSString *)hb_shareText {
	return @"Check out #SwitchSpring by HASHBANG Productions!";
}

+(NSURL *)hb_shareURL {
	return [NSURL URLWithString:@"https://github.com/hbang/SwitchSpring"];
}

+(UIColor *)hb_tintColor {
	return [UIColor colorWithRed:57/255.0f green:124/255.0f blue:203/255.0f alpha:1.0f];
}

#pragma mark - PSListController

-(NSArray *)specifiers{
	if (!_specifiers)
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];

	return _specifiers;
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];

	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/ws.hbang.switchspring.plist"]];
	
	if(![settings objectForKey:@"actionOption"]){
		PSSpecifier *actionSpecifier = [self specifierForID:@"ActionControl"];
		[self setPreferenceValue:@(3) specifier:actionSpecifier];
		[self reloadSpecifier:actionSpecifier];
	}
}

@end