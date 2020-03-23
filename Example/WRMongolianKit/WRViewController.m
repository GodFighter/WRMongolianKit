//
//  WRViewController.m
//  WRMongolianKit
//
//  Created by GodFighter on 03/20/2020.
//  Copyright (c) 2020 GodFighter. All rights reserved.
//

#import "WRViewController.h"
#import <WRMongolianKit.h>

@interface WRViewController ()

@end

@implementation WRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initTextView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTextView
{
    WRVerticalTextView *textView = [[WRVerticalTextView alloc] initWithFrame:CGRectMake(50, 300, 200, 100)];
    //    attr[NSFontAttributeName] = [UIFont fontWithName:@"DelehiSoninQaganTig" size:19];
    textView.font = [UIFont fontWithName:@"DelehiSoninQaganTig" size:19];
//    textView.text = @"ᠪᠠᠭᠤᠯᠭᠠᠬᠤ ᠲᠤᠰᠭᠠᠢ good  ᠪᠠᠭᠤᠯᠭᠠᠬᠤ ᠲᠤᠰᠭᠠᠢ ᠪᠠᠭᠤᠯᠭᠠᠬᠤ";
    [self.view addSubview:textView];
    
    [textView becomeFirstResponder];
    
    textView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
//    textView.caretColor = [UIColor blackColor];
}

@end
