//
//  ListTableViewController.h
//  ToDoApp
//
//  Created by Akram Elhayani on 27/01/2022.
//

#import <UIKit/UIKit.h>
#import "ToDoObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface ListTableViewController :UIViewController< UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
-(void)RefreshDataSourc;
-(void) SaveDataIntoFile;
-(void)LoadData;
-(void) addNotficationForObject:(ToDoObject*)obj;
@end

NS_ASSUME_NONNULL_END
