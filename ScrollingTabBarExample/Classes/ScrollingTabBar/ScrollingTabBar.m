/*
 *  ScrollingTabBar.m
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
 
#import "ScrollingTabBar.h"

// Default Padding between two TabBarItems
#define STB_ITEM_PADDING 4.0

// Default Width of a TabBarItem
#define STB_ITEM_WIDTH 100.0
// default height of a tab item
# define STB_ITEM_HEIGHT 47.0

// Default height of the ScrollingTabBar
#define STB_BAR_HEIGHT 49.0

// for the bounce back anim
#define ANIM_BOUNCE_DURATION 0.6
#define ANIM_BOUNCE_DELAY 0.1

//pixel limit when the max Alpha is reached
#define BUMPER_ALPHA_LIMIT 30


// -------------------------------------------------------------------------------
// Interface Private Functions
// -------------------------------------------------------------------------------
#pragma mark - Interface Private Functions
@interface ScrollingTabBar (Private)

// called by every contructor to set default
// values for our Class
- (void) setupDefaults:(NSInteger)itemCount delegate:(id<ScrollingTabBarDelegate>)d hideGradient:(BOOL)hideG;

// initializes our gradient
- (void) setupGradient;

// setup our default item Style Dictionary
- (void) setupDefaultItemStyle;

- (void) setupDefaultScrollIndicators;

- (void) setupDefaultScrollBumpers;

- (void) layoutTabBarItems;

// is called by our other add tab functions
- (void) addTabBarItem:(NSString *) label
			normalIcon:(NSString *) nicon
			activeIcon:(NSString *) aicon
		viewController:(UIViewController *) controller
			  selector:(SEL) action
		selectorTarget:(id) target;

// called by scrollingTabBarItemTouchEnded
// if a movement was done returns true if 
// a bounce animation is triggert
- (BOOL) doBounceBackAnimation;

// called by scrollingTabBarItemTouchEnded
// if a movement stopped in the middle finish scrolling
- (void) doScrollToNextItem:(enum ScrollingDirection) direction;

// hides/unhides the indicators by current item position
- (void) toggleScrollIndicators;

// same as above but in addition the pulse animation
// is started if a indicator is visible
- (void) toggleScrollIndicatorsAndPulse;

- (void) blendScrollBumpers;

@end


// -------------------------------------------------------------------------------
// Implementation Private
// -------------------------------------------------------------------------------
#pragma mark - Implementation Private
@implementation ScrollingTabBar (Private)


- (void) setupDefaults:(NSInteger) itemCount
              delegate:(id<ScrollingTabBarDelegate>) d
          hideGradient:(BOOL) hideG;
{
	self.delegate = d;
	
	self.arrTabBarItems = [[NSMutableArray alloc] initWithCapacity:itemCount];
	self.activeTabIndex = -1;
	
	self.scrolling = NO;
	
	[self setupDefaultItemStyle];
	
	self.itemPadding = STB_ITEM_PADDING;
	
	// view releated stuff
	self.backgroundColor = [UIColor blackColor];
	self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
                                UIViewAutoresizingFlexibleTopMargin |
                                UIViewAutoresizingFlexibleWidth;
	
	[self setupDefaultScrollBumpers];
	
	if( !hideG )
		[self setupGradient];	
	
	[self setupDefaultScrollIndicators];
}


- (void) setupGradient
{
	UIImage *img = [UIImage imageNamed:@"Data/stb/ScrollingTabBarGradient.png"];
	
	self.gradientView = [[UIView alloc] initWithFrame:CGRectMake(0,0,0, img.size.height)];
	self.gradientView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self.gradientView setUserInteractionEnabled:NO];
	[self.gradientView setBackgroundColor: [UIColor colorWithPatternImage: img]];
	[self.gradientView setOpaque:NO];
	[self addSubview:self.gradientView];
}


- (void) setupDefaultItemStyle
{
	self.itemStyle = @{@"width": @(STB_ITEM_WIDTH),
					  @"height": @(STB_ITEM_HEIGHT),
					  @"selectionBackground": @"Data/stb/ScrollingTabBarSelection.png",
					  @"selectionBgCapInsets": @"{0.0,4.0,-1.0,4.0}",
					  @"fontNormalColor": [UIColor grayColor],
					  @"fontActiveColor": [UIColor whiteColor]
                    };
}

- (void) setupDefaultScrollIndicators
{
	self.leftScrollIndicator = [[ScrollIndicator alloc] initWithImagePath: @"Data/stb/ScrollingIndicatorLeftN.png"
                                                                   fxPath: @"Data/stb/ScrollingIndicatorLeftFX.png"];
	
	[self addSubview:self.leftScrollIndicator];
	
	self.rightScrollIndicator = [[ScrollIndicator alloc] initWithImagePath: @"Data/stb/ScrollingIndicatorRightN.png"
                                                                    fxPath: @"Data/stb/ScrollingIndicatorRightFX.png"];
	[self addSubview:self.rightScrollIndicator];
	
}

- (void) setupDefaultScrollBumpers
{
	self.leftScrollBumper = [[ScrollBumper alloc] initWithPosition: CGPointMake(0,0)
                                                         imagePath: @"Data/stb/ScrollingBumpLeft.png"];
	
	[self addSubview:self.leftScrollBumper];
	
	self.rightScrollBumper = [[ScrollBumper alloc] initWithPosition: CGPointMake(self.frame.size.width,0)
                                                          imagePath: @"Data/stb/ScrollingBumpRight.png"];
	
	[self addSubview:self.rightScrollBumper];
}

- (void) layoutTabBarItems
{
	if(self.arrTabBarItems.count > 0 )
    {
        int max = [self calculateMaxVisibleTabs];
        
        int fw = self.frame.size.width + self.itemPadding;
        int tw = [(self.itemStyle)[@"width"] floatValue] + self.itemPadding;
        
        int delta = fw/self.arrTabBarItems.count;
        if(self.arrTabBarItems.count > max )
            delta=tw;
        
        for( int i=0; i< self.arrTabBarItems.count; i++ )
        {
            UIView *v = self.arrTabBarItems[i];
            CGRect f = v.frame;
            
            f.origin.x = i*delta + delta/2 - tw/2;            
            v.frame = f;
        }
    }
}


- (void) addTabBarItem:(NSString *) label
			normalIcon:(NSString *) nicon
			activeIcon:(NSString *) aicon
		viewController:(UIViewController *) controller
			  selector:(SEL) action
		selectorTarget:(id) target
{
	float w = [(self.itemStyle)[@"width"] floatValue];
	float h = [(self.itemStyle)[@"height"] floatValue];
	
 	CGRect f = CGRectMake(0, self.frame.size.height - h, w, h);
	
    ScrollingTabBarItem *item = [[ScrollingTabBarItem alloc] initWithFrame: f
                                                                  delegate: self
                                                                     label: label
                                                                normalIcon: nicon
                                                                activeIcon: aicon
                                                            viewController: controller
                                                                  selector: action
                                                            selectorTarget: target];
	
    // we store the items array index as tag property
    [item setTag:self.arrTabBarItems.count];
    [item setDelegate:self];
    
    [self.arrTabBarItems addObject:item];
    
	// add below the scroll indicators if they are available
	if( self.leftScrollIndicator != nil  ) {
		[self insertSubview:item belowSubview:self.leftScrollIndicator];
    } else {
		[self addSubview:item];
    }
	
	// TODO if visible maybe animation
	//[self layoutTabBarItems];
}

- (BOOL) doBounceBackAnimation
{
	float bounceDelta = 0;
    float itemWidth = [self.itemStyle[@"width"] floatValue];
    float frameWidth = self.frame.size.width;
    
	float firstItemPos = [self.arrTabBarItems[0] frame].origin.x;
	float lastItemPos = [self.arrTabBarItems[self.arrTabBarItems.count-1] frame].origin.x;
	
	
    if( firstItemPos > 0 )
        bounceDelta = 0-firstItemPos;
    
    if( lastItemPos + itemWidth < frameWidth )
        bounceDelta = (frameWidth-itemWidth) - lastItemPos;
    
    if( bounceDelta == 0 )
        return FALSE;
	
	//ScrollBumper animation
	if( bounceDelta < 0 )
		[self.leftScrollBumper doBlendOut: ANIM_BOUNCE_DURATION andDelay: ANIM_BOUNCE_DELAY];
	
	if( bounceDelta > 0 )
		[self.rightScrollBumper doBlendOut: ANIM_BOUNCE_DURATION andDelay: ANIM_BOUNCE_DELAY];
	
    //limit movement and bounce back
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:ANIM_BOUNCE_DURATION];
    [UIView setAnimationDelay:ANIM_BOUNCE_DELAY];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    for( UIView *v in self.arrTabBarItems )
    {
        CGRect f = v.frame;
        f.origin.x += bounceDelta;
        v.frame = f;
    }
    [UIView commitAnimations];
	
	return TRUE;
}

- (void) doScrollToNextItem:(enum ScrollingDirection) direction
{
	float itemWidth = [self.itemStyle[@"width"] floatValue];
    float frameWidth = self.frame.size.width;
    float scrollDelta = 0;
		
	if( direction == ScrollsRight )
	{
		// look for last visible item
		for( int i=self.arrTabBarItems.count-1; i>-1; i-- )
		{
			CGRect f = [self.arrTabBarItems[i] frame];
			
			if( f.origin.x < (frameWidth - itemWidth) )
			{	
				scrollDelta = frameWidth - f.origin.x - itemWidth;
				break;
			}
		}
		
		CGRect fFirst = [self.arrTabBarItems[0] frame];
		
        if( fFirst.origin.x + scrollDelta > 0 ) {
            scrollDelta = - fFirst.origin.x;
        }
	} else if( direction == ScrollsLeft ) {
		// look for first visible item
		for( int i=0; i<self.arrTabBarItems.count; i++ )
		{
			CGRect f =  [self.arrTabBarItems[i] frame];
			if( f.origin.x > (0 - itemWidth - self.itemPadding) )
			{	
				scrollDelta = 0 - f.origin.x - itemWidth - self.itemPadding;
				break;
			}
		}
	}
	
	// do animate scroll
	[UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(toggleScrollIndicatorsAndPulse)];
	
    for( UIView *v in self.arrTabBarItems )
    {
        CGRect f = v.frame;
        f.origin.x += scrollDelta;
        v.frame = f;
    }
    
	[UIView commitAnimations];
}


- (void)toggleScrollIndicators
{
	if( self.leftScrollIndicator == nil )
		return;
	
	if( self.arrTabBarItems.count == 0 )
	{
		[self.leftScrollIndicator setHidden:TRUE];
		[self.rightScrollIndicator setHidden:TRUE];
		return;
	}
		
    // left indicator
    {
        CGRect f = [self.arrTabBarItems[0] frame];
        if( f.origin.x < 0 )
        {
            [self.leftScrollIndicator setHidden:FALSE];
        } else {
            [self.leftScrollIndicator setHidden:TRUE];
        }
    }
    
    //right indicator
    {
        CGRect f = [self.arrTabBarItems[self.arrTabBarItems.count-1] frame];
        
		if( (f.origin.x + f.size.width ) > self.frame.size.width )
        {
            [self.rightScrollIndicator setHidden:FALSE];
        } else {
            [self.rightScrollIndicator setHidden:TRUE];
        }
    }
}


- (void) toggleScrollIndicatorsAndPulse
{
	[self toggleScrollIndicators];
	
	if( self.leftScrollIndicator == nil )
		return;
	
	if( ![self.rightScrollIndicator isHidden] )
		[self.rightScrollIndicator doPulse];
	
	if( ![self.leftScrollIndicator isHidden] )
		[self.leftScrollIndicator doPulse];
	
}

- (void) blendScrollBumpers
{
	if( self.leftScrollBumper == nil )
		return;
	
	// left bumper
    {
		CGRect f = [self.arrTabBarItems[0] frame];
		
        if( f.origin.x > 0 )
        {
			float a = f.origin.x/BUMPER_ALPHA_LIMIT;
			
            [self.leftScrollBumper setAlpha: a];
			[self.leftScrollBumper setHidden:FALSE];
		} else {
		    [self.leftScrollBumper setHidden:TRUE];
		}
    }
    
	//right bumper
	{
		CGRect f = [self.arrTabBarItems[self.arrTabBarItems.count-1] frame];
		
        if( (f.origin.x + f.size.width ) < self.frame.size.width )
        {
			float a = (self.frame.size.width - f.origin.x - f.size.width)/BUMPER_ALPHA_LIMIT;
			[self.rightScrollBumper setAlpha: a];
			[self.rightScrollBumper setHidden:FALSE];
			
		} else {
            [self.rightScrollBumper setHidden:TRUE];
        }
    }
}

@end


// -------------------------------------------------------------------------------
// Implementation Public
// -------------------------------------------------------------------------------
#pragma mark - Implementation Public
@implementation ScrollingTabBar

@synthesize leftScrollBumper;
@synthesize rightScrollBumper;

@synthesize leftScrollIndicator;
@synthesize rightScrollIndicator;

// -------------------------------------------------------------------------------
// Dealloc
// -------------------------------------------------------------------------------
#pragma mark - Dealloc

- (void) dealloc
{
	self.delegate = nil;	
}


// -------------------------------------------------------------------------------
// Initialize
// -------------------------------------------------------------------------------
#pragma mark - Initialize

- (id) initWithItemCount:(NSInteger)count delegate:(id<ScrollingTabBarDelegate>)d
{
	self = [super initWithFrame:CGRectMake(0,0,0, STB_BAR_HEIGHT)];
    
	if( self )
    {
        [self setupDefaults:count delegate:d hideGradient:NO];
    }
    return self;
}


- (id) initWithItemCount:(NSInteger)count delegate:(id<ScrollingTabBarDelegate>)d hideGradient:(BOOL)hideG
{
	self = [super initWithFrame:CGRectMake(0,0,0, STB_BAR_HEIGHT)];
    
	if( self )
    {
        [self setupDefaults:count delegate:d hideGradient:hideG];
    }
    return self;
}

// -------------------------------------------------------------------------------
// Functions
// -------------------------------------------------------------------------------
#pragma mark - Functions

- (NSInteger) calculateMaxVisibleTabs
{
	int fw = self.frame.size.width + self.itemPadding;
    int tw = [(self.itemStyle)[@"width"] floatValue] + self.itemPadding;
    
    return fw / tw;
}


- (void) setGradientHidden:(BOOL) hidden
{
	if( hidden == YES )
	{		
		self.gradientView = nil;
	} else {
		[self setupGradient];
	}
}


#pragma mark add/remove  tab bar items
- (void) addTabBarItemWithLabel:(NSString *) label
					 normalIcon:(NSString *) nicon
     				 activeIcon:(NSString *) aicon
 				 viewController:(UIViewController *) controller
{
    [self addTabBarItem:label
             normalIcon:nicon
             activeIcon:aicon
         viewController:controller
               selector:nil
         selectorTarget:nil];
}


- (void) addTabBarItemWithLabel:(NSString *) label
					 normalIcon:(NSString *) nicon
					   selector:(SEL) action
				 selectorTarget:(id) target
{
    [self addTabBarItem:label 
     		 normalIcon:nicon 
      		 activeIcon:nil 
		 viewController:nil
    	       selector:action
  		 selectorTarget:target
     ];
}


- (ScrollingTabBarItem *) removeTabBarItemAtIndex:(NSInteger) index
{
	if( self.arrTabBarItems.count == 0 || index < 0 || index >= self.arrTabBarItems.count )
		return nil;
	
	ScrollingTabBarItem *item = self.arrTabBarItems[index];
	[item removeFromSuperview];
	[self.arrTabBarItems removeObjectAtIndex:index];
	
	// TODO if visible maybe animation 
	//[self layoutTabBarItems];
	
	return item;
}


#pragma mark Accessing Tabs
- (void) selectTabAtIndex:(NSInteger)index
{
	if( self.arrTabBarItems.count == 0 || index < 0 || index >= self.arrTabBarItems.count )
		return;
	
    ScrollingTabBarItem *newitem = self.arrTabBarItems[index];
    
    // fail save
    if( ![newitem isEnabled] )
        return;
    
    // Deselect
    if( self.activeTabIndex > -1 )
    {
		ScrollingTabBarItem *previtem = self.arrTabBarItems[self.activeTabIndex];
        
        // switch views only if the new item has a controller
        if( previtem.viewController != nil && newitem.viewController != nil )
        {
            [previtem.viewController.view removeFromSuperview];
            
            if( [[[UIDevice currentDevice] systemVersion] compare: @"5.0"] == NSOrderedAscending )
                [previtem.viewController viewDidDisappear:NO];
            
            [previtem setSelected:FALSE];
        }
    }
    
    // select new tab 
    // if a item has a call back we only call the action
    if( newitem.callbackAction != nil && newitem.callbackTarget != nil)
    {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [newitem.callbackTarget performSelector: newitem.callbackAction];
        #pragma clang diagnostic pop
    } else if( newitem.viewController != nil ) {
        CGRect rect = self.superview.bounds;
		//FIXME
        newitem.viewController.view.frame = CGRectMake(0, 0, rect.size.width, rect.size.height-self.frame.size.height);
		
        [self.superview insertSubview:newitem.viewController.view belowSubview:self];
		
        if( [[[UIDevice currentDevice] systemVersion] compare: @"5.0"] == NSOrderedAscending )
            [newitem.viewController viewDidAppear:NO];
		
        [newitem setSelected:TRUE];
        self.activeTabIndex = index;
    }
}


- (void) enableTab:(BOOL)e atIndex:(NSInteger)index
{
	if( self.arrTabBarItems.count == 0 || index < 0 || index >= self.arrTabBarItems.count )
		return;
	
    ScrollingTabBarItem *item = self.arrTabBarItems[index];
    [item setEnabled:e];
}


- (void) setTabLabelText:(NSString *) text atIndex:(NSInteger) index
{
	if( self.arrTabBarItems.count == 0 || index < 0 || index >= self.arrTabBarItems.count )
		return;
	
    ScrollingTabBarItem *item = self.arrTabBarItems[index];
    [item updateLabelText:text];
}

- (void) setTabNormalIcon:(NSString *) nicon activeIcon:(NSString *) aicon atIndex:(NSInteger) index
{
	if( self.arrTabBarItems.count == 0 || index < 0 || index >= self.arrTabBarItems.count )
		return;
	
	ScrollingTabBarItem *item = self.arrTabBarItems[index];
    [item updateNormalIcon: nicon];
	[item updateActiveIcon: aicon];
}


#pragma mark Accessing Active Controller
- (UIViewController *) getActiveViewController
{
	if( self.arrTabBarItems.count == 0 )
		return nil;
	
    ScrollingTabBarItem *item = self.arrTabBarItems[self.activeTabIndex];
    return item.viewController;
}


#pragma mark Accessing Indicator and Bumper
- (void) setIndicators:(ScrollIndicator *) left right:(ScrollIndicator *) right
{
	// TODO
	if( left == nil || right == nil )
	{
	}
}

- (void) setBumpers:(ScrollBumper *) left right:(ScrollBumper *) right
{
	// TODO
	
}


# pragma mark - ScrollingTabBarItem Delegate
- (NSDictionary *) getItemStyle
{
	return self.itemStyle;
}

- (void) scrollingTabBarLockScroll:(BOOL)lock
{
	self.scrolling = lock;
}

- (BOOL) scrollingTabBarIsLockedForScroll
{
	return self.scrolling;
}

- (void) scrollingTabBarItemTouchEnded:(ScrollingTabBarItem *) item
					scrollingDirection:(enum ScrollingDirection) scrolls
{
	// no scrolling just select
    if( scrolls == ScrollsNot )
    {
        // prevents selecting the same tap
        if( [item tag] == [self activeTabIndex] )
            return;
		
        [self selectTabAtIndex:[item tag]];
     	
		//call our delegate if selector exists
        __weak ScrollingTabBar* weakSelf = self;
		if( [self.delegate respondsToSelector:@selector(scrollingTabBarTouched:atItem:atIndex:)] )
            [self.delegate scrollingTabBarTouched:weakSelf atItem: item atIndex: [item tag]];
		return;
    }
    
    // no need for scrolling
    if( self.arrTabBarItems.count <= [self calculateMaxVisibleTabs] )
        return;
	
	// try to bounce back
	if( [self doBounceBackAnimation] )
		return;
	
	// now just move to next item
	[self doScrollToNextItem: scrolls];
}

- (void) scrollingTabBarItemScroll:(ScrollingTabBarItem *) item 
							  from:(CGPoint) from 
							    to:(CGPoint) to
{
	// no need for scrolling
    if( self.arrTabBarItems.count <= [self calculateMaxVisibleTabs] )
        return;
    
	// move our tab bar items
    float delta = to.x - from.x; 
    
	for( UIView *v in self.arrTabBarItems )
    {
        CGRect f = v.frame;
        f.origin.x += delta; 
        v.frame = f;
    }
    
	[self toggleScrollIndicators];
	[self blendScrollBumpers];
	
	//call our delegate if selector exists
    __weak ScrollingTabBar* weakSelf = self;
	if( [self.delegate respondsToSelector: @selector(scrollingTabBarMoved:withItem:atIndex:from:to:)] )
		[self.delegate scrollingTabBarMoved:weakSelf withItem:item atIndex:[item tag] from:from to:to];
}


#pragma mark - UIView 
// overridden to setup our layout
- (void) willMoveToSuperview:(UIView *)newSuperview
{
	[super willMoveToSuperview:newSuperview];
	
	if( newSuperview == nil )
		return;
	
	// since we do not init our view with a frame
	// we need now to setup the frame 
	CGRect rect = CGRectMake(0, newSuperview.bounds.size.height - STB_BAR_HEIGHT, newSuperview.bounds.size.width, STB_BAR_HEIGHT);
	self.frame = rect;
}


// overridden to do some custom adjustments
- (void) layoutSubviews
{
    [super layoutSubviews];
    
    // first our tab items
    [self layoutTabBarItems];
    
    // Indicators
	if( self.leftScrollIndicator != nil )
    {
        float w = self.rightScrollIndicator.frame.size.width;
        float h = self.rightScrollIndicator.frame.size.height;
        float y = 0;
		float xright = self.frame.size.width - w;
        
		CGRect rightRect = CGRectMake(xright, y, w, h);
        CGRect leftRect = CGRectMake(0, y, w, h);
		
		self.rightScrollIndicator.frame = rightRect;
        self.leftScrollIndicator.frame = leftRect;
		
        [self.leftScrollIndicator setHidden:TRUE];
        
        if( self.arrTabBarItems.count > [self calculateMaxVisibleTabs] )
        {
            [self.rightScrollIndicator setHidden:FALSE];
        } else {
            [self.rightScrollIndicator setHidden:TRUE];
        }
    }
	
	// Bumpers
	if( self.leftScrollBumper != nil )
	{
		float w = self.rightScrollBumper.frame.size.width;
        float h = self.rightScrollBumper.frame.size.height;
        float y = self.frame.size.height - h;
        float xright = self.frame.size.width - w;
		
        CGRect rightRect = CGRectMake(xright, y, w, h);
        CGRect leftRect = CGRectMake(0, y, w, h);
		
		self.rightScrollBumper.frame = rightRect;
        self.leftScrollBumper.frame = leftRect;
	}
}

@end
