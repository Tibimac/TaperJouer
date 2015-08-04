//
//  TJPlayerView.h
//  TaperJouer
//
//  Created by Thibault Le Cornec on 30/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TJPlayerViewController;

@interface TJPlayerView : UIView
{
    BOOL isiOS7OrLater;
    BOOL isiPhone;
}
////////// Propriétés //////////

//  Référence le controlleur gérant cette vue
@property (retain) TJPlayerViewController *playerViewController;

@property (readonly) UIView *shuffleView;
@property (retain) UIImageView *shuffleIcon;
@property (readonly) UISwitch *shuffleSwitch;

@property (retain) UILabel *songTitle;
@property (retain) UILabel *songArtist;
@property (retain) UILabel *songAlbum;

@property (retain) UIImageView *cover;
@property (retain) UIImageView *coverOverlay;

@property (retain) UILabel *durationPlayed;
@property (retain) UIProgressView *playerProgressView;
@property (retain) UILabel *songDuration;


////////// Méthodes //////////

//  Méthode pour dessiner la vue selon une orientation et en gérant la frame de la statusBar
//  Cette méthode est également appellée par FAAppDelegate lors d'un changement de frame de la statusBar
- (void)setViewForOrientation:(UIInterfaceOrientation)orientation withStatusBarFrame:(CGRect)statusBarFrame;

@end
