--[[
    constants
]]

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 640
VIRTUAL_HEIGHT = 360

-- tile size
TILE_SIZE = 32

-- board offsets
BOARD_OFFSET_X = 192
BOARD_OFFSET_Y = 52

-- piece indexes
WHITE_PAWN = 15
WHITE_ROOK = 14
WHITE_KNIGHT = 13
WHITE_BISHOP = 7
WHITE_QUEEN = 6
WHITE_KING = 5
BLACK_PAWN = 11
BLACK_ROOK = 10
BLACK_KNIGHT = 9
BLACK_BISHOP = 3
BLACK_QUEEN = 2
BLACK_KING = 1

-- decorative piece indexes
DEC_WHITE_KING = 21
DEC_WHITE_QUEEN = 22
DEC_BLACK_KING = 17
DEC_BLACK_QUEEN = 18

-- UI constants
MENU_BUTTON_WIDTH = VIRTUAL_WIDTH / 4
MENU_BUTTON_HEIGHT = 40

PLAY_BUTTON_WIDTH = 16
PLAY_BUTTON_HEIGHT = 16

RESTART_BUTTON = 118
HOME_BUTTON = 143

TAKEN_PIECES_W_START = 475
TAKEN_PIECES_B_START = 5
PAWN_Y_START = 75

-- piece values
PIECE_VALUE = {
    pawn = 1, knight = 3, bishop = 3, rook = 5, queen = 9, king = 0
}

