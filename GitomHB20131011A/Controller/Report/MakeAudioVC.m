//
//  MakeAudioVC.m
//  GitomNetLjw
//
//  Created by jiawei on 13-7-3.
//  Copyright (c) 2013年 Gitom. All rights reserved.
//

#import "MakeAudioVC.h"
#import <AVFoundation/AVFoundation.h>
#include "lame.h"
#import "WCommonMacroDefine.h"

typedef NS_ENUM(NSInteger, Tag_MakeAudioVC) {
    TAG_BtnStartAudio = 101,
    TAG_BtnEndAudio = 102
};
static int num_mp3;
@interface MakeAudioVC ()
{
    CGFloat sampleRate;
    AVAudioQuality quality;
    NSInteger formatIndex;
    // 录音
    NSURL * recordFile;
        AVAudioRecorder*                recorder;
        NSTimer*                        secTimer;  // 控制时间
     NSTimer*                        timer;  // 控制图片
     int                             num;
    UILabel *_lblShowTime;
    UIImageView *_imgViewAudio;
}
@end

@implementation MakeAudioVC


#pragma mark - 生命周期
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"录音";
        self.view.backgroundColor = [UIColor blackColor];
        // 录音 初始化
        sampleRate = 44100.0;
        quality = AVAudioQualityLow;
         formatIndex = [self formatIndexToEnum:0];
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        
        if (session == nil)
        {
            NSLog(@"Error creating session: %@",[sessionError description]);
        }
        else
        {
            [session setActive:YES error:nil];
        }
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	//导航条设置
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 44);
    [btn setBackgroundImage:[UIImage imageNamed:@"btnBackFromNavigationBar_On"] forState:UIControlStateNormal];
    [btn  setBackgroundImage:[UIImage imageNamed:@"btnBackFromNavigationBar_Off"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [self.navigationItem setLeftBarButtonItem:backItem];
    [backItem release];
    
    [self initCustomView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma  mark - 视图生成
-(void)initCustomView
{
    _lblShowTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 320, 30)];
    _lblShowTime.text = @"00:00:00";
    _lblShowTime.textColor = [UIColor whiteColor];
    _lblShowTime.backgroundColor = [UIColor clearColor];
    _lblShowTime.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lblShowTime];
    [_lblShowTime release];
    
    _imgViewAudio = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 -35, 150, 70, 142)];
    [self.view addSubview:_imgViewAudio];
    _imgViewAudio.image = [UIImage imageNamed:@"speak0"];
    [_imgViewAudio release];
    
    UIButton * btnMakeAudio = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnMakeAudio setTag:TAG_BtnStartAudio];
    [btnMakeAudio setFrame:CGRectMake(20,Height_Screen - 100, 100, 40)];
    [btnMakeAudio setTitle:@"开始录音" forState:UIControlStateNormal];
    [btnMakeAudio setBackgroundImage:[[UIImage imageNamed:@"commit_btn_normal"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [btnMakeAudio setBackgroundImage:[[UIImage imageNamed:@"commit_btn_highlighted"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [btnMakeAudio addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnMakeAudio];
    
    UIButton * btnEndMakeAudio = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnEndMakeAudio setTag:TAG_BtnEndAudio];
    [btnEndMakeAudio setFrame:CGRectMake(20,Height_Screen - 100, 100, 40)];
    [btnEndMakeAudio setTitle:@"停止录音" forState:UIControlStateNormal];
    [btnEndMakeAudio setBackgroundImage:[[UIImage imageNamed:@"commit_btn_normal"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [btnEndMakeAudio setBackgroundImage:[[UIImage imageNamed:@"commit_btn_highlighted"]stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    [btnEndMakeAudio addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnEndMakeAudio];
    [btnEndMakeAudio setHidden:YES];
    
    UISwipeGestureRecognizer * swip = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipAction:)];
    swip.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swip];
    [swip release];
}

#pragma mark - 用户事件
-(void)swipAction:(UIGestureRecognizer *)gesture
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnAction:(UIButton *)btn
{
    if (btn.tag == TAG_BtnStartAudio)
    {
        NSLog(@"开始录音");
        [btn setHidden:YES];
        UIButton * btnEnd = (UIButton *)[self.view viewWithTag:TAG_BtnEndAudio];
        [btnEnd setHidden:NO];
        
        NSDictionary * settings = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [NSNumber numberWithFloat:sampleRate],
                                  AVSampleRateKey,
                                  [NSNumber numberWithInt:formatIndex],
                                  AVFormatIDKey,
                                  [NSNumber numberWithInt:2],
                                  AVNumberOfChannelsKey,
                                  [NSNumber numberWithInt:quality],
                                  AVEncoderAudioQualityKey,
                                  nil];
        recordFile = [[NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"]] retain];
        NSError *error;
        recorder = [[AVAudioRecorder alloc] initWithURL:recordFile settings:settings error:&error];
        error ? NULL : (NSLog(@"Error: %@",[error description]));
        [recorder prepareToRecord];
        recorder.meteringEnabled = YES;
        [recorder record];
        
        secTimer = [NSTimer scheduledTimerWithTimeInterval:.01f target:self selector:@selector(timerUpdate) userInfo:nil repeats:YES];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(recordTimer) userInfo:nil repeats:YES];
        num = 3;
        
    }
    else if (btn.tag == TAG_BtnEndAudio)
    {
        NSLog(@"停止录音");
        [btn setHidden:YES];
        UIButton * btnStart = (UIButton *)[self.view viewWithTag:TAG_BtnStartAudio];
        [btnStart setHidden:NO];
        NSLog(@"停止录音");
        [timer invalidate];
        [secTimer invalidate];
        timer = nil;
        secTimer = nil;
        
        if (recorder != nil)
        {
            NSLog(@"录音不存在");
        }
        [recorder stop];
        [recorder release];
        //[self encodingClick];
        [self toMP3];
        
    }
}
//- (void)encodingClick
//{
//    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
//    [NSThread detachNewThreadSelector:@selector(toMP3) toTarget:self withObject:nil];
//}
- (void)toMP3
{
    NSLog(@"MakeAudioVC 将内容转换为MP3");
    NSString *cafFilePath =[NSTemporaryDirectory() stringByAppendingString:@"RecordedFile"];
    
    NSString *mp3FileName = [NSString stringWithFormat:@"Mp3File%d",num_mp3++];
    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [[NSTemporaryDirectory() stringByAppendingFormat:@"/MP3/"] stringByAppendingPathComponent:mp3FileName];
    @try {
        int read, write;
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, sampleRate);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        /*
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            //出问题的地方 - - - - - -
        } while (read != 0);
        */
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        [self performSelectorOnMainThread:@selector(convertMp3Finish)
                               withObject:nil
                            waitUntilDone:YES];
    }
}
- (void)convertMp3Finish
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)recordTimer
{
    if (num < 0) num = 4;
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"speak%d",num] ofType:@"png"];
    _imgViewAudio.image = [UIImage imageWithContentsOfFile:path];
    num--;
}

- (void)timerUpdate
{
    int m = recorder.currentTime / 60;
    int s = ((int)recorder.currentTime) % 60;
    int ss = (recorder.currentTime - ((int)recorder.currentTime)) *100;
    _lblShowTime.text = [NSString stringWithFormat:@"%.2d:%.2d:%.2d",m,s,ss];
}

- (NSInteger) formatIndexToEnum:(NSInteger) index
{
    //auto generate by python
    switch (index) {
        case 0: return kAudioFormatLinearPCM; break;
        case 1: return kAudioFormatAC3; break;
        case 2: return kAudioFormat60958AC3; break;
        case 3: return kAudioFormatAppleIMA4; break;
        case 4: return kAudioFormatMPEG4AAC; break;
        case 5: return kAudioFormatMPEG4CELP; break;
        case 6: return kAudioFormatMPEG4HVXC; break;
        case 7: return kAudioFormatMPEG4TwinVQ; break;
        case 8: return kAudioFormatMACE3; break;
        case 9: return kAudioFormatMACE6; break;
        case 10: return kAudioFormatULaw; break;
        case 11: return kAudioFormatALaw; break;
        case 12: return kAudioFormatQDesign; break;
        case 13: return kAudioFormatQDesign2; break;
        case 14: return kAudioFormatQUALCOMM; break;
        case 15: return kAudioFormatMPEGLayer1; break;
        case 16: return kAudioFormatMPEGLayer2; break;
        case 17: return kAudioFormatMPEGLayer3; break;
        case 18: return kAudioFormatTimeCode; break;
        case 19: return kAudioFormatMIDIStream; break;
        case 20: return kAudioFormatParameterValueStream; break;
        case 21: return kAudioFormatAppleLossless; break;
        case 22: return kAudioFormatMPEG4AAC_HE; break;
        case 23: return kAudioFormatMPEG4AAC_LD; break;
        case 24: return kAudioFormatMPEG4AAC_ELD; break;
        case 25: return kAudioFormatMPEG4AAC_ELD_SBR; break;
        case 26: return kAudioFormatMPEG4AAC_ELD_V2; break;
        case 27: return kAudioFormatMPEG4AAC_HE_V2; break;
        case 28: return kAudioFormatMPEG4AAC_Spatial; break;
        case 29: return kAudioFormatAMR; break;
        case 30: return kAudioFormatAudible; break;
        case 31: return kAudioFormatiLBC; break;
        case 32: return kAudioFormatDVIIntelIMA; break;
        case 33: return kAudioFormatMicrosoftGSM; break;
        case 34: return kAudioFormatAES3; break;
        default:
            return -1;
            break;
    }
}
@end