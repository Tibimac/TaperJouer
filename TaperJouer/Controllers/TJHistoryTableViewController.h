//
//  TJHistoryTableViewController.h
//  TaperJouer
//
//  Created by Thibault Le Cornec on 30/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJHistory.h"

@interface TJHistoryTableViewController : UITableViewController <UITableViewDelegate>

////////// Propriétés //////////

//  Référence l'objet qui est l'historique
//  Permet au TableViewController de le donner comme dataSource à sa TableView
@property (retain) TJHistory *history;

//  Référence l'objet qui est le musicPlayer
//  Permet au TableViewController de lui setter un morceaux à jouer lorsqu'un
//      morceau est sélectionné dans l'historique
@property (retain) MPMusicPlayerController *musicPlayer;

@end
