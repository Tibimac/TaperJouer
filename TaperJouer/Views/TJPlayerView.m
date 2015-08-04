//
//  TJPlayerView.m
//  TaperJouer
//
//  Created by Thibault Le Cornec on 30/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "TJPlayerView.h"
#import "TJPlayerViewController.h"

@implementation TJPlayerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
       // [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        isiPhone = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
        isiOS7OrLater = ([[[UIDevice currentDevice] systemVersion] characterAtIndex:0] >= '7');
        
        if (isiPhone)
        {
            [self setTintColor:[UIColor redColor]];
        }
        
        // Création de la vue
        _shuffleView = [[UIView alloc] init];
        
        // Création de l'image
        _shuffleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shuffle"]];
        [_shuffleIcon setAlpha:0.4];
        [_shuffleView addSubview:_shuffleIcon];
        [_shuffleIcon release];
        
        // Creeation du switch
        _shuffleSwitch = [[UISwitch alloc] init];
        if (isiPhone)
        {
            [_shuffleSwitch setTintColor:[UIColor redColor]];
            [_shuffleSwitch setOnTintColor:[UIColor redColor]];
        }
        [_shuffleSwitch setOn:NO animated:NO];
        [_shuffleView addSubview:_shuffleSwitch];
        [_shuffleSwitch release];
        
        
        _songTitle = [[UILabel alloc] init];
        [_songTitle setTextAlignment:NSTextAlignmentCenter];
        if (isiPhone)
        {
            [_songTitle setTextColor:[UIColor redColor]];
        }
        [self addSubview:_songTitle];
        
        _songArtist = [[UILabel alloc] init];
        [_songArtist setTextAlignment:NSTextAlignmentCenter];
        if (isiPhone)
        {
            [_songArtist setTextColor:[UIColor redColor]];
        }
        [self addSubview:_songArtist];
        
        _songAlbum = [[UILabel alloc] init];
        [_songAlbum setTextAlignment:NSTextAlignmentCenter];
        if (isiPhone)
        {
            [_songAlbum setTextColor:[UIColor redColor]];
        }
        [self addSubview:_songAlbum];
        
        _cover = [[UIImageView alloc] init];
        [_cover setContentMode:UIViewContentModeScaleAspectFill];
        [self insertSubview:_cover atIndex:0];
        
        _coverOverlay = [[UIImageView alloc] init];
        [_coverOverlay setContentMode:UIViewContentModeScaleAspectFill];
        [_coverOverlay setImage:[UIImage imageNamed:@"coverOverlay"]];
        [_coverOverlay setAlpha:0.85];
        [_coverOverlay setHidden:NO];
        [self addSubview:_coverOverlay];
        
        _durationPlayed = [[UILabel alloc] init];
        [_durationPlayed setTextAlignment:NSTextAlignmentCenter];
        [_durationPlayed setFont:[UIFont systemFontOfSize:11]];
        [_durationPlayed setTextColor:[UIColor blackColor]];
        [self addSubview:_durationPlayed];
        
        _playerProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [_playerProgressView setHidden:YES];
        [_playerProgressView setProgress:0.0 animated:NO];
        [self addSubview:_playerProgressView];
        
        _songDuration= [[UILabel alloc] init];
        [_songDuration setTextAlignment:NSTextAlignmentCenter];
        [_songDuration setText:@"0:00"];
        [_songDuration setFont:[UIFont systemFontOfSize:11]];
        [_songDuration setTextColor:[UIColor blackColor]];
        [self addSubview:_songDuration];
        
        
        [self setViewForOrientation:[[UIApplication sharedApplication] statusBarOrientation]
                 withStatusBarFrame:[[UIApplication sharedApplication] statusBarFrame]];
       
//        [_songTitle setBackgroundColor:[UIColor grayColor]];
//        [_songArtist setBackgroundColor:[UIColor lightGrayColor]];
//        [_songAlbum setBackgroundColor:[UIColor grayColor]];
       [_cover setBackgroundColor:[UIColor lightGrayColor]];
//        [_durationPlayed setBackgroundColor:[UIColor lightGrayColor]];
//        [_playerProgressView setBackgroundColor:[UIColor lightGrayColor]];
//        [_songDuration setBackgroundColor:[UIColor lightGrayColor]];
        
        [_songTitle release];
        [_songArtist release];
        [_songAlbum release];
        [_cover release];
        [_coverOverlay release];
        [_durationPlayed release];
        [_playerProgressView release];
        [_songDuration release];
    }
    
    return self;
}


