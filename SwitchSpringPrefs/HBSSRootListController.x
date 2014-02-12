#import "HBSSRootListController.h"
#include <notify.h>

static CGFloat const kHBFPHeaderTopInset = 64.f; // i'm so sorry.
static CGFloat const kHBFPHeaderHeight = 150.f;

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

-(void)loadView{
	[super loadView];

	self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"SwitchSpring" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];

	_headerView = [[HBSSHeaderView alloc] initWithTopInset:kHBFPHeaderTopInset];
	_headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self.view addSubview:_headerView];
}

-(NSArray *)specifiers{
	if (!_specifiers)
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];

	return _specifiers;
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
		CGFloat headerHeight = kHBFPHeaderTopInset + kHBFPHeaderHeight;

		((UITableView *)self.view).contentInset = UIEdgeInsetsMake(headerHeight, 0, 0, 0);
		((UITableView *)self.view).contentOffset = CGPointMake(0, -headerHeight);

		_headerView.frame = CGRectMake(0, -headerHeight, self.view.frame.size.width, headerHeight);
	});

	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"/Library/Preferences/ws.hbang.switchspring.plist"]];
	
	if(![settings objectForKey:@"swipeUpAction"]){
		PSSpecifier *upSpecifier = [self specifierForID:@"SwipeUpList"];
		[self setPreferenceValue:@(0) specifier:upSpecifier];
		[self reloadSpecifier:upSpecifier];
	}

	if(![settings objectForKey:@"swipeDownAction"]){
		PSSpecifier *downSpecifier = [self specifierForID:@"SwipeDownList"];
		[self setPreferenceValue:@(3) specifier:downSpecifier];
		[self reloadSpecifier:downSpecifier];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.y > -kHBFPHeaderTopInset - (kHBFPHeaderHeight / 2)) {
		self.title = @"SwitchSpring";
	}

	if (scrollView.contentOffset.y > -kHBFPHeaderTopInset - kHBFPHeaderHeight) {
		return;
	}

	self.title = @"";

	CGRect headerFrame = _headerView.frame;
	headerFrame.origin.y = scrollView.contentOffset.y;
	headerFrame.size.height = -scrollView.contentOffset.y;
	_headerView.frame = headerFrame;
}

- (void)dealloc {
	[_headerView release];

	[super dealloc];
}


@end