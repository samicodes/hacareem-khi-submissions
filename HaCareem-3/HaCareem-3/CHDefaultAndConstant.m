//
//  CHDefaultAndConstant.m
//  WhisperO
//
//  Created by Oun Abbas on 17/06/2015.
//  Copyright (c) 2015 CodingHazard. All rights reserved.
//

#import "CHDefaultAndConstant.h"

#define KEY_DOCUMENTS_DIRECTORY @"DDK"
#define KEY_IS_USING_COMPRESSED_AUDIO @"UCAK"
#define KEY_MAX_AUDIO_LENGTH @"MALK"
#define KEY_MAX_WHISPER_AUDIO_LENGTH @"MWALK"

@interface CHDefault ()

@end


@implementation CHDefault

@synthesize
compressedAudio = _compressedAudio,
maxAudioLength = _maxAudioLength,
maxWhisperAudioLength = _maxWhisperAudioLength,
maxWhisperAudioCommentLength = _maxWhisperAudioCommentLength,
maxWhisperVideoLength = _maxWhisperVideoLength;

+ (instancetype)sharedInstance {
    static CHDefault *sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super alloc] init];
    });
    return sharedInstance;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _compressedAudio = [[NSUserDefaults standardUserDefaults] boolForKey:KEY_IS_USING_COMPRESSED_AUDIO];
        _maxAudioLength = [(NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:KEY_MAX_AUDIO_LENGTH] longLongValue];
        _maxWhisperAudioLength = [(NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:KEY_MAX_WHISPER_AUDIO_LENGTH] longLongValue];
        
        _maxAudioLength = _maxAudioLength < 60000 ? 600000 : _maxAudioLength;
        _maxWhisperAudioLength = _maxWhisperAudioLength < 1000 ? 60000 : _maxWhisperAudioLength;
        _maxWhisperAudioCommentLength = 10000;
        _maxWhisperPushToTalkAudioLength = 30000;
        _maxWhisperVideoLength = 15000;
        _maxAudioIntroLength = 10000;
        _maxAudioMessageLength = 30000;
    }
    return self;
}

- (void)dealloc
{
    [[NSUserDefaults standardUserDefaults ] setBool:_compressedAudio forKey:KEY_IS_USING_COMPRESSED_AUDIO];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLongLong:_maxAudioLength] forKey:KEY_MAX_AUDIO_LENGTH];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithLongLong:_maxWhisperAudioLength] forKey:KEY_MAX_WHISPER_AUDIO_LENGTH];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString*)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (NSString*)myIntroAudioPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/MyIntro/Audio"];
    // Get documents folder
    // documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"/MyWhispers/Audio"];
    if(![[NSFileManager  defaultManager] fileExistsAtPath:documentsDirectory]){
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"CHDefault|whisperDocumentsDirectory| ERROR [%@]",error.localizedDescription);
        }
    }
    return documentsDirectory;
}

- (NSString*)myMessagesAudioPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/Chats/Audio"];
    // Get documents folder
    // documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"/MyWhispers/Audio"];
    if(![[NSFileManager  defaultManager] fileExistsAtPath:documentsDirectory]){
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"CHDefault|whisperDocumentsDirectory| ERROR [%@]",error.localizedDescription);
        }
    }
    return documentsDirectory;
}

- (NSString*)myFilteredMessageAudioPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/Chats/AudioFilter"];
    // Get documents folder
    // documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"/MyWhispers/Audio"];
    if(![[NSFileManager  defaultManager] fileExistsAtPath:documentsDirectory]){
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"CHDefault|whisperDocumentsDirectory| ERROR [%@]",error.localizedDescription);
        }
    }
    return documentsDirectory;
}

- (NSString*)myWhisperImagePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/MyWhispers/Image"];
    // Get documents folder
    if(![[NSFileManager  defaultManager] fileExistsAtPath:documentsDirectory]){
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"CHDefault|whisperDocumentsDirectory| ERROR [%@]",error.localizedDescription);
        }
    }
    return documentsDirectory;
}

