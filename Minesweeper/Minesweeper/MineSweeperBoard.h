//
//  MineSweeperBoard.h
//  Minesweeper
//
//  Created by Rhed Shi on 9/26/14.
//  Copyright (c) 2014 Rhed Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineSweeperCell.h"

@interface MineSweeperBoard : NSObject <MineSweeperCellDelegate>

@property (nonatomic) NSUInteger rows;
@property (nonatomic) NSUInteger columns;
@property (nonatomic) NSUInteger numberOfMines;
@property (nonatomic, strong) NSArray *mines;
@property (nonatomic, strong) NSArray *cells;

- (id)initBoardWithRows:(NSUInteger)rows columns:(NSUInteger)columns numberOfMines:(NSUInteger)mines;
- (NSArray *)neighborMineSweeperCellsForCell:(MineSweeperCell *)cell;
- (BOOL)validateBoard;
- (void)resetBoard;

@end
