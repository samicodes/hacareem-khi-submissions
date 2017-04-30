//
//  CHDefaultAndConstant.h
//  WhisperO
//
//  Created by Oun Abbas on 17/06/2015.
//  Copyright (c) 2015 CodingHazard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum {
    CHAudioStatusDeownloadRequired,
    CHAudioStatusDownloading,
    CHAudioStatusDownloded,
    CHAudioStatusPlaying,
    CHAudioStatusPause,
    CHAudioStatusStop,
    CHAudioStatusNun
} CHAudioStatus;

#define ACTION_START    M13ProgressViewActionFailure
#define ACTION_STOP     M13ProgressViewActionSuccess

//    _______ _____      ___          ____
//   / ___/ // / _ \___ / _/__ ___ __/ / /_
//  / /__/ _  / // / -_) _/ _ `/ // / / __/
//  \___/_//_/____/\__/_/ \_,_/\_,_/_/\__/
//
@interface CHDefault : NSObject


@property(assign, nonatomic, getter=usingCompressedAudio) bool compressedAudio;
@property(assign, nonatomic) long long maxAudioLength;
@property(assign, nonatomic) long long maxWhisperAudioLength;
@property(assign, nonatomic) long long maxWhisperAudioCommentLength;
@property(assign, nonatomic) long long maxWhisperPushToTalkAudioLength;
@property(assign, nonatomic) long long maxWhisperVideoLength;
@property(assign, nonatomic) long long maxAudioIntroLength;
@property(assign, nonatomic) long long maxAudioMessageLength;
//@property(readonly, nonatomic, getter=usingCompressedAudio) bool compressedAudio;

+(instancetype) sharedInstance;

- (NSString*)documentsDirectory;
- (NSString*)myIntroAudioPath;
- (NSString*)myWhisperImagePath;
- (NSString *)newWhisperFileName;
- (NSString *)newCommentFileName;
- (NSString*)myMessagesAudioPath;
- (NSString*)myFilteredMessageAudioPath;

@end


//    __  ___________     __
//   / / / /  _/ ___/__  / /__  ____
//  / /_/ // // /__/ _ \/ / _ \/ __/
//  \____/___/\___/\___/_/\___/_/
//
@interface UIColor (whisper)

+ (UIColor *)whisperRed;      // 217,31,38 red
+ (UIColor *)whisperLightGray;      // 227,225,222 lightGray
+ (UIColor *)whisperDarkGray; //60,60,60
+ (UIColor *)whisperTabBarColor;
+ (UIColor *)whisperWhite;
+ (UIColor *)whisperBlue;
@end

// FB and Twitter Login stuff below
@protocol CommsDelegate <NSObject>
@optional
- (void) commsDidLogin:(BOOL)loggedIn;
@end

@interface Comms : NSObject
+ (void) login:(id<CommsDelegate>)delegate;
+ (void) loginTwitter:(id<CommsDelegate>)delegate;
@end

