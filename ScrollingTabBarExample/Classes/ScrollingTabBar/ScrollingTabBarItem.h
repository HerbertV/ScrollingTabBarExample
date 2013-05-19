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
@private
    CGPoint scrollStartPoint;
    BOOL scrollTolleranceReached;
    enum ScrollingDirection lastScrollDirection;
}

// -------------------------------------------------------------------------------
// Properties
// -------------------------------------------------------------------------------
@property (nonatomic, weak) id<ScrollingTabBarItemDelegate> delegate;

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *iconView;

@property (nonatomic, copy) NSString *normalIcon; //icon path for the normal appearance
@property (nonatomic, copy) NSString *activeIcon; //icon path for the selected appearance

@property (nonatomic, strong) UIViewController *viewController; // linked view Controller
@property (nonatomic, assign) SEL callbackAction; // linked callback function
@property (nonatomic, weak) id callbackTarget; // linked callback target

//-------------------------------------------------------
// if true this is the scroll anchor
// and only this item fires our scroll delegate function
//-------------------------------------------------------
@property (nonatomic, assign, getter = isScrollAnchor) BOOL scrollAnchor;
@property (nonatomic, assign, getter = isEnabled) BOOL enabled; // true if enabled and touchable
@property (nonatomic, assign, getter = isSelected) BOOL selected; // true if selected/active

//@property (nonatomic, assign) CGPoint scrollStartPoint;
//@property (nonatomic, assign) BOOL scrollTolleranceReached;
//@property (nonatomic, assign) enum ScrollingDirection lastScrollDirection; 

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
