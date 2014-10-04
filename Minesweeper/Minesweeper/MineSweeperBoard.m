//
//  MineSweeperBoard.m
//  Minesweeper
//
//  Created by Rhed Shi on 9/26/14.
//  Copyright (c) 2014 Rhed Shi. All rights reserved.
//

#import "MineSweeperBoard.h"

@interface MineSweeperBoard ()

@property (nonatomic, strong) NSMutableArray *marked;

@end

@implementation MineSweeperBoard

- (id)initBoardWithRows:(NSUInteger)rows columns:(NSUInteger)columns numberOfMines:(NSUInteger)mines
{
    self = [super init];
    if (self) {
        self.rows = rows;
        self.columns = columns;
        self.numberOfMines = mines;
        self.marked = [NSMutableArray array];
        
        NSMutableArray *rowCells = [NSMutableArray array];
        for (int i = 0; i < rows; i++)
        {
            NSMutableArray *columnCells = [NSMutableArray array];
            for (int j = 0; j < columns; j++)
            {
                MineSweeperCell *cell = [[MineSweeperCell alloc] initWithX:i Y:j];
                cell.delegate = self;
                
                [columnCells addObject:cell];
            }
            [rowCells addObject:[NSArray arrayWithArray:columnCells]];
        }
        self.cells = rowCells;
        
        [self placeNumberOfMinesOnBoard:mines];
        [self updateNumberOfMinesForMineSweeperCells];
    }
    return self;
}

- (NSUInteger)numberOfMinesForMineSweeperCell:(MineSweeperCell *)cell
{
    NSUInteger count = 0;
    for (MineSweeperCell *neighbor in [self neighborMineSweeperCellsForCell:cell])
    {
        count += neighbor.isMine ? 1 : 0;
    }
    return count;
}

- (NSArray *)neighborMineSweeperCellsForCell:(MineSweeperCell *)cell
{
    NSUInteger x = cell.x;
    NSUInteger y = cell.y;
    
    int xs[] = {-1, 0, 1};
    int ys[] = {-1, 0, 1};
    
    NSMutableArray *neighbors = [NSMutableArray array];
    for (int i = 0; i < 3; i++)
    {
        NSUInteger row = x + xs[i];
        for (int j = 0; j < 3; j++)
        {
            NSUInteger column = y + ys[j];
            if (row < self.rows && column < self.columns && !(xs[i] == 0 && ys[j] == 0)) {
                [neighbors addObject:[[self.cells objectAtIndex:row] objectAtIndex:column]];
            }
        }
    }
    return neighbors;
}

- (void)placeNumberOfMinesOnBoard:(NSUInteger)numberOfMines
{
    NSUInteger numberOfCells = self.rows * self.columns;
    NSMutableOrderedSet *randomSet = [NSMutableOrderedSet orderedSet];
    
    while (randomSet.count < numberOfMines)
    {
        int random = arc4random_uniform((int)numberOfCells);
        [randomSet addObject:[NSNumber numberWithInt:random]];
    }
    
    NSMutableArray *mines = [NSMutableArray array];
    for (int i = 0; i < numberOfMines; i++)
    {
        NSUInteger random = [randomSet[i] integerValue];
        
        NSUInteger row = random / self.rows;
        NSUInteger column = random % self.columns;
        
        MineSweeperCell *cell = [[self.cells objectAtIndex:row] objectAtIndex:column];
        cell.isMine = YES;
        
        [mines addObject:cell];
    }
    self.mines = mines;
}

- (void)updateNumberOfMinesForMineSweeperCells
{
    for (int i = 0; i < self.rows; i++)
    {
        for (int j = 0; j < self.columns; j++)
        {
            MineSweeperCell *cell = [[self.cells objectAtIndex:i] objectAtIndex:j];
            cell.neighborMines = [self numberOfMinesForMineSweeperCell:cell];
        }
    }
}

- (BOOL)validateBoard
{
    if (self.marked.count != self.numberOfMines) {
        return NO;
    }
    else {
        for (MineSweeperCell *cell in self.marked) {
            if (!cell.isMine) {
                return NO;
            }
        }
        return YES;
    }
}

- (void)resetBoard
{
    for (int i = 0; i < self.rows; i++)
    {
        for (int j = 0; j < self.columns; j++)
        {
            MineSweeperCell *cell = [[self.cells objectAtIndex:i] objectAtIndex:j];
            cell.isMine = NO;
            cell.visited = NO;
            cell.marked = NO;
        }
    }
    
    [self placeNumberOfMinesOnBoard:self.numberOfMines];
    [self updateNumberOfMinesForMineSweeperCells];
}

#pragma mark - MineSweeperCell Delegate Methods

- (void)didMarkAsPossibleMine:(MineSweeperCell *)cell
{
    if (cell.marked) {
        [self.marked addObject:cell];
    }
    else {
        [self.marked removeObject:cell];
    }
}

@end
