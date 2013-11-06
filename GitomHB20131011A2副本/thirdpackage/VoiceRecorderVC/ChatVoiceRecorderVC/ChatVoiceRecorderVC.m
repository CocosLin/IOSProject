//
//  ChatVoiceRecorderVC.m
//  Jeans
//
//  Created by Jeans on 3/23/13.
//  Copyright (c) 2013 Jeans. All rights reserved.
//

#import "ChatVoiceRecorderVC.h"

@interface ChatVoiceRecorderVC ()<AVAudioRecorderDelegate>{
    CGFloat                 curCount;           //当前计数,初始为0
    BOOL                    canNotSend;         //不能发送
    NSTimer                 *timer;
}

@property (retain, nonatomic)   AVAudioRecorder     *recorder;

@end

@implementation ChatVoiceRecorderVC
@synthesize recorder;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [recorder release];
    [super dealloc];
}

#pragma mark - 开始录音
- (void)beginRecordByFileName:(NSString*)_fileName;{
    
    //设置文件名和录音路径
    self.recordFileName = _fileName;
    self.recordFilePath = [VoiceRecorderBaseVC getPathByFileName:recordFileName ofType:@"wav"];
    
    //初始化录音
    self.recorder = [[[AVAudioRecorder alloc]initWithURL:[NSURL URLWithString:recordFilePath]
                                                settings:[VoiceRecorderBaseVC getAudioRecorderSettingDict]
                                                   error:nil]autorelease];
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    //开始录音
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [recorder record];

}



#pragma mark - 录音结束
- (void)endRecord{

    if (recorder.isRecording)
        [recorder stop];
}


@end
