//
//  AppDelegate.h
//  TaperJouer
//
//  Created by Thibault Le Cornec on 30/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJPlayerView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    //  Référence la vue player pour appel lors du changement de la statusBarFrame
    TJPlayerView *playerView;
}

@property (strong, nonatomic) UIWindow *window;

@end
