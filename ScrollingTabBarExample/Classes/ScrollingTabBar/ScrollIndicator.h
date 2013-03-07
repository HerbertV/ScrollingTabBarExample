/*
 *  ScrollIndicator.h
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
 
#import <UIKit/UIKit.h>


// -------------------------------------------------------------------------------
// Interface
// -------------------------------------------------------------------------------
@interface ScrollIndicator : UIView
{
	NSString *normalIcon;
	NSString *pulseFXIcon;
	
	UIView *pulseView;
	
	@private
		BOOL animRunning;
}

// -------------------------------------------------------------------------------
// Properties
// -------------------------------------------------------------------------------
@property (nonatomic, copy) NSString *normalIcon;
@property (nonatomic, copy) NSString *pulseFXIcon;

@property (nonatomic, retain) UIView *pulseView;

@property (nonatomic, assign) BOOL animRunning;

// -------------------------------------------------------------------------------
// Constructors
// -------------------------------------------------------------------------------
// constructor with only a normal image
- (id) initWithImagePath:(NSString *) path;

// constructor with a normal image and a fx image
- (id) initWithImagePath:(NSString *) path
			      fxPath:(NSString *) fxpath;

// -------------------------------------------------------------------------------
// Public Functions
// -------------------------------------------------------------------------------

- (void) doPulse;



@end
