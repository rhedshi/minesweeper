//
//  ViewController.m
//  Minesweeper
//
//  Created by Rhed Shi on 9/25/14.
//  Copyright (c) 2014 Rhed Shi. All rights reserved.
//

#import "ViewController.h"

#import "MineSweeperBoard.h"
#import "MineSweeperCell.h"
#import "MineSweeperTile.h"

static const NSUInteger NUMBER_OF_ROWS = 8;
static const NSUInteger NUMBER_OF_COLUMNS = 8;
static const NSUInteger NUMBER_OF_MINES = 10;


@interface ViewController () <UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UIView *boardView;
@property (nonatomic, strong) NSArray *mineSweeperTiles;
@property (nonatomic, strong) MineSweeperBoard *board;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Minesweeper";
    self.boardView.backgroundColor = [UIColor orangeColor];
    
    self.board = [[MineSweeperBoard alloc] initBoardWithRows:NUMBER_OF_ROWS
                                                     columns:NUMBER_OF_COLUMNS
                                               numberOfMines:NUMBER_OF_MINES];
    
    UIBarButtonItem *cheatButton = [[UIBarButtonItem alloc] initWithTitle:@"Cheat" style:UIBarButtonItemStylePlain target:self action:@selector(cheatPressed:)];
    UIBarButtonItem *validateButton = [[UIBarButtonItem alloc] initWithTitle:@"Validate" style:UIBarButtonItemStylePlain target:self action:@selector(validatePressed:)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:cheatButton, validateButton, nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initBoard];
}

- (void)initBoard
{
    CGFloat size = (self.boardView.frame.size.width - MARGIN) / NUMBER_OF_ROWS;
    NSMutableArray *rowTiles = [NSMutableArray array];
    for (int i = 0; i < self.board.rows; i++)
    {
        NSMutableArray *columnTiles = [NSMutableArray array];
        for (int j = 0; j < self.board.columns; j++)
        {
            MineSweeperCell *cell = [[self.board.cells objectAtIndex:i] objectAtIndex:j];
            
            MineSweeperTile *tile = [[MineSweeperTile alloc] initWithCell:cell size:size];
            [tile addTarget:self action:@selector(mineSweeperTilePressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [columnTiles addObject:tile];
            [self.boardView addSubview:tile];
        }
        [rowTiles addObject:columnTiles];
    }
    self.mineSweeperTiles = rowTiles;
}

- (void)resetBoard
{
    [self.board resetBoard];
    for (int i = 0; i < self.board.rows; i++) {
        for (int j = 0; j < self.board.columns; j++) {
            MineSweeperTile *tile = [[self.mineSweeperTiles objectAtIndex:i] objectAtIndex:j];
            [tile setSelected:NO];
        }
    }
}

- (IBAction)newGamePressed:(id)sender
{
    [self resetBoard];
}

- (IBAction)cheatPressed:(id)sender
{
    for (MineSweeperCell *cell in self.board.mines) {
        MineSweeperTile *tile = [[self.mineSweeperTiles objectAtIndex:cell.x] objectAtIndex:cell.y];
        [tile revealMine];
    }
}

- (IBAction)validatePressed:(id)sender
{
    if ([self.board validateBoard]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Congratulations!"
                                                            message:@"You won the minesweeper game."
                                                           delegate:self
                                                  cancelButtonTitle:@"New Game"
                                                  otherButtonTitles: nil];
        [alertView show];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"You have not completed the minesweeper game."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
        [alertView show];
    }
}

- (void)mineSweeperTilePressed:(MineSweeperTile *)sender
{
    [sender setSelected:YES];
    
    if (sender.cell.isMine) {
        [self endGame];
    }
    else {
        if (sender.cell.neighborMines == 0 && !sender.cell.isMine) {
            [self expandEmptyMineSweeperCellsForCell:sender.cell];
        }
    }
}

- (void)expandEmptyMineSweeperCellsForCell:(MineSweeperCell *)cell
{
    NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSetWithObjects:cell, nil];
    while (orderedSet.count > 0) {
        MineSweeperCell *cell= [orderedSet firstObject];
        [orderedSet removeObject:cell];
        NSArray *neighborCells = [self.board neighborMineSweeperCellsForCell:cell];
        for (MineSweeperCell *cell in neighborCells)
        {
            if (cell.neighborMines == 0 && !cell.isMine && !cell.visited) {
                [orderedSet addObject:cell];
            }
            MineSweeperTile *tile = [[self.mineSweeperTiles objectAtIndex:cell.x] objectAtIndex:cell.y];
            [tile setSelected:YES];
        }
    }
}

- (void)endGame
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"BOOM"
                                                        message:@"You blew up a mine!"
                                                       delegate:self
                                              cancelButtonTitle:@"New Game"
                                              otherButtonTitles: nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"New Game"]) {
        [self newGamePressed:nil];
    }
}

@end
