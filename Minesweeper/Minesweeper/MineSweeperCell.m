//
//  MineSweeperCell.m
//  Minesweeper
//
//  Created by Rhed Shi on 9/25/14.
//  Copyright (c) 2014 Rhed Shi. All rights reserved.
//

#import "MineSweeperCell.h"

@implementation MineSweeperCell

- (id)initWithX:(NSUInteger)x Y:(NSUInteger)y
{
    self = [super init];
    if (self) {
        self.x = x;
        self.y = y;
        self.isMine = NO;
        self.visited = NO;
        self.marked = NO;
        self.neighborMines = 0;
    }
    return self;
}

- (void)setMarked:(BOOL)marked
{
    _marked = marked;
    [self.delegate didMarkAsPossibleMine:self];
}

@end
