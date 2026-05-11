INCLUDE "hardware.inc"

SECTION "Header", ROM0[$100]

	jp EntryPoint

	ds $150 - @, 0 ; Make room for the header

EntryPoint:
	; Shut down audio circuitry
	ld a, 0
	ld [rNR52], a

	; Do not turn the LCD off outside of VBlank
WaitVBlank:
	ld a, [rLY]
	cp 144
	jp c, WaitVBlank

	; Turn the LCD off
	ld a, 0
	ld [rLCDC], a

	; Copy the tile data
	ld de, Tiles
	ld hl, $9000
	ld bc, TilesEnd - Tiles
CopyTiles:
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, CopyTiles

	; Copy the tilemap
	ld de, Tilemap
	ld hl, $9800
	ld c, SCREEN_HEIGHT
CopyTilemapRow:
        ld b, SCREEN_WIDTH
CopyTilemapTile:
        ld a, [de]
        ld [hli], a
        inc de
        dec b
        jp nz, CopyTilemapTile

        ; Row finished. Skip the 12 off-screen padding tiles
        push bc
        ld bc, 12
        add hl, bc
        pop bc

        dec c
        jp nz, CopyTilemapRow

	; Turn the LCD on
	ld a, LCDC_ON | LCDC_BG_ON
	ld [rLCDC], a

	; During the first (blank) frame, initialize display registers
	ld a, %11100100 ; Standard palette: Black, Dark Gray, Light Gray, White
	ld [rBGP], a

Done:
	jp Done


SECTION "Tile data", ROM0

Tiles:
	INCBIN "duckdemo.2bpp"
TilesEnd:

SECTION "Tilemap", ROM0

Tilemap:
	INCBIN "duckdemo.tilemap"
TilemapEnd:

