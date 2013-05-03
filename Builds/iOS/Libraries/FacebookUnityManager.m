//
//  FacebookUnityManager.m
//  Unity-iPhone
//
//  Created by Ranier Montalbo on 1/8/13.
//
//

#import "FacebookUnityManager.h"


NSTimeInterval timeBeforeCancelling = 10.0;

@implementation FacebookUnityManager
@synthesize session;
@synthesize overlayViewController;
@synthesize requestConnection;

+(FacebookUnityManager*)sharedManager {
    static FacebookUnityManager * sharedInstance;
    if(sharedInstance == NULL)
        sharedInstance = [[FacebookUnityManager alloc] init];
    return sharedInstance;
}

#pragma mark Public Member Methods

-(void) initializeRequestConnection {
    if(self.requestConnection != nil) {
        [self.requestConnection release];
        self.requestConnection = nil;
    }
    self.requestConnection = [[FBRequestConnection alloc] initWithTimeout:timeBeforeCancelling];
}

-(void) startShareRequestWithPhoto:(UIImage *) image parameters:(NSMutableDictionary *) params completionBlock:(void (^)(bool)) completion  {
    NSLog(@"%s", __func__);
    /*NSString *statusMessage = @"Request Started";
    const char *statusMessageC = [statusMessage cStringUsingEncoding:NSUTF8StringEncoding];
    UnitySendMessage(UNITY_FBLISTENER_GAMEOBJECT_NAME, UNITY_FBLISTENER_ONREQUEST_STARTED, statusMessageC);*/
    [self initializeRequestConnection];
    [self requestForUploadPhoto: image completionBlock:^(NSString *photoID){
        if(photoID != nil) {
            [self initializeRequestConnection];
            [self requestPhotoInformationWithID:photoID completionBlock:^(NSString *imageLink){
                if(imageLink != nil) {
                    [self initializeRequestConnection];
                    if([params objectForKey:@"picture"] != nil) [params removeObjectForKey:@"picture"];
                    [params setObject:imageLink forKey:@"picture"];
                    [self requestWithGraphPath:@"me/feed" parameters:params HTTPMethod:@"POST" completionBlock:^(BOOL isSuccess){
                        completion(isSuccess);
                        [self.requestConnection release];
                        self.requestConnection = nil;
                    }];
                } else {
                    completion(NO);
                    [self.requestConnection release];
                    self.requestConnection = nil;
                }
            }];
        } else {
            completion(NO);
            [self.requestConnection release];
            self.requestConnection = nil;
        }
    }];
}

-(void) requestForUploadPhoto:(UIImage *) image completionBlock:(void (^)(NSString*)) completion {
    NSLog(@"%s", __func__);
    if(self.requestConnection != nil) {
        [self.requestConnection addRequest:[FBRequest requestForUploadPhoto:image] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            NSLog(@"Result: %@ Error: %@", result, [error localizedDescription]);
            if(!error){
                completion([result objectForKey:@"id"]);
                NSError * jsonReadError;
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:&jsonReadError];
                NSString * jsonString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
                NSLog(@"%@", jsonString);
            } else {
                completion(nil);
                /*NSString * statusMessage = [NSString stringWithFormat:@"%@|%@", result, [error localizedDescription]];
                const char * statusMessageC = [statusMessage cStringUsingEncoding:NSUTF8StringEncoding];
                UnitySendMessage(UNITY_FBLISTENER_GAMEOBJECT_NAME, UNITY_FBLISTENER_ONGRAPHRESPONSE, statusMessageC);*/
            }
        }];
        [self.requestConnection start];
    }
}

-(void) requestPhotoInformationWithID:(NSString *) path completionBlock:(void (^)(NSString*)) completionBlock {
    NSLog(@"%s", __func__);
    if(self.requestConnection !=nil) {
        [self.requestConnection addRequest:[FBRequest requestForGraphPath:path] completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
            NSLog(@"Result: %@ Error: %@", result, [error localizedDescription]);
            if(!error) {
                //Get the pictureLink
                completionBlock([result objectForKey:@"picture"]);
                NSError * jsonReadError;
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:&jsonReadError];
                NSString * jsonString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
                NSLog(@"%@", jsonString);
            } else {
                completionBlock(nil);
                /*NSString * statusMessage = [NSString stringWithFormat:@"%@|%@", result, [error localizedDescription]];
                const char * statusMessageC = [statusMessage cStringUsingEncoding:NSUTF8StringEncoding];
                UnitySendMessage(UNITY_FBLISTENER_GAMEOBJECT_NAME, UNITY_FBLISTENER_ONGRAPHRESPONSE, statusMessageC);*/
            }
        }];
        [self.requestConnection start];
    }
}

-(void) requestWithGraphPath:(NSString*)path parameters:(NSDictionary*)params HTTPMethod:(NSString*)method completionBlock:(void (^)(BOOL)) completion {
    NSLog(@"%s", __func__);
    if(self.requestConnection != nil) {
        [self.requestConnection addRequest:[FBRequest requestWithGraphPath:path parameters:params HTTPMethod:method] completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
            NSLog(@"[FacebookManager requestGraphPath] Result: %@ Error: %@", result, [error localizedDescription]);
            if(!error){
                completion(YES);
                /*NSError * jsonReadError;
                NSData * jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:&jsonReadError];
                NSString * jsonString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
                NSString * statusMessage = [NSString stringWithFormat:@"%@|%@", jsonString, [error localizedDescription]];
                const char * statusMessageC = [statusMessage cStringUsingEncoding:NSUTF8StringEncoding];
                UnitySendMessage(UNITY_FBLISTENER_GAMEOBJECT_NAME, UNITY_FBLISTENER_ONGRAPHRESPONSE, statusMessageC);*/
            } else {
                completion(NO);
                /*NSString * statusMessage = [NSString stringWithFormat:@"%@|%@", result, [error localizedDescription]];
                const char * statusMessageC = [statusMessage cStringUsingEncoding:NSUTF8StringEncoding];
                UnitySendMessage(UNITY_FBLISTENER_GAMEOBJECT_NAME, UNITY_FBLISTENER_ONGRAPHRESPONSE, statusMessageC);*/
            }
        }];
        [self.requestConnection start];
    }
}

-(void)openSession:(NSString*)fbAppId addCompletionStatements: (void (^)(BOOL)) cBlock {
    NSLog(@"%s", __func__);
    if(session == NULL || session.state != FBSessionStateCreated) {
        [FBSession setDefaultAppID:fbAppId];
        [session release];
        session = [[FBSession alloc] init];
    }
    
        [session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        NSLog(@"Facebook Session State: %d Error: %@", status, [error localizedDescription]);
        [FBSession setActiveSession:self.session];
        if(!error) {
            cBlock(YES);
        } else {
            cBlock(NO);
        }
        /*NSString * statusMessage = [NSString stringWithFormat:@"%d|%@", status, [error localizedDescription]];
        const char * statusMessageC = [statusMessage cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
        UnitySendMessage(UNITY_FBLISTENER_GAMEOBJECT_NAME, UNITY_FBLISTENER_ONSESSIONSTATECHANGED, statusMessageC);*/
    }];
}
-(void)openSession:(NSString*)fbAppId {
    [self openSession:fbAppId addCompletionStatements:nil];
}

-(void)closeSession {
    NSLog(@"%s", __func__);
    [session closeAndClearTokenInformation];
    
}

-(BOOL)hasOpenSession {
    NSLog(@"%s", __func__);
    return session.isOpen;
}

