//
//  MineSweeperCell.h
//  Minesweeper
//
//  Created by Rhed Shi on 9/25/14.
//  Copyright (c) 2014 Rhed Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MineSweeperCellDelegate;


@interface MineSweeperCell : NSObject

@property (nonatomic) id <MineSweeperCellDelegate> delegate;

@property (nonatomic) NSUInteger x;
@property (nonatomic) NSUInteger y;
@property (nonatomic) BOOL isMine;
@property (nonatomic) BOOL visited;
@property (nonatomic) BOOL marked;
@property (nonatomic) NSUInteger neighborMines;

- (id)initWithX:(NSUInteger)x Y:(NSUInteger)y;

@end


@protocol MineSweeperCellDelegate <NSObject>

- (void)didMarkAsPossibleMine:(MineSweeperCell *)cell;

@end
