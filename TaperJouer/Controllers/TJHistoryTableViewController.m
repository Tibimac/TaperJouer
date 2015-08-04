//
//  TJHistoryTableViewController.m
//  TaperJouer
//
//  Created by Thibault Le Cornec on 30/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "TJHistoryTableViewController.h"

@interface TJHistoryTableViewController ()

@end

@implementation TJHistoryTableViewController

/* ************************************************** */
/* ----------------- Initialisation ----------------- */
/* ************************************************** */
#pragma mark - Initialisation

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            UITabBarItem *tabIcon = [[UITabBarItem alloc] initWithTitle:@"Historique" image:[UIImage imageNamed:@"playlistHistory"] tag:2];
            [self setTabBarItem:tabIcon];
            [[self tableView] setTintColor:[UIColor redColor]];
            [tabIcon release];
        }
        
        [self setTitle:@"Historique"];
      
        [[self tableView] setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}





/* ************************************************** */
/* ---- Sélection d'un morceau dans l'historique ---- */
/* ************************************************** */
#pragma mark - Sélection d'un morceau dans l'historique (UITableViewDelegate)

//  Méthode appellée lorsqu'une cellule est sélectionnée
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= 0 && indexPath.row <= [[_history historyPlaylist] count])
    {
        [_musicPlayer setNowPlayingItem:[[_history historyPlaylist] objectAtIndex:indexPath.row]];
    }
}




/* ************************************************** */
/* ----------------- Gestion Mémoire ---------------- */
/* ************************************************** */
#pragma mark - Gestion Mémoire

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
