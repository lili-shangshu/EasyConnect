//
//  DOPDropDownMenu.m
//  DOPDropDownMenuDemo
//
//  Created by Nathan on 9/26/14.
//  Copyright (c) 2014 Nathan. All rights reserved.
//

#import "DOPDropDownMenu.h"
#import "FGDropDownCell.h"

#define secondViewOffSet NAScreenWidth*(1.f/3.f)
#define kLimitRows 7

#define kLineViewHeight 3.f

@implementation DOPIndexPath
- (instancetype)initWithColumn:(NSInteger)column row:(NSInteger)row {
    self = [super init];
    if (self) {
        _column = column;
        _row = row;
    }
    return self;
}

+ (instancetype)indexPathWithCol:(NSInteger)col row:(NSInteger)row {
    DOPIndexPath *indexPath = [[self alloc] initWithColumn:col row:row];
    return indexPath;
}
@end

#pragma mark - menu implementation

@interface DOPDropDownMenu ()
@property (nonatomic, assign) NSInteger currentSelectedMenudIndex;
@property (nonatomic, assign) NSInteger numOfMenu;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) UITableView *tableView;
//data source
@property (nonatomic, copy) NSArray *array;
//layers array
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *indicators;
@property (nonatomic, copy) NSArray *bgLayers;

@property (nonatomic, strong) UITableView *secondTableView;
@property (nonatomic, assign) BOOL needSecondMenu;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *dropDownLineView;

@end


@implementation DOPDropDownMenu

#pragma mark - getter
- (UIColor *)indicatorColor {
    if (!_indicatorColor) {
        _indicatorColor = [UIColor blackColor];
    }
    return _indicatorColor;
}

- (UIColor *)textColor {
    if (!_textColor) {
        _textColor = [UIColor blackColor];
    }
    return _textColor;
}

- (UIColor *)separatorColor {
    if (!_separatorColor) {
        _separatorColor = [UIColor blackColor];
    }
    return _separatorColor;
}

//- (NSString *)titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
//    NSString*title = [self.dataSource menu:self titleForRowAtIndexPath:indexPath];
//    if ([title isEqual:kAllCate]) {
//        return [self.dataSource menu:self detaultTiteInColumn:indexPath.column];
//    }
//    return title;
//}



#pragma mark - setter
- (void)setDataSource:(id<DOPDropDownMenuDataSource>)dataSource {
    _dataSource = dataSource;
    
    //configure view
    if ([_dataSource respondsToSelector:@selector(numberOfColumnsInMenu:)]) {
        _numOfMenu = [_dataSource numberOfColumnsInMenu:self];
    } else {
        _numOfMenu = 1;
    }
    
    CGFloat textLayerInterval = self.frame.size.width / ( _numOfMenu * 2);
    CGFloat separatorLineInterval = self.frame.size.width / _numOfMenu;
    CGFloat bgLayerInterval = self.frame.size.width / _numOfMenu;
    
    NSMutableArray *tempTitles = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempIndicators = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    NSMutableArray *tempBgLayers = [[NSMutableArray alloc] initWithCapacity:_numOfMenu];
    
    for (int i = 0; i < _numOfMenu; i++) {
        //bgLayer
        CGPoint bgLayerPosition = CGPointMake((i+0.5)*bgLayerInterval+1.f, self.frame.size.height/2);
        CALayer *bgLayer = [self createBgLayerWithColor:[UIColor whiteColor] andPosition:bgLayerPosition];
        
//        [self.layer addSublayer:bgLayer];
        [tempBgLayers addObject:bgLayer];
        //title
        CGPoint titlePosition = CGPointMake( (i * 2 + 1) * textLayerInterval-10.f , self.frame.size.height / 2);
        NSString *titleString = [self getTitleWithMenu:self indexPath:[DOPIndexPath indexPathWithCol:i row:0] withTableView:0];
        CATextLayer *title = [self createTextLayerWithNSString:titleString withColor:self.textColor andPosition:titlePosition];
        [self.layer addSublayer:title];
        [tempTitles addObject:title];
        //indicator
        CAShapeLayer *indicator = [self createIndicatorWithColor:self.indicatorColor andPosition:CGPointMake(titlePosition.x + title.bounds.size.width / 2 + 15.f, self.frame.size.height / 2)];
        [self.layer addSublayer:indicator];
        
        [tempIndicators addObject:indicator];
        //separator
        if (i != _numOfMenu - 1) {
            CGPoint separatorPosition = CGPointMake((i + 1) * separatorLineInterval, self.frame.size.height / 2);
            CAShapeLayer *separator = [self createSeparatorLineWithColor:self.separatorColor andPosition:separatorPosition];
            [self.layer addSublayer:separator];
        }
        
    }
    _titles = [tempTitles copy];
    _indicators = [tempIndicators copy];
    _bgLayers = [tempBgLayers copy];
}

