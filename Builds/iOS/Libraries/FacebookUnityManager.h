//
//  FacebookUnityManager.h
//  Unity-iPhone
//
//  Created by Ranier Montalbo on 1/8/13.
//
//

#import <Foundation/Foundation.h>
#import "FacebookSDK.h"

#define UNITY_FBLISTENER_GAMEOBJECT_NAME        "FacebookListener"
#define UNITY_FBLISTENER_ONREQUEST_STARTED      "OnFBRequestStarted"
#define UNITY_FBLISTENER_ONSESSIONSTATECHANGED  "OnFbSessionStateChanged"
#define UNITY_FBLISTENER_ONPOSTTOWALL           "OnFbPostToWallResponded"
#define UNITY_FBLISTENER_ONGRAPHRESPONSE        "OnFbGraphRequestResponded"

@interface FacebookUnityManager : NSObject

@property (nonatomic, retain) FBSession * session;
@property (nonatomic, retain) FBRequestConnection *requestConnection;
@property (nonatomic, retain) UIViewController * overlayViewController;

+(FacebookUnityManager*)sharedManager;

-(void) initializeRequestConnection;

-(void) startShareRequestWithPhoto:(UIImage *) image parameters:(NSMutableDictionary *) params completionBlock:(void (^)(bool)) completion;

-(void) requestWithGraphPath:(NSString*)path parameters:(NSDictionary*)params HTTPMethod:(NSString*)method completionBlock:(void (^)(BOOL)) completion;


-(void)openSession:(NSString*)fbAppId;

-(void)openSession:(NSString*)fbAppId addCompletionStatements: (void (^)(BOOL)) cBlock;

-(void)closeSession;

-(BOOL)hasOpenSession;

-(void)postUserFeed:(NSDictionary*)params;

-(void)postStatusUpdate:(NSString *) message;

-(void) uploadPhotoWithImage:(UIImage *) image;

-(void) uploadPhotoWithImage:(UIImage *) image addCompletionStatements: (void (^)(NSString*)) cBlock;

-(void)requestGraphPath:(NSString*)path;

-(void)requestGraphPath:(NSString*)path parameters:(NSDictionary*)params HTTPMethod:(NSString*)method completion: (void (^)(BOOL)) cBlock;

@end
