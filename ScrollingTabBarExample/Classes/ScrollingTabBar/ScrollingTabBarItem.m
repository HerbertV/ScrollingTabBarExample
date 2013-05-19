/*
 *  ScrollingTabBarItem.m
 *  ScrollingTabBarExample 
 *  __  __      
 * /\ \/\ \  __________   
 * \ \ \_\ \/_______  /\   
 *  \ \  _  \  ____/ / /  
 *   \ \_\ \_\ \ \/ / / 
 *    \/_/\/_/\ \ \/ /  
 *             \ \  /
 *              \_\/
 *
 * -----------------------------------------------------------------------------
 * @author: Herbert Veitengruber 
 * @version: 1.0.0
 * -----------------------------------------------------------------------------
 *
 * Copyright (c) 2012 Herbert Veitengruber 
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */

#import "ScrollingTabBarItem.h"

// tolerance for triggering the scrolling
#define SCROLL_TOLERANCE 3

// some label settings
#define LABEL_HEIGHT 12
#define LABEL_FONTSIZE 10

#define ICON_MARGIN_TOP_WITH_LABEL 2


// -------------------------------------------------------------------------------
// Interface Private Functions
// -------------------------------------------------------------------------------
#pragma mark - Interface Private Functions
@interface ScrollingTabBarItem (Private)

- (void) setupLabel;

- (void) setupIconView;

// returns a streched and resized version of our
// selection bg (does work with retina displays
- (UIImage *) getSelectionBackgroundImage;

@end

// -------------------------------------------------------------------------------
// Implementation Private
// -------------------------------------------------------------------------------
#pragma mark - Implementation Private Functions
@implementation ScrollingTabBarItem (Private)

- (void) setupLabel
{
    float h = LABEL_HEIGHT;
    float y = self.frame.size.height - h;
    
    self.label = [[UILabel alloc] initWithFrame: CGRectMake(0, y, self.frame.size.width, h)];
    
    self.label.font = [UIFont boldSystemFontOfSize: LABEL_FONTSIZE];
    
    //------------------------------------------------------------------------------
    // if system version is grather then or equal to 6.0 use NSTextAlignmentCenter,
    // otherwise UITextAlignmentCenter
    //------------------------------------------------------------------------------
    if ([[[UIDevice currentDevice] systemVersion] compare: @"6.0" options:NSNumericSearch] != NSOrderedAscending) {
        self.label.textAlignment = NSTextAlignmentCenter;
    } else {
        self.label.textAlignment = UITextAlignmentCenter;
    }
    
    [self.label setBackgroundColor: [UIColor clearColor]];
    [self.label setTextColor:[UIColor whiteColor]];
    self.label.opaque = NO;
    
    [self addSubview:self.label];
}


- (void) setupIconView
{
    UIImage *img = [UIImage imageNamed:self.normalIcon];
    
	// using floats cause to blur the image,
	// this is because the tab bar height is uneven
	int x = (self.frame.size.width - img.size.width)/2;
    int y = ICON_MARGIN_TOP_WITH_LABEL;
    int w = img.size.width;
    int h = img.size.height;
	
	if( self.label == nil )
		y = (self.frame.size.height - img.size.height)/2;
    
    self.iconView = [[UIView alloc] initWithFrame:CGRectMake(x,y,w,h)];
    [self.iconView setBackgroundColor: [UIColor colorWithPatternImage:img]];
    self.iconView.opaque = NO;
    
    [self addSubview:self.iconView];
}


- (UIImage *) getSelectionBackgroundImage
{
	NSDictionary *style = [self.delegate getItemStyle];
	// the base image either normal or retina @2x
	UIImage *baseImage = [UIImage imageNamed: style[@"selectionBackground"]];
	
	// now set the cap insets for streching 
	UIEdgeInsets insets = UIEdgeInsetsFromString(style[@"selectionBgCapInsets"]);
	// since iOS 5.0 you can use this function
	UIImage *resizableImage = [baseImage resizableImageWithCapInsets: insets];	
	// instead of strechableImageWithLeftCapWidth ...
	
	// start resizing 
	// scale is needed for retina display
	UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [[UIScreen mainScreen] scale]);
	
	[resizableImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
	UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return resizedImage;
}

