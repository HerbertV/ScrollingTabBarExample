/*
 *  ScrollIndicator.m
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
 
#import "QuartzCore/QuartzCore.h"
#import "ScrollIndicator.h"


#define PULSE_DURATION 1.0

// -------------------------------------------------------------------------------
// Interface Private
// -------------------------------------------------------------------------------
#pragma mark - Interface Private Functions
@interface ScrollIndicator (Private)

- (void) setBackgroundImage: (UIImage *) image;

- (void) setupShadow;

- (void) setupPulseView;

// step 1 for pulse blend in
- (void) animBlendIn;

// step 2 for pulse blend out
- (void) animBlendOut;

// final animation step
- (void) animEnded;

@end


// -------------------------------------------------------------------------------
// Implementation Private
// -------------------------------------------------------------------------------
#pragma mark - Implementation Private Functions
@implementation ScrollIndicator (Private)


- (void) setBackgroundImage: (UIImage *) image
{
	// fix for issue with ios 4.x
	// you need to do it like this otherwise the bg image becomes not transparent!
	self.opaque = YES; 
	self.backgroundColor = [UIColor colorWithPatternImage:image]; 
	self.opaque = NO;    
}

- (void) setupShadow
{
	self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 0.750f;
    self.layer.shadowRadius = 3.0f;
}

- (void) setupPulseView
{
	pulseView = [[UIView alloc] 
				 initWithFrame: CGRectMake(0, 
										   0, 
										   self.frame.size.width, 
										   self.frame.size.height
										   )
				 ];
	
	[pulseView setUserInteractionEnabled:NO];
	[pulseView setHidden:YES];
	[self addSubview:pulseView];
	
	[pulseView setBackgroundColor:
	 [UIColor colorWithPatternImage:
	  [UIImage imageNamed:self.pulseFXIcon]
	  ]
	 ];
	pulseView.opaque = NO;
}

- (void) animBlendIn
{
	animRunning = TRUE;
	
	[pulseView setHidden:NO];
	[pulseView setAlpha:0.0];
	 
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:PULSE_DURATION/2];
	[UIView setAnimationDelay:0.0];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animBlendOut)];
	
	[pulseView setAlpha:1.0];
	 
	[UIView commitAnimations];
}

- (void) animBlendOut
{
	[pulseView setAlpha:1.0];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:PULSE_DURATION/2];
	[UIView setAnimationDelay:0.2];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animEnded)];
	
	[pulseView setAlpha:0.0];
	
	[UIView commitAnimations];
}

- (void) animEnded
{
	[pulseView setHidden:YES];
	animRunning = FALSE;
}

@end



// -------------------------------------------------------------------------------
// Implementation Public
// -------------------------------------------------------------------------------
#pragma mark - Implementation Public
@implementation ScrollIndicator

#pragma mark - Synthesize
@synthesize normalIcon;
@synthesize pulseFXIcon;

@synthesize pulseView;

@synthesize animRunning;

// -------------------------------------------------------------------------------
// Dealloc
// -------------------------------------------------------------------------------
#pragma mark - Dealloc

- (void) dealloc
{
	if( pulseView != nil )
		[pulseView release];
	
	self.normalIcon = nil;
	self.pulseFXIcon = nil;
	
	self.pulseView = nil;
	
	[super dealloc];
}


// -------------------------------------------------------------------------------
// Initialize
// -------------------------------------------------------------------------------
#pragma mark - Initialize

- (id) initWithImagePath:(NSString *)path
{
	UIImage *img = [UIImage imageNamed:path];
	self = [super initWithFrame:
			CGRectMake(0,
					   0,
					   img.size.width,
					   img.size.height
					   )
			];
    
	if( self )
    {
		self.animRunning = FALSE;
		[self setUserInteractionEnabled:NO];
		
        self.normalIcon = path;
		self.pulseFXIcon = nil;
		[self setBackgroundImage:img];
		[self setupShadow];
		
    }
    return self;
}


- (id) initWithImagePath:(NSString *)path
				 fxPath:(NSString *)fxpath
{
	UIImage *img = [UIImage imageNamed:path];
	self = [super initWithFrame:
			CGRectMake(0,
					   0,
					   img.size.width,
					   img.size.height
					   )
			];
    
	if( self )
    {
        self.animRunning = FALSE;
		[self setUserInteractionEnabled:NO];
		
		self.normalIcon = path;
		self.pulseFXIcon = fxpath;
		[self setBackgroundImage:img];
		[self setupShadow];
		[self setupPulseView];
    }
    return self;
}

// -------------------------------------------------------------------------------
// Functions
// -------------------------------------------------------------------------------
#pragma mark - Functions

- (void) doPulse
{
	if( self.pulseView == nil 
	   		|| animRunning )
		return;
	
	[self animBlendIn];	
}

@end
