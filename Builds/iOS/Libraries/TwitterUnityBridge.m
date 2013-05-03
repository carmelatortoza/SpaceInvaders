//
//  TwitterUnityBridge.m
//  Unity-iPhone
//
//  Created by Ranier Montalbo on 1/22/13.
//
//

#import "TwitterUnityManager.h"

void _twitterPostRequest() {
    NSError * jsonReadError;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * url = [defaults stringForKey:@"twitter_status_url"];
    NSString * paramString = [defaults stringForKey:@"twitter_status_parameters"];
    NSDictionary * params = [NSJSONSerialization JSONObjectWithData:[paramString dataUsingEncoding:NSUTF8StringEncoding]
                                                            options:NSJSONReadingMutableContainers
                                                              error:&jsonReadError];
    NSLog(@"_twitterPostRequest: %@", paramString);
    
    if(jsonReadError != NULL) {
        NSLog(@"[%s] %@", __func__, jsonReadError);
    }else{
        [[TwitterUnityManager sharedManager] postRequest:url params:params];
    }
}

void _twitterGetRequest() {
    NSError * jsonReadError;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * url = [defaults stringForKey:@"twitter_status_url"];
    NSString * paramString = [defaults stringForKey:@"twitter_status_parameters"];
    NSDictionary * params = [NSJSONSerialization JSONObjectWithData:[paramString dataUsingEncoding:NSUTF8StringEncoding]
                                                            options:NSJSONReadingMutableContainers
                                                              error:&jsonReadError];
    if(jsonReadError != NULL) {
        NSLog(@"[%s] %@", __func__, jsonReadError);
    }else{
        [[TwitterUnityManager sharedManager] getRequest:url params:params];
    }
}

void _twitterDeleteRequest() {
    NSError * jsonReadError;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * url = [defaults stringForKey:@"twitter_status_url"];
    NSString * paramString = [defaults stringForKey:@"twitter_status_parameters"];
    NSDictionary * params = [NSJSONSerialization JSONObjectWithData:[paramString dataUsingEncoding:NSUTF8StringEncoding]
                                                            options:NSJSONReadingMutableContainers
                                                              error:&jsonReadError];
    if(jsonReadError != NULL) {
        NSLog(@"[%s] %@", __func__, jsonReadError);
    }else{
        [[TwitterUnityManager sharedManager] deleteRequest:url params:params];
    }
}