- (NSString *)newWhisperFileName
{
    NSString *file;
    NSString *uuid;
    do{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *audioDirectory =  [documentsDirectory stringByAppendingPathComponent:@"/MyWhispers/Audio"];
        uuid = [[NSUUID UUID] UUIDString];
        file = [audioDirectory stringByAppendingPathComponent:uuid];
    }while([[NSFileManager defaultManager] fileExistsAtPath:file]);
    return uuid;
}

- (NSString *)newCommentFileName
{
    NSString *file;
    NSString *uuid;
    do{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *audioDirectory =  [documentsDirectory stringByAppendingPathComponent:@"/MyWhispers/Comments"];
        uuid = [[NSUUID UUID] UUIDString];
        file = [audioDirectory stringByAppendingPathComponent:uuid];
    }while([[NSFileManager defaultManager] fileExistsAtPath:file]);
    return uuid;
}


- (bool)usingCompressedAudio{
    return _compressedAudio;
}

@end


@implementation UIColor (whisper)

+ (UIColor *)whisperBlue
{
    return [UIColor colorWithRed:21/255.0 green:65/255.0 blue:148/255.0 alpha:1.0];//[UIColor colorWithRed:217/255.0 green:31/255.0 blue:38/255.0 alpha:1.0];
}

+ (UIColor *)whisperRed
{
    return [UIColor colorWithRed:216/255.0 green:31/255.0 blue:39/255.0 alpha:1.0];//[UIColor colorWithRed:217/255.0 green:31/255.0 blue:38/255.0 alpha:1.0];
}

+ (UIColor *)whisperLightGray
{
    return [UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1.0];
}

