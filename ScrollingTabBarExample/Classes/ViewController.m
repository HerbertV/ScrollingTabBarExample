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

@synthesize tabBar;
@synthesize activeLanguage;

#pragma mark - Dealloc
- (void) dealloc
{
	self.tabBar = nil;
	self.activeLanguage = nil;
	
	[super dealloc];
}

#pragma mark - Scrolling Tab Bar Callback Test
- (void) callbackLanguageButtonTest
{
	//switch between English and German
	if( [activeLanguage isEqualToString:@"de"] )
	{
		self.activeLanguage = @"en";
		
		[tabBar setTabLabelText:@"Start" 
						atIndex: 0];
		[tabBar setTabLabelText:@"Browser" 
						atIndex: 1];
		[tabBar setTabLabelText:@"Ordner inaktiv" 
						atIndex: 2];
		[tabBar setTabLabelText:@"Ordner blau" 
						atIndex: 3];
		[tabBar setTabLabelText:@"Ordner gelb" 
						atIndex: 4];
		[tabBar setTabLabelText:@"E-Mail" 
						atIndex:5];
		[tabBar setTabNormalIcon:@"Data/ico/TabBarItemLangDE.png" 
					  activeIcon:nil 
						 atIndex:6];
		
	} else if( [activeLanguage isEqualToString:@"en"] ) {
		
		self.activeLanguage = @"de";
		
		[tabBar setTabLabelText:@"Home" 
						atIndex: 0];
		[tabBar setTabLabelText:@"Web" 
						atIndex: 1];
		[tabBar setTabLabelText:@"Folder disabled" 
						atIndex: 2];
		[tabBar setTabLabelText:@"Folder blue" 
						atIndex: 3];
		[tabBar setTabLabelText:@"Folder yellow" 
						atIndex: 4];
		[tabBar setTabLabelText:@"Email" 
						atIndex:5];
		[tabBar setTabNormalIcon:@"Data/ico/TabBarItemLangEN.png" 
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
	
	self.tabBar = [[ScrollingTabBar alloc] 
				   initWithItemCount:5 
				   			delegate: nil
				   ];
	
	[self.view addSubview:tabBar];
	
	// a custom color test
	//[tabbar setBackgroundColor: [UIColor blueColor]];
	
	// a custom background test
	// TODO
	
	{
		UIViewController *con = [[[UIViewController alloc] init] autorelease];
		con.view.backgroundColor = [UIColor whiteColor];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(
																 0,
																 0,
																 self.view.bounds.size.width,
																 50
																 )
						  ];
		
		[label setTextAlignment:UITextAlignmentCenter];
		[label setFont: [UIFont systemFontOfSize:20]];
		[label setText:@"ScrollingTabBar Example"];
		label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin 
				| UIViewAutoresizingFlexibleBottomMargin
				| UIViewAutoresizingFlexibleWidth;
		
		[con.view addSubview:label];
		
		[tabBar addTabBarItemWithLabel: @"Home" 
							normalIcon: @"Data/ico/TabBarItemHomeN.png" 
							activeIcon: @"Data/ico/TabBarItemHomeA.png"
						viewController: con
		 ];
	}
	
	{
		// web view to test the rotation resizing for our views
		UIViewController *con = [[[UIViewController alloc] init] autorelease];
		
		UIWebView *web = [[UIWebView alloc] 
						  initWithFrame:CGRectMake(
						  						   0,
												   0,
												   self.view.bounds.size.width,
												   self.view.bounds.size.height
												   )
									];
		
		web.autoresizingMask = UIViewAutoresizingFlexibleRightMargin 
				| UIViewAutoresizingFlexibleBottomMargin
				| UIViewAutoresizingFlexibleHeight
				| UIViewAutoresizingFlexibleWidth;
		
		web.scalesPageToFit = YES;
		[con.view addSubview: web];
		[web loadRequest: [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://github.com"]]];
		
		[web release];
		
		[tabBar addTabBarItemWithLabel: @"Web" 
							normalIcon: @"Data/ico/TabBarItemGlobeN.png" 
							activeIcon: @"Data/ico/TabBarItemGlobeA.png"
						viewController: con
		 ];
	}
	
	{
		UIViewController *con = [[[UIViewController alloc] init] autorelease];
		con.view.backgroundColor = [UIColor whiteColor];
		
		[tabBar addTabBarItemWithLabel: @"Folder disabled" 
							normalIcon: @"Data/ico/TabBarItemFolderN.png" 
							activeIcon: @"Data/ico/TabBarItemFolderA.png"
						viewController: con
		 ];
		// disable test
		[tabBar enableTab:NO atIndex:2];
	}
	{
		UIViewController *con = [[[UIViewController alloc] init] autorelease];
		con.view.backgroundColor = [UIColor blueColor];
		
		[tabBar addTabBarItemWithLabel: @"Folder Blue" 
							normalIcon: @"Data/ico/TabBarItemFolderN.png" 
							activeIcon: @"Data/ico/TabBarItemFolderA.png"
						viewController: con
		 ];
	}
	
	{
		UIViewController *con = [[[UIViewController alloc] init] autorelease];
		con.view.backgroundColor = [UIColor yellowColor];
		
		[tabBar addTabBarItemWithLabel: @"Folder Yellow" 
							normalIcon: @"Data/ico/TabBarItemFolderN.png" 
							activeIcon: @"Data/ico/TabBarItemFolderA.png"
						viewController: con
		 ];
	
	}
	{
		UIViewController *con = [[[UIViewController alloc] init] autorelease];
		con.view.backgroundColor = [UIColor greenColor];
		
		[tabBar addTabBarItemWithLabel: @"Email" 
							normalIcon: @"Data/ico/TabBarItemAtN.png" 
							activeIcon: @"Data/ico/TabBarItemAtA.png"
						viewController: con
		 ];
	}
	
	// Test for the callback behavior
	// a simple language change
	// also demonstrates the layout adjustment if there is no label
	{
		[tabBar addTabBarItemWithLabel: nil
							normalIcon: @"Data/ico/TabBarItemLangDE.png"
							  selector: @selector(callbackLanguageButtonTest)
						selectorTarget: self
		 ];
	}
	
	// preselect a tab item
	[tabBar selectTabAtIndex:0];
	
}



- (void) viewDidUnload
{
	[tabBar release];
	
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

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
								 duration:(NSTimeInterval)duration
{
	
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	
}



@end