- (NSString *)getTitleWithMenu:(DOPDropDownMenu *)menu indexPath:(DOPIndexPath *)indexPath withTableView:(NSInteger)tableViewNumber
{
    NSString*title = [self.dataSource menu:self titleForRowAtIndexPath:indexPath tableView:tableViewNumber selectedColumn:self.selectedColumn];
    if ([title isEqual:kAllCate]) {
        return [self.dataSource menu:self detaultTiteInColumn:indexPath.column];
    }else if ([title isEqualToString:kCateAll] && [self.dataSource respondsToSelector:@selector(menu:categoryTitleAtIndex:selectedColumn:)]) {
            return [self.dataSource menu:self categoryTitleAtIndex:indexPath selectedColumn:self.selectedColumn];
    }
    
    return title;
}

#pragma mark - init method
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height andDataSource:(id) dataSource {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self = [self initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, height)];
    self.dataSource = dataSource;

    if (self) {
        _origin = origin;
        _currentSelectedMenudIndex = 0;
        _lastSelectedMenuIndexInTableOne = 0;
        _show = NO;
        _selectedColumn = 0;
        _shouldSelectedTitle = NO;
        //tableView init
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0) style:UITableViewStylePlain];
        _tableView.rowHeight = 44.f;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tag = 0;
        _tableView.clipsToBounds = YES;
        _tableView.separatorColor = [UIColor NA_ColorWithR:229 g:229 b:229];
        _tableView.layer.masksToBounds = YES;
        _tableView.alpha = 0.959;
        
        // Line VIew
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(secondViewOffSet, _tableView.top, 0.5f, _tableView.height)];
        self.lineView = lineView;
        lineView.backgroundColor = _tableView.separatorColor;
        
        // Secound TableView
        _secondTableView = [[UITableView alloc] initWithFrame:CGRectMake(origin.x+secondViewOffSet, self.frame.origin.y + self.frame.size.height, self.frame.size.width-secondViewOffSet, 0) style:UITableViewStylePlain];
        _secondTableView.rowHeight = 44.f;
        _secondTableView.dataSource = self;
        _secondTableView.delegate = self;
        _secondTableView.separatorColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
        _secondTableView.tag = 1;
        
        self.dropDownLineView = [[UIView alloc] initWithFrame:CGRectMake(_tableView.left, _tableView.top, _tableView.width, kLineViewHeight)];
        self.dropDownLineView.backgroundColor = [UIColor spThemeColor];
        
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
            [self.secondTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
            [self.secondTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
        }
        
        //self tapped
        self.backgroundColor = [UIColor whiteColor];
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapped:)];
        [self addGestureRecognizer:tapGesture];
        
        //background init and tapped
        _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(origin.x, origin.y, screenSize.width, screenSize.height)];
        _backGroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backGroundView.opaque = NO;
        UIGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        [_backGroundView addGestureRecognizer:gesture];
        
        //add bottom shadow
        UIView *bottomShadow = [UIView lineViewWithWidth:self.width yPoint:0 withColor:[UIColor spLineColor]];
        bottomShadow.bottom = self.height;
        [self addSubview:bottomShadow];
    }
    
    
    return self;
}

- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height withSelectedTitle:(NSString *)selectedTitle
{
    return nil;
}

