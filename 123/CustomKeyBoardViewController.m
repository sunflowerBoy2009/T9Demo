//
//  CustomKeyBoardViewController.m
//  CustomKeyBoard
//
//  Created by 姜小龙 on 13-1-10.
//  Copyright (c) 2013年 姜小龙. All rights reserved.
//

#import "CustomKeyBoardViewController.h"

@interface CustomKeyBoardViewController ()

@end

@implementation CustomKeyBoardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UILongPressGestureRecognizer *longPressRight = [[UILongPressGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(longPressKeyBoardRight)];
    [self.rightButton addGestureRecognizer:longPressRight];
    longPressRight.allowableMovement = NO;
    longPressRight.minimumPressDuration = 0.5;
    
    
    UILongPressGestureRecognizer *longPressZero = [[UILongPressGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(longPressKeyBoardNumberZero)];
    UIButton *zero = (UIButton *)[self.view viewWithTag:10];
    [zero addGestureRecognizer:longPressZero];
    longPressZero.allowableMovement = NO;
    longPressZero.minimumPressDuration = 0.5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setRightButton:nil];
    [super viewDidUnload];
}

- (IBAction)clickButton:(id)sender {
    UIButton* btn = (UIButton*)sender;
    NSInteger tag = btn.tag;
    if (tag < 10 && tag >= 1)
        if ([self.delegate respondsToSelector:@selector(clickKeyBoardNumber:)])
            [self.delegate clickKeyBoardNumber:tag];
    if (tag == 10)
        if ([self.delegate respondsToSelector:@selector(clickKeyBoardLeft)])
            [self.delegate clickKeyBoardNumber:0];
    if (tag == 11)
        if ([self.delegate respondsToSelector:@selector(clickKeyBoardLeft)])
            [self.delegate clickKeyBoardLeft];
    
    if (tag == 12)
        if ([self.delegate respondsToSelector:@selector(clickKeyBoardRight)])
            [self.delegate clickKeyBoardRight];
}

@end
