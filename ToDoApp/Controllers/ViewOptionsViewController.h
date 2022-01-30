//
//  ViewOptionsViewController.h
//  ToDoApp
//
//  Created by Akram Elhayani on 30/01/2022.
//

#import <UIKit/UIKit.h>
#import "ListTableViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ViewOptionsViewController : UIViewController<UIAdaptivePresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *orderBy;
@property (weak, nonatomic) IBOutlet UISegmentedControl *showItems;
@property (weak, nonatomic) IBOutlet UISegmentedControl *groupBy;
@property ListTableViewController *homeView;
@end

NS_ASSUME_NONNULL_END
