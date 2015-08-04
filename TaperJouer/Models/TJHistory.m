//
//  TJHistory.m
//  TaperJouer
//
//  Created by Thibault Le Cornec on 30/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "TJHistory.h"

@implementation TJHistory

/* ************************************************** */
/* ----------------- Initialisations ---------------- */
/* ************************************************** */
#pragma mark - Initialisation

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        //====================================
        // EN CAS DE PERSISTENCE DES DONNÉES |
        //====================================
        //  Ouverture du ficier contenant les données
        //  Lecture du fichier
        //  Données lues placées dans un tableau en mémoire.
        //  Données envoyées aux cellules lorsque demandé par le TableViewController
        
        _historyPlaylist = [[NSMutableArray alloc] init];
    }
    
    return self;
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_historyPlaylist count];
}


#pragma mark |--> Cellule pour indexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL newCell = NO;
    static NSString *CellIdentifier = @"SongCell";
    NSUInteger row = indexPath.row;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (row < [_historyPlaylist count])
    {
        if (cell == nil) // Si aucune cellule récupérée -> création d'une nouvelle
        {
            newCell = YES;
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
        MPMediaItem *item = [_historyPlaylist objectAtIndex:row];
        
        [[cell textLabel] setText:[item valueForProperty:MPMediaItemPropertyTitle]];
        [[cell detailTextLabel] setText:[item valueForProperty:MPMediaItemPropertyArtist]];
        
        MPMediaItemArtwork *artwork = [item valueForProperty: MPMediaItemPropertyArtwork];
        UIImage *artworkImage = [artwork imageWithSize:[cell imageView].frame.size];
        if (artworkImage)
        {
            [[cell imageView] setImage:artworkImage];
        }
        else
        {
            [[cell imageView] setImage:[UIImage imageNamed: @"NoArtwork"]];
        }
    }
    
    if (newCell)
    {
        return [cell autorelease];
    }
    else
    {
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] == 0)
    {
        
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