-(void)postUserFeed:(NSDictionary*)params {
    NSLog(@"%s", __func__);
    [self performPublishAction:^{
        
        [FBRequestConnection startWithGraphPath:@"me/feed"
                                     parameters:params
                                     HTTPMethod:@"POST"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  NSLog(@"[FacebookManager postUserFeed] Result: %@ Error: %@", result, [error localizedDescription]);
                                  NSString * statusMessage = [NSString stringWithFormat:@"%@|%@", result, [error localizedDescription]];
                                  const char * statusMessageC = [statusMessage cStringUsingEncoding:NSUTF8StringEncoding];
                                  UnitySendMessage(UNITY_FBLISTENER_GAMEOBJECT_NAME, UNITY_FBLISTENER_ONPOSTTOWALL, statusMessageC);
                              }];
    }];
}

-(void)postStatusUpdate:(NSString *) message {
    NSLog(@"%s", __func__);
    [self createOverlayViewController];
    // if it is available to us, we will post using the native dialog
    
    BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom: self.overlayViewController
                                                                    initialText:message
                                                                          image:nil
                                                                            url:nil
                                                                        handler:
                                  ^(FBNativeDialogResult result, NSError *error){
                                      NSLog(@"[FacebookManager postStatusUpdate] Result: %d Error: %@", result, [error localizedDescription]);
                                      NSString * statusMessage = [NSString stringWithFormat:@"%d|%@", result, [error localizedDescription]];
                                      const char * statusMessageC = [statusMessage cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
                                      UnitySendMessage(UNITY_FBLISTENER_GAMEOBJECT_NAME, UNITY_FBLISTENER_ONPOSTTOWALL, statusMessageC);
                                      [self destroyOverlayViewController];
                                  }];
    
    if (!displayedNativeDialog) {
        
        [self performPublishAction:^{
            // otherwise fall back on a request for permissions and a direct post
            [FBRequestConnection startForPostStatusUpdate:message
                                        completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                            NSLog(@"[FacebookManager postStatusUpdate] Result: %@ Error: %@", result, [error localizedDescription]);
                                            NSString * statusMessage = [NSString stringWithFormat:@"%@|%@", result, [error localizedDescription]];
                                            const char * statusMessageC = [statusMessage cStringUsingEncoding:NSStringEncodingConversionAllowLossy];
                                            UnitySendMessage(UNITY_FBLISTENER_GAMEOBJECT_NAME, UNITY_FBLISTENER_ONPOSTTOWALL, statusMessageC);
                                            [self destroyOverlayViewController];
                                        }];
        }];
    }
}

-(void)requestGraphPath:(NSString*)path {
    NSLog(@"%s", __func__);
    [self performPublishAction:^{
        [FBRequestConnection startWithGraphPath:path
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
                                  NSLog(@"[FacebookManager requestGraphPath] Result: %@ Error: %@", result, [error localizedDescription]);
                                  if(result != nil) {
                                      NSError * jsonReadError;
                                      NSData * jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:&jsonReadError];
                                      NSString * jsonString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
                                      NSString * statusMessage = [NSString stringWithFormat:@"%@|%@", jsonString, [error localizedDescription]];
                                      const char * statusMessageC = [statusMessage cStringUsingEncoding:NSUTF8StringEncoding];
                                      UnitySendMessage(UNITY_FBLISTENER_GAMEOBJECT_NAME, UNITY_FBLISTENER_ONGRAPHRESPONSE, statusMessageC);
                                  }
                              }];
    }];
}

-(void)requestGraphPath:(NSString*)path parameters:(NSDictionary*)params HTTPMethod:(NSString*)method completion:(void (^)(BOOL))cBlock {
    NSLog(@"%s", __func__);
    [FBRequestConnection startWithGraphPath:path
                                 parameters:params
                                 HTTPMethod:method
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
                              NSLog(@"[FacebookManager requestGraphPath] Result: %@ Error: %@", result, [error localizedDescription]);
                              if(!error){ cBlock(YES);}
                              else {cBlock(NO);}
                              NSError * jsonReadError;
                              NSData * jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:&jsonReadError];
                              NSString * jsonString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
                              NSString * statusMessage = [NSString stringWithFormat:@"%@|%@", jsonString, [error localizedDescription]];
                              const char * statusMessageC = [statusMessage cStringUsingEncoding:NSUTF8StringEncoding];
                              UnitySendMessage(UNITY_FBLISTENER_GAMEOBJECT_NAME, UNITY_FBLISTENER_ONGRAPHRESPONSE, statusMessageC);
                          }];
}

