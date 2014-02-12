#import "HBSSHeaderView.h"

@implementation HBSSHeaderView

+ (Class)layerClass {
	return CAGradientLayer.class;
}

- (instancetype)initWithTopInset:(CGFloat)topInset {
	self = [self init];

	if (self) {
		self.clipsToBounds = YES;

		((CAGradientLayer *)self.layer).locations = @[ @0, @0.5f, @0.75f, @1 ];
		((CAGradientLayer *)self.layer).colors = @[
			(id)[UIColor colorWithRed:57/255.0f green:124/255.0f blue:203/255.0f alpha:1.0f].CGColor,
			(id)[UIColor colorWithRed:57/255.0f green:151/255.0f blue:212/255.0f alpha:1.0f].CGColor,
			(id)[UIColor colorWithRed:57/255.0f green:168/255.0f blue:193/255.0f alpha:1.0f].CGColor,
			(id)[UIColor colorWithRed:57/255.0f green:141/255.0f blue:157/255.0f alpha:1.0f].CGColor
		];

		NSMutableAttributedString *attributedString = [[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"SwitchSpring\nby HASHBANG Productions\nVersion %@", @"1.1"]] autorelease];

		NSMutableParagraphStyle *paragraphStyle = [[[NSMutableParagraphStyle alloc] init] autorelease];
		paragraphStyle.lineSpacing = 10.f;
		paragraphStyle.alignment = NSTextAlignmentCenter;

		[attributedString setAttributes:@{
			NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Thin" size:50.f],
			NSForegroundColorAttributeName: [UIColor colorWithWhite:1.f alpha:0.8f],
			NSKernAttributeName: [NSNull null],
			NSParagraphStyleAttributeName: paragraphStyle
		} range:NSMakeRange(0, 12)];

		[attributedString setAttributes:@{
			NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:16.f],
			NSForegroundColorAttributeName: [UIColor colorWithWhite:0.8f alpha:0.7f],
			NSKernAttributeName: [NSNull null]
		} range:NSMakeRange(12, attributedString.string.length - 12)];


		UILabel *switchSpringLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, topInset, 0, self.frame.size.height - topInset)] autorelease];
		switchSpringLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		switchSpringLabel.textAlignment = NSTextAlignmentCenter;
		switchSpringLabel.numberOfLines = 0;
		switchSpringLabel.attributedText = attributedString;
		[self addSubview:switchSpringLabel];
	}

	return self;
}

@end
