/*
 *  ViewController.m
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
#import "ViewController.h"

@implementation ViewController

#pragma mark - Scrolling Tab Bar Callback Test
- (void) callbackLanguageButtonTest
{
	//switch between English and German
	if( [self.activeLanguage isEqualToString:@"de"] )
	{
		self.activeLanguage = @"en";
		
		[self.tabBar setTabLabelText:@"Start" atIndex: 0];
		[self.tabBar setTabLabelText:@"Browser" atIndex: 1];
		[self.tabBar setTabLabelText:@"Ordner inaktiv" atIndex: 2];
		[self.tabBar setTabLabelText:@"Ordner blau" atIndex: 3];
		[self.tabBar setTabLabelText:@"Ordner gelb" atIndex: 4];
		[self.tabBar setTabLabelText:@"E-Mail" atIndex:5];
		[self.tabBar setTabNormalIcon:@"Data/ico/TabBarItemLangDE.png"
                           activeIcon:nil
                              atIndex:6];
		
	} else if( [self.activeLanguage isEqualToString:@"en"] ) {
		
		self.activeLanguage = @"de";
		
		[self.tabBar setTabLabelText:@"Home" atIndex: 0];
		[self.tabBar setTabLabelText:@"Web" atIndex: 1];
		[self.tabBar setTabLabelText:@"Folder disabled" atIndex: 2];
		[self.tabBar setTabLabelText:@"Folder blue" atIndex: 3];
		[self.tabBar setTabLabelText:@"Folder yellow" atIndex: 4];
		[self.tabBar setTabLabelText:@"Email" atIndex:5];
		[self.tabBar setTabNormalIcon:@"Data/ico/TabBarItemLangEN.png"
                           activeIcon:nil
                              atIndex:6];
	}
}

#pragma mark - View Lifecycle
- (void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.activeLanguage = @"en";
	_tabBar = [[ScrollingTabBar alloc]  initWithItemCount:5 delegate: nil];
	
	[self.view addSubview:self.tabBar];
	
	// a custom color test
	//[tabbar setBackgroundColor: [UIColor blueColor]];
	
	// a custom background test
	// TODO
	
	{
		UIViewController *con = [[UIViewController alloc] init];
		con.view.backgroundColor = [UIColor whiteColor];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];

        //------------------------------------------------------------------------------
        // if system version is grather then or equal to 6.0 use NSTextAlignmentCenter,
        // otherwise UITextAlignmentCenter
        //------------------------------------------------------------------------------
		if ([[[UIDevice currentDevice] systemVersion] compare: @"6.0" options:NSNumericSearch] != NSOrderedAscending) {
            [label setTextAlignment:NSTextAlignmentCenter];
        } else {
            [label setTextAlignment:UITextAlignmentCenter];
        }
		
		[label setFont: [UIFont systemFontOfSize:20]];
		[label setText:@"ScrollingTabBar Example"];
		label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
                                    UIViewAutoresizingFlexibleBottomMargin |
                                    UIViewAutoresizingFlexibleWidth;
		
		[con.view addSubview:label];
		
		[self.tabBar addTabBarItemWithLabel: @"Home"
                                 normalIcon: @"Data/ico/TabBarItemHomeN.png"
                                 activeIcon: @"Data/ico/TabBarItemHomeA.png"
                             viewController: con
		 ];
	}
	
	{
		// web view to test the rotation resizing for our views
		UIViewController *con = [[UIViewController alloc] init];
		
		UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
		
		web.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
                                UIViewAutoresizingFlexibleBottomMargin |
                                UIViewAutoresizingFlexibleHeight |
                                UIViewAutoresizingFlexibleWidth;
		
		web.scalesPageToFit = YES;
		[con.view addSubview: web];
		[web loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://github.com"]]];
		
		
		[self.tabBar addTabBarItemWithLabel: @"Web"
                                 normalIcon: @"Data/ico/TabBarItemGlobeN.png"
                                 activeIcon: @"Data/ico/TabBarItemGlobeA.png"
                             viewController: con];
	}
	
	{
		UIViewController *con = [[UIViewController alloc] init];
		con.view.backgroundColor = [UIColor whiteColor];
		
		[self.tabBar addTabBarItemWithLabel: @"Folder disabled"
                                 normalIcon: @"Data/ico/TabBarItemFolderN.png"
                                 activeIcon: @"Data/ico/TabBarItemFolderA.png"
                             viewController: con];
		// disable test
		[self.tabBar enableTab:NO atIndex:2];
	}
    
	{
		UIViewController *con = [[UIViewController alloc] init];
		con.view.backgroundColor = [UIColor blueColor];
		
		[self.tabBar addTabBarItemWithLabel: @"Folder Blue"
                                 normalIcon: @"Data/ico/TabBarItemFolderN.png"
                                 activeIcon: @"Data/ico/TabBarItemFolderA.png"
                             viewController: con];
	}
	
	{
		UIViewController *con = [[UIViewController alloc] init];
		con.view.backgroundColor = [UIColor yellowColor];
		
		[self.tabBar addTabBarItemWithLabel: @"Folder Yellow"
                                 normalIcon: @"Data/ico/TabBarItemFolderN.png"
                                 activeIcon: @"Data/ico/TabBarItemFolderA.png"
                             viewController: con];
	
	}

	{
		UIViewController *con = [[UIViewController alloc] init];
		con.view.backgroundColor = [UIColor greenColor];
		
		[self.tabBar addTabBarItemWithLabel: @"Email"
                                 normalIcon: @"Data/ico/TabBarItemAtN.png"
                                 activeIcon: @"Data/ico/TabBarItemAtA.png"
                             viewController: con];
	}
	
	// Test for the callback behavior
	// a simple language change
	// also demonstrates the layout adjustment if there is no label
	{
		[self.tabBar addTabBarItemWithLabel: nil
                                 normalIcon: @"Data/ico/TabBarItemLangDE.png"
                                   selector: @selector(callbackLanguageButtonTest)
                             selectorTarget: self];
	}
	
	// preselect a tab item
	[self.tabBar selectTabAtIndex:0];
	
}



- (void) viewDidUnload
{
	
    [super viewDidUnload];
}

# pragma mark - View Rotation

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
