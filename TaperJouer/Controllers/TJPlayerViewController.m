//
//  TJPlayerViewController.m
//  TaperJouer
//
//  Created by Thibault Le Cornec on 30/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "TJPlayerViewController.h"
#import "TJPlayerView.h"

@interface TJPlayerViewController ()

@end

@implementation TJPlayerViewController

/* ************************************************** */
/* ----------------- Initialisation ----------------- */
/* ************************************************** */
#pragma mark - Initialisation

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        //  Si le device est un iPhone, on a une TabBar, on parametre donc l'icône de notre vue
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            UITabBarItem *tabIcon = [[UITabBarItem alloc] initWithTitle:@"Lecteur" image:[UIImage imageNamed:@"player"] tag:1];
            [self setTabBarItem:tabIcon];
            [tabIcon release];
        }
        
        [self setTitle:@"Lecteur"];
        
        //  Instanciation de la vue player
        playerView = [[TJPlayerView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [playerView setPlayerViewController:self];
        
        // Création du BarButtonItem
        UIBarButtonItem *customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[playerView shuffleView]];
        [[self navigationItem] setRightBarButtonItem:customBarButtonItem];
        
        // Initialisation des gestureRecognizer que l'on ajoute à la vue
        UISwipeGestureRecognizer *leftToRightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previousSong)];
        [leftToRightGesture setDirection:UISwipeGestureRecognizerDirectionRight];
        [playerView addGestureRecognizer:leftToRightGesture];
        [leftToRightGesture release];
        
        UISwipeGestureRecognizer *rightToLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextSong)];
        [rightToLeftGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
        [playerView addGestureRecognizer:rightToLeftGesture];
        [rightToLeftGesture release];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playPauseSong)];
        [tapGesture setNumberOfTapsRequired:2];
        [tapGesture setNumberOfTouchesRequired:1];
        [playerView addGestureRecognizer:tapGesture];
        [tapGesture release];
        

        [self setView:playerView];
        [playerView release];
        
       
        // Initialisation du MPMediaPlayer
        _musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(songDidChange) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStateDidChange) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:nil];
        [_musicPlayer beginGeneratingPlaybackNotifications];
        [_musicPlayer setQueueWithQuery:[MPMediaQuery songsQuery]];
        [_musicPlayer setShuffleMode: MPMusicShuffleModeOff];
        [_musicPlayer setRepeatMode: MPMusicRepeatModeNone];
        [_musicPlayer play]; // Permet de charger le 1er élément de la liste
        [_musicPlayer pause];

        timerForRefresProgressView = [NSTimer scheduledTimerWithTimeInterval:0.25
                                                                      target:self
                                                                    selector:@selector(updateProgressView:)
                                                                    userInfo:nil
                                                                     repeats:YES];
        
        noArtwork = [UIImage imageNamed: @"NoArtwork"];
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}


//  Méthode appellée lorsque l'utilisateur fait un doubleTap sur l'écran
- (void)playPauseSong
{
    if ([_musicPlayer playbackState] == MPMusicPlaybackStatePlaying)
    {
        [_musicPlayer pause];
    }
    else
    {
        [_musicPlayer play];
    }
}


//  Méthode appellée par le musicPlayerController lorsque l'état change (play/pause)
//  Cette méthode affiche ou masque le coverOverlay pour indiquer qu'on est ou non en pause
- (void)playbackStateDidChange
{
    if ([_musicPlayer playbackState] == MPMusicPlaybackStatePlaying)
    {
        [[playerView coverOverlay] setHidden:YES];
    }
    else
    {
        [[playerView coverOverlay] setHidden:NO];
    }
}


//  Méthode appellée par le switch lors d'un changement de valeur (ON/OFF)
//  Cette méthode sette le mode Shuffle du musicPlayer en fonction de l'état du switch
//      et sette l'alpha de l'icone pour la rendre moins visible si le mode shuffle est désactivé
- (void)shuffleModeChange
{
    if ([[playerView shuffleSwitch] isOn])
    {
        [_musicPlayer setShuffleMode:MPMusicShuffleModeSongs];
        [[playerView shuffleIcon] setAlpha:1.0];
    }
    else if ([[playerView shuffleSwitch] isOn] == NO)
    {
        [_musicPlayer setShuffleMode:MPMusicShuffleModeOff];
        [[playerView shuffleIcon] setAlpha:0.4];
    }
}