+ (UIColor *)whisperWhite
{
    return [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
}


+ (UIColor *)whisperDarkGray
{
    return [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:1.0];
}
+ (UIColor *)whisperTabBarColor
{
    return nil;
}
@end

@implementation Comms


//+ (void) login:(id<CommsDelegate>)delegate
//{
//    FBSessionDefaultAudience defaultAudience;
//    defaultAudience = FBSessionDefaultAudienceFriends;
//    
//    // Basic User information and your friends are part of the standard permissions
//    // so there is no reason to ask for additional permissions
//    
//    //Additional Permissions
//    NSArray *permissionsArray = [NSArray arrayWithObjects:@"user_about_me",@"user_birthday",@"user_location",@"user_hometown",
//                                 @"email", /*@"read_friendlists",@"publish_actions",*/ nil];
//    
//    
//    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
//        // Was login successful ?
//        if (!user) {
//            if (!error) {
//                NSLog(@"The user cancelled the Facebook login.");
//            } else {
//                NSLog(@"An error occurred: %@", error.localizedDescription);
//            }
//            
//            // Callback - login failed
//            if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
//                [delegate commsDidLogin:NO];
//            }
//        } else {
//            if (user.isNew)
//            {
//                NSLog(@"User signed up and logged in through Facebook!");
//                
//                [PFCloud callFunctionInBackground:@"addWhisperoAsFriend"
//                                   withParameters:nil
//                                            block:^(NSArray *result, NSError *error) {
//                                                
//                                                if (!error) {
//                                                 
//                                                    NSLog(@"%@",result);
//                                                
//                                                }
//                                                else NSLog(@"%@",error.localizedDescription);
//                }];
//            }
//            else
//            {
//                NSLog(@"User logged in through Facebook!");
//            }
//            
//            if (FBSession.activeSession.isOpen)
//            {
//                /*
//                [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
//                    if (error)
//                    {
//                        NSLog(@"error:%@",error);
//                        
//                    }
//                    else
//                    {
//                        // retrive user's details at here as shown below
//                        NSLog(@"FB user first name:%@",user.first_name);
//                        NSLog(@"FB user last name:%@",user.last_name);
//                        NSLog(@"FB user birthday:%@",user.birthday);
//                    }
//                }];
//                 */
//                
//                [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                    if (!error) {
//                        
//                        NSDictionary<FBGraphUser> *me = (NSDictionary<FBGraphUser> *)result;
//                        NSLog(@"Facebook User data fetched: %@",me);
//                        // Store the Facebook User Data
//                        NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] init];
//                        userProfile[@"name"] = me.name;
//                        userProfile[@"facebookId"] = me.objectID;
//                        userProfile[@"email"] = [me objectForKey:@"email"];
//                        userProfile[@"gender"] = [me objectForKey:@"gender"];
//                        userProfile[@"pictureURL"] = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1",me.objectID];
//                        [[PFUser currentUser]  setObject:userProfile forKey:@"profile"];
//                        [[PFUser currentUser]  setObject:me.name forKey:@"name"];
//                        [[PFUser currentUser]  setObject:[me objectForKey:@"email"] forKey:@"email"];
//                        [[PFUser currentUser]  setObject:me.objectID forKey:@"socialId"];
//                        
//                        [[PFUser currentUser] saveInBackground];
//                        
//                        // Callback - login successful
//                        if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
//                            [delegate commsDidLogin:YES];
//                        }
//                        
//                         
//                    }
//                    
//                    else
//                    {
//                        NSLog(@"%@",error.localizedDescription);
//                        
//                        // Callback - login failed
//                        if ([delegate respondsToSelector:@selector(commsDidLogin:)])
//                        {
//                            [delegate commsDidLogin:NO];
//                        }
//                    }
//                    
//                    
//                }];
//            }
//            
//            /*
//            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//                if (!error) {
//                    NSDictionary<FBGraphUser> *me = (NSDictionary<FBGraphUser> *)result;
//                    NSLog(@"Facebook User data fetched: %@",me);
//                    // Store the Facebook User Data
//                    NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] init];
//                    userProfile[@"name"] = me.name;
//                    userProfile[@"facebookId"] = me.objectID;
//                    userProfile[@"email"] = [me objectForKey:@"email"];
//                    userProfile[@"gender"] = [me objectForKey:@"gender"];
//                    userProfile[@"pictureURL"] = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1",me.objectID];
//                    [[PFUser currentUser]  setObject:userProfile forKey:@"profile"];
//                    [[PFUser currentUser]  setObject:[me objectForKey:@"email"] forKey:@"email"];
//                    
//                    [[PFUser currentUser] saveInBackground];
//                }
//                
//                // Callback - login successful
//                if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
//                    [delegate commsDidLogin:YES];
//                }
//            }];
//            */
//            
//            /*
//            [FBRequestConnection startForMyFriendsWithCompletionHandler:
//             ^(FBRequestConnection *connection, id<FBGraphUser> friends, NSError *error)
//             {
//                 if(!error){
//                     NSLog(@"results = %@", friends);
//                 }
//                 else NSLog(@"%@",error.localizedDescription);
//             }
//             ];
//             */
//        }
//    }];
//}
//
//+ (void) loginTwitter:(id<CommsDelegate>)delegate
//{
//    /*[PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
//        if (!user) {
//            if (!error) {
//                NSLog(@"The user cancelled the Twitter login.");
//            } else {
//                NSLog(@"An error occurred: %@", error.localizedDescription);
//            }
//            
//            // Callback - login failed
//            if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
//                [delegate commsDidLogin:NO];
//            }
//        } else {
//            if (user.isNew) {
//                NSLog(@"User signed up and logged in through Twitter!");
//            } else {
//                NSLog(@"User logged in through Twitter!");
//            }
//            
//            // TODO find a way to fetch details with Twitter..
//            
//           // NSString * requestString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/users/show.json?screen_name=%@", user.username];
//            
//            NSString *twitterScreenName = @"hyderishere"; //[PFTwitterUtils twitter].screenName;
//            NSString * requestString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/users/show.json?screen_name=%@", twitterScreenName];
//            
//            NSURL *verify = [NSURL URLWithString:requestString];
//            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:verify];
//            [[PFTwitterUtils twitter] signRequest:request];
//            NSURLResponse *response = nil;
//            NSData *data = [NSURLConnection sendSynchronousRequest:request
//                                                 returningResponse:&response
//                                                             error:&error];
//            
//            
//            if ( error == nil){
//                NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//                NSLog(@"%@",result);
//                
//        //Twitter doesnt store gender, DOB and email of user so we can't get it throught this API
//                
//                NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] init];
//                userProfile[@"name"] = [result objectForKey:@"name"];
//                userProfile[@"twitterId"] = [PFTwitterUtils twitter].userId;
//              //userProfile[@"email"] = [me objectForKey:@"email"];
//              //userProfile[@"gender"] = [me objectForKey:@"gender"];
//                userProfile[@"pictureURL"] = [result objectForKey:@"profile_image_url_https"];
//                [[PFUser currentUser]  setObject:userProfile forKey:@"profile"];
//                [[PFUser currentUser]  setObject:@"noemail@noemail.com" forKey:@"email"];
//                
//                [[PFUser currentUser] saveInBackground];
//            }
//            
//            
//            // Callback - login successful
//            if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
//                [delegate commsDidLogin:YES];
//            }
//        }
//    }];*/
//    
//    
//    
//    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
//        if (!user) {
//            NSLog(@"Uh oh. The user cancelled the Twitter login.\nError : %@",error.localizedDescription);
//
//            // Callback - login failed
//            if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
//                [delegate commsDidLogin:NO];
//            }
//            
//            return;
//        }
//        else {
//            if (user.isNew) {
//                NSLog(@"User signed up and logged in with Twitter!");
//                NSLog(@"%@",user);
//                
//                [PFCloud callFunctionInBackground:@"addWhisperoAsFriend"
//                                   withParameters:nil
//                                            block:^(NSArray *result, NSError *error) {
//                                                
//                                                if (!error) {
//                                                    
//                                                    NSLog(@"%@",result);
//                                                    
//                                                }
//                                                else NSLog(@"%@",error.localizedDescription);
//                                            }];
//                
//            }
//            else {
//                NSLog(@"User logged in with Twitter!");
//                NSLog(@"%@",user);
//            }
//            
//            /*
//            NSURL *verify = [NSURL URLWithString:@"https://api.twitter.com/1.1/account/verify_credentials.json"];
//            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:verify];
//            [[PFTwitterUtils twitter] signRequest:request];
//            NSURLResponse *response = nil;
//            NSError *error = nil;
//            NSData *data = [NSURLConnection sendSynchronousRequest:request
//                                                 returningResponse:&response
//                                                            error:&error];
//            */
//            
//            
//            // TODO find a way to fetch details with Twitter..
//            
//            // NSString * requestString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/users/show.json?screen_name=%@", user.username];
//            
//            NSString *twitterScreenName = [PFTwitterUtils twitter].screenName;
//            NSString * requestString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/users/show.json?screen_name=%@", twitterScreenName];
//            
//            NSURL *verify = [NSURL URLWithString:requestString];
//            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:verify];
//            
//            [[PFTwitterUtils twitter] signRequest:request];
//            
//            NSURLResponse *response = nil;
//            NSData *data = [NSURLConnection sendSynchronousRequest:request
//                                                 returningResponse:&response
//                                                             error:&error];
//            
//            
//            if ( error == nil){
//                NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//                NSLog(@"%@",result);
//                
//                //Twitter doesnt store gender, DOB and email of user so we can't get it throught this API
//                
//                NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] init];
//                userProfile[@"name"] = [result objectForKey:@"name"];
//                userProfile[@"twitterId"] = [PFTwitterUtils twitter].userId;
//                //userProfile[@"email"] = [me objectForKey:@"email"];
//                //userProfile[@"gender"] = [me objectForKey:@"gender"];
//                
//                //NSString *newString = [result objectForKey:@"profile_image_url_https"];
//                //NSString *newString1 = [[result objectForKey:@"profile_image_url_https"] stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"]
//                
//                userProfile[@"pictureURL"] = [[result objectForKey:@"profile_image_url_https"] stringByReplacingOccurrencesOfString:@"_normal" withString:@""];//[result objectForKey:@"profile_image_url_https"];
//                
//                [[PFUser currentUser]  setObject:userProfile forKey:@"profile"];
//                [[PFUser currentUser]  setObject:[result objectForKey:@"name"] forKey:@"name"];
//                [[PFUser currentUser]  setObject:[NSString stringWithFormat:@"%@@noemail.com",[result objectForKey:@"screen_name"]] forKey:@"email"];
//                
//                [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//                    if (succeeded) {
//                        NSLog(@"Twitter user updated");
//                    }
//                    else NSLog(@"%@",error.localizedDescription);
//                }];
//            }
//            
//            
//            // Callback - login successful
//            if ([delegate respondsToSelector:@selector(commsDidLogin:)]) {
//                [delegate commsDidLogin:YES];
//            }
//        }
//    }];
//}


@end

