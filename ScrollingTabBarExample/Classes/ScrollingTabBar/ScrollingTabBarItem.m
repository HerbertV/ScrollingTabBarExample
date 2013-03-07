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
    
    self.label = [[UILabel alloc] initWithFrame: 
			 CGRectMake(
						0,
						y,
						self.frame.size.width,
						h
						)
			 ];
    
    label.font = [UIFont boldSystemFontOfSize: LABEL_FONTSIZE];
    label.textAlignment = UITextAlignmentCenter;
    
    [label setBackgroundColor: [UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    label.opaque = NO;
    
    [self addSubview:label]; 
}


- (void) setupIconView
{
    UIImage *img = [UIImage imageNamed:normalIcon];
    
	// using floats cause to blur the image,
	// this is because the tab bar height is uneven
	int x = (self.frame.size.width - img.size.width)/2;
    int y = ICON_MARGIN_TOP_WITH_LABEL;
    int w = img.size.width;
    int h = img.size.height;
	
	if( self.label == nil )
		y = (self.frame.size.height - img.size.height)/2;
    
    self.iconView = [[UIView alloc] initWithFrame:CGRectMake(x,y,w,h)];
    [iconView setBackgroundColor: [UIColor colorWithPatternImage:img]];
    iconView.opaque = NO;
    
    [self addSubview:iconView];
}


- (UIImage *) getSelectionBackgroundImage
{
	NSDictionary *style = [delegate getItemStyle];
	// the base image either normal or retina @2x
	UIImage *baseImage = [UIImage imageNamed:
						  [style objectForKey:@"selectionBackground"]
						  ];	
	
	// now set the cap insets for streching 
	UIEdgeInsets insets = UIEdgeInsetsFromString([style objectForKey:@"selectionBgCapInsets"]);
	// since iOS 5.0 you can use this function
	UIImage *resizableImage = [baseImage resizableImageWithCapInsets: insets];	
	// instead of strechableImageWithLeftCapWidth ...
	
	// start resizing 
	// scale is needed for retina display
	UIGraphicsBeginImageContextWithOptions(self.frame.size,
										   NO, 
										   [[UIScreen mainScreen] scale]
										   );
	
	[resizableImage drawInRect:CGRectMake(0,
										  0,
										  self.frame.size.width,
										  self.frame.size.width)
	 ];
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

#pragma mark - Synthesize
@synthesize delegate;

@synthesize label;
@synthesize iconView;

@synthesize normalIcon;
@synthesize activeIcon;

@synthesize viewController;
@synthesize callbackAction;
@synthesize callbackTarget;

@synthesize scrollAnchor;
@synthesize enabled;
@synthesize selected;

@synthesize scrollStartPoint;
@synthesize scrollTolleranceReached;
@synthesize lastScrollDirection;



// -------------------------------------------------------------------------------
// Dealloc
// -------------------------------------------------------------------------------
#pragma mark - Dealloc

- (void) dealloc
{
	[delegate release];
	
	if( label != nil )
		[label release];
	
	[iconView release];
	[viewController release];
	
	
	self.delegate = nil;
	self.label = nil;
	self.iconView = nil;
	self.normalIcon = nil;
	self.activeIcon = nil;
	self.viewController = nil;
	self.callbackAction = nil;
	self.callbackTarget = nil;
	
	[super dealloc];
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
    
    if( !selected 
			&& icon != nil )
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
    
    if( selected 
	   		&& icon != nil )
    {
        UIImage *img = [UIImage imageNamed:icon];
        self.iconView.opaque = YES;
        [self.iconView setBackgroundColor: [UIColor colorWithPatternImage:img]];
        self.iconView.opaque = NO;
    }
}

- (void) updateLabelText:(NSString *)text
{
	if( text == nil && label != nil ) 
	{
		[label removeFromSuperview];
		[label release];
		self.label = nil;
		
		[self setNeedsLayout];
	}
	
	if( text != nil && label == nil )
	{
		[self setupLabel];
		[self setNeedsLayout];	
	}
	
	if( text != nil )
		label.text = text;
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
    enabled=e;     
}

// override setter
-(void) setSelected:(BOOL)s
{
    self.opaque = YES;
    self.iconView.opaque = YES;
    
	NSDictionary *style = [delegate getItemStyle];
	
    if( s ) 
    {
        if( activeIcon != nil )
        {
            [self.iconView setBackgroundColor: 
             [UIColor colorWithPatternImage:
              [UIImage imageNamed: activeIcon]
              ]
             ];
        }
		
		[self setBackgroundColor:
         [UIColor colorWithPatternImage: 
          [self getSelectionBackgroundImage]
          ]
         ];
        [self.label setTextColor: [style objectForKey:@"fontActiveColor"]];
        
    }
    else
    {
        [self.iconView setBackgroundColor: 
         [UIColor colorWithPatternImage: 
          [UIImage imageNamed: normalIcon]
          ]
         ];
		
        [self setBackgroundColor:[UIColor clearColor]];
        [self.label setTextColor:[style objectForKey:@"fontNormalColor"]];
        
    }
    self.opaque = NO;
    self.iconView.opaque = NO;
    
    
    // imporant no self. here
    // otherwise it results in an invinite loop
    selected = s;
}


#pragma mark - User Interaction
#pragma mark Touch Handling
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // prepare move here
    UITouch *t = [touches anyObject];
	// save the movement starting point for later use
    self.scrollStartPoint  = [t locationInView: [self superview]];
	self.scrollTolleranceReached = FALSE;
	self.lastScrollDirection = ScrollsNot;
	
	if( !self.enabled )
        return;
    
	// do normal touch handling if enabled
    self.opaque = YES;
    
    if( !selected )
        [self setBackgroundColor:
         [UIColor colorWithPatternImage:
          [self getSelectionBackgroundImage]
		  ]
         ];
    
    self.opaque = NO;
    
}


- (void) touchesEnded:(NSSet *) touches 
			withEvent:(UIEvent *) event
{
    //release scroll lock
    if( [delegate scrollingTabBarIsLockedForScroll] 
	   		&& self.scrollAnchor )
    {
        self.scrollAnchor = FALSE;
		self.scrollTolleranceReached = FALSE;
        [delegate scrollingTabBarLockScroll:FALSE];
	}
    
	// hide selection bg again
	if( !self.selected )
        [self setBackgroundColor:[UIColor clearColor]];
    
	if( !self.enabled 
	   && lastScrollDirection == ScrollsNot )
        return;
    
	// prevent multiple touches
	if( [[touches anyObject] tapCount] > 1 )
		return;
	
	// call delegate
	[delegate scrollingTabBarItemTouchEnded: self
						 scrollingDirection: self.lastScrollDirection
	 ];
    
}

-(void) touchesMoved:(NSSet *) touches
           withEvent:(UIEvent *) event
{
    UITouch *t = [touches anyObject];
    CGPoint loc = [t locationInView: [self superview]];
    
    // fire only if tolerance is reached
	// tolerance only until it is the first time reached
	if( ABS(loc.x - scrollStartPoint.x) < SCROLL_TOLERANCE 
	   		&& !self.scrollTolleranceReached )
		return;
	
	self.scrollTolleranceReached = TRUE;
	
	// update the scroll direction
	if( loc.x > scrollStartPoint.x )
		self.lastScrollDirection = ScrollsRight;
	else 
		self.lastScrollDirection = ScrollsLeft;
	
    // lock for scrolling
    if( ![delegate scrollingTabBarIsLockedForScroll] )
    {
		self.scrollAnchor = TRUE;
        [delegate scrollingTabBarLockScroll:TRUE];
    }
    
    // check if iam the scroll anchor
    if( [delegate scrollingTabBarIsLockedForScroll] 
	   		&& !self.scrollAnchor )
        return;
	
    // now call our delegate
    [delegate scrollingTabBarItemScroll: self
                                   from: self.scrollStartPoint 
                                     to: loc 
     ]; 
    
    // update startpoint for our next call;
    self.scrollStartPoint = loc;
}


- (void) touchesCancelled:(NSSet *) touches 
				withEvent:(UIEvent *) event
{
    //release scroll lock
    if( [delegate scrollingTabBarIsLockedForScroll] 
	   && self.scrollAnchor )
    {
        self.scrollAnchor = FALSE;
		self.scrollTolleranceReached = FALSE;
        [delegate scrollingTabBarLockScroll:FALSE];
	}
    
    if( !self.selected )
        [self setBackgroundColor:[UIColor clearColor]];
    
}

#pragma mark - UIView
// overridden to do some custom adjustments
- (void) layoutSubviews
{
    [super layoutSubviews];
	
	// adjust icon position
	CGRect f = iconView.frame;
	int y = ICON_MARGIN_TOP_WITH_LABEL;
    
	if( self.label == nil )
		y = (self.frame.size.height - f.size.height)/2;
	
	iconView.frame = f;
	
}

@end
