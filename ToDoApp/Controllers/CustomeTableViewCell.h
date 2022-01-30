//
//  CustomeTableViewCell.h
//  ToDoApp
//
//  Created by Akram Elhayani on 29/01/2022.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgPriorty;
@property (weak, nonatomic) IBOutlet UIImageView *imgFile;
@property (weak, nonatomic) IBOutlet UILabel *NameLable; 
@property (weak, nonatomic) IBOutlet UILabel *progressLable;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLable;
@end

NS_ASSUME_NONNULL_END
