//
//  AppDelegate.m
//  TaperJouer
//
//  Created by Thibault Le Cornec on 30/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "AppDelegate.h"
#import "TJHistory.h"
#import "TJHistoryTableViewController.h"
#import "TJPlayerViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [_window setBackgroundColor:[UIColor whiteColor]];
    
    
    //  Instanciation du model (Historique)
    TJHistory *historyDataSource = [[TJHistory alloc] init];
    
    
    //  Instanciation TableViewController pour affichage de l'historique (contenue dans un UINavigationController)
    TJHistoryTableViewController *historyTableViewController = [[TJHistoryTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [historyTableViewController setHistory:historyDataSource];
    [[historyTableViewController tableView] setDataSource:historyDataSource];
    
    UINavigationController *historyTableViewNavController = [[UINavigationController alloc] initWithRootViewController:historyTableViewController];
    [[historyTableViewNavController toolbar] setTintColor:[UIColor redColor]];
    
    
    //  Instanciation de la vue player (contenue dans un UINavigationController)
    TJPlayerViewController *playerViewController = [[TJPlayerViewController alloc] init];
    playerView = (TJPlayerView *)[playerViewController view];
    [[playerView shuffleSwitch] addTarget:playerViewController
                                   action:@selector(shuffleModeChange)
                         forControlEvents:UIControlEventValueChanged];
    
    [playerViewController setHistory:historyDataSource];
    [playerViewController setHistoryTableViewController:historyTableViewController];
    UINavigationController *playerViewNavController = [[UINavigationController alloc] initWithRootViewController:playerViewController];
    [[playerViewNavController toolbar] setTintColor:[UIColor redColor]];
    
    
    // Permet au TableViewController de connaitre quel est l'objet qui est le musicPlayer
    [historyTableViewController setMusicPlayer:[playerViewController musicPlayer]];
    
    
    //  Instanciation du UITabBar ou UISplitView
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        // Création du UITabBar
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        [[tabBarController tabBar] setTintColor:[UIColor redColor]];
        
        //  Inclusion des controleurs dans un tableau
        NSArray *controllers = [[NSArray alloc] initWithObjects:playerViewNavController, historyTableViewNavController, nil];
        
        [tabBarController setViewControllers:controllers animated:YES];
        
        [_window setRootViewController:tabBarController];
        [tabBarController release];
        [controllers release];
    }
    else
    {
        // Création du UISplitView
        UISplitViewController *splitViewController = [[UISplitViewController alloc] init];
        
        //  Inclusion des controleurs dans un tableau
        NSArray *controllers = [[NSArray alloc] initWithObjects:historyTableViewNavController, playerViewNavController, nil];
        
        [splitViewController setViewControllers:controllers];
        [splitViewController setDelegate:playerViewController];
        
        [_window setRootViewController:splitViewController];
        [splitViewController release];
        [controllers release];
    }
    
    
    [self.window makeKeyAndVisible];

    [historyDataSource release];
    [historyTableViewController release];
    [historyTableViewNavController release];
    [playerViewController release];
    [playerViewNavController release];
    
    return YES;
}





/* ************************************************** */
/* ---------------- Gestion Affichage --------------- */
/* ************************************************** */
#pragma mark - Gestion Affichage

#pragma mark |--> Changement de statusBarFrame (UIApplicationDelegate)
// Permet de redimensionner la vue lorsque la frame de la statusBar change
- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame
{
    //  Lorsque cette méthode est appellée elle donne les nouvelles dimensions de la statusBar
    //      mais si on passe en paramètre d'orientation l'orientation actuelle de l'application
    //      celle-ci ayant pas encore fait sa rotation on passe alors l' "ANCIENNE" orientation.
    //  On ne peut pas non plus passer directement la valeur de l'orientation du iDevice car
    //      car ça ne correspond pas exactement aux valeurs d'orientation de l'interface.
    //      On passe donc une valeur 1 pour l'orientation portrait et 3 pour le paysage en fonction
    //      de l'orientation du iDevice (0 ou 1 pour le portrait, 3 ou 4 pour le paysage).
    //  On peut se baser sur l'orientation du iDevice car l'appel de cette méthode se fait justement
    //      parce-que le iDevice a déjà changé d'orientation ou que la frame de la statusBar change
    //      donc l'orientation du iDevice au moment de la demande est bien l'orientation actuelle (nouvelle).
    if (([[UIDevice currentDevice] orientation] == 0) || ([[UIDevice currentDevice] orientation] == 1) || ([[UIDevice currentDevice] orientation] == 2))
    {
        [playerView setViewForOrientation:1
                       withStatusBarFrame:newStatusBarFrame];
    }
    else if (([[UIDevice currentDevice] orientation] == 3) || ([[UIDevice currentDevice] orientation] == 4))
    {
        [playerView setViewForOrientation:3
                       withStatusBarFrame:newStatusBarFrame];
    }
}





- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