-- piece square tables
PST_PAWN = {
    -- Rank 8 (Black's 1st rank - promoting here is ideal)
    { 0,  0,  0,  0,  0,  0,  0,  0 }, -- Should be handled by promotion logic
    -- Rank 7 (Close to promotion)
    { 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5 },
    -- Rank 6
    { 0.1, 0.1, 0.2, 0.3, 0.3, 0.2, 0.1, 0.1 },
    -- Rank 5
    { 0.05, 0.05, 0.1, 0.25, 0.25, 0.1, 0.05, 0.05 },
    -- Rank 4
    { 0,  0,  0, 0.2, 0.2,  0,  0,  0 },
    -- Rank 3
    { 0.05, -0.05, -0.1,  0,  0, -0.1, -0.05, 0.05 },
    -- Rank 2 (Starting rank)
    { 0,  0,  0,  0,  0,  0,  0,  0 },
    -- Rank 1 (Start of board)
    { 0,  0,  0,  0,  0,  0,  0,  0 }
}

PST_KNIGHT = {
    -- Rank 8
    { -0.5, -0.4, -0.3, -0.3, -0.3, -0.3, -0.4, -0.5 },
    -- Rank 7
    { -0.4, -0.2,   0,   0,   0,   0, -0.2, -0.4 },
    -- Rank 6
    { -0.3,   0,  0.1,  0.15,  0.15,  0.1,   0, -0.3 },
    -- Rank 5
    { -0.3,  0.05,  0.15,  0.2,  0.2,  0.15,  0.05, -0.3 },
    -- Rank 4
    { -0.3,   0,  0.15,  0.2,  0.2,  0.15,   0, -0.3 },
    -- Rank 3
    { -0.3,  0.05,  0.1,  0.15,  0.15,  0.1,  0.05, -0.3 },
    -- Rank 2
    { -0.4, -0.2,   0,  0.05,  0.05,   0, -0.2, -0.4 },
    -- Rank 1
    { -0.5, -0.4, -0.3, -0.3, -0.3, -0.3, -0.4, -0.5 }
}

PST_BISHOP = {
    -- Rank 8
    { -0.2, -0.1, -0.1, -0.1, -0.1, -0.1, -0.1, -0.2 },
    -- Rank 7
    { -0.1,   0,   0,   0,   0,   0,   0, -0.1 },
    -- Rank 6
    { -0.1,   0,  0.05,  0.1,  0.1,  0.05,   0, -0.1 },
    -- Rank 5
    { -0.1,  0.05,  0.05,  0.1,  0.1,  0.05,  0.05, -0.1 },
    -- Rank 4
    { -0.1,   0,  0.1,  0.1,  0.1,  0.1,   0, -0.1 },
    -- Rank 3
    { -0.1,  0.1,  0.1,  0.1,  0.1,  0.1,  0.1, -0.1 },
    -- Rank 2
    { -0.1,  0.05,   0,   0,   0,   0,  0.05, -0.1 },
    -- Rank 1
    { -0.2, -0.1, -0.1, -0.1, -0.1, -0.1, -0.1, -0.2 }
}

PST_ROOK = {
    -- Rank 8
    { 0,  0,  0,  0.05,  0.05,  0,  0,  0 },
    -- Rank 7 (Very strong for attack and pawns)
    { 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5 },
    -- Rank 6
    { -0.1,  0,  0,  0,  0,  0,  0, -0.1 },
    -- Rank 5
    { -0.1,  0,  0,  0,  0,  0,  0, -0.1 },
    -- Rank 4
    { -0.1,  0,  0,  0,  0,  0,  0, -0.1 },
    -- Rank 3
    { -0.1,  0,  0,  0,  0,  0,  0, -0.1 },
    -- Rank 2
    { -0.1,  0,  0,  0,  0,  0,  0, -0.1 },
    -- Rank 1 (Starting rank - prefer open files)
    { 0,  0,  0,  0.05,  0.05,  0,  0,  0 }
}

PST_QUEEN = {
    -- Rank 8
    { -0.2, -0.1, -0.1, -0.05, -0.05, -0.1, -0.1, -0.2 },
    -- Rank 7
    { -0.1,   0,   0,  0,  0,   0,   0, -0.1 },
    -- Rank 6
    { -0.1,   0,  0.05,  0.05,  0.05,  0.05,   0, -0.1 },
    -- Rank 5
    { -0.1,   0,  0.05,  0.05,  0.05,  0.05,   0, -0.1 },
    -- Rank 4
    { -0.1,   0,  0.05,  0.05,  0.05,  0.05,   0, -0.1 },
    -- Rank 3
    { -0.1,   0,  0.05,  0.05,  0.05,  0.05,   0, -0.1 },
    -- Rank 2
    { -0.1,   0,   0,  0,  0,   0,   0, -0.1 },
    -- Rank 1
    { -0.2, -0.1, -0.1, -0.05, -0.05, -0.1, -0.1, -0.2 }
}

PST_KING_MG = {
    -- Rank 8 (Opponent's side)
    { -0.3, -0.4, -0.4, -0.5, -0.5, -0.4, -0.4, -0.3 },
    -- Rank 7
    { -0.3, -0.4, -0.4, -0.5, -0.5, -0.4, -0.4, -0.3 },
    -- Rank 6
    { -0.3, -0.4, -0.4, -0.5, -0.5, -0.4, -0.4, -0.3 },
    -- Rank 5
    { -0.3, -0.4, -0.4, -0.5, -0.5, -0.4, -0.4, -0.3 },
    -- Rank 4
    { -0.2, -0.3, -0.3, -0.4, -0.4, -0.3, -0.3, -0.2 },
    -- Rank 3
    { -0.1, -0.2, -0.2, -0.2, -0.2, -0.2, -0.2, -0.1 },
    -- Rank 2 (Where castling ends up)
    {  0.2,  0.3,  0.1,   0,   0,  0.1,  0.3,  0.2 },
    -- Rank 1 (Starting rank - encourages castling)
    {  0.2,  0.3,  0.1,   0,   0,  0.1,  0.3,  0.2 }
}

PST_KING_EG = {
    -- Rank 8 (Opponent's side)
    { -0.5, -0.3, -0.3, -0.3, -0.3, -0.3, -0.3, -0.5 },
    -- Rank 7
    { -0.3, -0.1,  0.1,  0.1,  0.1,  0.1, -0.1, -0.3 },
    -- Rank 6
    { -0.3,  0.1,  0.2,  0.2,  0.2,  0.2,  0.1, -0.3 },
    -- Rank 5
    { -0.3,  0.1,  0.2,  0.2,  0.2,  0.2,  0.1, -0.3 },
    -- Rank 4
    { -0.3,  0.1,  0.2,  0.2,  0.2,  0.2,  0.1, -0.3 },
    -- Rank 3
    { -0.3, -0.1,  0.1,  0.1,  0.1,  0.1, -0.1, -0.3 },
    -- Rank 2
    { -0.5, -0.3, -0.3, -0.3, -0.3, -0.3, -0.3, -0.5 },
    -- Rank 1 (Edges are bad)
    { -0.5, -0.3, -0.3, -0.3, -0.3, -0.3, -0.3, -0.5 }
}

PSTs = {
    pawn = PST_PAWN,
    knight = PST_KNIGHT,
    bishop = PST_BISHOP,
    rook = PST_ROOK,
    queen = PST_QUEEN,
    king = PST_KING_MG
}