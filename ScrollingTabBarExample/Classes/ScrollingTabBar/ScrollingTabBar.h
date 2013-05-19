/*
 *  ScrollingTabBar.h
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

#import "ScrollingTabBarItem.h"
#import "ScrollIndicator.h"
#import "ScrollBumper.h"



// predefine Delegate Protocol
@protocol ScrollingTabBarDelegate;


// -------------------------------------------------------------------------------
// Interface
// -------------------------------------------------------------------------------
@interface ScrollingTabBar : UIView <ScrollingTabBarItemDelegate>
{
@private
    // indicator to show, there are more items to the left
    ScrollIndicator *leftScrollIndicator;
    // indicator to show, there are more items to the left
    ScrollIndicator *rightScrollIndicator;
    
    // Bumper that appears if the left scroll limit is reached
    ScrollBumper *leftScrollBumper;
    // Bumper that appears if the right scroll limit is reached
    ScrollBumper *rightScrollBumper;
}
// -------------------------------------------------------------------------------
// Properties
// -------------------------------------------------------------------------------
@property (nonatomic, weak) id<ScrollingTabBarDelegate> delegate; // Delgate

@property (nonatomic, strong) NSMutableArray *arrTabBarItems; // Array that contains ScrollingTabBarItems

@property (nonatomic, unsafe_unretained) NSInteger activeTabIndex; // Index of the active Tab

//---------------------------------------------------------------
// True if you currently scroll
// To lock all other item for scroll (prevents 2 finger scrolls)
//---------------------------------------------------------------
@property (nonatomic, getter=isScrolling) BOOL scrolling;

@property (nonatomic, strong) UIView *gradientView; // view for our gradient

@property (nonatomic, unsafe_unretained) float itemPadding; // padding between two items

//-------------------------------------------------------
// Dictionary for styling our items
// item style keys:
//  - width
//  - height
//  - selectionBackground
//  - selectionBgCapInsets
//  - fontNormalColor
//  - fontActiveColor
//-------------------------------------------------------
@property (nonatomic, strong) NSDictionary *itemStyle;

@property (nonatomic, strong) ScrollIndicator *leftScrollIndicator;
@property (nonatomic, strong) ScrollIndicator *rightScrollIndicator;

@property (nonatomic, strong) ScrollBumper *leftScrollBumper;
@property (nonatomic, strong) ScrollBumper *rightScrollBumper;


// -------------------------------------------------------------------------------
// Constructors
// -------------------------------------------------------------------------------

// Basic Constructor
// delegate can be nil
- (id) initWithItemCount:(NSInteger) count
				delegate:(id<ScrollingTabBarDelegate>) d;


- (id) initWithItemCount:(NSInteger)count
				delegate:(id<ScrollingTabBarDelegate>) d
			hideGradient:(BOOL) hideG;



// -------------------------------------------------------------------------------
// Public Functions
// -------------------------------------------------------------------------------

// calculates the maximum visible Tabs
- (NSInteger) calculateMaxVisibleTabs;

// toggles the gradient visibility
- (void) setGradientHidden:(BOOL) hidden;

// adds a classic tab with view controller
// if the tab is active the view controllers view
// is visible
- (void) addTabBarItemWithLabel:(NSString *) label
     				 normalIcon:(NSString *) nicon
     			  	 activeIcon:(NSString *) aicon
				 viewController:(UIViewController *) controller;

// adds a tab with selector and its target
// no need for a active icon since
// such a tab is never selected and locked in.
- (void) addTabBarItemWithLabel:(NSString *) label
     		         normalIcon:(NSString *) nicon
			           selector:(SEL) action
				 selectorTarget:(id) target;

// returns the removed item 
// you have to release it manually
- (ScrollingTabBarItem *) removeTabBarItemAtIndex:(NSInteger) index;


// activates the new tab 
// also deselects the previous tab
// or just calls the @selector
- (void) selectTabAtIndex:(NSInteger) index;

// enables/disables a tab
- (void) enableTab:(BOOL) e 
		   atIndex:(NSInteger) index;

// changes the text for a tab
- (void) setTabLabelText:(NSString *) text 
				 atIndex:(NSInteger) index;

// changes the icon pathes for a tab
// active icon can be nil
- (void) setTabNormalIcon:(NSString *) nicon
			   activeIcon:(NSString *) aicon
				  atIndex:(NSInteger) index;


// returns the viewcontroller of the active tab
- (UIViewController *) getActiveViewController;

// to replace the default indicators.
// if one parameter is nil both indicators
// are removed
- (void) setIndicators:(ScrollIndicator *) left
				 right: (ScrollIndicator *) right;

// to replace the default bumpers.
// if one parameter is nil both bumopers
// are removed
- (void) setBumpers:(ScrollBumper *) left
			  right:(ScrollBumper *) right;


@end

// -------------------------------------------------------------------------------
// ScrollingTabBar Delegate
// -------------------------------------------------------------------------------
@protocol ScrollingTabBarDelegate <NSObject>


@optional
// this function is only called if there was no movement
- (void) scrollingTabBarTouched:(ScrollingTabBar *) tabBar 
						 atItem:(ScrollingTabBarItem *) item
						atIndex:(NSInteger) i;

// since scrolling is handled with touching and moving
// an item we use the items position a reference
- (void) scrollingTabBarMoved:(ScrollingTabBar *) tabBar
					 withItem:(ScrollingTabBarItem *) item
					  atIndex:(NSInteger) i
						 from:(CGPoint) f 
						   to:(CGPoint) t;


@end