#pragma mark - Uploading photo and getting its info.

-(void) uploadPhotoWithImage:(UIImage *) image addCompletionStatements:(void (^)(NSString*)) cBlock {
    NSLog(@"%s", __func__);
    if (!image) return;
    NSString *statusMessage = @"Request Started";
    const char *statusMessageC = [statusMessage cStringUsingEncoding:NSUTF8StringEncoding];
    UnitySendMessage(UNITY_FBLISTENER_GAMEOBJECT_NAME, UNITY_FBLISTENER_ONREQUEST_STARTED, statusMessageC);
        [FBRequestConnection startForUploadPhoto:image
                               completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                   NSLog(@"[FacebookManager uploadPhotoWithImage] Result: %@ Error: %@", result, [error localizedDescription]);
                                   if(!error){
                                       [self getPhotoInfoFromGraphPathWithID:[result objectForKey:@"id"] addCompletionBlock:cBlock];
                                   } else {
                                       cBlock(nil);
                                       NSError * jsonReadError;
                                       NSData * jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:&jsonReadError];
                                       NSString * jsonString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
                                       NSString * statusMessage = [NSString stringWithFormat:@"%@|%@", jsonString, [error localizedDescription]];
                                       const char * statusMessageC = [statusMessage cStringUsingEncoding:NSUTF8StringEncoding];
                                       UnitySendMessage(UNITY_FBLISTENER_GAMEOBJECT_NAME, UNITY_FBLISTENER_ONGRAPHRESPONSE, statusMessageC);
                                   }
        }];
}

-(void) uploadPhotoWithImage:(UIImage *) image {
    [self uploadPhotoWithImage:image addCompletionStatements:nil];
}

-(void) getPhotoInfoFromGraphPathWithID:(NSString *) path addCompletionBlock:(void (^)(NSString*)) cBlock {
    NSLog(@"%s", __func__);
    [FBRequestConnection startWithGraphPath:path completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
        NSLog(@"[FacebookManager uploadPhoto] Result: %@ Error: %@", result, [error localizedDescription]);
        if(!error) {
            //Get the pictureLink
            cBlock([result objectForKey:@"picture"]);
        } else {
            NSError * jsonReadError;
            NSData * jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:&jsonReadError];
            NSString * jsonString = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
            NSString * statusMessage = [NSString stringWithFormat:@"%@|%@", jsonString, [error localizedDescription]];
            const char * statusMessageC = [statusMessage cStringUsingEncoding:NSUTF8StringEncoding];
            UnitySendMessage(UNITY_FBLISTENER_GAMEOBJECT_NAME, UNITY_FBLISTENER_ONGRAPHRESPONSE, statusMessageC);
        }
    }];
}

#pragma mark Private Methods


// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action {
    // we defer request for permission to post to the moment of post, then we check for the permission
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // if we don't already have the permission, then we request it now
        [FBSession.activeSession reauthorizeWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"/*, @"publish_stream"*/]
                                                   defaultAudience:FBSessionDefaultAudienceFriends
                                                 completionHandler:^(FBSession *session, NSError *error) {
                                                     if (!error) {
                                                         action();
                                                     }
                                                     //For this example, ignore errors (such as if user cancels).
                                                 }];
    } else {
        action();
    }
}



-(void)createOverlayViewController {
    CGSize windowSize = [UIScreen mainScreen].bounds.size;
    self.overlayViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.overlayViewController.view];
    self.overlayViewController.view.frame = CGRectMake(0, 0, windowSize.width, windowSize.height);
}

-(void)destroyOverlayViewController {
    [self.overlayViewController.view removeFromSuperview];
    [self.overlayViewController release];
    self.overlayViewController = nil;
}

@end
