#import "HBSSAboutListController.h"

@implementation HBSSAboutListController

#pragma mark - PSListController

- (NSArray *)specifiers {
	if (!_specifiers)
		_specifiers = [[self loadSpecifiersFromPlistName:@"About" target:self] retain];

	return _specifiers;
}

@end
