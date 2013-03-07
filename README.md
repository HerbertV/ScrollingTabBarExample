# iOS ScrollingTabBar

-----------------------------------

*Scrolling Tab Bar Component.*

A Sample XCode Project for iOS. 
Runns on iOS 5.1 or higher


-----------------------------------

[Inspired by idev-recipes CustomTabBar](https://github.com/boctor/idev-recipes/tree/master/CustomTabBar)

[Scrolling Tab Bar Licensed under MIT License](http://opensource.org/licenses/MIT)

Sources: http://github.com/HerbertV/

-----------------------------------

## Features

- Fully skinnable 
- Has optional scroll indicators and bumbers.
- can be used to switch between View Controllers or to call a Selector.
- As long as all tabs fit in the screen width, it behaves like the original iOS Tab Bar.


## How to use

### Adding it to your own project:

just copy the "ScrollingTabBar" folder into your project and add the files inside to your project. 


### Some code snippets:

	// inits a tab bar for 5 tabs
	self.tabBar = [[ScrollingTabBar alloc] initWithItemCount:5 delegate: nil];

	// adds a tab item with a UIViewController
	// label can be nil
	[tabBar addTabBarItemWithLabel: @"Home" 
							normalIcon: @"Data/ico/TabBarItemHomeN.png" 
							activeIcon: @"Data/ico/TabBarItemHomeA.png"
						viewController: yourUIViewController
		 ];
		 
	// adds a tab item with a selector and target and without a label
	[tabBar addTabBarItemWithLabel: nil
							normalIcon: @"Data/ico/TabBarItemLangDE.png"
							  selector: @selector(yourSelector)
						selectorTarget: yourTarget
		 ];	 
		 
	// disables/enables a tab item at the given index	 
	[tabBar enableTab:NO atIndex:0];
	
	// preselect a tab item
	[tabBar selectTabAtIndex:0];
	
	// changes the background tint 
	tabBar.backgroundColor = [UIColor blackColor]

	
## Sample Images

TODO sample images
	

## Drafts 

Contains psd files for the icons/images this component uses.
Some of these icons are based on WPZOOM Developer Icon Set.

[WPZOOM Developer Icon Set by WPZOOM is licensed under a Creative Commons Attribution-Share Alike 3.0 Unported License](http://creativecommons.org/licenses/by-sa/3.0/). 

[Designed by David Ferreira http://www.wpzoom.com](http://www.wpzoom.com)

