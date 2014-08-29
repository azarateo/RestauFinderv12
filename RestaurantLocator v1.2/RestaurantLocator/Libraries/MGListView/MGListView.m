

#import "MGListView.h"

@implementation MGListView

@synthesize tableView = _tableView;
@synthesize delegate = _delegate;
@synthesize cellHeight;
@synthesize nibName = _nibName;
@synthesize cellIdentifier = _cellIdentifier;
@synthesize arrayData = _arrayData;
@synthesize object;
@synthesize selectedIndex;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _nibContents = [[NSBundle mainBundle] loadNibNamed:@"ListView"
                                                     owner:self
                                                   options:nil];
        
        self = [_nibContents objectAtIndex:0];
        [self baseInit];
    }
    return self;
}

-(void) baseInit {
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Initialization code
    }
    return self;
}

-(void)registerNibName:(NSString*)nibName cellIndentifier:(NSString *)cellIdentifier {
    _nibName = [nibName copy];
    _cellIdentifier = [cellIdentifier copy];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView * view in [self subviews]) {
        if (view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event]) {
            return YES;
        }
    }
    return NO;
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayData.count;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MGListCell *cell = (MGListCell*)[tableView cellForRowAtIndexPath:indexPath];
    [self.delegate MGListView:self didSelectCell:cell indexPath:indexPath];
    selectedIndex = indexPath.row;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}


-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView registerNib:[UINib nibWithNibName:_nibName bundle:nil] forCellReuseIdentifier:_cellIdentifier];
    MGListCell *cell = [tableView dequeueReusableCellWithIdentifier:_cellIdentifier];
    [self.delegate MGListView:self didCreateCell:cell indexPath:indexPath];
    return cell;
}

-(void)setSelectedList:(NSInteger)index {
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    [self tableView:_tableView didSelectRowAtIndexPath:indexPath];
}

-(void)reloadData {
    [self.tableView reloadData];
}

@end
