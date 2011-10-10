//
//  DCRoundSwitchToggleLayer.m
//
//  Created by Patrick Richards on 29/06/11.
//  MIT License.
//
//  http://twitter.com/patr
//  http://domesticcat.com.au/projects
//  http://github.com/domesticcatsoftware/DCRoundSwitch
//

#import "DCRoundSwitchToggleLayer.h"

@implementation DCRoundSwitchToggleLayer
@synthesize onString, offString, onTintColor, offTintColor, onTextColor, onTextShadowColor, offTextColor, offTextShadowColor, onImage, offImage;
@synthesize drawOnTint;
@synthesize clip;
@synthesize labelFont;

- (void)dealloc
{
    [onTextColor release];
    [offTextColor release];
    [onImage release];
    [offImage release];
	[onString release];
	[offString release];
	[onTintColor release];
    [offTintColor release];
    
	[super dealloc];
}

- (id)initWithOnString:(NSString *)anOnString offString:(NSString *)anOffString onTintColor:(UIColor *)anOnTintColor
{
	if ((self = [super init]))
	{
		self.onString = anOnString;
		self.offString = anOffString;
		self.onTintColor = anOnTintColor;
        self.offTintColor = [UIColor colorWithWhite:0.963 alpha:1.0];
        self.onTextColor = [UIColor whiteColor];
        self.onTextShadowColor = [UIColor colorWithWhite:0.45 alpha:1.0];
        self.offTextColor = [UIColor colorWithWhite:0.52 alpha:1.0];
        self.offTextShadowColor = [UIColor whiteColor];
	}

	return self;
}

- (UIFont *)labelFont
{
	return [UIFont boldSystemFontOfSize:ceilf(self.bounds.size.height * .6)];
}

- (void)drawInContext:(CGContextRef)context
{
	CGFloat knobRadius = self.bounds.size.height - 2.0;
	CGFloat knobCenter = self.bounds.size.width / 2.0;
	CGRect knobRect = CGRectMake(knobCenter - knobRadius / 2.0, 1.0, knobRadius, knobRadius);

	if (self.clip)
	{
		UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-self.frame.origin.x + 0.5, 0, self.bounds.size.width / 2.0 + self.bounds.size.height / 2.0 - 1.5, self.bounds.size.height) cornerRadius:self.bounds.size.height / 2.0];
		CGContextAddPath(context, bezierPath.CGPath);
		CGContextClip(context);
	}

	// on tint color
	if (self.drawOnTint)
	{
		CGContextSetFillColorWithColor(context, self.onTintColor.CGColor);
		CGContextFillRect(context, CGRectMake(0, 0, knobCenter, self.bounds.size.height));
	}

	// off tint color (white)
	CGContextSetFillColorWithColor(context, offTintColor.CGColor);
	CGContextFillRect(context, CGRectMake(knobCenter, 0, self.bounds.size.width - knobCenter, self.bounds.size.height));

	// knob shadow
	CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 1.5, [UIColor colorWithWhite:0.2 alpha:1.0].CGColor);
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.42 alpha:1.0].CGColor);
	CGContextSetLineWidth(context, 1.0);
	CGContextStrokeEllipseInRect(context, knobRect);
	CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 0, NULL);

	// strings and images
	CGFloat textSpaceWidth = (self.bounds.size.width / 2) - (knobRadius / 2);

	UIGraphicsPushContext(context);

    if (!IsEmpty(self.onImage))
    {
        //'ON' Image
        CGSize onImageSize = [self.onImage size];
        CGPoint onImagePoint = CGPointMake((textSpaceWidth - onImageSize.width) / 2.0 + knobRadius * .15, floorf((self.bounds.size.height - onImageSize.height) / 2.0) + 1.0);
        [self.onImage drawAtPoint:onImagePoint];
    }


    if (!IsEmpty(self.onString))
    {
        // 'ON' state label (self.onString)
        CGSize onTextSize = [self.onString sizeWithFont:self.labelFont];
        CGPoint onTextPoint = CGPointMake((textSpaceWidth - onTextSize.width) / 2.0 + knobRadius * .15, floorf((self.bounds.size.height - onTextSize.height) / 2.0) + 1.0);
        [onTextShadowColor set]; // .2 & .4
        [self.onString drawAtPoint:CGPointMake(onTextPoint.x, onTextPoint.y - 1.0) withFont:self.labelFont];
        [onTextColor set];
        [self.onString drawAtPoint:onTextPoint withFont:self.labelFont];
    }

    if (!IsEmpty(self.offImage))
    {
        // 'OFF' Image
        CGSize offImageSize = [self.offImage size];
        CGPoint offImagePoint = CGPointMake(textSpaceWidth + (textSpaceWidth - offImageSize.width) / 2.0 + knobRadius * .86, floorf((self.bounds.size.height - offImageSize.height) / 2.0) + 1.0);
        [self.offImage drawAtPoint:offImagePoint];
    }

    if (!IsEmpty(self.offString))
    {
        // 'OFF' state label (self.offString)
        CGSize offTextSize = [self.offString sizeWithFont:self.labelFont];
        CGPoint offTextPoint = CGPointMake(textSpaceWidth + (textSpaceWidth - offTextSize.width) / 2.0 + knobRadius * .86, floorf((self.bounds.size.height - offTextSize.height) / 2.0) + 1.0);
        [offTextShadowColor set];
        [self.offString drawAtPoint:CGPointMake(offTextPoint.x, offTextPoint.y + 1.0) withFont:self.labelFont];
        [offTextColor set];
        [self.offString drawAtPoint:offTextPoint withFont:self.labelFont];
    }   

	UIGraphicsPopContext();
}

@end