- (void)setViewForOrientation:(UIInterfaceOrientation)orientation withStatusBarFrame:(CGRect)statusBarFrame
{
    #pragma mark Define Variables
    #define PADDING_X 10              // Marge en largeur
    #define PADDING_Y 10              // Marge en hauteur
    NSUInteger STATUSBAR = 0;       // Décalage en hauteur lié à la hauteur de la statusBar (pour iOS7 et +)
    NSUInteger STATUSBAR_EXTRA = 0; // Stocke le décalage lié à la statusBar si frame > 20
    NSUInteger NAVBAR = 0;          // Décalage lié à la barre de navigation
    NSUInteger TABBAR = 0;          // Hauteur de la TabBar sur iPhone
    NSUInteger ALL_TOP_MARGE = 0;   // Ensemble des éléments générant un décalage depuis le haut
    NSUInteger ALL_BOTTOM_MARGE = 0;// Ensemble des éléments générant un décalage depuis le bas
    
    CGFloat viewWidth, viewHeight, viewOriginY;
    
    // Définition MARGE_Y liée à l'origine en Y de la vue ne fonction du système
    if (isiOS7OrLater) { STATUSBAR = 20.0; } // iOS7 = 20 mini = contenu décalé en bas de la statusBar
    
    
    // Définition de la hauteur de la statusBar
    if (UIInterfaceOrientationIsPortrait(orientation)) // Portait
    {
        if (statusBarFrame.size.height > 20)
        {
            STATUSBAR_EXTRA = statusBarFrame.size.height-20;
        }
    }
    else if (UIInterfaceOrientationIsLandscape(orientation))
    {
        if (statusBarFrame.size.width > 20)
        {
            STATUSBAR_EXTRA = statusBarFrame.size.width-20;
        }
    }
    
    
    // Définition de la valeur du décalage lié à la barre de navigation en fonction du device et du système
    if (! isiPhone)
    {
        NAVBAR = 44.0; // iPad : toujours 44
    }
    else // iPhone
    {
        TABBAR = 49; // Sur iPhone UITabBar en plus
        
        if (UIInterfaceOrientationIsPortrait(orientation)) // Portait
        {
            NAVBAR = 44.0; // iOS6
        }
        else if (UIInterfaceOrientationIsLandscape(orientation)) // Paysage
        {
            NAVBAR = 32.0; // iOS6
        }
    }
    
    ALL_TOP_MARGE = STATUSBAR + STATUSBAR_EXTRA + NAVBAR;
    ALL_BOTTOM_MARGE = TABBAR;
    
    // Définition de la hauteur et la largeur de la vue en fonction de l'orientation du terminal
    if(UIInterfaceOrientationIsPortrait(orientation))
    {
        [self setFrame:CGRectMake(0, ALL_TOP_MARGE,
                                  [[UIScreen mainScreen] bounds].size.width,
                                  [[UIScreen mainScreen] bounds].size.height - (ALL_TOP_MARGE + ALL_BOTTOM_MARGE))];
    }
    else if (UIInterfaceOrientationIsLandscape(orientation))
    {
        [self setFrame:CGRectMake(0, ALL_TOP_MARGE,
                                  [[UIScreen mainScreen] bounds].size.height,
                                  [[UIScreen mainScreen] bounds].size.width - (ALL_TOP_MARGE + ALL_BOTTOM_MARGE))];
    }

    viewWidth   = [self frame].size.width;
    viewHeight  = [self frame].size.height;
    viewOriginY = [self frame].origin.y;
    
    #pragma mark Positionning Objects
    
    // iPhone et iPad en Portrait
    if(UIInterfaceOrientationIsPortrait(orientation))
    {
        [_shuffleView setFrame:CGRectMake(0, 0, 76, 30)];
        [_shuffleIcon setFrame:CGRectMake(0, 0, 31, 30)];
        [_shuffleSwitch setFrame:CGRectMake(36, 0, 30, 30)];
        
        [_songTitle  setFrame: CGRectMake(PADDING_X, viewOriginY+PADDING_Y,       viewWidth-(PADDING_X*2), 20)];
        [_songArtist setFrame: CGRectMake(PADDING_X, viewOriginY+PADDING_Y+20,    viewWidth-(PADDING_X*2), 20)];
        [_songAlbum  setFrame: CGRectMake(PADDING_X, viewOriginY+PADDING_Y+20+20, viewWidth-(PADDING_X*2), 20)];
        
        [_cover         setFrame: CGRectMake(0, viewOriginY+PADDING_Y+20+20+20+15, viewWidth, viewWidth)];
        [_coverOverlay  setFrame: CGRectMake(0, viewOriginY+PADDING_Y+20+20+20+15, viewWidth, viewWidth)];
        
        float endOfCover = [_cover frame].origin.y + [_cover frame].size.height;
        float gapBetweenEndOfCoverAndBottomOfView = (ALL_TOP_MARGE + viewHeight) - endOfCover;
        float middleBetweenCoverAndBottom = gapBetweenEndOfCoverAndBottomOfView/2;
        float topOfBottomScreenElements = [_cover frame].origin.y+viewWidth+middleBetweenCoverAndBottom;

        [_durationPlayed setFrame:      CGRectMake(PADDING_X, topOfBottomScreenElements-8, 30, 15)];
        [_playerProgressView setFrame:  CGRectMake(PADDING_X+30, topOfBottomScreenElements-2, viewWidth-(PADDING_X*2+60), 5)];
        [_songDuration setFrame:        CGRectMake(viewWidth-(PADDING_X+30), topOfBottomScreenElements-8, 30, 15)];
    }
    
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        if (isiPhone) // iPhone en paysage
        {
            [_shuffleView setFrame:CGRectMake(0, -2, 76, 30)];
            [_shuffleIcon setFrame:CGRectMake(0, -2, 31, 30)];
            [_shuffleSwitch setFrame:CGRectMake(36, -2, 30, 30)];
            
            [_songTitle  setFrame: CGRectMake(viewHeight+PADDING_X, viewOriginY+PADDING_Y,       viewWidth-(viewHeight+PADDING_X*2), 25)];
            [_songArtist setFrame: CGRectMake(viewHeight+PADDING_X, viewOriginY+PADDING_Y+25,    viewWidth-(viewHeight+PADDING_X*2), 25)];
            [_songAlbum  setFrame: CGRectMake(viewHeight+PADDING_X, viewOriginY+PADDING_Y+25+25, viewWidth-(viewHeight+PADDING_X*2), 25)];
            
            [_cover         setFrame: CGRectMake(0, viewOriginY, viewHeight, viewHeight)];
            [_coverOverlay  setFrame: CGRectMake(0, viewOriginY, viewHeight, viewHeight)];
            
            [_durationPlayed setFrame:      CGRectMake(viewHeight+PADDING_X, viewOriginY+viewHeight-(PADDING_Y+3+7.5), 30, 15)];
            [_playerProgressView setFrame:  CGRectMake(viewHeight+PADDING_X+30, viewOriginY+viewHeight-(PADDING_Y+5), viewWidth-(viewHeight+PADDING_X*2+60), 5)];
            [_songDuration setFrame:        CGRectMake(viewWidth-(PADDING_X+30), viewOriginY+viewHeight-(PADDING_Y+3+7.5), 30, 15)];
        }
        else // iPad en paysage
        {
            // Déduction des 320 de la vue de gauche
            [self setFrame:CGRectMake(320, ALL_TOP_MARGE,
                                     [[UIScreen mainScreen] bounds].size.height-320,
                                     [[UIScreen mainScreen] bounds].size.width - (ALL_TOP_MARGE + ALL_BOTTOM_MARGE))];
           
            viewWidth   = [self frame].size.width;
            viewHeight  = [self frame].size.height;
            viewOriginY = [self frame].origin.y;
            
            [_shuffleView setFrame:CGRectMake(0, 0, 76, 30)];
            [_shuffleIcon setFrame:CGRectMake(0, 0, 31, 30)];
            [_shuffleSwitch setFrame:CGRectMake(36, 0, 30, 30)];
            
            [_songTitle  setFrame: CGRectMake(PADDING_X, viewOriginY+PADDING_Y,       viewWidth-(PADDING_X*2), 25)];
            [_songArtist setFrame: CGRectMake(PADDING_X, viewOriginY+PADDING_Y+25,    viewWidth-(PADDING_X*2), 25)];
            [_songAlbum  setFrame: CGRectMake(PADDING_X, viewOriginY+PADDING_Y+25+25, viewWidth-(PADDING_X*2), 25)];
            
            [_cover         setFrame: CGRectMake((viewWidth-550)/2, viewOriginY+PADDING_Y+25+25+25+10, 550, 550)];
            [_coverOverlay  setFrame: CGRectMake((viewWidth-550)/2, viewOriginY+PADDING_Y+25+25+25+10, 550, 550)];
            
            float endOfCover = [_cover frame].origin.y + [_cover frame].size.height;
            float gapBetweenEndOfCoverAndBottomOfView = (ALL_TOP_MARGE + viewHeight) - endOfCover;
            float middleBetweenCoverAndBottom = gapBetweenEndOfCoverAndBottomOfView/2;
            float topOfBottomScreenElements = [_cover frame].origin.y+550+middleBetweenCoverAndBottom;

            [_durationPlayed setFrame:      CGRectMake(PADDING_X, topOfBottomScreenElements-8, 30, 15)];
            [_playerProgressView setFrame:  CGRectMake(PADDING_X+30, topOfBottomScreenElements-2, viewWidth-(PADDING_X*2+60), 5)];
            [_songDuration setFrame:        CGRectMake(viewWidth-(PADDING_X+30), topOfBottomScreenElements-8, 30, 15)];
        }
    }
}

@end