#pragma mark - init support
- (CALayer *)createBgLayerWithColor:(UIColor *)color andPosition:(CGPoint)position {
    CALayer *layer = [CALayer layer];
    
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, self.frame.size.width/self.numOfMenu, self.frame.size.height-1);
//    NSLog(@"bglayer bounds:%@",NSStringFromCGRect(layer.bounds));
//    NSLog(@"bglayer position:%@", NSStringFromCGPoint(position));
    layer.backgroundColor = color.CGColor;
    
    return layer;
}

- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(1, 1)];
    [path addLineToPoint:CGPointMake(1.5, 0.5)];
    [path addLineToPoint:CGPointMake(5, 4)];
    [path addLineToPoint:CGPointMake(8.5, 0.5)];
    [path addLineToPoint:CGPointMake(9, 1)];
    [path addLineToPoint:CGPointMake(5, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 1.0;
    layer.fillColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    layer.position = point;
    
    return layer;
}

- (CAShapeLayer *)createLineWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, -2)];
    [path moveToPoint:CGPointMake(0, 8)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 0.5;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    layer.position = point;
    
    return layer;
}

- (CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160,0)];
    [path addLineToPoint:CGPointMake(160, 16)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 0.2f;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    layer.position = point;
//    NSLog(@"separator position: %@",NSStringFromCGPoint(point));
//    NSLog(@"separator bounds: %@",NSStringFromCGRect(layer.bounds));
    return layer;
}

- (CATextLayer *)createTextLayerWithNSString:(NSString *)string withColor:(UIColor *)color andPosition:(CGPoint)point {
    
    CGSize size = [self calculateTitleSizeWithString:string];
    
    CATextLayer *layer = [CATextLayer new];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    layer.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    layer.string = string;
    layer.fontSize = 15.0;
    UIFont *boldFont = [UIFont defaultTextFontWithSize:layer.fontSize];
    layer.font = (__bridge CFTypeRef)(boldFont.fontName);
    layer.alignmentMode = kCAAlignmentCenter;
    layer.foregroundColor = color.CGColor;
    
    layer.contentsScale = [[UIScreen mainScreen] scale];
    
    layer.position = point;
    
    return layer;
}

- (CGSize)calculateTitleSizeWithString:(NSString *)string
{
    CGFloat fontSize = 17.0;
    NSDictionary *dic = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [string boundingRectWithSize:CGSizeMake(280, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size;
}

#pragma mark - gesture handle
- (void)menuTapped:(UITapGestureRecognizer *)paramSender {
    
    CGPoint touchPoint = [paramSender locationInView:self];
    //calculate index
    NSInteger tapIndex = touchPoint.x / (self.frame.size.width / _numOfMenu);
    
    self.needSecondMenu = NO;
    if ([self.dataSource respondsToSelector:@selector(needSecondTableForMenu:inColumn:)]) {
        self.needSecondMenu = [self.dataSource needSecondTableForMenu:self inColumn:tapIndex];
    }
    
    for (int i = 0; i < _numOfMenu; i++) {
        if (i != tapIndex) {
            [self animateIndicator:_indicators[i] Forward:NO complete:^{
                [self animateTitle:_titles[i] show:NO complete:^{
                    
                }];
            }];
            [(CALayer *)self.bgLayers[i] setBackgroundColor:[UIColor whiteColor].CGColor];
        }
    }
    
    if (tapIndex == _currentSelectedMenudIndex && _show) {
        [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_tableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
            _currentSelectedMenudIndex = tapIndex;
            _show = NO;
        }];
        [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:[UIColor whiteColor].CGColor];
    } else {
        _currentSelectedMenudIndex = tapIndex;
        [_tableView reloadData];
        [_secondTableView reloadData];
        [self animateIdicator:_indicators[tapIndex] background:_backGroundView tableView:_tableView title:_titles[tapIndex] forward:YES complecte:^{
            _show = YES;
        }];
        [(CALayer *)self.bgLayers[tapIndex] setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1.0].CGColor];
    }
}

- (void)backgroundTapped:(UITapGestureRecognizer *)paramSender
{
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_tableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
    }];
    [(CALayer *)self.bgLayers[_currentSelectedMenudIndex] setBackgroundColor:[UIColor whiteColor].CGColor];
}

