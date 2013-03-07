/*
 *  ScrollingTabBarItem.h
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

// enum for determinating the scroll direction
enum ScrollingDirection 
{
	ScrollsNot,		// no scrolling occured
	ScrollsLeft,
	ScrollsRight
};



// predefine Delegate Protocol
@protocol ScrollingTabBarItemDelegate;

// -------------------------------------------------------------------------------
// Interface
// -------------------------------------------------------------------------------
@interface ScrollingTabBarItem : UIView
{
	id<ScrollingTabBarItemDelegate> delegate;
    
    UILabel *label;
    UIView *iconView;
    
    //icon path for the normal appearance
    NSString *normalIcon;
    //icon path for the selected appearance
    NSString *activeIcon;
	
    // linked view Controller
    UIViewController *viewController;
    // linked callback function
    SEL callbackAction;
	// linked callback target
    id callbackTarget;
	
    // if true this is the scroll anchor 
    // and only this item fires our scroll delegate function
    BOOL scrollAnchor;
	// true if enabled and touchable
    BOOL enabled;
	// true if selected/active
    BOOL selected;
    
	
	@private
    	CGPoint scrollStartPoint;
		BOOL scrollTolleranceReached;
		enum ScrollingDirection lastScrollDirection;
}

// -------------------------------------------------------------------------------
// Properties
// -------------------------------------------------------------------------------
@property (nonatomic, assign) id<ScrollingTabBarItemDelegate> delegate;

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIView *iconView;

@property (nonatomic, copy) NSString *normalIcon;
@property (nonatomic, copy) NSString *activeIcon;

@property (nonatomic, retain) UIViewController *viewController;
@property (nonatomic, assign) SEL callbackAction;
@property (nonatomic, assign) id callbackTarget;

@property (nonatomic, assign, getter = isScrollAnchor) BOOL scrollAnchor;
@property (nonatomic, assign, getter = isEnabled) BOOL enabled;
@property (nonatomic, assign, getter = isSelected) BOOL selected;

@property (nonatomic, assign) CGPoint scrollStartPoint;
@property (nonatomic, assign) BOOL scrollTolleranceReached;
@property (nonatomic, assign) enum ScrollingDirection lastScrollDirection; 

// -------------------------------------------------------------------------------
// Constructors
// -------------------------------------------------------------------------------

- (id) initWithFrame:(CGRect) frame
		    delegate:(id<ScrollingTabBarItemDelegate>) d
               label:(NSString *) txt
          normalIcon:(NSString *) nicon
          activeIcon:(NSString *) aicon
      viewController:(UIViewController *) controller
            selector:(SEL) action
      selectorTarget:(id) target;

// -------------------------------------------------------------------------------
// Public Functions
// -------------------------------------------------------------------------------

// for changing the image later
- (void) updateNormalIcon:(NSString *)icon;

// for changing the image later
- (void) updateActiveIcon:(NSString *)icon;

// text can be nil
- (void) updateLabelText:(NSString *)text;

@end


// -------------------------------------------------------------------------------
// ScrollingTabBarItem Delegate
// -------------------------------------------------------------------------------
@protocol ScrollingTabBarItemDelegate <NSObject>

// To get the style definition from our TabBar
//
// item style keys:
//  - width
//  - height
//  - selectionBackground
//  - selectionBgCapInsets
//  - fontNormalColor
//  - fontActiveColor
- (NSDictionary *) getItemStyle;


- (void) scrollingTabBarLockScroll:(BOOL)lock;

- (BOOL) scrollingTabBarIsLockedForScroll;


// called whenever a touch ended
- (void) scrollingTabBarItemTouchEnded:(ScrollingTabBarItem *) item
					scrollingDirection:(enum ScrollingDirection) scrolls;

// called whenever a item is scrolling 
// and the touch has not ended yet
- (void) scrollingTabBarItemScroll:(ScrollingTabBarItem *) item 
							  from:(CGPoint) from 
							    to:(CGPoint) to;

@end
