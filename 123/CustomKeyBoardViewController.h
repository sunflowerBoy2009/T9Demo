//
//  CustomKeyBoardViewController.h
//  CustomKeyBoard
//
//  Created by 姜小龙 on 13-1-10.
//  Copyright (c) 2013年 姜小龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomKeyBoardDelegate <NSObject>

- (void) clickKeyBoardNumber:(NSInteger) number;
- (void) clickKeyBoardLeft;
- (void) clickKeyBoardRight;
- (void) longPressKeyBoardRight;
- (void) longPressKeyBoardNumberZero;

@end

@interface CustomKeyBoardViewController : UIViewController

@property (nonatomic, assign) id<CustomKeyBoardDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIButton *rightButton;

- (IBAction)clickButton:(id)sender;

@end
