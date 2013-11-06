//
//  MakeAudioVC.h
//  GitomNetLjw
//
//  Created by jiawei on 13-7-3.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "VcWithNavBar.h"
//#import <AVFoundation/AVFoundation.h>
//#import <CoreAudio/CoreAudioTypes.h> 
#import "RecordAudio.h"

@interface MakeAudioVC : VcWithNavBar<RecordAudioDelegate>{
    RecordAudio *recordAudio;
    NSData *curAudio;

}

@end
