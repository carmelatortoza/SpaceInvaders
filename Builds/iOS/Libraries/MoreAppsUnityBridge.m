//
//  MoreAppsUnityBridge.m
//  Unity-iPhone
//
//  Created by Mikhail Lomibao Basbas on 3/15/13.
//
//

#import "MoreAppsUnityManager.h"


void _maOpenLink () {
    NSString *link = [[NSUserDefaults standardUserDefaults] objectForKey:@"ma_link"];
    [[MoreAppsUnityManager sharedManager] openLinkWithString:link];
}