//
//  TJPlayerViewController.h
//  TaperJouer
//
//  Created by Thibault Le Cornec on 30/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJHistory.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TJHistoryTableViewController.h"
@class TJPlayerView;

@interface TJPlayerViewController : UIViewController <UISplitViewControllerDelegate>
{
    //  Référence la vue gérée par ce controlleur
    TJPlayerView *playerView;
    
    MPMediaItem *currentPlayingItem;
    NSTimer *timerForRefresProgressView;
    
    UIImage *noArtwork;
}
////////// Propriétés //////////

//  Référence l'objet qui est l'historique
@property (retain) TJHistory *history;

//  Référence l'objet qui est le TableViewController
@property (retain) TJHistoryTableViewController *historyTableViewController;
@property (readonly) MPMusicPlayerController *musicPlayer;


////////// Méthodes //////////

- (void)shuffleModeChange;

@end
