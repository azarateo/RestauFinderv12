

#import <UIKit/UIKit.h>
#import "MGListCell.h"

@class MGListView;

@protocol MGListViewDelegate <NSObject>

-(UITableViewCell*) MGListView:(MGListView*)listView didCreateCell:(MGListCell*)cell indexPath:(NSIndexPath *)indexPath;
-(void) MGListView:(MGListView *)listView didSelectCell:(MGListCell *)cell indexPath:(NSIndexPath*)indexPath;

@end


@interface MGListView : UIView  <UITableViewDataSource, UITableViewDelegate> {
    
    NSArray* _nibContents;
    NSString* _nibName;
    NSString* _cellIdentifier;
    __weak id <MGListViewDelegate> _delegate;
    NSMutableArray* _arrayData;
    UITableView* _tableView;
}

@property (nonatomic, retain) IBOutlet UITableView* tableView;
@property (nonatomic, weak) id <MGListViewDelegate> delegate;
@property (nonatomic, assign) float cellHeight;
@property (nonatomic, copy) NSString* nibName;
@property (nonatomic, copy) NSString* cellIdentifier;
@property (nonatomic, retain) NSMutableArray* arrayData;
@property (nonatomic, retain) id object;

@property (nonatomic, assign) NSInteger selectedIndex;

-(void)registerNibName:(NSString*)nibName cellIndentifier:(NSString*)cellIdentifier;
-(void)setSelectedList:(NSInteger)index;

-(void)reloadData;

-(void)baseInit;

@end
