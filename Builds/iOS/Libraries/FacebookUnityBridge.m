//
//  FacebookUnityBridge.m
//  Unity-iPhone
//
//  Created by Ranier Montalbo on 1/8/13.
//
//

#import "FacebookUnityManager.h"

void _fbOpenSession() {
    NSString *fbAppId = [[NSUserDefaults standardUserDefaults] stringForKey:@"fb_app_id"];
    [[FacebookUnityManager sharedManager] openSession:fbAppId];
}

void _fbCloseSession() {
    [[FacebookUnityManager sharedManager] closeSession];
}

bool _fbHasOpenSession() {
    return [[FacebookUnityManager sharedManager] hasOpenSession];
}

void _fbPostUserFeed() {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * message = [defaults stringForKey:@"fb_post_message"];
    NSString * name = [defaults stringForKey:@"fb_post_name"];
    NSString * caption = [defaults stringForKey:@"fb_post_caption"];
    NSString * description = [defaults stringForKey:@"fb_post_description"];
    NSString * link = [defaults stringForKey:@"fb_post_link"];
    NSString * picture = [defaults stringForKey:@"fb_post_picture"];
    
    NSString * actions = [defaults stringForKey:@"fb_post_actions"];
    NSMutableArray * actionLinks = [NSMutableArray array];
    if(actions != NULL) {
        NSArray * actionNameLinkPairs = [actions componentsSeparatedByString:@","];
        for (NSString * nameLinkPair in actionNameLinkPairs) {
            NSArray * nameLink = [nameLinkPair componentsSeparatedByString:@"|"];
            [actionLinks addObject:[NSDictionary dictionaryWithObjectsAndKeys:nameLink[0], @"name", nameLink[1], @"link", nil]];
        }
    }
    
    NSDictionary * postParams;
    if(actionLinks.count > 0) {
        postParams = [NSDictionary dictionaryWithObjectsAndKeys:
                      message, @"message",
                      name, @"name",
                      caption, @"caption",
                      description, @"description",
                      link, @"link",
                      picture, @"picture",
                      actionLinks, @"actions", nil];
    }else{
        postParams = [NSDictionary dictionaryWithObjectsAndKeys:
                      message, @"message",
                      name, @"name",
                      caption, @"caption",
                      description, @"description",
                      link, @"link",
                      picture, @"picture", nil];
    }
    [[FacebookUnityManager sharedManager] postUserFeed:postParams];
}

void _fbPostStatusUpdate() {
    NSString *fbMessage = [[NSUserDefaults standardUserDefaults] stringForKey:@"fb_status_message"];
    [[FacebookUnityManager sharedManager] postStatusUpdate:fbMessage];
}

void _fbRequestGraphPath() {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * path = [defaults stringForKey:@"fb_request_path"];
    NSString * method = [defaults stringForKey:@"fb_request_method"];
    NSString * params = [defaults stringForKey:@"fb_request_params"];
    
    if(method == NULL || params == NULL) {
        [[FacebookUnityManager sharedManager] requestGraphPath:path];
    }else{
        NSError * jsonReadError;
        NSDictionary * jsonData = [NSJSONSerialization JSONObjectWithData:[params dataUsingEncoding:NSUTF8StringEncoding]
                                                                  options:NSJSONReadingMutableContainers
                                                                    error:&jsonReadError];
        if(jsonReadError != NULL)
            NSLog(@"[%s] %@", __func__, [jsonReadError localizedDescription]);
        else
            [[FacebookUnityManager sharedManager] requestGraphPath:path parameters:jsonData HTTPMethod:method completion:nil];
    }
}