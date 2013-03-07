/*
 *  ScrollBumper.m
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
 
#import "ScrollBumper.h"


// -------------------------------------------------------------------------------
// Implementation Public
// -------------------------------------------------------------------------------
#pragma mark - Implementation Public

@implementation ScrollBumper

#pragma mark - Synthesize
@synthesize imgPath;

// -------------------------------------------------------------------------------
// Dealloc
// -------------------------------------------------------------------------------
#pragma mark - Dealloc

- (void) dealloc
{
	self.imgPath = nil;
	
	[super dealloc];
}

// -------------------------------------------------------------------------------
// Initialize
// -------------------------------------------------------------------------------
#pragma mark - Initialize
- (id) initWithPosition:(CGPoint) pos
			  imagePath:(NSString *) path
{
	UIImage *img = [UIImage imageNamed:path];
	CGRect frame = CGRectMake(pos.x, 
							  pos.y,
							  img.size.width, 
							  img.size.height
							  );
    
	self = [super initWithFrame: frame];
    
	if( self ) 
	{
    	self.imgPath = path;
		
		[self setUserInteractionEnabled: NO];
		[self setBackgroundColor: 
		 [UIColor colorWithPatternImage: img]
		 ];
		self.opaque = NO;
		self.alpha = 0.0;
	}
    return self;
}


// -------------------------------------------------------------------------------
// Functions
// -------------------------------------------------------------------------------
#pragma mark - Functions



- (void) doBlendOut:(float)duration 
		   andDelay:(float)delay
{
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationDelay:delay];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
	[self setAlpha:0.0];
	
	[UIView commitAnimations];
}


@end
