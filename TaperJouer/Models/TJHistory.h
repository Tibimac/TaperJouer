//
//  TJHistory.h
//  TaperJouer
//
//  Created by Thibault Le Cornec on 30/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface TJHistory : NSObject <UITableViewDataSource>

////////// Propriétés //////////

//  Tableau contenant les morceaux joués
@property (readonly) NSMutableArray *historyPlaylist;

@end
