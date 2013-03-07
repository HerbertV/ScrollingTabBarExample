/*
 *  ViewController.h
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
#import "ScrollingTabBar.h"

@interface ViewController : UIViewController
{
	ScrollingTabBar *tabBar;
	
	NSString *activeLanguage;
}

@property (nonatomic, retain) ScrollingTabBar *tabBar;
@property (nonatomic, copy) NSString *activeLanguage;


- (void) callbackLanguageButtonTest;


@end