#pragma mark - animation method
- (void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward complete:(void(^)())complete {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.3];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];
    
    if (!anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator addAnimation:anim forKey:anim.keyPath];
        [indicator setValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }
    
    [CATransaction commit];
    
    complete();
}

- (void)animateBackGroundView:(UIView *)view show:(BOOL)show complete:(void(^)())complete {
    if (show) {
        [self.superview addSubview:view];
        [view.superview addSubview:self];
        
        [UIView animateWithDuration:0.3 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.55];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    }
    complete();
}

- (void)animateTableView:(UITableView *)tableView show:(BOOL)show complete:(void(^)())complete {
    
    if (show) {
        tableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
        [self.superview addSubview:tableView];
        _secondTableView.frame = CGRectMake(tableView.left+secondViewOffSet, tableView.top, tableView.width-secondViewOffSet, tableView.height);
        _lineView.left = secondViewOffSet;
        _lineView.height = tableView.height;
        
        if (self.needSecondMenu) {
            [self.superview addSubview:_secondTableView];
            [self.superview addSubview:_lineView];
        }
        
        [self.superview addSubview:_dropDownLineView];
        _dropDownLineView.top = tableView.top;
        _dropDownLineView.left = tableView.left;
        
        CGFloat tableViewHeight = ([tableView numberOfRowsInSection:0] > kLimitRows) ? (kLimitRows * tableView.rowHeight) : ([tableView numberOfRowsInSection:0] * tableView.rowHeight)+0.5f;
        
        [UIView animateWithDuration:0.3 animations:^{
            _tableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, tableViewHeight);
            _secondTableView.frame = CGRectMake(self.origin.x+secondViewOffSet, self.frame.origin.y + self.frame.size.height, self.frame.size.width-secondViewOffSet, tableViewHeight);
            _lineView.left = secondViewOffSet;
            _lineView.height = tableViewHeight;
            _dropDownLineView.top = self.frame.origin.y + self.frame.size.height+tableViewHeight-0.4;
            _dropDownLineView.alpha = 1.f;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            _tableView.frame = CGRectMake(self.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 0);
            _secondTableView.frame = CGRectMake(self.origin.x+secondViewOffSet, self.frame.origin.y + self.frame.size.height, self.frame.size.width-secondViewOffSet, 0);
            _lineView.height = 0;
            _dropDownLineView.top = self.frame.origin.y + self.frame.size.height;
            _dropDownLineView.alpha = 0.f;
        } completion:^(BOOL finished) {
            [_secondTableView removeFromSuperview];
            [_lineView removeFromSuperview];
            [tableView removeFromSuperview];
            [_dropDownLineView removeFromSuperview];
        }];
    }
    complete();
}

- (void)animateTitle:(CATextLayer *)title show:(BOOL)show complete:(void(^)())complete {
    CGSize size = [self calculateTitleSizeWithString:title.string];
    CGFloat sizeWidth = (size.width < (self.frame.size.width / _numOfMenu) - 25) ? size.width : self.frame.size.width / _numOfMenu - 25;
    title.bounds = CGRectMake(0, 0, sizeWidth, size.height);
    complete();
}