@end


// -------------------------------------------------------------------------------
// Implementation Public
// -------------------------------------------------------------------------------
#pragma mark - Implementation Public
@implementation ScrollingTabBarItem

// -------------------------------------------------------------------------------
// Dealloc
// -------------------------------------------------------------------------------
#pragma mark - Dealloc
- (void) dealloc
{
	self.delegate = nil;
	self.callbackAction = nil;
	self.callbackTarget = nil;
}


// -------------------------------------------------------------------------------
// Initialize
// -------------------------------------------------------------------------------
#pragma mark - Initialize

- (id) initWithFrame:(CGRect) frame
			delegate:(id<ScrollingTabBarItemDelegate>) d
               label:(NSString *) txt
          normalIcon:(NSString *) nicon
          activeIcon:(NSString *) aicon
      viewController:(UIViewController *) controller
            selector:(SEL) action
      selectorTarget:(id) target
{
    self = [super initWithFrame:frame];
	
    if( self ) 
	{
		self.delegate = d;
        self.viewController = controller;
        self.normalIcon = nicon;
        self.activeIcon = aicon;
		
		if( txt != nil )
        {
			[self setupLabel];
			self.label.text = txt;
		}
		[self setupIconView];
		
        self.enabled = TRUE;
        self.selected = FALSE;
        
        self.callbackAction = action;
        self.callbackTarget = target;
    }
    return self;
}

// -------------------------------------------------------------------------------
// Functions
// -------------------------------------------------------------------------------
#pragma mark - Functions

- (void) updateNormalIcon:(NSString *)icon
{
    self.normalIcon = icon;
    
    if( !self.isSelected && icon != nil )
    {
        UIImage *img = [UIImage imageNamed:icon];
        self.iconView.opaque = YES;
        [self.iconView setBackgroundColor: [UIColor colorWithPatternImage:img]];
        self.iconView.opaque = NO;
    }
}


- (void) updateActiveIcon:(NSString *)icon
{
    self.activeIcon = icon;
    
    if( self.isSelected && icon != nil )
    {
        UIImage *img = [UIImage imageNamed:icon];
        self.iconView.opaque = YES;
        [self.iconView setBackgroundColor: [UIColor colorWithPatternImage:img]];
        self.iconView.opaque = NO;
    }
}

- (void) updateLabelText:(NSString *)text
{
	if( text == nil && self.label != nil )
	{
		[self.label removeFromSuperview];
		self.label = nil;
		
		[self setNeedsLayout];
	}
	
	if( text != nil && self.label == nil )
	{
		[self setupLabel];
		[self setNeedsLayout];	
	}
	
	if( text != nil )
		self.label.text = text;
}

#pragma mark Override Setters
// override setter
- (void) setEnabled:(BOOL)e
{
    if( e )
    {   
        self.alpha = 1.00f;
        
    } else {
        self.alpha = 0.50f;
    }
    // imporant no self. here
    // otherwise it results in an invinite loop
    _enabled=e;
}

// override setter
-(void) setSelected:(BOOL)s
{
    self.opaque = YES;
    self.iconView.opaque = YES;
    
	NSDictionary *style = [self.delegate getItemStyle];
	
    if( s ) 
    {
        if( self.activeIcon != nil )
        {
            [self.iconView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed: self.activeIcon]]];
        }
		
		[self setBackgroundColor:[UIColor colorWithPatternImage:[self getSelectionBackgroundImage]]];
        [self.label setTextColor: style[@"fontActiveColor"]];
    }
    else
    {
        [self.iconView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed: self.normalIcon]]];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.label setTextColor:style[@"fontNormalColor"]];
        
    }
    self.opaque = NO;
    self.iconView.opaque = NO;
    
    // imporant no self. here
    // otherwise it results in an invinite loop
    _selected = s;
}


