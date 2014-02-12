#import "HBSSLinkListController.h"

@implementation HBSSLinkListController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.tintColor = [HBSSRootListController hb_tintColor];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	self.navigationController.navigationBar.tintColor = nil;
}

@end