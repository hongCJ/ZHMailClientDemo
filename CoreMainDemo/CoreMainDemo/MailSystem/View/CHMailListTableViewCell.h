//
//  CHMailListTableViewCell.h
//  CoreMainDemo
//
//  Created by 郑红 on 20/02/2017.
//  Copyright © 2017 zhenghong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CHMailAction) {
    MailActionUnRead,
    MailActionRead,
    MailActionStar,
    MailActionDelete,
    MailActionMore,
};

@protocol CHMailListCellProtocol <NSObject>

@required;
- (BOOL)MailUnReadAt:(NSIndexPath*)indexPath;
- (void)Action:(CHMailAction)action ForMailAt:(NSIndexPath*)indexPath;

@end



@interface CHMailListTableViewCell : UITableViewCell

@property (nonatomic,weak) id<CHMailListCellProtocol> mailListDelegate;
@property (nonatomic,strong) NSIndexPath *cellIndexPath;

@property (strong, nonatomic) IBOutlet UILabel *mailFromLabel;
@property (strong, nonatomic) IBOutlet UILabel *mailSubjectLabel;
@property (strong, nonatomic) IBOutlet UILabel *mailBodyLabel;
@property (strong, nonatomic) IBOutlet UILabel *mailDateLabel;



@end
