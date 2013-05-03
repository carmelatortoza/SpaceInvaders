//
//  TwitterUnityManager.m
//  Unity-iPhone
//
//  Created by Ranier Montalbo on 1/22/13.
//
//

#import <Accounts/Accounts.h>
#import "TwitterUnityManager.h"
#import <Twitter/Twitter.h>

@implementation TwitterUnityManager

+(TwitterUnityManager*)sharedManager {
    static TwitterUnityManager * sharedInstance;
    if(sharedInstance == NULL)
        sharedInstance = [[TwitterUnityManager alloc] init];
    return sharedInstance;
}

-(void) tweetComposeWithViewController:(UIViewController *) viewController text:(NSString *) text image:(UIImage *) image url:(NSURL *) url completion:(void (^)(TwitterStatus))completion {
    NSLog(@"%s", __func__);
    if([TWTweetComposeViewController canSendTweet]) {
    TWTweetComposeViewController *tweet = [[[TWTweetComposeViewController alloc] init] autorelease];
        [tweet setInitialText:text];
        [tweet addImage:image];
        [tweet addURL:url];
        [tweet setCompletionHandler:^(TWTweetComposeViewControllerResult result){
            switch (result) {
                case SLComposeViewControllerResultDone:
                        completion(TweetSuccess);
                    break;
                case SLComposeViewControllerResultCancelled:
                        completion(TweetCancelled);
                    break;
                default:
                    break;
            }
            [tweet dismissViewControllerAnimated:YES completion:^{
                [viewController.view removeFromSuperview];
            }];
            
        }];
        [viewController presentViewController:tweet animated:YES completion:nil];
    } else {
         completion(TweetNoAccount);
    }
}

-(void)getRequest:(NSString *)url params:(NSDictionary *)params {
    NSLog(@"%s", __func__);
    [self createRequest:url params:params method:TWRequestMethodGET];
}

-(void)postRequest:(NSString *)url params:(NSDictionary *)params {
    NSLog(@"%s", __func__);
    [self createRequest:url params:params method:TWRequestMethodPOST];
}

-(void)deleteRequest:(NSString *)url params:(NSDictionary *)params {
    NSLog(@"%s", __func__);
    [self createRequest:url params:params method:TWRequestMethodDELETE];
}

-(void)createRequest:(NSString*)path params:(NSDictionary*)params method:(TWRequestMethod)method {
    //  First, we need to obtain the account instance for the user's Twitter account
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType =
    [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //  Request permission from the user to access the available Twitter accounts
    [store requestAccessToAccountsWithType:twitterAccountType
                     withCompletionHandler:
     ^(BOOL granted, NSError *error) {
         if (!granted) {
             // The user rejected your request
             NSLog(@"User rejected access to the account.");
             const char * errorMessageC = [[error localizedDescription] cStringUsingEncoding:NSUTF8StringEncoding];
             UnitySendMessage(UNITY_TWTRLISTENER_GAMEOBJECT_NAME, UNITY_TWTRLISTENER_ONREQUESTERROR, errorMessageC);
         }
         else {
             // Grab the available accounts
             NSArray *twitterAccounts =
             [store accountsWithAccountType:twitterAccountType];
             
             if ([twitterAccounts count] > 0) {
                 // Use the first account for simplicity
                 ACAccount *account = [twitterAccounts objectAtIndex:0];
                 
                 // Build the request with our parameter
                 TWRequest *request =
                 [[TWRequest alloc] initWithURL:[NSURL URLWithString:path]
                                     parameters:params
                                  requestMethod:TWRequestMethodGET];
                 
                 // Attach the account object to this request
                 [request setAccount:account];
                 
                 [request performRequestWithHandler:
                  ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                      if (!responseData) {
                          // inspect the contents of error
                          const char * errorMessageC = [[error localizedDescription] cStringUsingEncoding:NSUTF8StringEncoding];
                          UnitySendMessage(UNITY_TWTRLISTENER_GAMEOBJECT_NAME, UNITY_TWTRLISTENER_ONREQUESTERROR, errorMessageC);
                      } 
                      else {
                          NSError *jsonError;
                          NSArray *timeline = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
                          if (timeline) {                          
                              // at this point, we have an object that we can parse
                              NSLog(@"%@", timeline);
                              NSString * resultMessage = [[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
                              const char * resultMessageC = [resultMessage cStringUsingEncoding:NSUTF8StringEncoding];
                              UnitySendMessage(UNITY_TWTRLISTENER_GAMEOBJECT_NAME, UNITY_TWTRLISTENER_ONREQUESTRESULT, resultMessageC);
                          } 
                          else { 
                              // inspect the contents of jsonError
                              const char * errorMessageC = [[jsonError localizedDescription] cStringUsingEncoding:NSUTF8StringEncoding];
                              UnitySendMessage(UNITY_TWTRLISTENER_GAMEOBJECT_NAME, UNITY_TWTRLISTENER_ONREQUESTERROR, errorMessageC);
                          }
                      }
                  }];
                 
             } // if ([twitterAccounts count] > 0)
         } // if (granted)
     }];
}

@end
