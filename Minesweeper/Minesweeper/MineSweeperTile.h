//
//  MineSweeperTile.h
//  Minesweeper
//
//  Created by Rhed Shi on 10/2/14.
//  Copyright (c) 2014 Rhed Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineSweeperCell.h"

static const CGFloat MARGIN = 12;

typedef enum {
    kHiddenState,
    kRevealedState,
    kMarkedState
} MineSweeperTileStateType;

@interface MineSweeperTile : UIButton

@property (nonatomic, strong) MineSweeperCell *cell;

- (id)initWithCell:(MineSweeperCell *)cell size:(CGFloat)size;
- (void)changeState:(MineSweeperTileStateType)state;
- (void)revealMine;

@end