- (void)animateIdicator:(CAShapeLayer *)indicator background:(UIView *)background tableView:(UITableView *)tableView title:(CATextLayer *)title forward:(BOOL)forward complecte:(void(^)())complete{
    
    [self animateIndicator:indicator Forward:forward complete:^{
        [self animateTitle:title show:forward complete:^{
            [self animateBackGroundView:background show:forward complete:^{
                [self animateTableView:tableView show:forward complete:^{
                    if (forward && self.needSecondMenu) [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedColumn inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                }];
            }];
        }];
    }];
    
    complete();
}

#pragma mark - table datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    NSAssert(self.dataSource != nil, @"menu's dataSource shouldn't be nil");
    if ([self.dataSource respondsToSelector:@selector(menu:numberOfRowsInColumn:tableView:selectedColumn:)]) {
        return [self.dataSource menu:self
                numberOfRowsInColumn:self.currentSelectedMenudIndex tableView:tableView.tag selectedColumn:self.selectedColumn];
    } else {
        NSAssert(0 == 1, @"required method of dataSource protocol should be implemented");
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"DropDownMenuCell";
    FGDropDownCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FGDropDownCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.separatorInset = UIEdgeInsetsZero;
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    NSAssert(self.dataSource != nil, @"menu's datasource shouldn't be nil");
    if ([self.dataSource respondsToSelector:@selector(menu:titleForRowAtIndexPath:tableView:selectedColumn:)]) {
        cell.textLabel.text = [self.dataSource menu:self titleForRowAtIndexPath:[DOPIndexPath indexPathWithCol:self.currentSelectedMenudIndex row:indexPath.row] tableView:tableView.tag selectedColumn:self.selectedColumn];
    } else {
        NSAssert(0 == 1, @"dataSource method needs to be implemented");
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.separatorInset = UIEdgeInsetsZero;
    
    if (cell.textLabel.text == [(CATextLayer *)[_titles objectAtIndex:_currentSelectedMenudIndex] string]) {
        cell.selectedCell = YES;
        if (tableView.tag == 0 && self.needSecondMenu && (indexPath.row == self.selectedColumn || _shouldSelectedTitle)) {
            cell.backgroundColor = [UIColor spBackgroundColor];
        }
    }else{
        cell.selectedCell = NO;
    }
    
    if (tableView.tag == 0 && self.selectedColumn != 0 && indexPath.row == self.selectedColumn && self.needSecondMenu) {
        cell.selectedCell = YES;
        cell.backgroundColor = [UIColor spBackgroundColor];
        [self.secondTableView reloadData];
    }
    
    if ([cell.textLabel.text isEqualToString:kCateAll] && _lastSelectedMenuIndexInTableOne == self.selectedColumn) {
        cell.selectedCell = YES;
    }
    
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _shouldSelectedTitle = NO;
    FGDropDownCell *cell = (FGDropDownCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.selectedCell = YES;
    if (self.delegate || [self.delegate respondsToSelector:@selector(menu:didSelectRowAtIndexPath:forTableView:selectedColumn:)]) {
        if (self.needSecondMenu && tableView.tag == 0 && indexPath.row != 0) {
            self.selectedColumn = indexPath.row;
            [_tableView reloadData];
            [_secondTableView reloadData];
        }else
        {
            if (tableView.tag == 1 && indexPath.row == 0)
                _lastSelectedMenuIndexInTableOne = self.selectedColumn;
            else
                _lastSelectedMenuIndexInTableOne = -1;
            [self confiMenuWithSelectRow:indexPath.row withTableView:tableView.tag];
            if (indexPath.row == 0 && tableView.tag == 0) self.selectedColumn = 1;
        }
        [self.delegate menu:self didSelectRowAtIndexPath:[DOPIndexPath indexPathWithCol:self.currentSelectedMenudIndex row:indexPath.row] forTableView:tableView.tag selectedColumn:self.selectedColumn];
    } else {
        //TODO: delegate is nil
    }
}

- (void)confiMenuWithSelectRow:(NSInteger)row withTableView:(NSInteger)tableViewNum{
    
    
    CATextLayer *title = (CATextLayer *)_titles[_currentSelectedMenudIndex];
    title.string = [self getTitleWithMenu:self indexPath:[DOPIndexPath indexPathWithCol:self.currentSelectedMenudIndex row:row] withTableView:tableViewNum];
    
    [self animateIdicator:_indicators[_currentSelectedMenudIndex] background:_backGroundView tableView:_tableView title:_titles[_currentSelectedMenudIndex] forward:NO complecte:^{
        _show = NO;
    }];
    [(CALayer *)self.bgLayers[_currentSelectedMenudIndex] setBackgroundColor:[UIColor whiteColor].CGColor];
    
    CAShapeLayer *indicator = (CAShapeLayer *)_indicators[_currentSelectedMenudIndex];
    indicator.position = CGPointMake(title.position.x + title.frame.size.width / 2 + 8, indicator.position.y);
}






@end
