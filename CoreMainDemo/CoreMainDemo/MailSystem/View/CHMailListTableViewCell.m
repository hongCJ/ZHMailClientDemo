//
//  CHMailListTableViewCell.m
//  CoreMainDemo
//
//  Created by 郑红 on 20/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import "CHMailListTableViewCell.h"
#import "UIView+Frame.h"

typedef enum : NSUInteger {
    DirectionLeft,
    DirectionRight,
} MoveDirection;

typedef enum : NSUInteger {
    StateNone,
    StateLeft,
    StateRight,
} MoveState;

@interface CHMailListTableViewCell ()<UIGestureRecognizerDelegate>
{
    CGFloat width;
    CGFloat height;
    
    MoveDirection moveDirection;
    MoveState moveState;
}

@property (strong, nonatomic) IBOutlet UIView *mailView;

@property (strong, nonatomic) IBOutlet UIView *moreActionView;

@property (strong, nonatomic) IBOutlet UIView *markActionView;
@property (strong, nonatomic) IBOutlet UIView *deleteActionView;

@property (strong, nonatomic) IBOutlet UIView *readActionView;
@property (strong, nonatomic) IBOutlet UILabel *readLabel;

@end

@implementation CHMailListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    width = [UIScreen mainScreen].bounds.size.width;
    height = 100.0;
    
    self.mailFromLabel.text = @"";
    self.mailSubjectLabel.text = @"";
    self.mailBodyLabel.text = @"";
    self.mailDateLabel.text = @"";
    
    self.moreActionView.frame = CGRectMake(width, 0, width, height);
    self.markActionView.frame = CGRectMake(width, 0, width, height);
    self.deleteActionView.frame = CGRectMake(width, 0, width, height);
    self.readActionView.frame = CGRectMake(-width, 0, width, height);
    
    
    [self addGestureToView];
    
}

#pragma mark Gesture
- (void)panGesture:(UIPanGestureRecognizer*)panGes {
    switch (panGes.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint velocity = [panGes velocityInView:self.contentView];
            if (velocity.x < 0) {
                moveDirection = moveState == StateRight ? DirectionRight:DirectionLeft;
            } else
            {
                moveDirection = moveState == StateLeft ? DirectionLeft : DirectionRight;
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint transition = [panGes translationInView:self.contentView];
            [self move:transition.x];
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint transition = [panGes translationInView:self.contentView];
            [self moveEnd:transition.x];
            
        }
            break;
        default:
            break;
    }
}

- (void)moveEnd:(CGFloat)xOffSet {
    if (moveDirection == DirectionLeft) {
        xOffSet = [self moveLeftXOff:xOffSet];
        if (xOffSet < 100) {
            [UIView animateWithDuration:0.3 animations:^{
                self.mailView.MS_X = 0;
                self.moreActionView.MS_X = width;
                self.markActionView.MS_X = width;
                self.deleteActionView.MS_X = width;
            } completion:^(BOOL finished) {
                moveState = StateNone;
            }];
            
        }  else if (xOffSet < 300) {
            [UIView animateWithDuration:0.3 animations:^{
                self.mailView.MS_X = 0 - 240;
                self.moreActionView.MS_X = width - 240;
                self.markActionView.MS_X = width - 160;
                self.deleteActionView.MS_X = width - 80;
            } completion:^(BOOL finished) {
                moveState = StateLeft;
            }];
            
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                self.mailView.MS_X = 0;
                self.moreActionView.MS_X = width;
                self.markActionView.MS_X = width;
                self.deleteActionView.MS_X = width;
            } completion:^(BOOL finished) {
                [self PerformDelegateAction:MailActionDelete];
                moveState = StateNone;
            }];
        }
        
    } else {
        [self moveRight:0];
        moveState = StateNone;
        if (xOffSet > 160) {
            if (self.mailListDelegate) {
                BOOL unRead = [self.mailListDelegate MailUnReadAt:self.cellIndexPath];
                if (unRead) {
                   [self PerformDelegateAction:MailActionRead];
                } else {
                    [self PerformDelegateAction:MailActionUnRead];
                }
            }
            
        }
    }
}

- (void)move:(CGFloat)xOffSet {
    switch (moveDirection) {
        case DirectionLeft:
            [self moveLeft:xOffSet];
            break;
        default:
            [self moveRight:xOffSet];
            break;
    }
}

- (void)moveLeft:(CGFloat)xOffSet {
    if (xOffSet > 0 && moveState != StateLeft) {
        return;
    }
    xOffSet = [self moveLeftXOff:xOffSet];
    self.mailView.MS_X = 0-xOffSet;
    if (xOffSet <= 240) {
        self.moreActionView.MS_X = width - xOffSet;
        self.markActionView.MS_X = width - xOffSet * 2 / 3;
        self.deleteActionView.MS_X = width - xOffSet / 3;
    }
    else if (xOffSet > 240 && xOffSet <= 300) {
        if (self.deleteActionView.MS_X != width - 80) {
            [UIView animateWithDuration:0.3 animations:^{
                self.deleteActionView.MS_X = width - 80;
            }];
        }
        
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
           self.deleteActionView.MS_X = width - xOffSet;
        }];
    }
}

- (void)moveRight:(CGFloat)xOffSet {
    if (xOffSet < 0 && moveState != StateRight) {
        return;
    }
    self.mailView.MS_X = xOffSet;
    if (xOffSet < 100 || xOffSet > 200) {
        self.readActionView.MS_X = xOffSet - width;
    } else if (xOffSet > 200) {
        [UIView animateWithDuration:0.5 animations:^{
           self.readActionView.MS_X = xOffSet - width;
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.readActionView.MS_X = 100 - width;
        }];
    }
}

- (CGFloat)moveLeftXOff:(CGFloat)xOff {
    if (moveState == StateLeft) {
        xOff = 240 - xOff;
    }
    xOff = fabs(xOff);
    
    return xOff;
}

#pragma mark UI


#pragma mark action

- (void)addGestureToView {
    UIPanGestureRecognizer * panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.contentView addGestureRecognizer:panGes];
}

- (IBAction)MoreAction:(id)sender {
    [self PerformDelegateAction:MailActionMore];
}
- (IBAction)StarAction:(id)sender {
     [self PerformDelegateAction:MailActionStar];
}

- (IBAction)DeleteAction:(id)sender {
     [self PerformDelegateAction:MailActionDelete];
}

- (void)PerformDelegateAction:(CHMailAction)action {
    if (self.mailListDelegate) {
        if ([self.mailListDelegate respondsToSelector:@selector(Action:ForMailAt:)]) {
            [self.mailListDelegate Action:action ForMailAt:self.cellIndexPath];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
