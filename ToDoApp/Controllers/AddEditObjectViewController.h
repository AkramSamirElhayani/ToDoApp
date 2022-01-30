//
//  AddEditObjectViewController.h
//  ToDoApp
//
//  Created by Akram Elhayani on 27/01/2022.
//

#import <UIKit/UIKit.h>
#import "ToDoObject.h"
#import "ListTableViewController.h"
NS_ASSUME_NONNULL_BEGIN
enum ViewState {
    Adding,
    Editing
};
@interface AddEditObjectViewController : UIViewController<UITextViewDelegate,UIAdaptivePresentationControllerDelegate,
UIImagePickerControllerDelegate>
@property int currentObjectIndex;
@property NSMutableArray<ToDoObject *> *dataSource;
@property enum ViewState State;
@property ListTableViewController *homeView;
@end

NS_ASSUME_NONNULL_END