//  Méthode appellé lorsque l'utilisateur fait un swipe de la gauche vers la droite
- (void)previousSong
{
    //  Vérification si on est pas déjà au début de la liste des morceaux   
    if ([_musicPlayer indexOfNowPlayingItem] > 0)
    {
        [_musicPlayer skipToPreviousItem];
    }
}


//  Méthode appellé lorsque l'utilisateur fait un swipe de la droite vers la gauche
- (void)nextSong
{
    //  Vérification si on est pas au bout de la liste des morceaux
    if ([_musicPlayer indexOfNowPlayingItem] < [[[MPMediaQuery songsQuery] items]count]-1)
    {
        [_musicPlayer skipToNextItem];
    }
}


//  Méthode appellé par le musicPlayerController lorsqu'il a chargé un nouveau morceau
//  Cette méthode récupère les infos du nouveau morceau et les affiches
- (void)songDidChange
{
    if ([_musicPlayer nowPlayingItem] != nil)
    {
        ////////// -------------------------------------------------- //////////
        MPMediaItem *newItem = [_musicPlayer nowPlayingItem];
        
        // Si nouveau morceau n'est pas dans l'historique, on l;ajoute à l'historique
        if (! [self findObjectByMPMediaItemPropertyPersistantID:[newItem valueForProperty:MPMediaItemPropertyPersistentID]])
        {
            [[_history historyPlaylist] addObject:[_musicPlayer nowPlayingItem]]; // Ajout du morceau maintenant en lecture à l'historique
            
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
            {
                // Changement du badge du tabBarItem de la vue historique. On lui donne le nombre d'éléments dans l'historique
                [[_historyTableViewController tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%d", (int)[[_history historyPlaylist] count]]];
            }
        }
        
        [[_historyTableViewController tableView] reloadData];
        ////////// -------------------------------------------------- //////////
        
        [[playerView songTitle] setText:[[_musicPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyTitle]];
        [[playerView songArtist] setText:[[_musicPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyArtist]];
        [[playerView songAlbum] setText:[[_musicPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyAlbumTitle]];
       
        
        MPMediaItemArtwork *artwork = [[_musicPlayer nowPlayingItem] valueForProperty: MPMediaItemPropertyArtwork];
  
        float coverHeight = [[playerView cover] bounds].size.height;
        float coverWidth = [[playerView cover] bounds].size.width;
        UIImage *artworkImage;
        
        if (coverHeight > coverWidth)
        {
            artworkImage = [artwork imageWithSize:CGSizeMake(coverWidth, coverWidth)];
        }
        else if (coverHeight < coverWidth)
        {
            artworkImage = [artwork imageWithSize:CGSizeMake(coverHeight, coverHeight)];
        }
        else
        {
            artworkImage = [artwork imageWithSize:CGSizeMake(coverWidth, coverHeight)];
        }
    
        
//        UIColor *dominantColor = [self getDominantColor:artworkImage];
//        if ([self color:dominantColor isEqualToColor:[UIColor whiteColor]])
//        {
//            dominantColor = [UIColor lightGrayColor];
//        }
//        
//        [[playerView songTitle] setTextColor:dominantColor];
//        [[playerView songArtist] setTextColor:dominantColor];
//        [[playerView songAlbum] setTextColor:dominantColor];
//        [[playerView playerProgressView] setTintColor:dominantColor];
//        [playerView setTintColor:dominantColor];
//        [[[self tabBarController] tabBar] setTintColor:dominantColor];
        
        
        if (artworkImage != nil)
        {
            [[playerView cover] setImage:artworkImage];
        }
        else
        {
            [[playerView cover] setImage:noArtwork];
        }
        
        double songDuration = [[[_musicPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
        int minutes = floor(songDuration/60); // Renvoi la valeure entière (ex : 234.33/60 = 3.90 => floor(3.90) = 3)
        int seconds = round(songDuration - (minutes * 60)); // Renvoi la valeure entière la plus proche (ex : 3*60 = 180 => 234.33-180 = 54.33 => round(54.33) = 54)
        
        [[playerView songDuration] setText:[NSString stringWithFormat:@"%d:%.2d", minutes, seconds]];
    }
}


//  Méthode appellé avant un ajout à l'historique pour vérifier si un ID donné est déjà dans l'historique ou non
- (BOOL)findObjectByMPMediaItemPropertyPersistantID:(NSNumber *)propertyID
{
    for (MPMediaItem *item in [_history historyPlaylist]) // Parcours de items de l'historique
    {
        // Comparaison entre l'ID demandé et l'ID de l'item de l'historique
        NSNumber *itemPropertyID = [item valueForProperty:MPMediaItemPropertyPersistentID];
        if ([propertyID isEqualToNumber:itemPropertyID])
        {
            return YES;
        }
    }
    
    return NO;
}


// Méthode appellée par le timer pour mettre à jour la progressView selon l'avancement de lecture du morceau
- (void)updateProgressView:(NSTimer *)timer
{
    double durationTotal = [[[_musicPlayer nowPlayingItem] valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
    double durationPlayed = [_musicPlayer currentPlaybackTime];
    
    int minutes = floor(durationPlayed/60); // Renvoi la valeure entière (ex : 234.33/60 = 3.90 => floor(3.90) = 3)
    int seconds = (durationPlayed - (minutes * 60));

    [[playerView durationPlayed] setText:[NSString stringWithFormat:@"%d:%.2d", minutes, seconds]];
    if (seconds < 1)
    {
        [[playerView playerProgressView] setHidden:YES];
    }
    else
    {
        [[playerView playerProgressView] setHidden:NO];
    }
    [[playerView playerProgressView] setProgress:(durationPlayed / durationTotal) animated:YES];
}





//- (BOOL) color:(UIColor *)colorOne isEqualToColor:(UIColor *)colorTwo
//{
//    return CGColorEqualToColor(colorOne.CGColor, colorTwo.CGColor);
//}


//struct pixel
//{
//    unsigned char r, g, b, a;
//};
//
//- (UIColor*) getDominantColor:(UIImage*)image
//{
//    NSUInteger red = 0;
//    NSUInteger green = 0;
//    NSUInteger blue = 0;
//    
//    // Allocate a buffer big enough to hold all the pixels
//    struct pixel* pixels = (struct pixel*) calloc(1, image.size.width * image.size.height * sizeof(struct pixel));
//    
//    if (pixels != nil)
//    {
//        CGContextRef context = CGBitmapContextCreate(
//                                                     (void*) pixels,
//                                                     image.size.width,
//                                                     image.size.height,
//                                                     8,
//                                                     image.size.width * 4,
//                                                     CGImageGetColorSpace(image.CGImage),
//                                                     kCGImageAlphaPremultipliedLast
//                                                     );
//        if (context != NULL)
//        {
//            // Draw the image in the bitmap
//            
//            CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), image.CGImage);
//            
//            // Now that we have the image drawn in our own buffer, we can loop over the pixels to
//            // process it. This simple case simply counts all pixels that have a pure red component.
//            
//            // There are probably more efficient and interesting ways to do this. But the important
//            // part is that the pixels buffer can be read directly.
//            
//            NSUInteger numberOfPixels = image.size.width * image.size.height;
//            for (int i=0; i<numberOfPixels; i++)
//            {
//                red += pixels[i].r;
//                green += pixels[i].g;
//                blue += pixels[i].b;
//            }
//            
//            red /= numberOfPixels;
//            green /= numberOfPixels;
//            blue/= numberOfPixels;
//            
//            CGContextRelease(context);
//        }
//        free(pixels);
//    }
//    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0f];
//}





/* ************************************************** */
/* ---------------- Gestion Affichage --------------- */
/* ************************************************** */
#pragma mark - Gestion Affichage

- (BOOL)shouldAutorotate
{
    return YES;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [playerView setViewForOrientation:toInterfaceOrientation withStatusBarFrame:[[UIApplication sharedApplication] statusBarFrame]];
}


#pragma mark - Rotation en mode portrait
- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    [[self navigationItem] setLeftBarButtonItem:barButtonItem animated:YES];
}


#pragma mark - Rotation en mode paysage
- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)button
{
    [[self navigationItem] setLeftBarButtonItem:nil animated:YES];
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
