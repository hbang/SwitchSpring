#import "HBSSLinkListController.h"

@implementation HBSSLinkListController

- (void)viewWillAppear:(BOOL)animated {
	//self.view.tintColor = CRTINTCOLOR;
    self.navigationController.navigationBar.tintColor = [HBSSRootListController hb_tintColor];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	//self.view.tintColor = nil;
	self.navigationController.navigationBar.tintColor = nil;
}

@end