#pragma mark - User Interaction
#pragma mark Touch Handling
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // prepare move here
    UITouch *t = [touches anyObject];
	// save the movement starting point for later use
    scrollStartPoint  = [t locationInView: [self superview]];
	scrollTolleranceReached = FALSE;
	lastScrollDirection = ScrollsNot;
	
	if( !self.enabled )
        return;
    
	// do normal touch handling if enabled
    self.opaque = YES;
    
    if( !self.isSelected )
        [self setBackgroundColor:[UIColor colorWithPatternImage:[self getSelectionBackgroundImage]]];
    
    self.opaque = NO;
}


- (void) touchesEnded:(NSSet *) touches withEvent:(UIEvent *) event
{
    //release scroll lock
    if( [self.delegate scrollingTabBarIsLockedForScroll] && self.scrollAnchor )
    {
        self.scrollAnchor = FALSE;
		scrollTolleranceReached = FALSE;
        [self.delegate scrollingTabBarLockScroll:FALSE];
	}
    
	// hide selection bg again
	if( !self.selected )
        [self setBackgroundColor:[UIColor clearColor]];
    
	if( !self.enabled && lastScrollDirection == ScrollsNot )
        return;
    
	// prevent multiple touches
	if( [[touches anyObject] tapCount] > 1 )
		return;
	
	// call delegate
	[self.delegate scrollingTabBarItemTouchEnded: self scrollingDirection: lastScrollDirection];    
}

-(void) touchesMoved:(NSSet *) touches withEvent:(UIEvent *) event
{
    UITouch *t = [touches anyObject];
    CGPoint loc = [t locationInView: [self superview]];
    
    // fire only if tolerance is reached
	// tolerance only until it is the first time reached
	if( ABS(loc.x - scrollStartPoint.x) < SCROLL_TOLERANCE && !scrollTolleranceReached )
		return;
	
	scrollTolleranceReached = TRUE;
	
	// update the scroll direction
	if( loc.x > scrollStartPoint.x )
		lastScrollDirection = ScrollsRight;
	else 
		lastScrollDirection = ScrollsLeft;
	
    // lock for scrolling
    if( ![self.delegate scrollingTabBarIsLockedForScroll] )
    {
		self.scrollAnchor = TRUE;
        [self.delegate scrollingTabBarLockScroll:TRUE];
    }
    
    // check if iam the scroll anchor
    if( [self.delegate scrollingTabBarIsLockedForScroll] && !self.scrollAnchor )
        return;
	
    // now call our delegate
    [self.delegate scrollingTabBarItemScroll: self
                                        from: scrollStartPoint
                                          to: loc]; 
    
    // update startpoint for our next call;
    scrollStartPoint = loc;
}


- (void) touchesCancelled:(NSSet *) touches 
				withEvent:(UIEvent *) event
{
    //release scroll lock
    if( [self.delegate scrollingTabBarIsLockedForScroll] && self.scrollAnchor )
    {
        self.scrollAnchor = FALSE;
		scrollTolleranceReached = FALSE;
        [self.delegate scrollingTabBarLockScroll:FALSE];
	}
    
    if( !self.isSelected )
        [self setBackgroundColor:[UIColor clearColor]];
    
}

#pragma mark - UIView
// overridden to do some custom adjustments
- (void) layoutSubviews
{
    [super layoutSubviews];
	
	// adjust icon position
	CGRect f = self.iconView.frame;
	int y = ICON_MARGIN_TOP_WITH_LABEL;
    
	if( self.label == nil )
		y = (self.frame.size.height - f.size.height)/2;
	
	self.iconView.frame = f;
	
}

@end
