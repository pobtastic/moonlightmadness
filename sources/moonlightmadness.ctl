; Copyright Bubble Bus Software 1986, 2026 ArcadeGeek LTD.
; NOTE: Disassembly is Work-In-Progress.
; Label naming is loosely based on Action_ActionName_SubAction
; e.g. Print_HighScore_Loop.

> $4000 @rom
> $4000 @start
> $4000 @expand=#DEF1(#SKOOLKID(addr,anchor=0)(name)#HTML(<a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/#IF({{mode[base]}}==16)(hex/)asm/#IF({{mode[base]}}==16)(#EVAL({addr},16,4),#EVAL({addr})).html#IF({anchor})(#CHR(35)#IF({{mode[base]}}==16)(#EVAL({anchor},16,4),#EVAL({anchor})))">){name}#HTML(</a>))
> $4000 @expand=#DEF(#POKE()(anchor,text) #LINK(Pokes#$anchor)($text))
> $4000 @expand=#DEF(#ANIMATE(delay,count=$50)(name=$a)#FRAMES#(($name-1,$delay;#FOR$02,$count||x|$name-x|;||))($name-animation))
> $4000 @expand=#DEF(#INK(id)#LET(bright=$id&$40)#LET(flash=$id&$80)#LET(ink=$id&$07)#IF({ink}>=$00)(#MAP({ink})(UNKNOWN,0:BLACK,1:BLUE,2:RED,3:MAGENTA,4:GREEN,5:CYAN,6:YELLOW,7:WHITE))#IF({bright}>$00)( (BRIGHT))#IF({flash}>$00)( (FLASH: ON)))
> $4000 @expand=#DEF(#SPRITE(id,attr=$47,base=$9070)(fname)#UDG($base+$08*($id-$01),attr=$attr,scale=$04)($fname))
> $4000 @expand=#DEF(#GLYPH(id,attr=$47,base=$7C70)(fname)#UDG($base+$08*$id,attr=$attr,scale=$04)($fname))
> $4000 @expand=#IF({asm})(#DEF(#BOOTY(addr)(link=Booty)$link))
> $4000 @expand=#IF({asm}==0)(#DEF1(#BOOTY(addr)#HTML(<a href="/booty/#IF({{mode[base]}}==16)(,dec/)asm/#IF({{mode[base]}}==16)(#EVAL({addr},16,4),#EVAL({addr})).html">Booty</a>)))
> $4000 @set-handle-unsupported-macros=1
b $4000 Loading Screen
D $4000 #UDGTABLE
. { =h Moonlight Madness Loading Screen. }
. { #SCR$02(loading) }
. UDGTABLE#
@ $4000 label=Loading
  $4000,$0885,$20 Pixels.

c $4885 Decrypt Game
@ $4885 label=Decrypt_Game
D $4885 After the tape load, the game is still encoded. This stub
. sits in the loading-screen bitmap, restores the #N$7F94 bytes
. below #N$FFFE, then starts the title/menu at #R$D5AC.
  $4885,$04 Use the whole screen; no rows are reserved for BASIC.
  $4889,$09 Point at the last encoded byte and set the length to
. #N$7F94.
N $4892 Undo the tape encoding: complement, subtract one, and store
. the byte one address higher. Walks backwards through the loaded
. game until every encoded byte is restored.
@ $4892 label=Decrypt_Game_Loop
  $4892,$07 Decode one byte and step both pointers down.
  $4899,$05 Jump to #R$4892 until the whole image is restored.
  $489E,$03 Jump to #R$D5AC.

b $48A1 Loading Screen Remainder
D $48A1 The rest of the loading-screen bitmap after #R$4885.
  $48A1,$0D5F,$20 Pixels.

b $5800 Loading Screen Attributes
@ $5800 label=Loading_Attributes
  $5800,$0300,$20 Attributes.

u $5B00

t $5D32 Messaging: Credits
@ $5D32 label=Messaging_Credits
D $5D32 Leftover loader/BASIC credits in the system variable area.
  $5D32,$20 "#STR(#PC,$04,$20)".
  $5D52,$14 "#STR(#PC,$04,$14)".

u $5D66

g $5DCE Buffer: Room Tiles
@ $5DCE label=Buffer_RoomTiles
D $5DCE #N$20 column by #N$19 row tile buffer. #R$E3B3 clears it, and
. the print utilities write through it when drawing a room.
B $5DCE,$0320,$20

g $60EE Buffer: Room Attributes
@ $60EE label=Buffer_RoomAttributes
D $60EE Attribute bytes matching #R$5DCE.
B $60EE,$0320,$20

g $640E Pointer: Active Font
@ $640E label=Pointer_ActiveFont
W $640E,$02

g $6410 Player Jump Timer
@ $6410 label=Player_JumpTimer
D $6410 Non-zero while the player is jumping or falling.
B $6410,$01

g $6411 Restart Room Flag
@ $6411 label=RestartRoomFlag
D $6411 Set when a life is lost so #R$E1CC can restart the room.
B $6411,$01

g $6412 Print Buffer Offset
@ $6412 label=Print_BufferOffset
D $6412 Offset into #R$5DCE calculated by #R$F6AA.
W $6412,$02

u $6414
B $6414,$02

g $6416 Print Width
@ $6416 label=Print_Width
B $6416,$01

g $6417 Temporary Pair
@ $6417 label=TemporaryPair
W $6417,$02

g $6419 Clip Window
@ $6419 label=ClipWindow
D $6419 Inclusive min/max row and column used by the clipped print
. routines. Defaults to rows #N$02-#N$18 and columns #N$01-#N$21.
B $6419,$01 Minimum row
@ $641A label=ClipWindow_MaximumRow
B $641A,$01 Maximum row
@ $641B label=ClipWindow_MinimumColumn
B $641B,$01 Minimum column
B $641C,$01 Maximum column

g $641D Active Border Colour
@ $641D label=Active_BorderColour
E $641D View the equivalent code in #BOOTY$5BD0.
B $641D,$01

g $641E Pointer: Room Header
@ $641E label=Pointer_RoomHeader
W $641E,$02

g $6420 Reference: Furniture
@ $6420 label=ReferenceFurniture
D $6420 Populated by #R$EA02. See #R$DF8E for usage.
E $6420 View the equivalent code in #BOOTY$5BE2.
W $6420,$02

g $6422 Reference: Doors
@ $6422 label=ReferenceDoors
D $6422 Populated by #R$EA02. See #R$DFD0 for usage.
E $6422 View the equivalent code in #BOOTY$5BD6.
W $6422,$02

g $6424 Reference: Collectibles
@ $6424 label=ReferenceCollectibles
D $6424 Three-byte #N$FF-terminated records. See #R$D7D2.
W $6424,$02

g $6426 Reference: Inventory Items
@ $6426 label=ReferenceInventoryItems
D $6426 Two-byte #N$FF-terminated key records. See #R$DBC9.
W $6426,$02

g $6428 Reference: Ladders
@ $6428 label=ReferenceLadders
D $6428 Populated by #R$EA02. See #R$E013 and #R$E06A.
E $6428 View the equivalent code in #BOOTY$5BD8.
W $6428,$02

g $642A Reference: Moving Objects
@ $642A label=ReferenceMovingObjects
D $642A #N$13-byte records drawn by #R$D894.
W $642A,$02

g $642E Reference: Decorations
@ $642E label=ReferenceDecorations
W $642E,$02

g $6430 Reference: Actors
@ $6430 label=ReferenceActors
D $6430 #N$0D-byte records handled by #R$E3DE.
W $6430,$02

g $6432 Reference: Enemies
@ $6432 label=ReferenceEnemies
D $6432 #N$0E-byte records handled by #R$DC62.
W $6432,$02

g $6434 Collision State
@ $6434 label=CollisionState
D $6434 #N$03 means the player has touched an actor.
B $6434,$01

g $6435 Player Hit Timer
@ $6435 label=Player_HitTimer
B $6435,$01

g $6436 Temporary Flags
@ $6436 label=TemporaryFlags
B $6436,$02

g $6438 Player Stand Timer
@ $6438 label=Player_StandTimer
D $6438 Counts falling frames; a hit starts when it reaches #N$0A.
B $6438,$01

u $6439
B $6439,$01

g $643A Player Mask
@ $643A label=Player_Mask
D $643A Three-byte shifted collision mask from #R$DE96.
B $643A,$03

u $643D
B $643D,$01

g $643E Sprite Shift Buffer
@ $643E label=Sprite_ShiftBuffer
B $643E,$02

g $6440 Actor Mask Buffer
@ $6440 label=Actor_MaskBuffer
B $6440,$08

g $6448 Player Footprint
@ $6448 label=Player_Footprint
B $6448,$01 Width
B $6449,$01 Offset

g $644A Hit Ceiling Row
@ $644A label=HitCeilingRow
B $644A,$01

g $644B Pointer: Collided Actor
@ $644B label=Pointer_CollidedActor
W $644B,$02

g $644D Special Actor
@ $644D label=SpecialActor
D $644D Used by the room-#N$07 balls and the room-#N$16 special.
B $644D,$0E

u $645B
B $645B,$0E

g $6469 Pointer: Tune Data
@ $6469 label=Pointer_TuneData
D $6469 Walks the #R$B370 stream. #R$E666 reads one byte at a time.
W $6469,$02

g $646B Pointer: Tune Data Copy
@ $646B label=Pointer_TuneDataCopy
D $646B Walks the #R$B491 stream in step with #R$6469.
W $646B,$02

g $646D Current Tune Byte
@ $646D label=CurrentTuneByte
B $646D,$01

g $646E Interrupt Tick
@ $646E label=InterruptTick
D $646E Counts to #N$05 in #R$E46C before the tune is allowed to play.
B $646E,$01

g $646F Game Active Flag
@ $646F label=GameActiveFlag
D $646F #N$00 on the introduction/menu. #N$FF after the intro timeout
. so #R$D5AC starts a game.
B $646F,$01

g $6470 Pause Timer
@ $6470 label=PauseTimer
D $6470 16-bit countdown used by the introduction and demo timeout.
W $6470,$02

g $6472 Sound Flags
@ $6472 label=SoundFlags
B $6472,$01

g $6473 Sound Duration
@ $6473 label=SoundDuration
B $6473,$01

u $6474
B $6474,$08

g $647C Skip Delay Flag
@ $647C label=SkipDelayFlag
D $647C When set, #R$E666 returns through the delay routine instead
. of playing a note.
B $647C,$01

g $647D Game Complete Flag
@ $647D label=GameCompleteFlag
D $647D Set to #N$FF by #R$D7FF when the combination is complete
. (every #R$64C1 digit is #N$09).
B $647D,$01

g $647E Control Method
@ $647E label=ControlMethod
D $647E #N$00 is keyboard. Non-zero selects Kempston (and the
. define-keys highlight).
E $647E View the equivalent code in #BOOTY$5BEA.
B $647E,$01

g $647F User-Defined Keys
@ $647F label=UserDefinedKeys
D $647F Five #SKOOLKID$028E(KEY_SCAN) codes copied from #R$E6EC.
. Order: left, right, up, down, action.
E $647F View the equivalent code in #BOOTY$5BEB.
B $647F,$01 Left
@ $6480 label=UserDefinedKey_Right
B $6480,$01 Right
B $6481,$01 Up
B $6482,$01 Down
B $6483,$01 Action

g $6484 Saved Keys
@ $6484 label=SavedKeys
W $6484,$02

g $6486 Kempston Masks
@ $6486 label=KempstonMasks
D $6486 Default #N$01/#N$02 (right/left) written by #R$EA02.
W $6486,$02

g $6488 Tape Checksum
@ $6488 label=TapeChecksum
B $6488,$01

g $6489 Action Timer
@ $6489 label=ActionTimer
B $6489,$01

g $648A Climb Row
@ $648A label=ClimbRow
B $648A,$01

g $648B Carried Object
@ $648B label=CarriedObject
D $648B Bit 7 set means nothing is being carried. Drawn by #R$DA3F.
B $648B,$14

g $649F Event Timer
@ $649F label=EventTimer
D $649F Counts down; when it hits #N$00 #R$DC26 fires *#R$64A0.
B $649F,$01

g $64A0 Pending Event
@ $64A0 label=PendingEvent
B $64A0,$01

g $64A1 Collected Keys
@ $64A1 label=CollectedKeys
D $64A1 Number of keys collected. #R$DA15 highlights this slot.
B $64A1,$01

g $64A2 Current Room
@ $64A2 label=CurrentRoom
D $64A2 Room IDs run from #N$00 to #N$16.
E $64A2 View the equivalent code in #BOOTY$5BD3.
B $64A2,$01

g $64A3 Temporary Room
@ $64A3 label=TempCurrentRoom
B $64A3,$01

g $64A4 Player
@ $64A4 label=Player
D $64A4 Player entity used as #REGix by #R$E1CC.
E $64A4 View the equivalent code in #BOOTY$F231.
B $64A4,$01 Column
@ $64A5 label=Player_Row
B $64A5,$01 Row
@ $64A6 label=Player_FineX
B $64A6,$01 Fine-X
@ $64A7 label=Player_FineY
B $64A7,$01 Fine-Y
B $64A8,$02
@ $64AA label=Player_SpriteFrame
B $64AA,$01 Sprite frame
@ $64AB label=Player_Facing
B $64AB,$01 Facing / state
@ $64AC label=Player_HorizontalDelta
B $64AC,$01 Horizontal delta
@ $64AD label=Player_VerticalDelta
B $64AD,$01 Vertical delta

g $64B2 Random Number Seed
@ $64B2 label=RandomNumberSeed
E $64B2 View the equivalent code in #BOOTY$F343.
W $64B2,$02

g $64B4 Player Lives
@ $64B4 label=Player_Lives
D $64B4 Initialised to #N$04 by #R$EA02.
E $64B4 View the equivalent code in #BOOTY$5BF1.
B $64B4,$01

u $64B5
B $64B5,$0C

g $64C1 Collection Slots
@ $64C1 label=CollectionSlots
D $64C1 Four combination digits shown on room #N$00. #N$09 in
. every slot is the completed combination and sets #R$647D.
B $64C1,$01
@ $64C2 label=CollectionSlot_Two
B $64C2,$01
@ $64C3 label=CollectionSlot_Three
B $64C3,$01
@ $64C4 label=CollectionSlot_Four
B $64C4,$01

g $64C5 Table: Room Data
@ $64C5 label=Table_RoomData
D $64C5 One pointer per room, filled by #R$EA02 from #R$BC11.
E $64C5 View the equivalent code in #BOOTY$BAA9.
W $64C5,$2E,$02

g $64F7 Buffer: Unpacked Rooms
@ $64F7 label=Buffer_UnpackedRooms
D $64F7 Working copy of the #N$17 packed rooms. See #R$EA02.
B $64F7,$1779

b $7C70 Buffer: Active Font
@ $7C70 label=Buffer_ActiveFont
D $7C70 #SKOOLKID$5C36(CHARS) is pointed here in-game. #R$ED2D,
. #R$ED39 and #R$ED45 copy a font bank over this buffer.
B $7C70,$0800,$08

b $8470 Graphics: Font Bank 1
@ $8470 label=Graphics_FontBank1
D $8470 Copied to #R$7C70 by #R$ED2D.
  $8470,$08 #UDGTABLE(default,centre)
. { #N((#PC-$8470)/$08) } { #UDG(#PC) }
. UDGTABLE#
L $8470,$08,$80

b $8870 Graphics: Font Bank 2
@ $8870 label=Graphics_FontBank2
D $8870 Copied to #R$7C70 by #R$ED39.
  $8870,$08 #UDGTABLE(default,centre)
. { #N((#PC-$8870)/$08) } { #UDG(#PC) }
. UDGTABLE#
L $8870,$08,$80

b $8C70 Graphics: Font Bank 3
@ $8C70 label=Graphics_FontBank3
D $8C70 Copied to #R$7C70 by #R$ED45.
  $8C70,$08 #UDGTABLE(default,centre)
. { #N((#PC-$8C70)/$08) } { #UDG(#PC) }
. UDGTABLE#
L $8C70,$08,$80

b $9070 Graphics: Tile Font
@ $9070 label=Graphics_TileFont
D $9070 Alternate #SKOOLKID$5C36(CHARS) used for enemies and some
. scenery.
. #UDGTABLE
. { #FONT$9070,attr=$07,chars=$0100(tile-font) }
. UDGTABLE#
  $9070,$08 #UDGTABLE(default,centre)
. { #N((#PC-$9070)/$08) } { #UDG(#PC) }
. UDGTABLE#
L $9070,$08,$0100

b $9870 Introduction Screen
@ $9870 label=IntroductionScreen
D $9870 #PUSHS #UDGTABLE
. { =h Moonlight Madness Introduction Screen. }
. { #SIM(start=$D5E0,stop=$D5EB) #SCR$02(introduction-screen) }
. UDGTABLE# #POPS
E $9870 View the equivalent code in #BOOTY$6978.
  $9870,$1800,$20 Pixels.
  $B070,$0300,$20 Attributes.

b $B370 Data: Tune Stream
@ $B370 label=Data_TuneStream
D $B370 Note stream walked by #R$E666. #N$FF wraps back to the start.
B $B370,$121

b $B491 Data: Tune Stream Copy
@ $B491 label=Data_TuneStreamCopy
D $B491 Duration stream walked in step with #R$B370.
B $B491,$120

b $B5B1 Graphics: Player
@ $B5B1 label=Graphics_PlayerFont
D $B5B1 #SKOOLKID$5C36(CHARS) while #R$E1CC draws the player.
. Each frame is #N$02 tiles wide by #N$03 tall. Walking steps
. the glyph by #N$06 (wrapping at #N$30); standing uses #N$60.
. #R$DE96 reads the shifted mask at #R$B5D8.
. #UDGTABLE(default,centre)
. { #N$00 | #UDGS$02,$03,$04(player-1*)(
. #UDG($B5B1+$08*($02*$y+$x),attr=$45)(*player)player) }
. { #N$06 | #UDGS$02,$03,$04(player-2*)(
. #UDG($B5E1+$08*($02*$y+$x),attr=$45)(*player)player) }
. { #N$0C | #UDGS$02,$03,$04(player-3*)(
. #UDG($B611+$08*($02*$y+$x),attr=$45)(*player)player) }
. { #N$12 | #UDGS$02,$03,$04(player-4*)(
. #UDG($B641+$08*($02*$y+$x),attr=$45)(*player)player) }
. { #N$18 | #UDGS$02,$03,$04(player-5*)(
. #UDG($B671+$08*($02*$y+$x),attr=$45)(*player)player) }
. { #N$1E | #UDGS$02,$03,$04(player-6*)(
. #UDG($B6A1+$08*($02*$y+$x),attr=$45)(*player)player) }
. { #N$24 | #UDGS$02,$03,$04(player-7*)(
. #UDG($B6D1+$08*($02*$y+$x),attr=$45)(*player)player) }
. { #N$2A | #UDGS$02,$03,$04(player-8*)(
. #UDG($B701+$08*($02*$y+$x),attr=$45)(*player)player) }
. { #N$60 | #UDGS$02,$03,$04(player-stand)(
. #UDG($B8B1+$08*($02*$y+$x),attr=$45)(*player)player) }
. UDGTABLE#
E $B5B1 #UDGTABLE { #ANIMATE$0F,$08(player) } UDGTABLE#
B $B5B1,$27

b $B5D8 Data: Player Masks
@ $B5D8 label=Data_PlayerMasks
D $B5D8 Shifted bit-masks used by #R$DE96.
B $B5D8,$639

b $BC11 Data: Rooms
@ $BC11 label=Data_Rooms
D $BC11 Packed data for the #N$17 rooms. #R$EA02 unpacks each room
. into #R$64F7.
E $BC11 View the equivalent code in #BOOTY$ABD6.
B $BC11,$16ED

b $D2FE Graphics: Menu Font
@ $D2FE label=Graphics_MenuFont
D $D2FE Six-row capital letters used on the introduction screen.
. #UDGTABLE
. { #FONT$D2FE,attr=$07,chars=$10(menu-font) }
. UDGTABLE#
  $D2FE,$08 #UDGTABLE(default,centre)
. { #N((#PC-$D2FE)/$08) } { #UDG(#PC) }
. UDGTABLE#
L $D2FE,$08,$10
B $D37E,$03

b $D381 Graphics: Introduction Frames
@ $D381 label=Graphics_IntroductionFrames
@ $D3A1 label=Graphics_IntroductionFrame2
@ $D3C1 label=Graphics_IntroductionFrame3
@ $D3E1 label=Graphics_IntroductionFrame4
D $D381 Bat/moon UDGs animated by #R$E51D. The four starting
. frames are #R$D381, #R$D3A1, #R$D3C1 and #R$D3E1.
E $D381 #UDGTABLE { #ANIMATE$0F,$0A(intro-frame) } UDGTABLE#
  $D381,$20,$08 #LET(filename=#EVAL($01+(#PC-$D381)/$20))
. #UDGTABLE(default,centre)
. { #UDGS$02,$02,$04(#FORMAT(intro-frame-{filename}*))(
. #UDG(#PC+$08*($02*$y+$x))(*intro-frame)intro-frame) }
. UDGTABLE#
L $D381,$20,$0A

u $D4C1 Source Code Remnants
@ $D4C1 label=SourceCodeRemnants
D $D4C1 Assembler text left in the snapshot.
E $D4C1 View the equivalent code in #BOOTY$A16C.
T $D4E2,$09 #STR(#PC,$04,$09)
T $D4EC,$08 #STR(#PC,$04,$08)
T $D4F4,$0A #STR(#PC,$04,$0A)
T $D4FE,$0B #STR(#PC,$04,$0B)
T $D509,$07 #STR(#PC,$04,$07)
T $D519,$0B #STR(#PC,$04,$0B)
T $D526,$05 #STR(#PC,$04,$05)
T $D52C,$0B #STR(#PC,$04,$0B)
T $D539,$05 #STR(#PC,$04,$05)
T $D53F,$0B #STR(#PC,$04,$0B)
T $D54C,$07 #STR(#PC,$04,$07)
T $D554,$07 #STR(#PC,$04,$07)
T $D55B,$08 #STR(#PC,$04,$08)
T $D563,$04 #STR(#PC,$04,$04)
T $D568,$0A #STR(#PC,$04,$0A)
T $D572,$0A #STR(#PC,$04,$0A)
T $D57C,$07 #STR(#PC,$04,$07)
T $D583,$06 #STR(#PC,$04,$06)
T $D589,$0A #STR(#PC,$04,$0A)
T $D593,$0A #STR(#PC,$04,$0A)
T $D59D,$06 #STR(#PC,$04,$06)
T $D5A3,$06 #STR(#PC,$04,$06)

c $D5AC Initialise Game
@ $D5AC label=Initialise_Game
D $D5AC Sets up the stack, copies the default keys, shows the
. introduction screen and installs the interrupt handler.
E $D5AC View the equivalent code in #BOOTY$CD14.
  $D5AC,$01 Disable interrupts.
  $D5AD,$04 #REGsp=#N$5BFF.
  $D5B1,$0B Copy #N($0007,$04,$04) bytes from #R$E6EC to #R$647F.
  $D5BC,$07 Write #N$00 to: #LIST
. { *#R$647E }
. { *#R$647C }
. LIST#
  $D5C3,$06 Write #R$B370 to *#R$6469.
  $D5C9,$06 Write #R$B491 to *#R$646B.
  $D5CF,$06 Keep bit 7 of the refresh register set.
N $D5D5 Reset the introduction / demo state.
@ $D5D5 label=Reset_Introduction
  $D5D5,$04 Write #N$00 to *#R$646F.
  $D5D9,$01 Disable interrupts.
  $D5DA,$04 Write #N$00 to *#R$641D.
  $D5DE,$02 Set the border to #INK$00.
  $D5E0,$0B Copy #N$1B00 bytes from #R$9870 to #N$4000.
  $D5EB,$07 Write #N$0190 to *#R$6470.
  $D5F2,$03 Call #R$E51D.
N $D5F5 Install IM #N$02. Every interrupt vector in the #N$FD page
. holds #N$FE, so the CPU jumps to #R$FEFE, which jumps to #R$E46C.
  $D5F5,$05 Write #N$C3 to *#R$FEFE.
  $D5FA,$01 Disable interrupts.
  $D5FB,$06 Write #R$E46C after the jump at #R$FEFE.
  $D601,$04 Write #N$00 to *#R$646E.
  $D605,$06 Write #N($0000,$04,$04) to *#R$6472.
  $D60B,$04 Set #N$FD as the high-order byte in #REGi.
  $D60F,$02 Set interrupt mode #N$02.
  $D611,$03 Call #R$F42A.
  $D614,$01 Enable interrupts.
  $D615,$07 Jump to #R$D730 if *#R$646F is set (start a game).
  $D61C,$04 Write #N$00 to *#R$641D.
  $D620,$02 Set the border to #INK$00.
  $D622,$06 Write #N$3C00 to *#SKOOLKID$5C36(CHARS).
@ $D628 label=Draw_Menu
  $D628,$03 Call #R$E3B3.
N $D62B Print the introduction menu.
@ $D62B label=Print_Menu
  $D62B,$06 Print the messaging at #R$E6F3.
  $D631,$06 Print the messaging at #R$E73C.
  $D637,$06 Jump to #R$D642 if the keyboard is not selected.
  $D63D,$05 Write #INK$38 to *#SKOOLKID$5C8F(ATTR_T) so the
. keyboard line is highlighted.
@ $D642 label=Print_Menu_Keyboard
  $D642,$06 Print the messaging at #R$E750.
  $D648,$06 Jump to #R$D653 if Kempston is not selected.
  $D64E,$05 Write #INK$38 to *#SKOOLKID$5C8F(ATTR_T) so the
. Kempston line is highlighted.
@ $D653 label=Print_Menu_DefineKeys
  $D653,$06 Print the messaging at #R$E762.
  $D659,$06 Jump to #R$D673 if *#R$647E is zero.
N $D65F Wait for a Kempston menu choice.
  $D65F,$02 #REGb=#N$FF.
@ $D661 label=Menu_Kempston_Loop
  $D661,$03 Call #R$D826.
  $D664,$02 Jump to #R$D66B if the port is unstable.
  $D666,$05 Jump to #R$D730 if fire was pressed.
@ $D66B label=Menu_Kempston_Next
  $D66B,$05 Jump to #R$D661 until #REGbc is zero.
  $D670,$03 Jump to #R$D889.
N $D673 Keyboard menu. Codes are from #SKOOLKID$028E(KEY_SCAN).
@ $D673 label=Menu_Keyboard_Loop
E $D673 View the equivalent code in #BOOTY$CDD1.
  $D673,$05 Call #R$F430 with a pause of #N$03.
  $D678,$03 Call #SKOOLKID$028E(KEY_SCAN).
  $D67B,$01 #REGa=the keypress.
  $D67C,$05 Jump to #R$D730 if "0" was pressed.
  $D681,$05 Jump to #R$D889 if "1" was pressed.
  $D686,$05 Jump to #R$D88C if "2" was pressed.
  $D68B,$04 Jump to #R$D673 if the key was not "3".
N $D68F Define the five user keys.
  $D68F,$03 Call #R$E3B3.
  $D692,$06 Print the messaging at #R$E6F3.
  $D698,$06 Print the messaging at #R$E78F.
@ $D69E label=DefineKeys_Restart
  $D69E,$04 Write #N$00 to *#R$647E.
  $D6A2,$02 #REGb=#N$00.
@ $D6A4 label=DefineKeys_Loop
  $D6A4,$01 Stash the key index on the stack.
  $D6A5,$0A Print at column #N$1B, row #N$05+index*#N$02.
  $D6AF,$03 Call #R$F42D.
  $D6B2,$02 Restore and restash the key index.
  $D6B4,$06 Jump to #R$D6BF unless this is the current slot.
  $D6BA,$05 Write #INK$38 to *#SKOOLKID$5C8F(ATTR_T).
@ $D6BF label=DefineKeys_PrintSlot
  $D6BF,$0B Load the key code for slot #REGb into #REGde.
  $D6CA,$05 Point at the glyph in #R$E802 for this slot.
  $D6CF,$03 Call #R$F436.
  $D6D2,$05 Write #INK$07 to *#SKOOLKID$5C8F(ATTR_T).
  $D6D7,$01 Restore the key index from the stack.
  $D6D8,$06 Increase the key index and jump to #R$D6A4 until
. five keys have been printed.
@ $D6DE label=DefineKeys_Read
  $D6DE,$06 Call #R$F430 with a pause of #N$4E20.
  $D6E4,$03 Call #SKOOLKID$028E(KEY_SCAN).
  $D6E7,$01 #REGa=the keypress.
  $D6E8,$04 Jump to #R$D6DE if no key is pressed.
  $D6EC,$04 Jump to #R$D706 if ENTER was pressed.
  $D6F0,$0A Point #REGhl at the current slot in #R$647F.
  $D6FA,$01 Write the keypress into that slot.
  $D6FB,$07 Increase *#R$647E by one.
  $D702,$04 Jump to #R$D6A4 if fewer than five keys are set.
N $D706 Reject a set that contains any duplicate key.
@ $D706 label=DefineKeys_CheckDuplicates
  $D706,$08 #REGhl=#R$647F, #REGde=#R$6480, #REGb=#N$04.
@ $D70E label=DefineKeys_Compare
  $D70E,$02 Stash the compare pointers on the stack.
@ $D710 label=DefineKeys_CompareSlot
  $D710,$04 Jump to #R$D719 if this pair differs.
  $D714,$05 Restart define-keys if a duplicate was found.
@ $D719 label=DefineKeys_CompareNext
  $D719,$01 Increase #REGde by one.
  $D71A,$02 Decrease the inner counter and loop back to #R$D710.
  $D71C,$02 Restore the compare pointers from the stack.
  $D71E,$02 Increase both pointers by one.
  $D720,$03 Jump to #R$D70E until every pair is unique.
  $D723,$06 Copy the first two keys to *#R$6484.
  $D729,$04 Write #N$00 to *#R$647E.
  $D72D,$03 Jump to #R$D628.

c $D730 Start Game
@ $D730 label=Start_Game
D $D730 Starts a new game from room #N$00.
E $D730 View the equivalent code in #BOOTY$D08A.
E $D730 Continue on to #R$D738.
  $D730,$06 Write #N$03E8 to *#R$E82A.
  $D736,$02 #REGa=#N$FF.

c $D738 Change Room
@ $D738 label=Change_Room
D $D738 Loads the room in #REGa.
E $D738 Continue on to #R$D765.
  $D738,$03 Call #R$E9FC.
  $D73B,$03 Call #R$DA15.
  $D73E,$07 Write #N$0096 to *#R$6470.
  $D745,$05 Write #N$FF to *#R$DAC3.
  $D74A,$06 Jump to #R$D765 if *#R$647D is zero.
  $D750,$06 Jump to #R$D765 if *#R$64A2 is not zero.
  $D756,$05 Call #R$E9FF with event #N$1D.
  $D75B,$05 Write #N$12 to the door pointed to by *#R$6422.
  $D760,$05 Write #N$01 to *#R$64B4.

c $D765 Game Loop
@ $D765 label=Game_Loop
D $D765 Watches demo input and *#R$6470. Jumps to #R$D7A2 while
. the game is active or the demo timer is running, else picks a
. room and jumps to #R$D738.
  $D765,$06 Jump to #R$D7A2 if *#R$646F is zero.
  $D76B,$03 Call #R$D826.
  $D76E,$02 Jump to #R$D775 if the port is unstable.
  $D770,$05 Jump to #R$D5D5 if fire was pressed.
@ $D775 label=Demo_Timeout
  $D775,$03 Call #SKOOLKID$028E(KEY_SCAN).
  $D778,$05 Jump to #R$D5D5 if any key is pressed.
  $D77D,$09 Decrease *#R$6470 by one.
  $D786,$04 Jump to #R$D7A2 until the timer is zero.
  $D78A,$07 Jump to #R$D5D5 if *#R$D888 is #N$01.
  $D791,$03 Write the decreased count back to *#R$D888.
N $D794 Pick a random room between #N$00-#N$16 and jump to #R$D738.
M $D794,$06 Generate a random number between #N$00-#N$0F in #REGe.
  $D794,$03 Call #R$F433.
  $D797,$02,b$01 Keep only bits 0-3.
  $D799,$01 Copy that room nibble into #REGe.
M $D79A,$06 Generate a random number between #N$00-#N$07 and add it to #REGe.
  $D79A,$03 Call #R$F433.
  $D79D,$02,b$01 Keep only bits 0-2.
  $D79F,$01 Add the two nibbles together.
  $D7A0,$02 Jump to #R$D738.

c $D7A2 Dispatch Handlers
@ $D7A2 label=Dispatch_Handlers
D $D7A2 Calls each frame handler, then jumps back to #R$D765.
  $D7A2,$03 Call #R$DD97.
  $D7A5,$03 Call #R$DE19.
  $D7A8,$03 Call #R$E3DE.
  $D7AB,$03 Call #R$E1CC.
  $D7AE,$03 Call #R$D7FF.
  $D7B1,$03 Call #R$DC26.
  $D7B4,$03 Call #R$DC62.
  $D7B7,$03 Call #R$D894.
  $D7BA,$03 Call #R$D9B6.
  $D7BD,$03 Call #R$D904.
  $D7C0,$03 Call #R$DB05.
  $D7C3,$03 Call #R$DBC9.
  $D7C6,$03 Call #R$D7D2.
  $D7C9,$03 Call #R$DA3F.
  $D7CC,$03 Call #R$D877.
  $D7CF,$03 Jump to #R$D765.

c $D7D2 Handler: Collectibles
@ $D7D2 label=Handler_Collectibles
D $D7D2 Walks the #N$03-byte records at *#R$6424. When the player
. stands on an active record, bit 7 is set and #R$E9FF runs.
  $D7D2,$04 #REGix=*#R$6424.
@ $D7D6 label=Handler_Collectibles_Loop
  $D7D6,$05 Return if the terminator #N$FF is reached.
  $D7DB,$05 Jump to #R$D7F8 if this record is already collected.
  $D7E0,$08 Jump to #R$D7F8 if the column does not match *#R$64A4.
  $D7E8,$08 Jump to #R$D7F8 if the row does not match *#R$64A5.
  $D7F0,$05 Set bit 7 of the record.
  $D7F5,$03 Jump to #R$E9FF.
N $D7F8 Advance to the next collectible record.
@ $D7F8 label=Handler_Collectibles_Next
  $D7F8,$05 #REGix+=#N($0003,$04,$04).
  $D7FD,$02 Jump to #R$D7D6.

c $D7FF Handler: Housekeeping
@ $D7FF label=Handler_Housekeeping
D $D7FF Marks the game complete when the combination is #N$09 in
. every #R$64C1 slot, then ticks #R$6489.
  $D7FF,$07 Test whether the combination is complete (every digit
. is #N$09).
N $D806 Compare each combination digit with #N$09.
@ $D806 label=Handler_Housekeeping_SlotLoop
  $D806,$03 Jump to #R$D818 if this slot differs.
  $D809,$01 Advance to the next slot.
  $D80A,$02 Decrease the slot count and loop back to #R$D806.
  $D80C,$07 Jump to #R$D818 unless *#R$64A1 is #N$10.
  $D813,$05 Write #N$FF to *#R$647D.
N $D818 Tick the action timer.
@ $D818 label=Handler_Housekeeping_Timer
  $D818,$05 Return if *#R$6489 is zero.
  $D81D,$04 Decrease *#R$6489 by one.
  $D821,$02 Return if the timer is still running.
  $D823,$03 Jump to #R$DF22.

c $D826 Read Kempston
@ $D826 label=Read_Kempston
D $D826 Reads the Kempston port twice and returns with the Z
. flag set if the two reads match.
R $D826 O:A Kempston port value
R $D826 O:F Z flag set if the two reads match
  $D826,$05 Read from the Kempston joystick port twice.
  $D82B,$01 Set the Z flag if the two reads match.
  $D82C,$01 Return.

c $D82D Handler: Kempston
@ $D82D label=Controls_Kempston
D $D82D Reads Kempston and walks, climbs, jumps or fires.
N $D82D Fetch the left/right Kempston masks.
  $D82D,$03 Fetch the left mask into #REGl and the right mask into
. #REGh.
N $D830 Walk left.
  $D830,$09 Call #R$DF44 if left matches the stored mask.
N $D839 Walk right.
@ $D839 label=Controls_Kempston_Right
  $D839,$09 Call #R$DF69 if right matches the stored mask.
N $D842 Climb up, or start a jump.
@ $D842 label=Controls_Kempston_Up
  $D842,$0A Call #R$E06A if up (bit 3) is pressed.
N $D84C Climb down.
@ $D84C label=Controls_Kempston_Down
  $D84C,$0A Call #R$E013 if down (bit 2) is pressed.
N $D856 Fire / use the furniture.
@ $D856 label=Controls_Kempston_Action
  $D856,$0B Call #R$DF8E if fire (bit 4) is pressed.
N $D861 Resolve the player movement.
  $D861,$03 Jump to #R$E28C.

c $D864 Handler: Kempston Climb
@ $D864 label=Controls_Kempston_Climb
D $D864 Reads Kempston while climbing and jumps to the matching
. climb routine.
N $D864 Bail out if the port is unstable.
  $D864,$03 Call #R$D826.
  $D867,$03 Jump to #R$E358 if the port is unstable.
N $D86A Climb up.
  $D86A,$05 Jump to #R$E145 if up (bit 3) is pressed.
N $D86F Climb down.
  $D86F,$05 Jump to #R$E130 if down (bit 2) is pressed.
N $D874 Hold the current climb if neither direction is pressed.
  $D874,$03 Jump to #R$E358.

c $D877 Handler: Room Pause
@ $D877 label=Handler_RoomPause
D $D877 Pauses using the per-room delay at #R$E82A.
  $D877,$0E Load this room's pause delay into #REGbc.
  $D885,$03 Jump to #R$F430.

g $D888 Demo Room Count
@ $D888 label=Demo_RoomCount
D $D888 Remaining demo rooms before returning to the menu.
B $D888,$01

c $D889 Select Control Method
@ $D889 label=Select_Keyboard
D $D889 Selects keyboard (#N$00) or Kempston (#N$FF) and returns
. to the menu.
N $D889 Select keyboard.
  $D889,$01 #REGa=#N$00.
  $D88A,$02 Jump to #R$D88E.
N $D88C Select Kempston.
@ $D88C label=Select_Kempston
  $D88C,$02 Set Kempston (#N$FF).
N $D88E Write the control method and return to the menu.
@ $D88E label=Select_ControlMethod
R $D88E A Control method (#N$00 keyboard, #N$FF Kempston)
  $D88E,$03 Write #REGa to *#R$647E.
  $D891,$03 Jump to #R$D62B.

c $D894 Handler: Moving Objects
@ $D894 label=Handler_MovingObjects
D $D894 Animates the #N$13-byte records at *#R$642A.
N $D894 Walk the moving-object list.
  $D894,$04 Point #REGix at the moving-object list.
N $D898 Skip inactive objects and expired timers.
@ $D898 label=Handler_MovingObjects_Loop
  $D898,$07 Jump to #R$D8FC if the terminator #N$FF is reached.
  $D89F,$04 Jump to #R$D8F5 if this object is inactive.
  $D8A3,$06 Jump to #R$D8AF unless the object's timer is zero.
  $D8A9,$04 Deactivate the object.
  $D8AD,$02 Jump to #R$D8F5.
N $D8AF Set the font and clip window.
@ $D8AF label=Handler_MovingObjects_Draw
  $D8AF,$0B Use #R$7C70, or #R$9070 when the stored font ID differs.
@ $D8BA label=Handler_MovingObjects_Font
  $D8BA,$03 Write #REGhl to *#SKOOLKID$5C36(CHARS).
  $D8BD,$0A Write the object's clip window to *#R$6419.
  $D8C7,$03 Call #R$F448.
N $D8CA Test the moving edge against the stored limit.
  $D8CA,$07 Compare the moving edge against the stored limit.
  $D8D1,$06 Jump to #R$D8E9 if they differ.
@ $D8D2 label=Handler_MovingObjects_LimitHit
N $D8D7 Reverse at the stored limit.
  $D8D7,$03 Call #R$DC37.
  $D8DA,$0C Swap the two limit bytes.
  $D8E6,$03 Call #R$F448.
N $D8E9 Store, move, draw and erase the object.
@ $D8E9 label=Handler_MovingObjects_Update
  $D8E9,$03 Call #R$F424.
  $D8EC,$03 Call #R$F442.
  $D8EF,$03 Call #R$F44B.
  $D8F2,$03 Call #R$F44E.
N $D8F5 Advance to the next moving object.
@ $D8F5 label=Handler_MovingObjects_Next
  $D8F5,$05 #REGix+=#N($0013,$04,$04).
  $D8FA,$02 Jump to #R$D898.
N $D8FC Restore the default clip window.
@ $D8FC label=Handler_MovingObjects_Done
  $D8FC,$07 Write #N$0218 to *#R$6419.
  $D903,$01 Return.

c $D904 Handler: Room Sixteen
@ $D904 label=Handler_RoomSixteen
D $D904 Special actor for room #N$16.
N $D904 Return unless this is room #N$16.
  $D904,$06 Return if *#R$64A2 is not #N$16.
N $D90A Point at the special actor and set the clip window.
  $D90A,$04 Point #REGix at #R$644D.
  $D90E,$07 Write #N$051D to *#R$641B.
N $D915 Draw the actor if it is already active.
  $D915,$06 Jump to #R$D994 if the actor is already active.
N $D91B Only spawn when the player is on a trigger row.
  $D91B,$07 Jump to #R$D92B if the player row is #N$07.
  $D922,$04 Jump to #R$D92B if the player row is #N$14.
  $D926,$05 Jump to #R$D9AE unless the player row is #N$11.
N $D92B Only spawn when the player is in the trigger columns.
@ $D92B label=Handler_RoomSixteen_Column
  $D92B,$08 Jump to #R$D9AE if the player column is #N$17 or
. higher.
  $D933,$04 Jump to #R$D9AE if the player column is below
. #N$0F.
N $D937 Spawn on a random roll.
  $D937,$07 Jump to #R$D9AE if the random number is #N$DC or
. higher.
N $D93E #UDGTABLE { #SPRITE$E6,$47(sprite-e6) } UDGTABLE#
  $D93E,$07 Spawn the actor with sprite #N($E6), colour #INK$47
. and size #N$01 by #N$01.
  $D945,$03 Call #R$F457.
N $D948 Choose left or right movement.
  $D948,$07 Jump to #R$D95D if the random number is #N$80 or
. higher.
  $D94F,$08 Start at column #N$1E.
  $D957,$04 Write #N$FB as the horizontal delta.
  $D95B,$02 Jump to #R$D969.
N $D95D Start on the left and move right.
@ $D95D label=Handler_RoomSixteen_Right
  $D95D,$08 Start at column #N$05.
  $D965,$04 Write #N$05 as the horizontal delta.
N $D969 Sound the actor appearing.
. #HTML(#AUDIO0(noise.wav)(#INCLUDE(Noise)))
@ $D969 label=Handler_RoomSixteen_Sound
  $D969,$07 Call #R$E4B1 with mask #N$FF and #N$32 iterations.
N $D970 Choose the actor row.
  $D970,$07 Jump to #R$D982 if the player row is #N$14.
  $D977,$04 Jump to #R$D98C if the player row is #N$11.
  $D97B,$07 Jump to #R$D98C if the random number is #N$80 or
. higher.
@ $D982 label=Handler_RoomSixteen_RowLow
  $D982,$08 Write row #N$13 into the actor.
  $D98A,$02 Jump to #R$D994.
@ $D98C label=Handler_RoomSixteen_RowHigh
  $D98C,$08 Write row #N$10 into the actor.
N $D994 Store, move, draw and erase the actor.
@ $D994 label=Handler_RoomSixteen_Draw
  $D994,$03 Call #R$F448.
  $D997,$03 Call #R$F424.
  $D99A,$03 Call #R$F442.
  $D99D,$03 Call #R$F44B.
  $D9A0,$03 Call #R$F44E.
N $D9A3 Hide the actor once it has left the room.
  $D9A3,$0B Deactivate the actor once column #N$23 is passed.
N $D9AE Restore the clip window.
@ $D9AE label=Handler_RoomSixteen_Done
  $D9AE,$07 Write #N$0121 to *#R$641B.
  $D9B5,$01 Return.

c $D9B6 Handler: Room Seven
@ $D9B6 label=Handler_RoomSeven
D $D9B6 Two balls in room #N$07, stored at #R$644D.
N $D9B6 Return unless this is room #N$07.
  $D9B6,$04 Point #REGix at #R$644D.
  $D9BA,$06 Return if *#R$64A2 is not #N$07.
N $D9C0 Clip drawing to a maximum row of #N$0E.
  $D9C0,$05 Write #N$0E to *#R$641A.
  $D9C5,$02 Set the ball count to #N$02.
N $D9C7 Process each ball.
@ $D9C7 label=Handler_RoomSeven_Loop
  $D9C7,$01 Stash the ball count on the stack.
N $D9C8 Draw the ball if it is already active.
  $D9C8,$07 Jump to #R$D9EB if this ball is already active.
N $D9CF Spawn on a random roll.
  $D9CF,$07 Jump to #R$DA07 if the random number is #N$BE or
. higher.
N $D9D6 #UDGTABLE { #SPRITE$E7,$46(sprite-e7) } UDGTABLE#
  $D9D6,$02,b$01 Keep only bits 0-3.
  $D9D8,$0C Spawn the ball at row #N$19, column #N$09-#N$18,
. sprite #N($E7), colour #INK$46 and size #N$01 by #N$01.
  $D9E4,$03 Call #R$F457.
  $D9E7,$04 Write #N$FA as the vertical delta.
N $D9EB Hide the ball once it has reached row #N$0C.
@ $D9EB label=Handler_RoomSeven_Move
  $D9EB,$0B Deactivate the ball if it has reached row #N$0C.
  $D9F6,$02 Jump to #R$DA07.
N $D9F8 Store, move, draw and erase the ball.
@ $D9F8 label=Handler_RoomSeven_Draw
  $D9F8,$03 Call #R$F448.
  $D9FB,$03 Call #R$F424.
  $D9FE,$03 Call #R$F442.
  $DA01,$03 Call #R$F44B.
  $DA04,$03 Call #R$F44E.
N $DA07 Step to the next ball.
@ $DA07 label=Handler_RoomSeven_Next
  $DA07,$01 Restore the ball count from the stack.
  $DA08,$05 #REGix+=#N($000E,$04,$04).
  $DA0D,$02 Decrease the ball count and loop back to #R$D9C7.
N $DA0F Reset the clip maximum row.
  $DA0F,$05 Write #N$02 to *#R$641A.
  $DA14,$01 Return.

c $DA15 Print Key Bar
@ $DA15 label=Print_KeyBar
D $DA15 Draws the #N$10 collected-key icons along the bottom
. of the screen.
N $DA15 Set the icon font and print position.
  $DA15,$06 Write #R$7C70 to *#SKOOLKID$5C36(CHARS).
  $DA1B,$06 Call #R$F42D at column #N$19, row #N$01 (the
. bottom line).
N $DA21 Start the key loop.
  $DA21,$02 Start at key #N$00.
  $DA23,$05 Write #INK$07 to *#SKOOLKID$5C8F(ATTR_T).
N $DA28 Skip the highlight unless this key matches *#R$64A1.
@ $DA28 label=Print_KeyBar_Loop
  $DA28,$06 Jump to #R$DA33 unless this key matches *#R$64A1.
N $DA2E Highlight this key.
  $DA2E,$05 Write #INK$38 to *#SKOOLKID$5C8F(ATTR_T).
N $DA33 #UDGTABLE { #GLYPH$E4,$07(glyph-e4) } UDGTABLE#
@ $DA33 label=Print_KeyBar_Glyph
  $DA33,$05 Print key glyph #N$E4.
  $DA38,$06 Jump to #R$DA28 until #N$10 keys are printed.
  $DA3E,$01 Return.

c $DA3F Handler: Carried Object
@ $DA3F label=Handler_CarriedObject
D $DA3F Draws #R$648B and drops it when it lines up with a slot.
N $DA3F Point at the carried object.
  $DA3F,$06 Write #R$7C70 to *#SKOOLKID$5C36(CHARS).
  $DA45,$04 Point #REGix at #R$648B.
N $DA49 Return unless something is being carried.
  $DA49,$06 Return if nothing is being carried.
N $DA4F Stash the clip window and use the object's.
  $DA4F,$08 Stash the current clip window on the stack.
  $DA57,$12 Write the object's clip window to *#R$6419.
N $DA69 Store and draw the object.
  $DA69,$03 Call #R$F448.
  $DA6C,$03 Call #R$F424.
  $DA6F,$03 Call #R$F44B.
N $DA72 Restore the clip window.
  $DA72,$08 Restore the clip window from the stack.
N $DA7A Only drop when the object is cell-aligned.
  $DA7A,$06 Return unless the fine-Y is #N$07.
  $DA80,$04 Return unless the fine-X is #N$07.
N $DA84 Only drop on the stored drop cell.
  $DA84,$07 Return unless the column matches the stored drop
. column.
  $DA8B,$07 Return unless the row matches the stored drop row.
N $DA92 Stamp the object into the room.
  $DA92,$0F Fetch the object's cell, size and sprite ID.
  $DAA1,$03 Call #R$F445.
N $DAA4 Mark it as no longer carried.
  $DAA4,$04 Set bit 7 of *#REGix+#N$00.
N $DAA8 Only the #R$F125 object writes a window into the room.
. #UDGTABLE { #GLYPH$D9(object-d9) } UDGTABLE#
  $DAA8,$06 Skip the window write unless this is #N$D9.
  $DAAE,$08 Fetch the drop cell, clearing bit 7 of the column.
  $DAB6,$03 Call #R$F43C.
N $DAB9 Write a 2-wide window into those tiles.
. #UDGTABLE
. { #GLYPH$0E,$47,$8470(window-0e) | #GLYPH$0F,$47,$8470(window-0f) }
. UDGTABLE#
  $DAB9,$04 Point #REGhl at that tile in #R$5DCE.
  $DABD,$05 Write #N$0E and #N$0F into those tiles.
  $DAC2,$01 Return.

g $DAC3 Pendulum Position
@ $DAC3 label=Pendulum_Position
D $DAC3 Pendulum sprite ID for rooms #N$0A and #N$0B. #N$FF
. resets at #R$DAC5.
B $DAC3,$01

g $DAC4 Pendulum Delta
@ $DAC4 label=Pendulum_Delta
D $DAC4 Added to #R$DAC3 each step. Negated at each end-stop.
B $DAC4,$01

c $DAC5 Animate Pendulum
@ $DAC5 label=Handler_Pendulum
D $DAC5 Steps the pendulum sprite IDs for rooms #N$0A and
. #N$0B.
N $DAC5 Reset after a room change.
  $DAC5,$07 Jump to #R$DAD6 unless the position is #N$FF.
  $DACC,$05 Write #N$D8 to *#R$DAC3.
  $DAD1,$05 Write #N$02 to *#R$DAC4.
N $DAD6 Advance the position.
@ $DAD6 label=Handler_Pendulum_Step
  $DAD6,$0B Add *#R$DAC4 to *#R$DAC3.
N $DAE1 Keep the new position as both sprite IDs.
  $DAE1,$02 Copy the position into #REGb and #REGc.
N $DAE3 Bounce at the end-stops.
  $DAE3,$08 Jump to #R$DAFA if the position is #N$D6 or
. #N$E2.
N $DAEB Use the same frame for both sprites in room #N$0A.
  $DAEB,$07 Jump to #R$DB24 if the room is #N$0A.
N $DAF2 Mirror the first sprite in room #N$0B.
  $DAF2,$06 Mirror the first sprite around #N$DC.
  $DAF8,$02 Jump to #R$DB24.
N $DAFA Negate the delta and apply it again.
@ $DAFA label=Handler_Pendulum_Bounce
  $DAFA,$04 Decrease the delta by one.
  $DAFE,$02,b$01 Invert every bit.
  $DB00,$03 Write the negated delta to *#R$DAC4.
  $DB03,$02 Jump to #R$DAD6.

c $DB05 Handler: Pendulum
@ $DB05 label=Handler_PendulumRooms
D $DB05 Room #N$09 chooses a frame from the player column.
. Rooms #N$0A and #N$0B animate at #R$DAC5.
E $DB05 Continue on to #R$DB24.
N $DB05 Return unless this is a pendulum room.
  $DB05,$06 Return if the room is #N$0C or higher.
  $DB0B,$03 Return if the room is lower than #N$09.
N $DB0E Animate rooms #N$0A and #N$0B.
  $DB0E,$04 Jump to #R$DAC5 if the room is #N$0A or #N$0B.
N $DB12 Choose a frame from the player column.
  $DB12,$05 Start from the player column minus #N$04.
N $DB17 #UDGTABLE
. { #GLYPH$E0,$47,$9070(pendulum-e0)
. | #GLYPH$E1,$47,$9070(pendulum-e1) }
. UDGTABLE#
  $DB17,$02 Set the sprite ID to #N$E0.
N $DB19 Step the sprite ID back for each six columns.
@ $DB19 label=Handler_Pendulum_FrameLoop
  $DB19,$0A Subtract #N$06 until #REGa is negative, decreasing
. the sprite ID by two each pass.
N $DB23 Use the same frame for both sprites.
@ $DB23 label=Handler_Pendulum_DrawPair
  $DB23,$01 Copy the sprite ID into #REGc.

c $DB24 Draw Pendulum
@ $DB24 label=Draw_Pendulum
D $DB24 Draws the two pendulum sprites.
R $DB24 B First sprite ID
R $DB24 C Second sprite ID
N $DB24 Draw the pair.
  $DB24,$05 Write #INK$47 to *#SKOOLKID$5C8F(ATTR_T).
  $DB29,$0C Draw the first sprite at row #N$12, column #N$14.
  $DB35,$0A Jump to #R$F445 for the second sprite at row
. #N$12, column #N$10.

c $DB3F Test Actor Collision
@ $DB3F label=Test_ActorCollision
D $DB3F Reverses the actor at a destination. On a player hit,
. copies the actor deltas onto #R$64A4.
R $DB3F IY Actor record
N $DB3F Reverse at the destination when cell-aligned.
  $DB3F,$06 Jump to #R$DB57 if the horizontal delta is set.
N $DB45 Test the destination row.
  $DB45,$07 Jump to #R$DB67 unless the fine-Y is #N$07.
  $DB4C,$09 Call #R$E43B if the row matches the destination.
  $DB55,$02 Jump to #R$DB67.
N $DB57 Test the destination column.
@ $DB57 label=Test_ActorCollision_Column
  $DB57,$07 Jump to #R$DB67 unless the fine-X is #N$07.
  $DB5E,$09 Call #R$E43B if the column matches the
. destination.
N $DB67 Skip the hit test while jumping or falling.
@ $DB67 label=Test_ActorCollision_Bounds
  $DB67,$05 Return if *#R$6410 is set.
N $DB6C Require a close vertical overlap.
  $DB6C,$0A Convert the actor row and fine-Y into a pixel row.
N $DB76 Convert the player row the same way.
  $DB76,$0D Convert the player row and fine-Y into a pixel row.
  $DB83,$04 Return unless the difference is less than #N$04.
N $DB87 Keep the gap and convert the actor column.
  $DB87,$01 Keep the vertical gap in #REGd.
  $DB88,$0C Convert the actor column and fine-X into a pixel
. column.
N $DB94 Build the overlap limit.
  $DB94,$04 Copy the footprint offset into #REGc.
  $DB98,$0B Write the actor pixel width plus that offset into
. *#R$DB3F(#N$DBAD).
N $DBA3 Test the player width against the actor column.
  $DBA3,$03 Restore the actor pixel width in #REGc.
  $DBA6,$09 Return unless the ranges overlap.
N $DBAF Copy the actor movement onto the player.
  $DBAF,$06 Write the horizontal delta to *#R$64AC.
  $DBB5,$05 Write #N$03 to *#R$6434.
N $DBBA Adjust the vertical delta by the gap.
  $DBBA,$06 Jump to #R$DBC1 if the vertical delta is zero.
  $DBC0,$01 Subtract the vertical gap.
N $DBC1 Store the vertical delta and the actor.
@ $DBC1 label=Test_ActorCollision_Store
  $DBC1,$03 Write the vertical delta to *#R$64AD.
  $DBC4,$04 Write the actor pointer to *#R$644B.
  $DBC8,$01 Return.

c $DBC9 Handler: Inventory Items
@ $DBC9 label=Handler_InventoryItems
D $DBC9 Picks up the first matching 2-wide key and redraws
. #R$DA15.
N $DBC9 Point at the inventory list.
  $DBC9,$06 Write #R$7C70 to *#SKOOLKID$5C36(CHARS).
  $DBCF,$04 Point #REGix at *#R$6426.
  $DBD3,$04 Copy the player column into #REGc.
N $DBD7 Walk each key record.
@ $DBD7 label=Handler_InventoryItems_Loop
  $DBD7,$06 Return if the terminator #N$FF is reached.
  $DBDD,$04 Jump to #R$DC20 if this item is already taken.
N $DBE1 Accept this column or the next.
  $DBE1,$03 Jump to #R$DBE8 if the column matches.
  $DBE4,$04 Jump to #R$DC20 unless the next column matches.
N $DBE8 Require the same row.
@ $DBE8 label=Handler_InventoryItems_Row
  $DBE8,$08 Jump to #R$DC20 unless the player row matches.
N $DBF0 Punch a hole in the room tiles.
  $DBF0,$06 Fetch the item cell.
  $DBF6,$03 Call #R$F43C.
  $DBF9,$04 Point #REGhl at that tile in #R$5DCE.
  $DBFD,$05 Fill a #N$02 by #N$02 hole with #N$C8.
  $DC02,$03 Call #R$F454.
N $DC05 Hide the record.
  $DC05,$03 Reload the item column.
  $DC08,$02,b$01 Set bit 7.
  $DC0A,$03 Write the hidden record.
N $DC0D Count the key.
  $DC0D,$07 Increase *#R$64A1 by one.
N $DC14 Play the pickup sound and redraw the key bar.
. #HTML(#AUDIO0(pickup.wav)(#INCLUDE(Pickup)))
  $DC14,$09 Call #R$E501 with delay #N$32 and #N$19
. iterations.
  $DC1D,$03 Jump to #R$DA15.
N $DC20 Step to the next record.
@ $DC20 label=Handler_InventoryItems_Next
  $DC20,$04 Increase #REGix by two.
  $DC24,$02 Jump to #R$DBD7.

c $DC26 Handler: Event Timer
@ $DC26 label=Handler_EventTimer
D $DC26 Counts *#R$649F down and fires *#R$64A0 through #R$E9FF.
N $DC26 Return unless a timer is running.
  $DC26,$05 Return if *#R$649F is zero.
N $DC2B Count down and fire when it hits zero.
  $DC2B,$04 Decrease *#R$649F by one.
  $DC2F,$02 Return if the timer is still running.
  $DC31,$06 Jump to #R$E9FF with *#R$64A0.

c $DC37 Reverse Direction
@ $DC37 label=Reverse_Direction
D $DC37 Negates both deltas and flips facing when the
. horizontal delta is non-zero.
R $DC37 IX Entity record
N $DC37 Negate the vertical delta.
  $DC37,$04 Fetch the vertical delta and decrease it by one.
  $DC3B,$02,b$01 Invert every bit.
  $DC3D,$03 Write the negated vertical delta.
N $DC40 Negate the horizontal delta.
  $DC40,$04 Fetch the horizontal delta and decrease it by one.
  $DC44,$02,b$01 Invert every bit.
  $DC46,$03 Write the negated horizontal delta.
  $DC49,$01 Return if it is now zero.
N $DC4A Flip the facing bit.
  $DC4A,$08 Toggle bit 7 of *#REGix+#N$07.
  $DC52,$01 Return.

c $DC53 Pause Leaving Room
@ $DC53 label=Pause_LeavingRoom
D $DC53 Delays when leaving a non-zero room.
N $DC53 Skip the pause in room #N$00.
  $DC53,$01 Stash #REGaf on the stack.
  $DC54,$06 Jump to #R$DC60 if the room is zero.
N $DC5A Wait, then restore.
  $DC5A,$06 Call #R$F430 with a pause of #N$03E8.
@ $DC60 label=Pause_LeavingRoom_Done
  $DC60,$01 Restore #REGaf from the stack.
  $DC61,$01 Return.

c $DC62 Handler: Enemies
@ $DC62 label=Handler_Enemies
D $DC62 Animates the #N$0E-byte records at *#R$6432.
E $DC62 View the equivalent code in #BOOTY$E22D.
N $DC62 Point at the enemy list.
  $DC62,$06 Write #R$9070 to *#SKOOLKID$5C36(CHARS).
  $DC68,$04 Point #REGix at *#R$6432.
N $DC6C Walk each enemy record.
@ $DC6C label=Handler_Enemies_Loop
  $DC6C,$05 Return if the terminator #N$FF is reached.
  $DC71,$05 Call #R$DC53 if this enemy is inactive.
  $DC76,$03 Jump to #R$DCED if it is still inactive.
N $DC79 Skip the walk-frame wrap for high sprite IDs.
  $DC79,$07 Jump to #R$DC92 if the sprite ID is #N$E2 or higher.
N $DC80 Advance the walking frame.
  $DC80,$05 Add #N$06 to the sprite ID and set the wrap to #N$24.
@ $DC85 label=Handler_Enemies_WrapLoop
  $DC85,$07 Subtract #N$24 until the frame is in range.
N $DC8C Wrap an exact multiple of #N$24.
@ $DC8C label=Handler_Enemies_WrapExact
  $DC8C,$03 Subtract one more span of #N$24.
@ $DC8F label=Handler_Enemies_CommitFrame
  $DC8F,$03 Write the wrapped sprite ID.
N $DC92 Only probe when the enemy is cell-aligned.
@ $DC92 label=Handler_Enemies_Probe
  $DC92,$07 Jump to #R$DCDE unless the fine-X is #N$07.
  $DC99,$06 Jump to #R$DCBC if the enemy is facing left.
N $DC9F Probe the cell ahead on the right.
  $DC9F,$0B Set the probe to the top row, one column right.
  $DCAA,$03 Call #R$F42D.
  $DCAD,$07 Point #REGhl at that #R$5DCE tile.
  $DCB4,$06 Call #R$DC37 if the tile is empty (#N$10 or
. higher).
  $DCBA,$02 Jump to #R$DCDE.
N $DCBC Probe ahead on the left.
@ $DCBC label=Handler_Enemies_ProbeLeft
  $DCBC,$07 Set the probe row to the top of the enemy.
  $DCC3,$07 Jump to #R$DCDE if the column is #N$23 or higher.
  $DCCA,$04 Set the probe column to the left of the enemy.
  $DCCE,$03 Call #R$F42D.
  $DCD1,$07 Point #REGhl at that #R$5DCE tile.
  $DCD8,$06 Call #R$DC37 if the tile is empty (#N$10 or
. higher).
N $DCDE Store, move, draw and erase the enemy.
@ $DCDE label=Handler_Enemies_Update
  $DCDE,$03 Call #R$F448.
  $DCE1,$03 Call #R$F424.
  $DCE4,$03 Call #R$F442.
  $DCE7,$03 Call #R$F44B.
  $DCEA,$03 Call #R$F44E.
N $DCED Step to the next record.
@ $DCED label=Handler_Enemies_Next
  $DCED,$05 #REGix+=#N($000E,$04,$04).
  $DCF2,$03 Jump to #R$DC6C.

c $DCF5 Cheat: Next Room
@ $DCF5 label=Cheat_NextRoom
D $DCF5 Wraps from room #N$16 back to #N$00.
N $DCF5 Drop the stacked return and step the room.
  $DCF5,$01 Restore #REGbc from the stack.
  $DCF6,$09 Jump to #R$D738 with the next room, unless this
. was room #N$16.
  $DCFF,$04 Jump to #R$D738 with room #N$00.

c $DD03 Cheat: Previous Room
@ $DD03 label=Cheat_PreviousRoom
D $DD03 Wraps from room #N$00 back to #N$16.
N $DD03 Drop the stacked return and step the room.
  $DD03,$01 Restore #REGbc from the stack.
  $DD04,$09 Jump to #R$D738 with the previous room, unless
. this was room #N$00.
  $DD0D,$05 Jump to #R$D738 with room #N$16.

c $DD12 Prepare Tape Block
@ $DD12 label=Tape_BlockRange
D $DD12 Sets #REGix to #R$647C, #REGde to the length
. and #REGa to #N$FF.
R $DD12 O:IX Start of the tape block
R $DD12 O:DE Length of the tape block
R $DD12 O:A Data block flag (#N$FF)
N $DD12 Point at the start and the exclusive end.
  $DD12,$04 Point #REGix at #R$647C.
  $DD16,$03 Point #REGde at #R$647C.
  $DD19,$03 Point #REGhl at #N$7C67.
N $DD1C Make the length.
  $DD1C,$01 Clear #REGa and the carry flag.
  $DD1D,$02 Subtract #REGde from #REGhl.
N $DD1F Set the data-block flag.
  $DD1F,$01 Put the length in #REGde.
  $DD20,$01 Set #REGa to #N$FF.
N $DD21 Return.
  $DD21,$01 Return.

c $DD22 Save Game
@ $DD22 label=Tape_Save
D $DD22 Writes the checksum and saves #R$647C to tape.
N $DD22 Store the checksum, then save the block.
  $DD22,$06 Write the checksum from #R$DD6C to *#R$6488.
  $DD28,$01 Restore #REGbc from the stack.
  $DD29,$03 Call #R$DD12.
  $DD2C,$03 Call #SKOOLKID$04C2(SA_BYTES).
N $DD2F Reload the room with bit 7 set.
  $DD2F,$05 Set bit 7 of the room ID.
  $DD34,$03 Jump to #R$D738.

c $DD37 Load Game
@ $DD37 label=Tape_Load
D $DD37 Prints #R$E7E4, waits for "2", then loads the tape
. block.
N $DD37 Use the ROM font and print the load message.
  $DD37,$06 Write #N$3C00 to *#SKOOLKID$5C36(CHARS).
  $DD3D,$06 Print the messaging at #R$E7E4.
N $DD43 Wait until a key is pressed.
@ $DD43 label=Tape_Load_Wait
  $DD43,$06 Call #R$F430 with a pause of #N$2710.
  $DD49,$03 Call #SKOOLKID$028E(KEY_SCAN).
  $DD4C,$05 Jump to #R$DD43 if no key is pressed.
N $DD51 Load only if "2" was pressed.
  $DD51,$04 Jump to #R$DD64 unless "2" was pressed.
  $DD55,$01 Restore #REGbc from the stack.
  $DD56,$03 Call #R$DD12.
  $DD59,$04 Call #SKOOLKID$0556(LD_BYTES) with carry set.
  $DD5D,$07 Jump to #R$D5D5 if the checksum does not match.
N $DD64 Reload the room with bit 7 set.
@ $DD64 label=Tape_Load_Resume
  $DD64,$05 Set bit 7 of the room ID.
  $DD69,$03 Jump to #R$D738.

c $DD6C Checksum Tape
@ $DD6C label=Tape_Checksum
D $DD6C Adds every byte in the tape block after
. writing #N$00 to *#R$6488. #REGl keeps the previous
. checksum for the load compare.
R $DD6C O:A The checksum
R $DD6C O:L The previous *#R$6488
N $DD6C Point at the tape block.
  $DD6C,$03 Call #R$DD12.
N $DD6F Keep the previous checksum and clear the stored
. one.
  $DD6F,$01 Clear the sum.
  $DD70,$03 Copy *#R$6488 into #REGl.
  $DD73,$03 Write #N$00 to *#R$6488.
  $DD76,$01 Clear #REGh.
N $DD77 Add each byte into the running total.
@ $DD77 label=Tape_Checksum_Loop
  $DD77,$04 Add *(#REGix) into #REGa and keep the sum in
. #REGh.
  $DD7B,$03 Move to the next byte.
  $DD7E,$02 Test whether #REGde is zero.
  $DD80,$01 Restore the sum.
  $DD81,$02 Jump to #R$DD77 if #REGde is not zero.
N $DD83 Return.
  $DD83,$01 Return.

c $DD84 Wait Keypress
@ $DD84 label=Wait_Keypress
D $DD84 Pauses, then returns when any key is pressed.
N $DD84 Delay, then scan.
  $DD84,$06 Call #R$F430 with a pause of #N$2710.
  $DD8A,$03 Call #SKOOLKID$028E(KEY_SCAN).
  $DD8D,$04 Jump to #R$DD84 if no key is pressed.
  $DD91,$01 Return.

c $DD92 Toggle Tune
@ $DD92 label=Toggle_Tune
D $DD92 Fires event #N$09, which inverts *#R$647C.
  $DD92,$05 Jump to #R$E9FF with event #N$09.

c $DD97 Handler: Keyboard
@ $DD97 label=Handler_Keyboard
D $DD97 In-game keypresses: save, load, pause, toggle
. tune, and the hidden room cheats when *#N$FFFF is #N$0A.
  $DD97,$03 Call #SKOOLKID$028E(KEY_SCAN).
  $DD9A,$01 #REGa=the keypress.
  $DD9B,$04 Jump to #R$DD22 if "S" was pressed.
  $DD9F,$04 Jump to #R$DD37 if "J" was pressed.
  $DDA3,$04 Jump to #R$DD84 if "H" was pressed.
  $DDA7,$04 Jump to #R$DD92 if "Q" was pressed.
  $DDAB,$06 Return unless *#N$FFFF is #N$0A.
  $DDB1,$07 Jump to #R$DDBD if *#R$64B4 is below #N$02.
  $DDB8,$05 Write #N$03 to *#R$64B4.
@ $DDBD label=Handler_Keyboard_Cheats
  $DDBD,$06 Write #N$3C00 to *#SKOOLKID$5C36(CHARS).
  $DDC3,$06 Jump to #R$DCF5 if "8" was pressed.
  $DDC9,$04 Jump to #R$DD03 if "1" was pressed.
  $DDCD,$0A Write #N$0705 to *#R$64A4 if "C" was pressed.
@ $DDD7 label=Handler_Keyboard_Corner2
  $DDD7,$0A Write #N$161F to *#R$64A4 if "X" was pressed.
@ $DDE1 label=Handler_Keyboard_Corner3
  $DDE1,$0A Write #N$071F to *#R$64A4 if "Z" was pressed.
@ $DDEB label=Handler_Keyboard_Corner4
  $DDEB,$0A Write #N$1605 to *#R$64A4 if "V" was pressed.
@ $DDF5 label=Handler_Keyboard_Lives
  $DDF5,$09 Write #N$01 to *#R$64B4 if "B" was pressed.
@ $DDFE label=Handler_Keyboard_RoomLetter
  $DDFE,$06 Call #R$F42D at column #N$03, row #N$21.
  $DE04,$05 Write #INK$07 to *#SKOOLKID$5C8F(ATTR_T).
  $DE09,$08 Print *#R$64A2 as "A"+"room".
  $DE11,$01 Return.
N $DE12 Print #REGc as an ASCII digit.
@ $DE12 label=Print_Digit
  $DE12,$03 Convert the digit into ASCII.
  $DE15,$03 Call #R$F436.
  $DE18,$01 Return.

c $DE19 Handler: Combination
@ $DE19 label=Handler_Combination
D $DE19 Prints the four #R$64C1 digits on room #N$00.
  $DE19,$04 Return if *#R$647D is set.
  $DE1D,$04 Return if *#R$64A2 is not zero.
  $DE21,$08 Write #N$3C00 to *#SKOOLKID$5C36(CHARS).
  $DE29,$05 Write #INK$17 to *#SKOOLKID$5C8F(ATTR_T).
  $DE2E,$03 Call #R$F42D at column #N$14, row #N$13.
  $DE31,$03 #REGhl=#R$64C1.
  $DE34,$03 #REGb=#N$04.
@ $DE39 label=Handler_Combination_Loop
  $DE39,$06 Print *(#REGhl) as a decimal digit.
  $DE3F,$03 Increase #REGhl and loop back to #R$DE39.
  $DE42,$01 Return.
N $DE43 Probe the three tiles above the player for a solid.
@ $DE43 label=Probe_Ceiling
  $DE43,$04 Fetch the player's fine-Y and increase it by one.
  $DE47,$02,b$01 Keep only bits 0-2.
  $DE49,$03 Return if that offset is #N$04 or higher.
  $DE4C,$03 Negate the offset into #REGa.
  $DE4F,$03 Write it into the self-modifying store at
. #R$DE43(#N$DE83).
  $DE52,$09 Point #REGbc at the cell three rows above the
. player.
  $DE5B,$08 Drop one more row unless the fine-Y is #N$07.
@ $DE63 label=Probe_Ceiling_Ready
  $DE63,$03 Call #R$F42D.
  $DE66,$07 Point #REGhl at that #R$5DCE tile.
  $DE6D,$03 #REGde=#R$643A.
  $DE70,$02 #REGb=#N$03.
@ $DE72 label=Probe_Ceiling_Loop
  $DE72,$04 Jump to #R$DE85 if this mask byte is zero.
  $DE76,$05 Jump to #R$DE85 if this tile is empty (#N$10 or
. higher).
  $DE7B,$05 Write #N$02 to *#R$6434.
  $DE80,$04 Write the computed offset to *#REGix+#N$09.
  $DE84,$01 Return.
@ $DE85 label=Probe_Ceiling_Next
  $DE85,$04 Increase both pointers and loop back to #R$DE72.
  $DE89,$01 Return.
N $DE8A Mirror the #REGde bitmask into #REGe.
@ $DE8A label=Mirror_Mask
  $DE8A,$0B Reverse the eight bits of #REGd into #REGe.
@ $DE8D label=Mirror_Mask_Loop
  $DE95,$01 Return.
N $DE96 Build the player's shifted collision mask.
@ $DE96 label=Build_PlayerMask
  $DE96,$16 Point #REGhl at the *#R$64AA mask row in #R$B5D8.
  $DEAC,$07 Load the two mask bytes into #REGde.
  $DEB3,$08 Mirror them if the player is facing left.
  $DEBB,$0E Shift the mask down by the player's fine-Y.
@ $DEC1 label=Build_PlayerMask_Shift
  $DEC9,$07 Write the shifted mask to *#R$643A.
  $DED0,$08 Convert the player column into a pixel column.
  $DED8,$0F Walk left until a set mask bit is found.
@ $DEDD label=Build_PlayerMask_Scan
  $DEE7,$07 Write #N($0000,$04,$04) to *#R$6448.
  $DEEE,$01 Return.
@ $DEEF label=Build_PlayerMask_Width
  $DEEF,$0B Count the run of set bits into *#R$6448.
@ $DEF1 label=Build_PlayerMask_Count
  $DEFA,$01 Return.
N $DEFB Award points and flash the player after a successful action.
. #HTML(#AUDIO0(action.wav)(#INCLUDE(Action)))
@ $DEFB label=Award_Action
  $DEFB,$05 Return if *#R$6489 is already running.
  $DF00,$09 Call #R$E4E1 (score sound).
  $DF09,$09 Call #R$E501 (pickup sound).
  $DF12,$05 Write #N$12 to *#R$6489.
  $DF17,$03 #REGa=*#R$64AB.
  $DF1A,$02,b$01 Keep only the facing bit.
  $DF1C,$02,b$01 Set bright red.
  $DF1E,$03 Write the flashed attributes back to *#R$64AB.
  $DF21,$01 Return.
N $DF22 Lose a life and restart the room.
@ $DF22 label=Lose_Life
E $DF22 View the equivalent code in #BOOTY$E3A4.
  $DF22,$06 Jump to #R$DF30 if no event is pending.
  $DF28,$05 Write #N$01 to *#R$649F.
  $DF2D,$03 Call #R$DC26.
@ $DF30 label=Lose_Life_Apply
  $DF30,$01 Restore #REGbc from the stack.
  $DF31,$05 Write #N$01 to *#R$6411.
  $DF36,$07 Jump to #R$D5D5 if *#R$64B4 is #N$01.
  $DF3D,$03 Decrease *#R$64B4 by one.
  $DF40,$04 Jump to #R$D738 with #REGa=#N$00.
N $DF44 Walk left, or start a left-facing walk.
@ $DF44 label=Player_MoveLeft
E $DF44 View the equivalent code in #BOOTY$EB49.
  $DF44,$06 Jump to #R$DF53 if already facing left.
  $DF4A,$04 Face left.
  $DF4E,$04 Set frame #N$60.
  $DF52,$01 Return.
@ $DF53 label=Player_MoveLeft_Step
  $DF53,$0D Advance the walk frame, wrapping at #N$30.
@ $DF5D label=Player_MoveLeft_StoreFrame
  $DF60,$08 Increase the horizontal delta by #N$02.
  $DF68,$01 Return.
N $DF69 Walk right, or start a right-facing walk.
@ $DF69 label=Player_MoveRight
E $DF69 View the equivalent code in #BOOTY$EB05.
  $DF69,$06 Jump to #R$DF78 if already facing right.
  $DF6F,$04 Set frame #N$60.
  $DF73,$04 Face right.
  $DF77,$01 Return.
@ $DF78 label=Player_MoveRight_Step
  $DF78,$0D Advance the walk frame, wrapping at #N$30.
@ $DF82 label=Player_MoveRight_StoreFrame
  $DF85,$08 Decrease the horizontal delta by #N$02.
  $DF8D,$01 Return.
N $DF8E Fire / use the furniture in front of the player.
@ $DF8E label=Player_Action
  $DF8E,$03 #REGhl=*#R$6420.
@ $DF91 label=Player_Action_Loop
  $DF91,$05 Jump to #R$DFC8 if the terminator #N$FF is reached.
  $DF96,$04 Jump to #R$DFC2 if this record is inactive.
  $DF9A,$05 Jump to #R$DFC2 unless the column matches.
  $DF9F,$09 Jump to #R$DFC2 unless the row matches.
  $DFA8,$06 Jump to #R$DFB8 if no event is pending.
  $DFAE,$05 Write #N$01 to *#R$649F.
  $DFB3,$05 Call #R$DC26, preserving #REGhl.
@ $DFB8 label=Player_Action_Use
  $DFB8,$05 Fetch the furniture event ID.
  $DFBD,$02 Restore the return addresses from the stack.
  $DFBF,$03 Jump to #R$D738.
@ $DFC2 label=Player_Action_Next
  $DFC2,$04 #REGhl+=#N($0005,$04,$04).
  $DFC6,$02 Jump to #R$DF91.
@ $DFC8 label=Player_Action_Doors
  $DFC8,$05 Return if *#R$649F is running.
  $DFCD,$03 #REGhl=*#R$6422.
@ $DFD0 label=Player_Action_DoorLoop
  $DFD0,$04 Return if the terminator #N$FF is reached.
  $DFD4,$04 Jump to #R$E00C if this door is inactive.
  $DFD8,$05 Jump to #R$DFE3 if the door column matches.
  $DFDD,$06 Jump to #R$E00C unless the next column matches.
@ $DFE3 label=Player_Action_DoorMatch
  $DFE3,$08 Jump to #R$DFF1 if the door row matches.
  $DFEB,$06 Jump to #R$E00C unless the row above matches.
@ $DFF1 label=Player_Action_DoorUse
  $DFF1,$05 Point #REGhl at the door use count.
  $DFF6,$03 Jump to #R$DFFC if the count is zero.
  $DFF9,$02 Return if the count was #N$FF.
  $DFFB,$01 Write the increased count.
@ $DFFC label=Player_Action_DoorEvent
  $DFFC,$07 Jump to #R$E9FF unless the event is #N$2A.
  $E003,$06 Write #N($0001,$04,$04) to *#R$E82A.
  $E009,$03 Jump to #R$E9FF.
@ $E00C label=Player_Action_DoorNext
  $E00C,$04 #REGhl+=#N($0005,$04,$04).
  $E010,$02 Jump to #R$DFD0.
  $E012,$01 Return.
N $E013 Climb down a ladder from *#R$6428.
@ $E013 label=Player_ClimbDown
  $E013,$06 Return unless the player fine-Y is #N$07.
  $E019,$03 #REGhl=*#R$6428.
@ $E01C label=Player_ClimbDown_Loop
  $E01C,$04 Return if the terminator #N$FF is reached.
  $E020,$04 Jump to #R$E065 if this ladder is hidden.
  $E024,$05 Jump to #R$E036 if the ladder column matches.
  $E029,$06 Jump to #R$E065 unless the player is on the
. right-hand ladder column.
  $E02F,$07 Jump to #R$E065 unless the fine-X is below
. #N$04.
@ $E036 label=Player_ClimbDown_Start
  $E036,$0A Jump to #R$E065 unless the player is three rows
. below the ladder.
  $E040,$05 Write the ladder row to *#R$648A.
  $E045,$08 Start climbing down.
  $E04D,$06 Jump to #R$E05C unless the ladder column matches.
  $E053,$08 Write the remaining fine-X as the horizontal delta.
  $E05B,$01 Return.
@ $E05C label=Player_ClimbDown_Offset
  $E05C,$08 Write the opposite climb delta.
  $E064,$01 Return.
@ $E065 label=Player_ClimbDown_Next
  $E065,$03 Increase #REGhl by three.
  $E068,$02 Jump to #R$E01C.
N $E06A Climb up a ladder, or start a jump.
@ $E06A label=Player_ClimbUp
  $E06A,$05 Return if *#R$6410 is set.
  $E06F,$07 Jump to #R$E0CE unless the player fine-Y is #N$07.
  $E076,$03 #REGhl=*#R$6428.
@ $E079 label=Player_ClimbUp_Loop
  $E079,$05 Jump to #R$E0CE if the terminator #N$FF is reached.
  $E07E,$04 Jump to #R$E0C9 if this ladder is hidden.
  $E082,$05 Jump to #R$E094 if the ladder column matches.
  $E087,$06 Jump to #R$E0C9 unless the player is on the
. right-hand ladder column.
  $E08D,$07 Jump to #R$E0C9 unless the fine-X is below
. #N$04.
@ $E094 label=Player_ClimbUp_Start
  $E094,$08 Return if the player is already at the top.
  $E09C,$08 Jump to #R$E0C9 unless the player is two rows
. below the top.
  $E0A4,$05 Write the ladder row to *#R$648A.
  $E0A9,$08 Start climbing up.
  $E0B1,$06 Jump to #R$E0C0 unless the ladder column matches.
  $E0B7,$08 Write the remaining fine-X as the horizontal delta.
  $E0BF,$01 Return.
@ $E0C0 label=Player_ClimbUp_Offset
  $E0C0,$08 Write the opposite climb delta.
  $E0C8,$01 Return.
@ $E0C9 label=Player_ClimbUp_Next
  $E0C9,$03 Increase #REGhl by three.
  $E0CC,$02 Jump to #R$E079.
@ $E0CE label=Player_Jump
  $E0CE,$05 Write #N$07 to *#R$6410.
  $E0D3,$04 Write #N$03 as the vertical delta.
  $E0D7,$06 Jump to #R$E0E6 if the player is facing right.
  $E0DD,$08 Use jump frame #N$30 and left delta #N$FE.
  $E0E5,$01 Return.
@ $E0E6 label=Player_Jump_Right
  $E0E6,$08 Use jump frame #N$30 and right delta #N$02.
  $E0EE,$01 Return.
N $E0EF Stop climbing when the stored ladder row is left.
@ $E0EF label=Player_ClimbStop
  $E0EF,$07 Jump to #R$E110 unless the fine-Y is #N$07.
  $E0F6,$0A Jump to #R$E107 if the player is two rows below
. *#R$648A.
  $E100,$07 Jump to #R$E110 unless the player is three rows
. above that point.
@ $E107 label=Player_ClimbStop_Clear
  $E107,$04 Write #N$00 to *#R$648A.
  $E10B,$04 Restore walk frame #N$60.
  $E10F,$01 Return.
@ $E110 label=Player_ReadKeys
  $E110,$01 Restore #REGbc from the stack.
  $E111,$07 Jump to #R$D864 if Kempston is selected.
  $E118,$03 Call #SKOOLKID$028E(KEY_SCAN).
  $E11B,$04 #REGix=#R$64A4.
  $E11F,$06 Jump to #R$E358 if no key is pressed.
  $E125,$06 Jump to #R$E145 if the up key matches.
  $E12B,$05 Jump to #R$E358 unless the down key matches.
N $E130 Animate climbing down.
@ $E130 label=Player_ClimbDown_Anim
  $E130,$0B Step the climb frame down.
@ $E13B label=Player_ClimbDown_StoreFrame
  $E13B,$03 Store the climb frame.
  $E13E,$04 Write #N$FE as the vertical delta.
  $E142,$03 Jump to #R$E358.
N $E145 Animate climbing up.
@ $E145 label=Player_ClimbUp_Anim
  $E145,$0B Step the climb frame up.
@ $E150 label=Player_ClimbUp_StoreFrame
  $E150,$03 Store the climb frame.
  $E153,$04 Write #N$02 as the vertical delta.
  $E157,$03 Jump to #R$E358.
N $E15A Flash and drop the player after a hit.
. #HTML(#AUDIO0(bonus.wav)(#INCLUDE(Bonus)))
@ $E15A label=Player_Hit
  $E15A,$05 Jump to #R$E16A unless the hit timer is still
. #N$32.
  $E161,$09 Call #R$E501 with delay #N($0064,$04,$04) and
. #N$00C8.
@ $E16A label=Player_Hit_Fall
N $E16A Advance, store and erase the falling player.
  $E16A,$04 Write #N$FF as the vertical delta.
  $E16E,$03 Call #R$F448.
  $E171,$03 Call #R$F424.
  $E174,$03 Call #R$F442.
N $E177 Clip the draw against *#R$644A.
  $E177,$03 #REGa=*#R$641A.
  $E17A,$01 Stash it on the stack.
  $E17B,$06 Write *#R$644A to *#R$641A.
  $E181,$03 Call #R$F44B.
  $E184,$01 Restore *#R$641A from the stack.
  $E185,$03 Write it back to *#R$641A.
  $E188,$04 Decrease *#R$6435.
  $E18C,$03 Jump to #R$DF22 if it is now zero.
  $E18F,$03 Write the new count back.
  $E192,$01 Return.
N $E193 Animate the jump frames from *#R$6410.
@ $E193 label=Player_JumpAnim
  $E193,$04 Decrease *#R$6410.
  $E197,$04 Point at #R$E292 (using the stack).
  $E19B,$06 Use frame #N$30 while the timer is #N$06 or higher.
  $E1A1,$07 Use frame #N$36 while the timer is #N$04 or higher.
  $E1A8,$07 Use frame #N$3C while the timer is #N$03 or higher.
  $E1AF,$07 Use frame #N$42 while the timer is #N$01 or higher.
  $E1B6,$05 Use frame #N$12 for the last tick.
  $E1BB,$01 Return.
N $E1BC Start the hit sequence.
@ $E1BC label=Player_StartHit
  $E1BC,$05 Write #N$32 to *#R$6435.
  $E1C1,$08 Store the ceiling row in *#R$644A.
  $E1C9,$03 Jump to #R$E292.

c $E1CC Handler: Player
@ $E1CC label=Handler_Player
D $E1CC Moves, collides and draws the player entity at #R$64A4.
E $E1CC View the equivalent code in #BOOTY$EBD8.
  $E1CC,$05 Return if *#R$646F is set (demo / intro).
  $E1D1,$06 Write #R$B5B1 to *#SKOOLKID$5C36(CHARS).
  $E1D7,$04 #REGix=#R$64A4.
  $E1DB,$04 Test *#R$6489.
  $E1DF,$04 Call #R$F44B if it is set, preserving the flags.
  $E1E3,$02 Return if it is set.
  $E1E5,$07 Jump to #R$E15A if *#R$6435 is set.
  $E1EC,$07 Jump to #R$E193 if *#R$6410 is set.
  $E1F3,$07 Call #R$E0EF if *#R$648A is set.
  $E1FA,$03 Call #R$DE96.
  $E1FD,$07 Jump to #R$E22C if *#R$6434 is a collision.
  $E204,$04 Write #N$FC as the vertical delta.
  $E208,$02 Stash #REGiy on the stack.
  $E20A,$04 #REGiy=*#R$6430.
@ $E20E label=Handler_Player_ActorLoop
  $E20E,$07 Jump to #R$E22A if the terminator #N$FF is reached.
  $E215,$04 Jump to #R$E223 if this actor is inactive.
  $E219,$03 Call #R$DB3F.
  $E21C,$07 Stop scanning once *#R$6434 is a collision.
@ $E223 label=Handler_Player_ActorNext
  $E223,$05 #REGiy+=#N($000D,$04,$04).
  $E228,$02 Jump to #R$E20E.
@ $E22A label=Handler_Player_ActorsDone
  $E22A,$02 Restore #REGiy from the stack.
@ $E22C label=Handler_Player_Apply
  $E22C,$0A Jump to #R$E246 unless the vertical delta is
. negative.
  $E236,$03 Call #R$DE43.
  $E239,$07 Increase *#R$6438.
  $E240,$06 Jump to #R$E28C if *#R$6434 is zero.
@ $E246 label=Handler_Player_Stand
  $E246,$08 Start a hit if *#R$6438 reaches #N$0A.
  $E24E,$04 Clear *#R$6438.
  $E252,$07 Jump to #R$D82D if Kempston is selected.
  $E259,$03 Call #SKOOLKID$028E(KEY_SCAN).
  $E25C,$01 #REGa=the keypress.
  $E25D,$04 #REGix=#R$64A4.
  $E261,$09 Call #R$DF44 if the left key matches.
  $E26A,$09 Call #R$DF69 if the right key matches.
  $E273,$09 Call #R$E06A if the up key matches.
  $E27C,$09 Call #R$E013 if the down key matches.
  $E285,$07 Call #R$DF8E if the action key matches.
@ $E28C label=Handler_Player_Resolve
  $E28C,$06 Fall through to #R$E292 when *#R$648A is set.
@ $E292 label=Handler_Player_Draw
  $E292,$03 Call #R$F448.
N $E295 Start a fall if the new row is off the bottom of the
. room.
  $E295,$05 Jump to #R$E2AA unless the new row is #N$1B.
  $E29A,$04 Write #N$FC as the vertical delta.
  $E29E,$07 Write #N$00 to *#R$6434 and *#R$6410.
  $E2A5,$05 Write #N$0C to *#R$6438.
@ $E2AA label=Handler_Player_Collision
  $E2AA,$08 Jump to #R$E358 if *#R$6434 is a collision.
N $E2B2 Probe the tiles above while the player is jumping.
  $E2B2,$06 Jump to #R$E2E2 if *#R$6410 is zero.
  $E2B8,$06 Jump to #R$E2E2 if the row has not changed.
  $E2BE,$07 #REGa=#N$03, or #N$02 when fine-Y is #N$07.
  $E2C5,$01 Stash the probe count on the stack.
  $E2C6,$03 Call #R$F43C.
  $E2C9,$04 Point #REGhl at that tile in #R$5DCE.
  $E2CD,$02 Restore the probe count into #REGb.
@ $E2CF label=Handler_Player_ProbeUp
  $E2CF,$05 Jump to #R$E2DF if this tile is empty (#N$10 or
. higher).
  $E2D4,$04 Clear the vertical delta.
  $E2D8,$03 Jump to #R$E33F until the probe count is zero.
  $E2DB,$04 Clear the sprite.
@ $E2DF label=Handler_Player_ProbeUpNext
  $E2DF,$03 Advance the tile pointer and loop back to #R$E2CF.
N $E2E2 Probe the tiles to the right while moving right.
@ $E2E2 label=Handler_Player_Horizontal
  $E2E2,$03 Call #R$F448.
  $E2E5,$07 Jump to #R$E322 if the horizontal delta is
. negative.
  $E2EC,$06 Jump to #R$E358 if the column has not changed.
  $E2F2,$07 #REGa=#N$04, or #N$03 when fine-Y is #N$07.
  $E2F9,$01 Stash the probe count on the stack.
  $E2FA,$03 Call #R$F43C.
  $E2FD,$04 Point #REGhl at that tile in #R$5DCE.
  $E301,$02 Restore the probe count into #REGb.
  $E303,$03 #REGde=#N($0020,$04,$04).
@ $E306 label=Handler_Player_ProbeRight
  $E306,$05 Jump to #R$E31D if this tile is empty (#N$10 or
. higher).
  $E30B,$04 Clear the horizontal delta.
  $E30F,$06 Jump to #R$E31D if *#R$6410 is zero.
  $E315,$04 Write #N$00 to *#R$6410.
  $E319,$04 Clear the sprite.
@ $E31D label=Handler_Player_ProbeRightNext
  $E31D,$03 Step down one row and loop back to #R$E306.
  $E320,$02 Jump to #R$E358.
N $E322 Probe the tiles to the left while moving left.
@ $E322 label=Handler_Player_Left
  $E322,$06 Jump to #R$E358 if the column has not changed.
  $E328,$02 Point two columns left.
  $E32A,$07 #REGa=#N$04, or #N$03 when fine-Y is #N$07.
  $E331,$01 Stash the probe count on the stack.
  $E332,$03 Call #R$F43C.
  $E335,$04 Point #REGhl at that tile in #R$5DCE.
  $E339,$02 Restore the probe count into #REGb.
  $E33B,$03 #REGde=#N($0020,$04,$04).
@ $E33E label=Handler_Player_ProbeLeft
@ $E33F label=Handler_Player_ProbeLeftTest
  $E33E,$05 Jump to #R$E355 if this tile is empty (#N$10 or
. higher).
  $E343,$04 Clear the horizontal delta.
  $E347,$06 Jump to #R$E355 if *#R$6410 is zero.
  $E34D,$04 Write #N$00 to *#R$6410.
  $E351,$04 Clear the sprite.
@ $E355 label=Handler_Player_ProbeLeftNext
  $E355,$03 Step down one row and loop back to #R$E33E.
@ $E358 label=Handler_Player_Commit
  $E358,$03 Call #R$F448.
  $E35B,$06 Jump to #R$E398 if the new column is #N$22.
  $E361,$05 Jump to #R$E398 if the new column is #N$03.
  $E366,$05 Jump to #R$E373 unless the new row is #N$1A.
  $E36B,$04 Write #N$00 to *#R$6410.
  $E36F,$04 Write #N$FC as the vertical delta.
@ $E373 label=Handler_Player_Paint
N $E373 Store, move and draw the player.
  $E373,$03 Call #R$F424.
  $E376,$03 Call #R$F442.
  $E379,$03 Call #R$F44B.
  $E37C,$07 Jump to #R$E38A unless *#R$6434 is #N$03.
  $E383,$07 Draw the collided actor through #R$F45A.
N $E38A Reset after drawing.
@ $E38A label=Handler_Player_Reset
  $E38A,$04 Point #REGix at #R$64A4.
  $E38E,$04 Write #N$00 to *#R$6434.
  $E392,$06 Jump to #R$E3A4 if *#R$6410 is set.
N $E398 Clear the jump timer and both deltas.
@ $E398 label=Handler_Player_ClearDeltas
  $E398,$04 Write #N$00 to *#R$6410.
  $E39C,$08 Write #N$00 to both movement deltas.
@ $E3A4 label=Handler_Player_Floor
  $E3A4,$07 Jump to #R$E3B0 if the player is on the floor.
  $E3AB,$05 Return unless *#R$6411 is set.
@ $E3B0 label=Handler_Player_Award
  $E3B0,$03 Jump to #R$DEFB.
N $E3B3 Clear the play area and the room buffers.
@ $E3B3 label=Clear_PlayArea
E $E3B3 View the equivalent code in #BOOTY$D4BE.
  $E3B3,$04 Write #INK$00 to *#SKOOLKID$5C8F(ATTR_T).
  $E3B7,$03 Call #SKOOLKID$1C96,$1CAD(CLASS_07) at #N$1CAD.
  $E3BA,$0E Write #N$00 to the #N$0320 bytes at #R$5DCE.
@ $E3C0 label=Clear_PlayArea_TileLoop
  $E3C8,$10 Fill #R$60EE with *#SKOOLKID$5C8F(ATTR_T).
@ $E3CE label=Clear_PlayArea_AttributeLoop
  $E3D8,$05 Call #SKOOLKID$0E44(CL_LINE) for #N$18 lines.
  $E3DD,$01 Return.

c $E3DE Handler: Actors
@ $E3DE label=Handler_Actors
D $E3DE Animates the #N$0D-byte records at *#R$6430.
  $E3DE,$03 Call #R$DE96.
  $E3E1,$04 #REGix=*#R$6430.
@ $E3E5 label=Handler_Actors_Loop
  $E3E5,$05 Return if the terminator #N$FF is reached.
  $E3EA,$04 Jump to #R$E41E if this actor is inactive.
N $E3EE Test this actor against the player.
  $E3EE,$02 Stash #REGiy on the stack.
  $E3F0,$04 Copy #REGix to #REGiy (using the stack).
  $E3F4,$03 Call #R$DB3F.
  $E3F7,$02 Restore #REGiy from the stack.
  $E3F9,$03 Call #R$F45D.
  $E3FC,$06 Jump to #R$E40C unless the stored-row flag is set.
  $E402,$04 Clear the stored-row flag.
  $E406,$06 Restore the stored row.
@ $E40C label=Handler_Actors_Commit
N $E40C Store the new position.
  $E40C,$03 Call #R$F448.
  $E40F,$0C Store the new column, row, fine-X and fine-Y.
  $E41B,$03 Call #R$F45A.
@ $E41E label=Handler_Actors_Next
  $E41E,$05 #REGix+=#N($000D,$04,$04).
  $E423,$02 Jump to #R$E3E5.
  $E425,$01 Return.
N $E426 Lock or reverse an actor after a collision.
@ $E426 label=Actor_AfterCollision
  $E426,$05 Jump to #R$E436 if the actor type is #N$02.
  $E42B,$03 Call #R$E441.
  $E42E,$07 Write #N$00 to both actor deltas.
  $E435,$01 Return.
@ $E436 label=Actor_Lock
  $E436,$04 Set bit 7 of *#REGiy+#N$07.
  $E43A,$01 Return.
@ $E43B label=Actor_Reverse
  $E43B,$06 Jump to #R$E426 if *#REGiy+#N$0C is set.
@ $E441 label=Actor_SwapDestination
  $E441,$0C Swap *#REGiy+#N$05 with *#REGiy+#N$0A.
  $E44D,$0C Swap *#REGiy+#N$06 with *#REGiy+#N$0B.
  $E459,$04 #REGa=*#REGiy+#N$08-#N$01.
  $E45D,$02,b$01 Invert every bit.
  $E45F,$03 Write the new horizontal delta.
  $E462,$04 #REGa=*#REGiy+#N$09-#N$01.
  $E466,$02,b$01 Invert every bit.
  $E468,$03 Write the new vertical delta.
  $E46B,$01 Return.

c $E46C Handler: Interrupts
@ $E46C label=Handler_Interrupts
D $E46C IM #N$02 lands here from #R$FEFE. Plays the next tune note every five
. ticks and services any pending sound.
E $E46C View the equivalent code in #BOOTY$FE69.
  $E46C,$06 Stash #REGaf, #REGbc, #REGde, #REGhl and #REGix.
  $E472,$05 Return unless bit 7 of the refresh register is set.
  $E477,$07 Increase *#R$646E.
  $E47E,$04 Jump to #R$E49B unless it reached #N$05.
  $E482,$04 Write #N$00 to *#R$646E.
N $E486 #HTML(#AUDIO0(score.wav)(#INCLUDE(Score)))
  $E486,$08 Call #R$E4D3 if bit 4 of *#R$6472 is set.
N $E48E #HTML(#AUDIO0(beep.wav)(#INCLUDE(Beep)))
  $E48E,$07 Jump to #R$E4A3 if *#R$6473 is set.
N $E495 #HTML(#AUDIO0(theme-tune.wav)(#INCLUDE(ThemeTune)))
  $E495,$06 Call #R$E666 with note length #N$1106.
@ $E49B label=Handler_Interrupts_Done
  $E49B,$06 Restore the stashed registers from the stack.
  $E4A1,$01 Enable interrupts.
  $E4A2,$01 Return.
@ $E4A3 label=Handler_Interrupts_Beep
N $E4A3 #HTML(#AUDIO0(beep.wav)(#INCLUDE(Beep)))
  $E4A3,$04 Decrease *#R$6473.
  $E4A7,$07 Play a short beep.
  $E4AE,$03 Jump to #R$E49B.
N $E4B1 Toggle the speaker #REGd times using a random delay.
. #HTML(#AUDIO0(noise.wav)(#INCLUDE(Noise)))
@ $E4B1 label=Play_Noise
  $E4B1,$05 Output the quiet half-cycle.
  $E4B6,$03 Delay again.
  $E4B9,$02,b$01 Set the speaker bit.
  $E4BB,$02 Output the loud half-cycle.
  $E4BD,$03 Decrease #REGd and loop back to #R$E4B1.
  $E4C0,$01 Return.
@ $E4C1 label=Play_Noise_Delay
  $E4C1,$0D Delay by a random count masked with #REGb.
@ $E4CA label=Play_Noise_Wait
@ $E4CE label=Play_Noise_Done
  $E4CE,$04 #REGa=*#R$641D.
  $E4D2,$01 Return.
N $E4D3 Falling-pitch score sound.
. #HTML(#AUDIO0(score.wav)(#INCLUDE(Score)))
@ $E4D3 label=Sound_Score
  $E4D3,$02,b$01 Clear bit 4.
  $E4D5,$03 Write #REGa to *#R$6472.
  $E4D8,$03 #REGde=#N($0032,$04,$04).
  $E4DB,$03 #REGbc=#N($0064,$04,$04).
  $E4DE,$03 Jump to #R$E4E1.
N $E4E1 Square-wave sound while #REGde and #REGbc count down.
@ $E4E1 label=Sound_Square
  $E4E1,$08 Output the quiet half-cycle.
  $E4E9,$06 Fetch the border colour again.
  $E4EF,$02,b$01 Set the speaker bit.
  $E4F1,$02 Output the loud half-cycle.
  $E4F3,$05 Jump to #R$E4FD if #REGbc is now zero.
  $E4F8,$05 Decrease #REGde and loop back to #R$E4E1.
@ $E4FD label=Sound_Square_Done
  $E4FD,$03 #REGa=*#R$6472.
  $E500,$01 Return.
N $E501 Rising-pitch pickup sound.
. #HTML(#AUDIO0(pickup.wav)(#INCLUDE(Pickup)))
@ $E501 label=Sound_Pickup
  $E501,$08 Output the quiet half-cycle.
  $E509,$06 Fetch the border colour again.
  $E50F,$02,b$01 Set the speaker bit.
  $E511,$02 Output the loud half-cycle.
  $E513,$06 Increase #REGbc and loop back to #R$E501
. until #REGde is zero.
  $E519,$04 Return with *#R$6472.

c $E51D Animate Introduction
@ $E51D label=Animate_Introduction
D $E51D Animates the bats and moon on the introduction screen until a key is
. pressed or *#R$6470 reaches zero.
E $E51D View the equivalent code in #BOOTY$D0AC.
N $E51D #HTML(#AUDIO0(theme-tune.wav)(#INCLUDE(ThemeTune)))
  $E51D,$06 Call #R$E666 with note length #N$0A14.
  $E523,$0A Decrease *#R$6470 and jump to #R$E65B when it is
. zero.
  $E52D,$04 Write the decreased count back to *#R$6470.
  $E531,$09 Call #R$F430 when *#R$647C is set.
N $E53A Advance the four frame pointers and draw them across the
. moon.
  $E53A,$03 #REGhl=*#R$E632.
  $E53D,$04 Add #N($0004,$04,$04).
  $E541,$0A Jump to #R$E54E unless the pointer has reached #R$D4C1.
  $E54B,$03 Reset the pointer to #R$D381.
@ $E54E label=Animate_Introduction_Frame1
  $E54E,$03 Write #REGhl to *#R$E632.
  $E551,$06 Draw that frame at #N$4066.
  $E557,$03 #REGhl=*#R$E634.
  $E55A,$06 Subtract #N($0002,$04,$04).
  $E560,$09 Jump to #R$E56C unless the pointer has reached
. #R$D381(#N$D37F).
  $E569,$03 Reset the pointer to #R$D4C1.
@ $E56C label=Animate_Introduction_Frame2
  $E56C,$03 Write #REGhl to *#R$E634.
  $E56F,$06 Draw that frame at #N$4068.
  $E575,$03 #REGhl=*#R$E636.
  $E578,$02 Advance the pointer by two.
  $E57A,$0A Jump to #R$E587 unless the pointer has reached #R$D4C1.
  $E584,$03 Reset the pointer to #R$D381.
@ $E587 label=Animate_Introduction_Frame3
  $E587,$03 Write #REGhl to *#R$E636.
  $E58A,$06 Draw that frame at #N$406A.
  $E590,$03 #REGhl=*#R$E638.
  $E593,$06 Subtract #N($0004,$04,$04).
  $E599,$09 Jump to #R$E5A5 unless the pointer has reached #R$D381.
  $E5A2,$03 Reset the pointer to #R$D4C1.
@ $E5A5 label=Animate_Introduction_Frame4
  $E5A5,$03 Write #REGhl to *#R$E638.
  $E5A8,$06 Draw that frame at #N$406C.
N $E5AE Occasionally stamp a spark on the moon.
  $E5AE,$03 Call #R$F433.
  $E5B1,$04 Jump to #R$E5CA if the value is #N$40 or higher.
  $E5B5,$05 Point #REGhl at #R$E5EA when the value is #N$20 or
. higher.
  $E5BA,$05 Otherwise use the second spark at #R$E5EA(#N$E5EE).
@ $E5BF label=Animate_Introduction_Spark
  $E5BF,$03 #REGde=#N$40D7.
  $E5C2,$02 #REGb=#N$04.
@ $E5C4 label=Animate_Introduction_SparkLoop
  $E5C4,$06 Copy one pixel row and loop back to #R$E5C4 until all
. four rows are written.
N $E5CA Occasionally stamp a bat lower down the screen.
@ $E5CA label=Animate_Introduction_Bat
  $E5CA,$03 Call #R$F433.
  $E5CD,$04 Jump to #R$E5E1 if the value is #N$40 or higher.
  $E5D1,$07 Point #REGhl at #R$E5F2 when the value is #N$20 or
. higher.
  $E5D8,$03 Otherwise use #R$E612.
@ $E5DB label=Animate_Introduction_BatDraw
  $E5DB,$06 Draw that bat at #N$481D.
@ $E5E1 label=Animate_Introduction_Key
  $E5E1,$08 Jump to #R$E51D if no key is pressed.
  $E5E9,$01 Return.
@ $E5EA label=Graphics_IntroSpark
B $E5EA,$08 #UDGTABLE { #UDG(#PC)(intro-spark) } UDGTABLE#
@ $E5F2 label=Graphics_IntroBatA
E $E5F2 #UDGTABLE { #ANIMATE$0F,$02(intro-bat) } UDGTABLE#
B $E5F2,$20,$08 #UDGTABLE(default,centre)
. { #UDGS$02,$02,$04(intro-bat-1*)(
. #UDG(#PC+$08*($02*$y+$x))(*intro-bat)intro-bat) }
. UDGTABLE#
@ $E612 label=Graphics_IntroBatB
B $E612,$20,$08 #UDGTABLE(default,centre)
. { #UDGS$02,$02,$04(intro-bat-2*)(
. #UDG(#PC+$08*($02*$y+$x))(*intro-bat)intro-bat) }
. UDGTABLE#
@ $E632 label=Pointer_IntroFrame1
W $E632,$02
@ $E634 label=Pointer_IntroFrame2
W $E634,$02
@ $E636 label=Pointer_IntroFrame3
W $E636,$02
@ $E638 label=Pointer_IntroFrame4
W $E638,$02

c $E63A Draw Intro UDG
@ $E63A label=Draw_IntroUDG
D $E63A Draws a two-column, two-row UDG from *#REGhl to the
. screen at *#REGde. The introduction uses this for the moon
. and bat frames.
R $E63A HL Graphic data
R $E63A DE Screen address
N $E63A Draw the upper character row.
  $E63A,$02 Set the pixel-row counter to #N$08.
  $E63C,$01 Stash the screen address on the stack.
@ $E63D label=Draw_IntroUDG_Upper
  $E63D,$02 Write the left-hand pixel byte to the screen.
  $E63F,$02 Advance the graphic pointer and move to the next
. column.
  $E641,$02 Write the right-hand pixel byte to the screen.
  $E643,$01 Move back to the left-hand column.
  $E644,$01 Move down one pixel row.
  $E645,$01 Advance the graphic pointer.
  $E646,$02 Decrease the pixel-row counter by one and
. jump to #R$E63D until all eight rows are drawn.
N $E648 Move down one character row.
  $E648,$01 Restore the original screen address from the
. stack.
  $E649,$04 Add #N$20 to the screen address.
  $E64D,$02 Set the pixel-row counter to #N$08.
N $E64F Draw the lower character row.
@ $E64F label=Draw_IntroUDG_Lower
  $E64F,$02 Write the left-hand pixel byte to the screen.
  $E651,$02 Advance the graphic pointer and move to the next
. column.
  $E653,$02 Write the right-hand pixel byte to the screen.
  $E655,$01 Advance the graphic pointer.
  $E656,$01 Move back to the left-hand column.
  $E657,$01 Move down one pixel row.
  $E658,$02 Decrease the pixel-row counter by one and
. jump to #R$E64F until all eight rows are drawn.
  $E65A,$01 Return.

c $E65B Start Demo Game
@ $E65B label=Start_DemoGame
D $E65B The introduction timed out; start a demo game.
  $E65B,$05 Write #N$04 to *#R$D888.
  $E660,$05 Write #N$FF to *#R$646F.
  $E665,$01 Return.

c $E666 Play Tune
@ $E666 label=Play_Tune
D $E666 Plays one note from #R$B370 / #R$B491 through the speaker.
. #REGbc is the note length (#N$1106 in-game, #N$0A14 on the
. introduction).
N $E666 #HTML(#AUDIO0(theme-tune.wav)(#INCLUDE(ThemeTune)))
  $E666,$07 Jump to #R$F430 if *#R$647C is set.
  $E66D,$08 Jump to #R$E67F unless this byte is the wrap
. marker.
  $E675,$0A Reset both tune pointers and reload the first
. note.
@ $E67F label=Play_Tune_StorePitch
  $E67F,$07 Advance *#R$6469 and store the pitch in
. *#R$646D.
  $E686,$08 Read the matching duration from *#R$646B.
  $E68E,$09 Set the half-cycle counters from that pitch and
. duration.
  $E697,$08 Jump to #R$E6D7 if this is a rest.
@ $E69F label=Play_Tune_Tone
  $E69F,$0B Load the border colour and set the half-cycle
. counters.
@ $E6AA label=Play_Tune_Toggle
  $E6AA,$10 Toggle the speaker and loop back through
. #R$E6C5 and #R$E6CC.
@ $E6BA label=Play_Tune_Half
  $E6BA,$0B Reload the duration and loop back to #R$E6AA.
@ $E6C5 label=Play_Tune_Hold
  $E6C5,$07 Hold until the inner count expires.
@ $E6CC label=Play_Tune_Release
  $E6CC,$0B Toggle the speaker on the release half-cycle.
@ $E6D7 label=Play_Tune_Rest
  $E6D7,$15 Waste time for a rest.

b $E6EC Table: Default Keys
@ $E6EC label=Table_DefaultKeys
D $E6EC Copied to #R$647F by #R$D5AC. The first five
. bytes are the default #SKOOLKID$028E(KEY_SCAN) codes:
. 5, 8, 7, 6 and A (left, right, up, down, action).
E $E6EC View the equivalent code in #BOOTY$CD6F.
B $E6EC,$07

t $E6F3 Messaging: Title
@ $E6F3 label=Messaging_Title
D $E6F3 Control-byte message printed by #R$F460.
B $E6F3,$03 PRINT AT: #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
B $E6F6,$02 #COLOUR(#PEEK(#PC+$01)).
  $E6F8,$13 "#STR(#PC,$04,$13)".
B $E70B,$03 PRINT AT: #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $E70E,$15 "#STR(#PC,$04,$15)".
B $E723,$03 PRINT AT: #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $E726,$15 "#STR(#PC,$04,$15)".
B $E73B,$01 Terminator.

t $E73C Messaging: Menu
@ $E73C label=Messaging_Menu
B $E73C,$03 PRINT AT: #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
B $E73F,$02 #COLOUR(#PEEK(#PC+$01)).
  $E741,$0E "#STR(#PC,$04,$0E)".
B $E74F,$01 Terminator.

t $E750 Messaging: Keyboard
@ $E750 label=Messaging_Keyboard
B $E750,$03 PRINT AT: #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $E753,$0C "#STR(#PC,$04,$0C)".
B $E75F,$02 #COLOUR(#PEEK(#PC+$01)).
B $E761,$01 Terminator.

t $E762 Messaging: Kempston
@ $E762 label=Messaging_Kempston
B $E762,$03 PRINT AT: #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $E765,$15 "#STR(#PC,$04,$15)".
B $E77A,$02 #COLOUR(#PEEK(#PC+$01)).
B $E77C,$03 PRINT AT: #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $E77F,$0F "#STR(#PC,$04,$0F)".
B $E78E,$01 Terminator.

t $E78F Messaging: Define Keys
@ $E78F label=Messaging_DefineKeys
B $E78F,$02 #COLOUR(#PEEK(#PC+$01)).
B $E791,$03 PRINT AT: #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $E794,$0B "#STR(#PC,$04,$0B)".
B $E79F,$03 PRINT AT: #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $E7A2,$04 "#STR(#PC,$04,$04)".
B $E7A6,$03 PRINT AT: #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $E7A9,$05 "#STR(#PC,$04,$05)".
B $E7AE,$03 PRINT AT: #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $E7B1,$02 "#STR(#PC,$04,$02)".
B $E7B3,$03 PRINT AT: #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $E7B6,$04 "#STR(#PC,$04,$04)".
B $E7BA,$03 PRINT AT: #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $E7BD,$16 "#STR(#PC,$04,$16)".
B $E7D3,$03 PRINT AT: #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
B $E7D6,$02 #COLOUR(#PEEK(#PC+$01)).
  $E7D8,$0B "#STR(#PC,$04,$0B)".
B $E7E3,$01 Terminator.

t $E7E4 Messaging: Load Game
@ $E7E4 label=Messaging_LoadGame
B $E7E4,$03 PRINT AT: #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
B $E7E7,$02 #COLOUR(#PEEK(#PC+$01)).
  $E7E9,$18 "#STR(#PC,$04,$18)".
B $E801,$01 Terminator.

b $E802 Table: Key Map
@ $E802 label=Table_KeyMap
D $E802 Glyphs used when printing a KEY_SCAN code.
E $E802 View the equivalent code in #BOOTY$D22C.
B $E802,$28

w $E82A Table: Room Pause
@ $E82A label=Table_RoomPause
D $E82A One delay word per room, read by #R$D877.
W $E82A,$2E,$02

u $E858

c $E9FC Initialise Rooms
@ $E9FC label=Initialise_Rooms
D $E9FC Jumps to #R$EA02 to unpack the #N$17 rooms from #R$BC11.
E $E9FC View the equivalent code in #BOOTY$AA97.
  $E9FC,$03 Jump to #R$EA02.

c $E9FF Dispatch Events
@ $E9FF label=Dispatch_Events
D $E9FF Jumps to #R$EDD9 with the event ID in #REGa.
  $E9FF,$03 Jump to #R$EDD9.

c $EA02 Unpack Rooms
@ $EA02 label=Unpack_Rooms
D $EA02 Builds #R$64C5 and copies each packed room into #R$64F7. #REGa=#N$FF
. initialises every room, otherwise it loads that room.
  $EA02,$03 Return if #REGa is #N$1E.
  $EA05,$05 Jump to #R$EAA6 unless #REGa is #N$FF.
  $EA0A,$03 Call #R$ED51.
  $EA0D,$06 Write #R$7C70 to *#R$640E.
  $EA13,$03 Call #R$ED71.
  $EA16,$12 Clear the collection and score words.
  $EA28,$05 Write #N$04 to *#R$64B4.
  $EA2D,$03 Write #N($0000,$04,$04) to *#R$6417.
  $EA30,$07 Write #N$00 to *#R$64A1 and *#R$647D.
N $EA37 Point at the packed rooms and the unpack buffers.
  $EA37,$03 #REGhl=#R$BC11.
  $EA3A,$04 #REGix=#R$64C5.
  $EA3E,$03 #REGde=#R$64F7.
  $EA41,$02 #REGb=#N$17.
@ $EA43 label=Unpack_Rooms_Loop
  $EA43,$01 Stash the room count on the stack.
  $EA44,$0A Write the destination address into the next
. #R$64C5 slot.
  $EA4E,$04 Copy the room header byte.
  $EA52,$06 Copy each header-furniture record.
  $EA58,$06 Copy each furniture record.
  $EA5E,$06 Copy each door record.
  $EA64,$06 Copy each collectible record.
  $EA6A,$06 Copy each inventory record.
  $EA70,$06 Copy each ladder record.
  $EA76,$06 Copy each decoration record.
  $EA7C,$06 Copy each actor record.
  $EA82,$06 Copy each enemy record.
  $EA88,$06 Copy each moving-object record.
  $EA8E,$03 Restore the room count and loop back to #R$EA43.
  $EA91,$06 Store the final pointer.
  $EA97,$01 #REGa=#N$00.
  $EA98,$02 Jump to #R$EAA6.
@ $EA9A label=Copy_TerminatedField
  $EA9A,$04 Copy the next byte and advance both pointers.
  $EA9E,$02 Return if that byte was #N$FF.
N $EAA0 Copy the remaining bytes of this field.
  $EAA0,$01 Stash the count on the stack.
  $EAA1,$02 Copy the remaining #REGbc bytes.
  $EAA3,$01 Restore the count from the stack.
  $EAA4,$02 Jump to #R$EA9A.
N $EAA6 Load the room in #REGa.
@ $EAA6 label=Load_Room
E $EAA6 View the equivalent code in #BOOTY$A900.
  $EAA6,$03 Write #REGa to *#R$64A2.
  $EAA9,$02,b$01 Keep only bits 0-6.
  $EAAB,$0C Look up that room's pointer from #R$64C5.
  $EAB7,$03 #REGa=*#R$64A2.
N $EABA Refresh the working copy when this room is not already
. current.
  $EABA,$04 Jump to #R$EADD if bit 7 of *#R$64A2 is set.
  $EABE,$01 #REGa=*#REGde.
  $EABF,$02,b$01 Keep only bit 7.
  $EAC1,$02 Jump to #R$EADD if the working copy is already
. current.
  $EAC3,$06 Fetch the next pointer and copy it to #REGhl.
  $EAC9,$05 #REGbc=#REGhl-#REGde (length of this room).
  $EACE,$08 Point #REGhl at #R$64F7 relative to the packed
. source.
  $EAD6,$07 Add #R$BC11 and copy the packed room into the
. working buffer.
@ $EADD label=Load_Room_Draw
  $EADD,$08 Clear bit 7 of *#R$64A2.
  $EAE5,$02 Restore the room pointer from the stack into
. #REGix.
  $EAE7,$06 Write #R$7C70 to *#SKOOLKID$5C36(CHARS).
  $EAED,$03 Call #R$ED51.
  $EAF0,$05 Write #INK$01 to *#R$641D.
  $EAF5,$02 Set the border to #INK$01.
N $EAF7 Copy the matching font bank for this room.
  $EAF7,$03 #REGa=the room header.
  $EAFA,$02,b$01 Keep only bits 4-5.
  $EAFC,$03 Call #R$ED2D if the font bank is #N$00.
  $EAFF,$05 Call #R$ED39 if the font bank is #N$10.
  $EB04,$05 Call #R$ED45 if the font bank is #N$20.
  $EB09,$06 Write #REGix to *#R$641E.
N $EB0F Draw each visible header-furniture record.
@ $EB0F label=Load_Room_Header
  $EB0F,$07 Jump to #R$EB22 if the terminator #N$FF is reached.
  $EB16,$05 Call #R$EDB1 if this record is visible.
  $EB1B,$05 #REGix+=#N($0006,$04,$04).
  $EB20,$02 Jump to #R$EB0F.
N $EB22 Draw each visible furniture record into *#R$6420.
@ $EB22 label=Load_Room_Furniture
  $EB22,$06 Write #REGix to *#R$6420.
@ $EB28 label=Load_Room_Furniture_Target
  $EB28,$07 Jump to #R$EB3D if the terminator #N$FF is reached.
  $EB2F,$04 Jump to #R$EB36 if this record is hidden.
  $EB33,$03 Call #R$ED82.
@ $EB36 label=Load_Room_Furniture_Continue
  $EB36,$05 #REGix+=#N($0005,$04,$04).
  $EB3B,$02 Jump to #R$EB28.
N $EB3D Draw each visible door record into *#R$6422.
@ $EB3D label=Load_Room_Doors
  $EB3D,$06 Write #REGix to *#R$6422.
@ $EB43 label=Load_Room_Doors_Target
  $EB43,$07 Jump to #R$EB58 if the terminator #N$FF is reached.
  $EB4A,$04 Jump to #R$EB51 if this record is hidden.
  $EB4E,$03 Call #R$ED9A.
@ $EB51 label=Load_Room_Doors_Continue
  $EB51,$05 #REGix+=#N($0005,$04,$04).
  $EB56,$02 Jump to #R$EB43.
N $EB58 Skip each collectible record into *#R$6424.
@ $EB58 label=Load_Room_Collectibles
  $EB58,$06 Write #REGix to *#R$6424.
@ $EB5E label=Load_Room_Collectibles_Target
  $EB5E,$07 Jump to #R$EB6C if the terminator #N$FF is reached.
  $EB65,$05 #REGix+=#N($0003,$04,$04).
  $EB6A,$02 Jump to #R$EB5E.
N $EB6C Draw each visible key into *#R$6426.
@ $EB6C label=Load_Room_Inventory
  $EB6C,$06 Write #REGix to *#R$6426.
@ $EB72 label=Load_Room_Inventory_Target
  $EB72,$07 Jump to #R$EB97 if the terminator #N$FF is reached.
  $EB79,$04 Jump to #R$EB91 if this record is hidden.
  $EB7D,$07 Call #R$F42D at the item's column and row.
  $EB84,$05 Write #INK$07 to *#SKOOLKID$5C8F(ATTR_T).
  $EB89,$08 Call #R$F445 with the key glyph #N$80 and size
. #N$02 by #N$02.
@ $EB91 label=Load_Room_Inventory_Continue
  $EB91,$04 Advance #REGix by two.
  $EB95,$02 Jump to #R$EB72.
N $EB97 Draw each visible ladder into *#R$6428.
@ $EB97 label=Load_Room_Ladders
  $EB97,$06 Write #REGix to *#R$6428.
@ $EB9D label=Load_Room_Ladders_Target
  $EB9D,$07 Jump to #R$EBD3 if the terminator #N$FF is reached.
  $EBA4,$04 Jump to #R$EBCB if this record is hidden.
  $EBA8,$08 Call #R$F42D at the ladder's column and row.
  $EBB0,$06 Write the ladder colour to *#SKOOLKID$5C8F(ATTR_T).
  $EBB6,$08 Call #R$F445 with glyph #N$0E and size #N$01 by
. #N$02.
  $EBBE,$05 Call #R$F42D one row higher.
  $EBC3,$08 Call #R$F445 with glyph #N$DB and size #N$04 by
. #N$02.
@ $EBCB label=Load_Room_Ladders_Continue
  $EBCB,$06 Advance #REGix by three.
  $EBD1,$02 Jump to #R$EB9D.
N $EBD3 Draw each visible decoration into *#R$642E.
@ $EBD3 label=Load_Room_Decorations
  $EBD3,$06 Write #REGix to *#R$642E.
@ $EBD9 label=Load_Room_Decorations_Target
  $EBD9,$07 Jump to #R$EC04 if the terminator #N$FF is reached.
  $EBE0,$04 Jump to #R$EBFD if this record is hidden.
  $EBE4,$07 Call #R$F42D at the decoration's column and row.
  $EBEB,$06 Write the decoration colour to
. *#SKOOLKID$5C8F(ATTR_T).
  $EBF1,$0C Call #R$F445 with the stored glyph and size.
@ $EBFD label=Load_Room_Decorations_Continue
  $EBFD,$05 #REGix+=#N($0006,$04,$04).
  $EC02,$02 Jump to #R$EBD9.
N $EC04 Draw each visible actor into *#R$6430.
@ $EC04 label=Load_Room_Actors
  $EC04,$06 Write #REGix to *#R$6430.
@ $EC0A label=Load_Room_Actors_Target
  $EC0A,$07 Jump to #R$EC1F if the terminator #N$FF is reached.
  $EC11,$04 Jump to #R$EC18 if this record is hidden.
  $EC15,$03 Call #R$F45A.
@ $EC18 label=Load_Room_Actors_Continue
  $EC18,$05 #REGix+=#N($000D,$04,$04).
  $EC1D,$02 Jump to #R$EC0A.
N $EC1F Draw each visible enemy into *#R$6432.
@ $EC1F label=Load_Room_Enemies
  $EC1F,$06 Write #R$9070 to *#SKOOLKID$5C36(CHARS).
  $EC25,$06 Write #REGix to *#R$6432.
@ $EC2B label=Load_Room_Enemies_Target
  $EC2B,$07 Jump to #R$EC40 if the terminator #N$FF is reached.
  $EC32,$04 Jump to #R$EC39 if this record is hidden.
  $EC36,$03 Call #R$F44B.
@ $EC39 label=Load_Room_Enemies_Continue
  $EC39,$05 #REGix+=#N($000E,$04,$04).
  $EC3E,$02 Jump to #R$EC2B.
N $EC40 Draw each visible moving object into *#R$642A.
@ $EC40 label=Load_Room_Movers
  $EC40,$06 Write #REGix to *#R$642A.
@ $EC46 label=Load_Room_Movers_Target
  $EC46,$07 Jump to #R$EC65 if the terminator #N$FF is reached.
  $EC4D,$04 Jump to #R$EC5E if this record is hidden.
  $EC51,$0A Write the object's clip window to *#R$6419.
  $EC5B,$03 Call #R$F44B.
@ $EC5E label=Load_Room_Movers_Continue
  $EC5E,$05 #REGix+=#N($0013,$04,$04).
  $EC63,$02 Jump to #R$EC46.
N $EC65 Draw the status bar and reset the per-room flags.
@ $EC65 label=Load_Room_Status
  $EC65,$02 Advance past the terminator.
  $EC67,$06 Convert column #N$21, row #N$02 into a #R$5DCE
. offset.
  $EC6D,$04 Point #REGhl at the matching attribute cell.
  $EC71,$08 Fill #N$0220 attribute cells with #INK$08.
  $EC79,$03 Call #R$ECF2.
N $EC7C Draw the status icons.
  $EC7C,$03 #REGbc=#N$011F.
  $EC7F,$06 Write #R$7C70 to *#SKOOLKID$5C36(CHARS).
  $EC85,$03 Call #R$F427.
  $EC88,$07 Call #R$ED71 when *#R$6411 is set.
  $EC8F,$0E Write the default clip window to *#R$6419.
  $EC9D,$01 #REGa=#N$00.
  $EC9E,$0C Clear #N$0A bytes from *#R$6472.
  $ECAA,$06 Write #N$0102 to *#R$6486.
  $ECB0,$06 Copy *#R$6484 back to *#R$647F.
  $ECB6,$06 Clear *#R$6489 and *#R$648A.
  $ECBC,$06 Clear *#R$644B.
  $ECC2,$09 Clear *#R$649F, *#R$6410 and *#R$6411.
  $ECCB,$0F Clear *#R$6435 and the stand timers.
  $ECDA,$06 Clear *#R$64A3 and *#R$6434.
  $ECE0,$07 Write #N$FF to #R$644D and #R$645B.
  $ECE7,$05 Write #N$60 to *#R$64AA.
  $ECEC,$05 Write #N$80 to *#R$648B.
  $ECF1,$01 Return.

c $ECF2 Print Inventory
@ $ECF2 label=Print_Inventory
D $ECF2 Prints the four #R$64C1 digits and flashes them when every slot is
. #N$09.
  $ECF2,$05 Write #INK$0F to *#SKOOLKID$5C8F(ATTR_T).
  $ECF7,$06 Write #N$3C00 to *#SKOOLKID$5C36(CHARS).
  $ECFD,$06 Call #R$F42D at column #N$07, row #N$01.
N $ED03 Print the four combination digits.
  $ED03,$03 #REGbc=#N$0400.
  $ED06,$03 #REGhl=#R$64C1.
@ $ED09 label=Print_Inventory_Target
  $ED09,$05 Jump to #R$ED0F unless this digit is #N$09.
  $ED0E,$01 Increase the "#N$09" count.
@ $ED0F label=Print_Inventory_Continue
  $ED0F,$02 Convert the digit into ASCII.
  $ED11,$03 Call #R$F436.
  $ED14,$03 Advance the digit pointer and loop back to #R$ED09.
N $ED17 Flash the four cells when every digit is #N$09.
  $ED17,$04 Return unless all four digits were #N$09.
  $ED1B,$06 Convert column #N$07, row #N$01 into a #R$5DCE
. offset.
  $ED21,$06 Point #REGhl at the matching attribute cells.
@ $ED27 label=Print_Inventory_Target2
  $ED27,$05 Set FLASH on each of the four cells.
  $ED2C,$01 Return.

c $ED2D Copy Font Bank 1
@ $ED2D label=Copy_FontBank1
  $ED2D,$0B Copy #N$0400 bytes from #R$8470 to #R$7C70.
  $ED38,$01 Return.

c $ED39 Copy Font Bank 2
@ $ED39 label=Copy_FontBank2
  $ED39,$0B Copy #N$0400 bytes from #R$8870 to #R$7C70.
  $ED44,$01 Return.

c $ED45 Copy Font Bank 3
@ $ED45 label=Copy_FontBank3
  $ED45,$0B Copy #N$0400 bytes from #R$8C70 to #R$7C70.
  $ED50,$01 Return.

c $ED51 Clear Room Buffers
@ $ED51 label=Clear_RoomBuffers
  $ED51,$01 Stash #REGaf on the stack.
  $ED52,$04 Write #N$00 to *#SKOOLKID$5C8D(ATTR_P).
  $ED56,$05 Clear the bottom #N$18 lines using
. #SKOOLKID$0E44(CL_LINE).
  $ED5B,$0D Fill #R$5DCE with #N$C8.
  $ED68,$07 Fill #R$60EE with #N$00.
  $ED6F,$01 Restore #REGaf from the stack.
  $ED70,$01 Return.

c $ED71 Reset Player
@ $ED71 label=Reset_Player
  $ED71,$06 Place the player at column #N$12, row #N$12.
N $ED77 Use sprite #N$60.
  $ED77,$02 #REGa=#N$60.
  $ED79,$02 #REGl=#INK$45.
  $ED7B,$04 #REGix=#R$64A4.
  $ED7F,$03 Jump to #R$F457.

c $ED82 Draw Furniture
@ $ED82 label=Draw_FurnitureItem
N $ED82 Call #R$F42D at the furniture column and row.
  $ED82,$06 #REGbc=the furniture column and row.
  $ED88,$03 Call #R$F42D.
  $ED8B,$06 Write the furniture colour to
. *#SKOOLKID$5C8F(ATTR_T).
N $ED91 Use the stored glyph.
  $ED91,$03 #REGa=the stored glyph.
  $ED94,$03 #REGde=#N$0403.
  $ED97,$03 Jump to #R$F445.

c $ED9A Draw Door
@ $ED9A label=Draw_Door
N $ED9A Call #R$F42D at the door column and row.
  $ED9A,$06 #REGbc=the door column and row.
  $EDA0,$03 Call #R$F42D.
  $EDA3,$06 Write the door colour to *#SKOOLKID$5C8F(ATTR_T).
N $EDA9 Use glyph #N$84.
  $EDA9,$02 #REGa=#N$84.
  $EDAB,$03 #REGde=#N$0202.
  $EDAE,$03 Jump to #R$F445.

c $EDB1 Draw Header Furniture
@ $EDB1 label=Draw_HeaderFurniture
  $EDB1,$06 Fetch the print row and the stored column.
  $EDB7,$02,b$01 Keep only bits 0-6.
  $EDB9,$01 #REGc=the column.
  $EDBA,$03 Call #R$F42D.
  $EDBD,$06 Write the furniture colour to
. *#SKOOLKID$5C8F(ATTR_T).
  $EDC3,$03 #REGb=the remaining height.
@ $EDC6 label=Draw_HeaderFurniture_Target
  $EDC6,$06 Fetch the starting glyph and the remaining width.
@ $EDCC label=Draw_HeaderFurniture_Continue
  $EDCC,$03 Call #R$F436.
  $EDCF,$03 Call #R$F43F.
  $EDD2,$04 Increase the glyph and loop back to #R$EDCC
. until this row is drawn.
  $EDD6,$02 Decrease the height and loop back to #R$EDC6.
  $EDD8,$01 Return.

c $EDD9 Handler: Events
@ $EDD9 label=Handler_Events
D $EDD9 Dispatches the event ID in #REGa to a room
. action. Bit 7 marks a collectible pickup.
R $EDD9 A Event ID (bit 7 set for a collectible)
R $EDD9 IX Player entity (unused)
N $EDD9 Stash the caller context.
  $EDD9,$06 Stash #REGix and *#SKOOLKID$5C36(CHARS) on the
. stack.
  $EDDF,$04 Push #R$EECB as the return address.
N $EDE3 Use the in-game font.
  $EDE3,$06 Write #R$7C70 to *#SKOOLKID$5C36(CHARS).
N $EDE9 Ignore event #N$26.
  $EDE9,$03 Return through #R$EECB if the event is #N$26.
N $EDEC Return if a timer is already running.
  $EDEC,$01 Copy the event ID into #REGl.
  $EDED,$05 Return through #R$EECB if *#R$649F is already
. running.
N $EDF2 Collectibles skip the event sound.
  $EDF2,$04 Jump to #R$EDFB if this is a collectible event.
  $EDF6,$05 Write #N$10 to *#R$6472.
N $EDFB Keep only the event ID.
@ $EDFB label=Handler_Events_Dispatch
  $EDFB,$01 Copy the event ID into #REGa.
  $EDFC,$02,b$01 Keep only bits 0-6.
N $EDFE Jump to the handler for this event ID.
  $EDFE,$04 Jump to #R$EFE6 if the event is #N$00
. (draw the first header item).
  $EE02,$05 Jump to #R$EFF5 if the event is #N$01
. (draw the next header item).
  $EE07,$05 Jump to #R$F000 if the event is #N$03
. (draw the first two header items).
  $EE0C,$05 Jump to #R$F011 if the event is #N$02
. (nudge the first actor).
  $EE11,$05 Jump to #R$F350 if the event is #N$04
. (print the event message).
  $EE16,$05 Jump to #R$F03E if the event is #N$05
. (start the first enemy).
  $EE1B,$05 Jump to #R$EEFA if the event is #N$06
. (reveal the room-header item).
  $EE20,$05 Jump to #R$F0C0 if the event is #N$07
. (reveal three header items).
  $EE25,$05 Jump to #R$EF8A if the event is #N$08
. (start an actor walking).
  $EE2A,$05 Jump to #R$F395 if the event is #N$09
. (toggle the silent-tune flag).
  $EE2F,$05 Jump to #R$F06A if the event is #N$0A
. (start a short event timer).
  $EE34,$05 Jump to #R$F1C4 if the event is #N$0B
. (reveal a decoration and a mover).
  $EE39,$05 Jump to #R$F1D4 if the event is #N$0C
. (reveal the next decoration and mover).
  $EE3E,$05 Jump to #R$F26A if the event is #N$0D
. (hide a later actor).
  $EE43,$05 Jump to #R$EFD3 if the event is #N$0E
. (swap the left/right keys).
  $EE48,$05 Jump to #R$F28F if the event is #N$0F
. (hide the first active actor).
  $EE4D,$05 Jump to #R$F22C if the event is #N$11
. (hide the first furniture item).
  $EE52,$05 Jump to #R$F2E0 if the event is #N$12
. (reveal the first door).
  $EE57,$05 Jump to #R$F31D if the event is #N$13
. (reveal the next door).
  $EE5C,$05 Jump to #R$EEE5 if the event is #N$14
. (reveal two decorations).
  $EE61,$05 Jump to #R$F328 if the event is #N$15
. (reveal the third door).
  $EE66,$05 Jump to #R$F2B2 if the event is #N$16
. (randomise the combination).
  $EE6B,$05 Jump to #R$F072 if the event is #N$17
. (draw two header items and start a timer).
  $EE70,$05 Jump to #R$F164 if the event is #N$18
. (show the first hidden enemy).
  $EE75,$05 Jump to #R$F0E4 if the event is #N$19
. (reveal the first furniture item).
  $EE7A,$05 Jump to #R$EF3A if the event is #N$1A
. (reveal two decorations and a mover).
  $EE7F,$05 Jump to #R$F125 if the event is #N$1B
. (reveal the first ladder).
  $EE84,$05 Jump to #R$EF5C if the event is #N$1C
. (reveal three decorations and three movers).
  $EE89,$05 Jump to #R$F361 if the event is #N$1D
. (reveal every decoration).
  $EE8E,$05 Jump to #R$F1EE if the event is #N$1E
. (reveal three decorations).
  $EE93,$05 Jump to #R$F217 if the event is #N$1F
. (show every moving object).
  $EE98,$05 Jump to #R$F249 if the event is #N$20
. (increment combination digit 4).
  $EE9D,$05 Jump to #R$F244 if the event is #N$21
. (increment combination digit 3).
  $EEA2,$05 Jump to #R$F188 if the event is #N$22
. (award a combination digit).
  $EEA7,$05 Jump to #R$F24E if the event is #N$23
. (increment combination digit 2).
  $EEAC,$05 Jump to #R$F07D if the event is #N$24
. (hide two header items).
  $EEB1,$05 Jump to #R$F253 if the event is #N$25
. (increment combination digit 1).
  $EEB6,$05 Jump to #R$F006 if the event is #N$27
. (draw the fourth header item).
  $EEBB,$05 Jump to #R$F0B4 if the event is #N$28
. (hide the fourth header item).
  $EEC0,$05 Jump to #R$F1B6 if the event is #N$29
. (test the second header item).
  $EEC5,$05 Jump to #R$EED2 if the event is #N$2A
. (hide the first two enemies).
N $EECA Ignore an unhandled event ID.
@ $EECA label=Handler_Events_Done
  $EECA,$01 Drop the unused return address.
N $EECB Restore the font and #REGix.
@ $EECB label=Handler_Events_Restore
  $EECB,$04 Restore *#SKOOLKID$5C36(CHARS) from the stack.
  $EECF,$02 Restore #REGix from the stack.
N $EED1 Return.
  $EED1,$01 Return.

c $EED2 Event: Hide Enemies
@ $EED2 label=Event_HideEnemies
D $EED2 Event #N$2A: hide the first two enemies.
  $EED2,$03 Call #R$F006.
  $EED5,$03 Call #R$F164.
  $EED8,$04 #REGix=*#R$6432.
  $EEDC,$08 Set bit 7 on the first two enemy records.
  $EEE4,$01 Return.

c $EEE5 Event: Reveal Decorations
@ $EEE5 label=Event_RevealDecorations
D $EEE5 Event #N$14: reveal two decorations.
  $EEE5,$04 #REGix=*#R$642E.
  $EEE9,$02 #REGb=#N$02.
@ $EEEB label=Event_RevealDecorations_Target
  $EEEB,$01 Stash the count on the stack.
  $EEEC,$03 Call #R$F193.
  $EEEF,$05 Advance to the next decoration.
  $EEF4,$01 Restore the count from the stack.
  $EEF5,$02 Decrease the count and loop back to #R$EEEB.
  $EEF7,$03 Jump to #R$F164.

c $EEFA Event: Reveal Header
@ $EEFA label=Event_RevealHeader
D $EEFA Event #N$06: reveal the room-header item.
  $EEFA,$04 #REGix=*#R$641E.
  $EEFE,$05 Return if this header item is already visible.
  $EF03,$07 Write #N$2020 to *#R$6472.
  $EF0A,$04 Clear bit 7 of the header record.
  $EF0E,$09 Fetch the column, row and width.
  $EF17,$02 Height #N$01.
  $EF19,$06 Fetch the colour and glyph.
  $EF1F,$04 #REGix=#R$648B.
  $EF23,$03 Call #R$F457.
  $EF26,$03 Call #R$F333.
  $EF29,$04 Write #N$01 as the horizontal delta.
  $EF2D,$0C Subtract the width from the column and store it.
  $EF39,$01 Return.

c $EF3A Event: Reveal Pair
@ $EF3A label=Event_RevealPair
D $EF3A Event #N$1A: reveal two decorations and a mover.
  $EF3A,$09 #REGix=*#R$642E+#N($000C,$04,$04).
  $EF43,$03 Call #R$F193.
  $EF46,$05 Advance one decoration.
  $EF4B,$03 Call #R$F193.
  $EF4E,$0D Clear bit 7 of *#R$642A+#N($0026,$04,$04).
  $EF5B,$01 Return.

c $EF5C Event: Reveal Triple
@ $EF5C label=Event_RevealTriple
D $EF5C Event #N$1C: reveal three decorations and three movers.
  $EF5C,$09 #REGix=*#R$642E+#N($0018,$04,$04).
  $EF65,$02 #REGb=#N$03.
N $EF67 Reveal three decorations.
@ $EF67 label=Event_RevealTriple_Target
  $EF67,$01 Stash the count on the stack.
  $EF68,$03 Call #R$F193.
  $EF6B,$01 Restore the count from the stack.
  $EF6C,$05 Advance to the next decoration.
  $EF71,$02 Decrease the count and loop back to #R$EF67.
N $EF73 Reveal three movers.
  $EF73,$09 #REGix=*#R$642A+#N($0039,$04,$04).
  $EF7C,$02 #REGb=#N$03.
  $EF7E,$03 #REGde=#N($0013,$04,$04).
@ $EF81 label=Event_RevealTriple_Target2
  $EF81,$04 Clear bit 7 of this mover.
  $EF85,$02 #REGix+=#REGde.
  $EF87,$02 Decrease the count and loop back to #R$EF81.
  $EF89,$01 Return.

c $EF8A Event: Start Actor
@ $EF8A label=Event_StartActor
D $EF8A Event #N$08: start an actor walking.
  $EF8A,$04 #REGix=*#R$6430.
@ $EF8E label=Event_StartActor_Target
  $EF8E,$06 Return if the terminator #N$FF is reached.
  $EF94,$04 Jump to #R$EFCC if this actor is hidden.
  $EF98,$08 Jump to #R$EFCC if the actor already has a delta.
  $EFA0,$06 Jump to #R$EFB7 if there is no horizontal
. destination.
  $EFA6,$05 Jump to #R$EFB1 if the actor is left of the
. destination.
  $EFAB,$04 Write #N$FE as the horizontal delta.
  $EFAF,$02 Jump to #R$EFCC.
@ $EFB1 label=Event_StartActor_Branch
  $EFB1,$04 Write #N$02 as the horizontal delta.
  $EFB5,$02 Jump to #R$EFCC.
@ $EFB7 label=Event_StartActor_Skip
  $EFB7,$06 Jump to #R$EFCC if there is no vertical
. destination.
  $EFBD,$05 Jump to #R$EFC8 if the actor is above the
. destination.
  $EFC2,$04 Write #N$FE as the vertical delta.
  $EFC6,$02 Jump to #R$EFCC.
@ $EFC8 label=Event_StartActor_Branch2
  $EFC8,$04 Write #N$02 as the vertical delta.
@ $EFCC label=Event_StartActor_Continue
  $EFCC,$05 #REGix+=#N($000D,$04,$04).
  $EFD1,$02 Jump to #R$EF8E.

c $EFD3 Event: Swap Keys
@ $EFD3 label=Event_SwapKeys
D $EFD3 Event #N$0E: swap the left/right keys.
  $EFD3,$09 Swap *#R$647F with *#R$6480.
  $EFDC,$09 Swap the two bytes at *#R$6486.
  $EFE5,$01 Return.

c $EFE6 Event: Draw Header
@ $EFE6 label=Event_DrawHeader
D $EFE6 Event #N$00: draw the first header item.
  $EFE6,$04 #REGix=*#R$641E.
@ $EFEA label=Event_DrawHeader_Body
  $EFEA,$03 #REGa=the header record.
  $EFED,$02,b$01 Keep only bits 0-6.
  $EFEF,$03 Write it back.
  $EFF2,$03 Jump to #R$EDB1.

c $EFF5 Event: Draw Next Header
@ $EFF5 label=Event_DrawHeaderNext
D $EFF5 Event #N$01: draw the next header item.
  $EFF5,$04 #REGix=*#R$641E.
  $EFF9,$05 #REGix+=#N($0006,$04,$04).
  $EFFE,$02 Jump to #R$EFEA.

c $F000 Event: Draw Header Pair
@ $F000 label=Event_DrawHeaderPair
D $F000 Event #N$03: draw the first two header items.
  $F000,$03 Call #R$EFE6.
  $F003,$03 Jump to #R$EFF5.

c $F006 Event: Draw Fourth Header
@ $F006 label=Event_DrawHeaderFourth
D $F006 Event #N$27: draw the fourth header item.
  $F006,$04 #REGix=*#R$641E.
  $F00A,$05 #REGix+=#N($0012,$04,$04).
  $F00F,$02 Jump to #R$EFEA.

c $F011 Event: Nudge Actor
@ $F011 label=Event_NudgeActor
D $F011 Event #N$02: nudge the first actor.
  $F011,$04 #REGix=*#R$6430.
@ $F015 label=Event_NudgeActor_Target
  $F015,$05 Return if the terminator #N$FF is reached.
  $F01A,$05 Return if the actor already has a vertical delta.
  $F01F,$06 Jump to #R$F037 if there is no stored destination.
  $F025,$08 Jump to #R$F033 if the actor is above the
. destination.
  $F02D,$04 Write #N$FE as the vertical delta.
  $F031,$02 Jump to #R$F037.
@ $F033 label=Event_NudgeActor_Branch
  $F033,$04 Write #N$02 as the vertical delta.
@ $F037 label=Event_NudgeActor_Skip
  $F037,$05 #REGix+=#N($000D,$04,$04).
  $F03C,$02 Jump to #R$F015.

c $F03E Event: Start Enemy
@ $F03E label=Event_StartEnemy
D $F03E Event #N$05: start the first enemy.
  $F03E,$07 Write #N$2614 to *#R$649F.
  $F045,$04 #REGix=*#R$6432.
@ $F049 label=Event_StartEnemy_Target
  $F049,$05 Return if the terminator #N$FF is reached.
  $F04E,$04 Jump to #R$F063 if this enemy is hidden.
  $F052,$04 Negate the horizontal delta.
  $F056,$02,b$01 Invert the subtracted byte.
  $F058,$03 Write the new horizontal delta.
  $F05B,$03 #REGa=*#REGix+#N$07.
  $F05E,$02,b$01 Toggle bit 7.
  $F060,$03 Write the facing flag back.
@ $F063 label=Event_StartEnemy_Continue
  $F063,$05 #REGix+=#N($000E,$04,$04).
  $F068,$02 Jump to #R$F049.

c $F06A Event: Start Short Timer
@ $F06A label=Event_ShortTimer
D $F06A Event #N$0A: start a short event timer.
  $F06A,$07 Write #N$021C to *#R$649F.
  $F071,$01 Return.

c $F072 Event: Draw Header Timer
@ $F072 label=Event_HeaderAndTimer
D $F072 Event #N$17: draw two header items and start a timer.
  $F072,$03 Call #R$F000.
  $F075,$07 Write #N$246E to *#R$649F.
  $F07C,$01 Return.

c $F07D Event: Hide Header Pair
@ $F07D label=Event_HideHeaderPair
D $F07D Event #N$24: hide two header items.
  $F07D,$02 #REGb=#N$02.
  $F07F,$04 #REGix=*#R$641E.
@ $F083 label=Event_HideHeaderPair_Target
  $F083,$01 Stash the count on the stack.
  $F084,$03 Call #R$F090.
  $F087,$01 Restore the count from the stack.
  $F088,$05 Advance to the next header record.
  $F08D,$02 Decrease the count and loop back to #R$F083.
  $F08F,$01 Return.

c $F090 Hide Header Item
@ $F090 label=Hide_HeaderItem
D $F090 Hides one header item by overprinting #N$C8.
  $F090,$03 #REGa=the header record.
  $F093,$02,b$01 Keep only bits 0-6.
  $F095,$01 #REGc=the column.
  $F096,$04 Set bit 7 of the header record.
  $F09A,$03 #REGb=the row.
  $F09D,$03 Call #R$F42D.
  $F0A0,$03 #REGb=the remaining height.
@ $F0A3 label=Hide_HeaderItem_Target
  $F0A3,$03 #REGc=the remaining width.
@ $F0A6 label=Hide_HeaderItem_Continue
  $F0A6,$02 #REGa=#N$C8.
  $F0A8,$03 Call #R$F436.
  $F0AB,$03 Call #R$F43F.
  $F0AE,$03 Decrease the width and loop back to #R$F0A6.
  $F0B1,$02 Decrease the height and loop back to #R$F0A3.
  $F0B3,$01 Return.

c $F0B4 Event: Hide Fourth Header
@ $F0B4 label=Event_HideHeaderFourth
D $F0B4 Event #N$28: hide the fourth header item.
  $F0B4,$04 #REGix=*#R$641E.
  $F0B8,$05 #REGix+=#N($0012,$04,$04).
  $F0BD,$03 Jump to #R$F090.

c $F0C0 Event: Reveal Header Triple
@ $F0C0 label=Event_RevealHeaderTriple
D $F0C0 Event #N$07: reveal three header items.
  $F0C0,$07 Write #N$2614 to *#R$649F.
  $F0C7,$02 #REGb=#N$03.
  $F0C9,$04 #REGix=*#R$641E.
@ $F0CD label=Event_RevealHeaderTriple_Target
  $F0CD,$01 Stash the count on the stack.
  $F0CE,$03 #REGa=the header record.
  $F0D1,$02 Test bit 7.
  $F0D3,$01 Stash the flags on the stack.
  $F0D4,$03 Call #R$EFEA if the item is hidden.
  $F0D7,$01 Restore the flags from the stack.
  $F0D8,$03 Call #R$F090 if the item is visible.
  $F0DB,$01 Restore the count from the stack.
  $F0DC,$05 Advance to the next header record.
  $F0E1,$02 Decrease the count and loop back to #R$F0CD.
  $F0E3,$01 Return.

c $F0E4 Event: Reveal Furniture
@ $F0E4 label=Event_RevealFurniture
D $F0E4 Event #N$19: reveal the first furniture item.
  $F0E4,$04 #REGix=*#R$6420.
  $F0E8,$05 Return if this furniture item is already visible.
  $F0ED,$04 Clear bit 7 of the furniture record.
  $F0F1,$07 Write #N$1E08 to *#R$6472.
  $F0F8,$0C Fetch the column, row, colour and glyph.
  $F104,$04 Size #N$03 by #N$04.
  $F108,$04 #REGix=#R$648B.
  $F10C,$03 Call #R$F457.
  $F10F,$03 Call #R$F333.
  $F112,$06 Store the furniture row as the drop row.
  $F118,$08 Move the actor four cells above that row.
  $F120,$04 Write #N$01 as the vertical delta.
  $F124,$01 Return.

c $F125 Event: Reveal Ladder
@ $F125 label=Event_RevealLadder
D $F125 Event #N$1B: reveal the first ladder.
  $F125,$04 #REGix=*#R$6428.
  $F129,$05 Return if this ladder is already visible.
  $F12E,$04 Clear bit 7 of the ladder record.
  $F132,$07 Write #N$2207 to *#R$6472.
  $F139,$0B Fetch the column, row and colour; glyph #N$D9.
  $F144,$03 Size #N$05 by #N$02.
  $F147,$04 #REGix=#R$648B.
  $F14B,$03 Call #R$F457.
  $F14E,$03 Call #R$F333.
  $F151,$06 Store the ladder row as the drop row.
  $F157,$08 Move the actor five cells above that row.
  $F15F,$04 Write #N$01 as the vertical delta.
  $F163,$01 Return.

c $F164 Event: Show Enemy
@ $F164 label=Event_ShowEnemy
D $F164 Event #N$18: show the first hidden enemy.
  $F164,$04 #REGix=*#R$6432.
@ $F168 label=Event_ShowEnemy_Target
  $F168,$06 Return if the terminator #N$FF is reached.
  $F16E,$04 Jump to #R$F181 if this enemy is already visible.
  $F172,$02,b$01 Keep only bits 0-6.
  $F174,$03 Write the visible ID.
  $F177,$04 #REGbc=the column and row.
  $F17B,$03 Size #N$03 by #N$02.
  $F17E,$03 Call #R$F463.
@ $F181 label=Event_ShowEnemy_Skip
  $F181,$05 #REGix+=#N($000E,$04,$04).
  $F186,$02 Jump to #R$F168.

c $F188 Event: Award Digit
@ $F188 label=Event_AwardDigit
D $F188 Event #N$22: award a combination digit.
  $F188,$03 Call #R$F249.
  $F18B,$07 Write #N$2005 to *#R$649F.
  $F192,$01 Return.

c $F193 Hide Decoration
@ $F193 label=Reveal_Decoration
D $F193 Hides one decoration by filling its tiles with #N$C8.
  $F193,$01 Restore the return address from the stack.
  $F194,$05 Return if this decoration is already hidden.
  $F199,$01 Stash the return address on the stack.
  $F19A,$03 #REGc=the column.
  $F19D,$04 Set bit 7 of the decoration record.
  $F1A1,$03 #REGb=the row.
  $F1A4,$03 Call #R$F43C.
  $F1A7,$04 Point #REGhl at that #R$5DCE tile.
  $F1AB,$06 #REGbc=the remaining width and height.
  $F1B1,$02 #REGa=#N$C8.
  $F1B3,$03 Jump to #R$F454.

c $F1B6 Event: Test Header
@ $F1B6 label=Event_TestHeader
D $F1B6 Event #N$29: test the second header item.
E $F1B6 Continue on to #R$F1C4.
  $F1B6,$04 #REGix=*#R$641E.
  $F1BA,$0A Return if bit 7 of the next header record is
. clear.

c $F1C4 Event: Reveal Decor And Mover
@ $F1C4 label=Event_RevealDecorAndMover
D $F1C4 Event #N$0B: reveal a decoration and a mover.
  $F1C4,$04 #REGix=*#R$642E.
  $F1C8,$03 Call #R$F193.
  $F1CB,$08 Clear bit 7 of *#R$642A.
  $F1D3,$01 Return.

c $F1D4 Event: Reveal Next Pair
@ $F1D4 label=Event_RevealNextPair
D $F1D4 Event #N$0C: reveal the next decoration and mover.
  $F1D4,$09 #REGix=*#R$642E+#N($0006,$04,$04).
  $F1DD,$03 Call #R$F193.
  $F1E0,$0D Clear bit 7 of *#R$642A+#N($0013,$04,$04).
  $F1ED,$01 Return.

c $F1EE Event: Reveal Three Decorations
@ $F1EE label=Event_RevealThreeDecorations
D $F1EE Event #N$1E: reveal three decorations.
E $F1EE Continue on to #R$F217.
  $F1EE,$04 #REGix=*#R$642E.
  $F1F2,$02 #REGb=#N$03.
@ $F1F4 label=Event_RevealThreeDecorations_Target
  $F1F4,$01 Stash the count on the stack.
  $F1F5,$07 Jump to #R$F20F if this decoration is hidden.
  $F1FC,$0C Fetch the column, row and size.
  $F208,$03 Call #R$F463.
  $F20B,$04 Set bit 7 of the decoration record.
@ $F20F label=Event_RevealThreeDecorations_Continue
  $F20F,$01 Restore the count from the stack.
  $F210,$05 Advance to the next decoration.
  $F215,$02 Decrease the count and loop back to #R$F1F4.

c $F217 Event: Show Movers
@ $F217 label=Event_ShowMovers
D $F217 Event #N$1F: show every moving object.
  $F217,$04 #REGix=*#R$642A.
@ $F21B label=Event_ShowMovers_Target
  $F21B,$06 Return if the terminator #N$FF is reached.
  $F221,$04 Clear bit 7 of this mover.
  $F225,$05 #REGix+=#N($0013,$04,$04).
  $F22A,$02 Jump to #R$F21B.

c $F22C Event: Hide Furniture
@ $F22C label=Event_HideFurniture
D $F22C Event #N$11: hide the first furniture item.
  $F22C,$04 #REGix=*#R$6420.
  $F230,$03 #REGa=the furniture record.
  $F233,$02,b$01 Keep only bits 0-6.
  $F235,$01 #REGc=the column.
  $F236,$05 Set bit 7 of the furniture record.
  $F23B,$03 #REGb=the row.
  $F23E,$06 Jump to #R$F463 with size #N$04 by #N$03.

c $F244 Event: Bump Digit Three
@ $F244 label=Event_DigitThree
D $F244 Event #N$21: increment combination digit 3.
  $F244,$03 #REGhl=#R$64C3.
  $F247,$02 Jump to #R$F256.

c $F249 Event: Bump Digit Four
@ $F249 label=Event_DigitFour
D $F249 Event #N$20: increment combination digit 4.
  $F249,$03 #REGhl=#R$64C4.
  $F24C,$02 Jump to #R$F256.

c $F24E Event: Bump Digit Two
@ $F24E label=Event_DigitTwo
D $F24E Event #N$23: increment combination digit 2.
  $F24E,$03 #REGhl=#R$64C2.
  $F251,$02 Jump to #R$F256.

c $F253 Event: Bump Digit One
@ $F253 label=Event_DigitOne
D $F253 Event #N$25: increment combination digit 1.
E $F253 Continue on to #R$F256.
  $F253,$03 #REGhl=#R$64C1.

c $F256 Event: Bump Digit
@ $F256 label=Event_BumpDigit
D $F256 Increases *(#REGhl) and wraps at #N$0A.
  $F256,$07 Write #N$2614 to *#R$649F.
  $F25D,$02 Increase #REGa from *(#REGhl).
  $F25F,$02 Compare it with #N$0A.
  $F261,$01 Write it back.
  $F262,$03 Jump to #R$ECF2 if it did not wrap.
  $F265,$02 Write #N$00.
  $F267,$03 Jump to #R$ECF2.

c $F26A Event: Hide Later Actor
@ $F26A label=Event_HideLaterActor
D $F26A Event #N$0D: hide a later actor.
E $F26A Continue on to #R$F284.
  $F26A,$09 #REGix=*#R$6430+#N($0027,$04,$04).
  $F273,$06 Return if this actor is already hidden.
  $F279,$03 Call #R$F45D.
  $F27C,$03 #REGa=the actor record.
  $F27F,$02,b$01 Set bit 7.
  $F281,$03 Hide the actor.

c $F284 Clear Collision
@ $F284 label=Hide_ActorRecord
D $F284 Clears *#R$6434 after a collision.
  $F284,$06 Return unless *#R$6434 is #N$03.
  $F28A,$04 Write #N$00 to *#R$6434.
  $F28E,$01 Return.

c $F28F Event: Hide Actor
@ $F28F label=Event_HideActor
D $F28F Event #N$0F: hide the first active actor.
  $F28F,$03 Call #R$F284.
  $F292,$04 #REGix=*#R$6430.
@ $F296 label=Event_HideActor_Target
  $F296,$06 Return if the terminator #N$FF is reached.
  $F29C,$04 Jump to #R$F2AB if this actor is hidden.
  $F2A0,$03 Call #R$F45D.
  $F2A3,$08 Set bit 7 of the actor record.
@ $F2AB label=Event_HideActor_Continue
  $F2AB,$05 #REGix+=#N($000D,$04,$04).
  $F2B0,$02 Jump to #R$F296.

c $F2B2 Event: Randomise Combination
@ $F2B2 label=Event_RandomCombination
D $F2B2 Event #N$16: randomise the combination.
  $F2B2,$07 Write #N$013A to *#R$649F.
  $F2B9,$03 Call #R$F2D9.
  $F2BC,$03 Write the digit to *#R$64C1.
  $F2BF,$03 Call #R$F2D9.
  $F2C2,$03 Write the digit to *#R$64C2.
  $F2C5,$03 Call #R$F2D9.
  $F2C8,$03 Write the digit to *#R$64C3.
  $F2CB,$03 Call #R$F2D9.
  $F2CE,$02 Reset bit 0.
  $F2D0,$02,b$01 Keep only bits 0-2.
  $F2D2,$04 Write #N$01-#N$08 to *#R$64C4.
  $F2D6,$03 Jump to #R$ECF2.
@ $F2D9 label=Event_RandomCombination_Target
  $F2D9,$03 Call #R$F433.
  $F2DC,$02,b$01 Keep only bits 0-2.
  $F2DE,$01 Increase #REGa by one.
  $F2DF,$01 Return.

c $F2E0 Event: Reveal Door
@ $F2E0 label=Event_RevealDoor
D $F2E0 Event #N$12: reveal the first door.
  $F2E0,$04 #REGix=*#R$6422.
@ $F2E4 label=Event_RevealDoor_Body
  $F2E4,$05 Return if this door is already visible.
  $F2E9,$04 Clear bit 7 of the door record.
  $F2ED,$01 Halt.
  $F2EE,$07 Write #N$1006 to *#R$6472.
  $F2F5,$0B Fetch the column, row and colour; glyph #N$84.
  $F300,$03 Size #N$02 by #N$02.
  $F303,$04 #REGix=#R$648B.
  $F307,$03 Call #R$F457.
  $F30A,$03 Call #R$F333.
  $F30D,$06 Store the door row in *#REGix+#N$10.
  $F313,$05 Move the actor two cells below that row.
  $F318,$04 Write #N$FF as the vertical delta.
  $F31C,$01 Return.

c $F31D Event: Reveal Next Door
@ $F31D label=Event_RevealNextDoor
D $F31D Event #N$13: reveal the next door.
  $F31D,$04 #REGix=*#R$6422.
  $F321,$05 #REGix+=#N($0005,$04,$04).
  $F326,$02 Jump to #R$F2E4.

c $F328 Event: Reveal Third Door
@ $F328 label=Event_RevealThirdDoor
D $F328 Event #N$15: reveal the third door.
  $F328,$04 #REGix=*#R$6422.
  $F32C,$05 #REGix+=#N($000A,$04,$04).
  $F331,$02 Jump to #R$F2E4.

c $F333 Copy Destination
@ $F333 label=Copy_ActorDestination
D $F333 Copies the carried-object destination into the working
. slot.
  $F333,$06 Copy the column into *#REGix+#N$0E.
  $F339,$06 Copy the row into *#REGix+#N$0F.
  $F33F,$10 Write the default clip window #N$18/#N$02/#N$21/
. #N$02.
  $F34F,$01 Return.

c $F350 Event: Print Event Message
@ $F350 label=Event_PrintMessage
D $F350 Event #N$04: print the event message.
  $F350,$06 Write #N$3C00 to *#SKOOLKID$5C36(CHARS).
  $F356,$05 Write #INK$3A to *#SKOOLKID$5C8F(ATTR_T).
  $F35B,$03 #REGhl=#R$F3A5.
  $F35E,$03 Jump to #R$F460.

c $F361 Event: Reveal All Decorations
@ $F361 label=Event_RevealAllDecorations
D $F361 Event #N$1D: reveal every decoration.
  $F361,$04 #REGix=*#R$642E.
@ $F365 label=Event_RevealAllDecorations_Target
  $F365,$06 Return if the terminator #N$FF is reached.
  $F36B,$04 Jump to #R$F38E if this decoration is already
. visible.
  $F36F,$04 Clear bit 7 of the decoration record.
  $F373,$06 #REGbc=the column and row.
  $F379,$03 Call #R$F42D.
  $F37C,$06 Write the decoration colour to
. *#SKOOLKID$5C8F(ATTR_T).
  $F382,$03 #REGa=the stored glyph.
  $F385,$06 #REGde=the stored size.
  $F38B,$03 Call #R$F445.
@ $F38E label=Event_RevealAllDecorations_Skip
  $F38E,$05 #REGix+=#N($0006,$04,$04).
  $F393,$02 Jump to #R$F365.

c $F395 Event: Toggle Tune
@ $F395 label=Event_ToggleTune
D $F395 Event #N$09: toggle the silent-tune flag.
  $F395,$03 #REGa=*#R$647C.
  $F398,$02,b$01 Invert every bit.
  $F39A,$03 Write #REGa to *#R$647C.
  $F39D,$07 Write #N$2614 to *#R$649F.
  $F3A4,$01 Return.

t $F3A5 Messaging: Event
@ $F3A5 label=Messaging_Event
D $F3A5 Printed by event #N$04 at #R$F350.
B $F3A5,$03 PRINT AT: #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $F3A8,$0B "#STR(#PC,$04,$0B)".
B $F3B3,$03 PRINT AT: #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $F3B6,$0B "#STR(#PC,$04,$0B)".
B $F3C1,$03 PRINT AT: #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $F3C4,$0B "#STR(#PC,$04,$0B)".
B $F3CF,$01 Terminator.

u $F3D0

c $F424 Jump Store Position
@ $F424 label=JumpTable_StorePosition
  $F424,$03 Jump to #R$F466.

c $F427 Jump Draw Status
@ $F427 label=JumpTable_DrawStatus
  $F427,$03 Jump to #R$F4A8.

c $F42A Jump Initialise Display
@ $F42A label=JumpTable_InitialiseDisplay
  $F42A,$03 Jump to #R$F56A.

c $F42D Jump Set Print Position
@ $F42D label=JumpTable_SetPrintPosition
  $F42D,$03 Jump to #R$F5C4.

c $F430 Jump Delay
@ $F430 label=JumpTable_Delay
  $F430,$03 Jump to #R$F5EC.

c $F433 Jump Get Random Number
@ $F433 label=JumpTable_GetRandomNumber
  $F433,$03 Jump to #R$F5F4.

c $F436 Jump Print Character
@ $F436 label=JumpTable_PrintCharacter
  $F436,$03 Jump to #R$F60A.

c $F439 Jump Print Clipped
@ $F439 label=JumpTable_PrintClipped
  $F439,$03 Jump to #R$F662.

c $F43C Jump Convert Coordinate
@ $F43C label=JumpTable_ConvertCoordinate
  $F43C,$03 Jump to #R$F6AA.

c $F43F Jump Write Tile
@ $F43F label=JumpTable_WriteTile
  $F43F,$03 Jump to #R$F6C6.

c $F442 Jump Move Entity
@ $F442 label=JumpTable_MoveEntity
  $F442,$03 Jump to #R$F6E1.

c $F445 Jump Print Sprite
@ $F445 label=JumpTable_PrintSprite
  $F445,$03 Jump to #R$F7AA.

c $F448 Jump Advance Entity
@ $F448 label=JumpTable_AdvanceEntity
  $F448,$03 Jump to #R$F804.

c $F44B Jump Draw Entity
@ $F44B label=JumpTable_DrawEntity
  $F44B,$03 Jump to #R$F8B4.

c $F44E Jump Erase Entity
@ $F44E label=JumpTable_EraseEntity
  $F44E,$03 Jump to #R$F9EE.

c $F451 Jump Fill Tiles
@ $F451 label=JumpTable_FillTiles
  $F451,$03 Jump to #R$FA9E.

c $F454 Jump Fill Attributes
@ $F454 label=JumpTable_FillAttributes
  $F454,$03 Jump to #R$FA5A.

c $F457 Jump Spawn Entity
@ $F457 label=JumpTable_SpawnEntity
  $F457,$03 Jump to #R$FAFE.

c $F45A Jump Draw Actor
@ $F45A label=JumpTable_DrawActor
  $F45A,$03 Jump to #R$FB2F.

c $F45D Jump Update Actor
@ $F45D label=JumpTable_UpdateActor
  $F45D,$03 Jump to #R$FB90.

c $F460 Jump Print Message
@ $F460 label=JumpTable_PrintMessage
  $F460,$03 Jump to #R$F544.

c $F463 Jump Draw Box
@ $F463 label=JumpTable_DrawBox
  $F463,$03 Jump to #R$F48B.

c $F466 Store Entity Position
@ $F466 label=Store_EntityPosition
D $F466 Remembers the previous position, then writes the new one.
  $F466,$09 Store the old column and write #REGc as the new column.
  $F46F,$09 Store the old row and write #REGb as the new row.
  $F478,$09 Store the old fine-X and write #REGe as the new fine-X.
  $F481,$09 Store the old fine-Y and write #REGd as the new fine-Y.
  $F48A,$01 Return.

c $F48B Draw Box
@ $F48B label=Draw_Box
D $F48B Draws a box of character #N$C8.
  $F48B,$03 Call #R$FA6A.
  $F48E,$03 Return if the width is zero.
  $F491,$02 Return if the height is zero.
@ $F493 label=Draw_Box_Target
  $F493,$01 Stash the print position on the stack.
  $F494,$03 Call #R$F5C4.
  $F497,$01 Copy the remaining width into #REGb.
@ $F498 label=Draw_Box_Target2
  $F498,$05 Print a #N$C8 tile.
  $F49D,$03 Call #R$F6C6.
  $F4A0,$02 Decrease the width and loop back to #R$F498 until
. this row is drawn.
  $F4A2,$01 Restore the print position from the stack.
  $F4A3,$02 Return if every row is drawn.
  $F4A5,$01 Move up one row.
  $F4A6,$02 Jump to #R$F493.

c $F4A8 Draw Status Icons
@ $F4A8 label=Draw_StatusIcons
D $F4A8 Draws one life icon for each remaining life, then a blank.
E $F4A8 View the equivalent code in #BOOTY$E064.
  $F4A8,$03 Call #R$F5C4.
  $F4AB,$06 Jump to #R$F4B9 if *#R$64B4 is the last life.
N $F4B1 #UDGTABLE { #GLYPH$E3,$07(glyph-e3) } UDGTABLE#
  $F4B1,$03 Set the remaining-life count and the #N$E3 icon.
@ $F4B4 label=Draw_StatusIcons_Target
  $F4B4,$03 Call #R$F60A.
  $F4B7,$02 Decrease the life count and loop back to #R$F4B4
. until all lives are drawn.
@ $F4B9 label=Draw_StatusIcons_Skip
  $F4B9,$02 #REGa=#N$C8.
  $F4BB,$03 Jump to #R$F60A.

c $F4BE Add Score
@ $F4BE label=Draw_StatusIcons_Target2
D $F4BE Adds *#R$6417 into the score digits at #R$64B5(#N$64BA).
  $F4BE,$05 Return if *#R$6417 is zero.
  $F4C3,$14 Point at the digit that matches the place value.
  $F4D7,$02 Jump to #R$F4F0 if that digit is already in range.
  $F4D9,$02 Add the low byte into the digit.
  $F4DB,$02 Test whether the digit wrapped past #N$09.
  $F4DD,$03 Write the sum and skip the wrap when it is below
. #N$0A.
  $F4E0,$03 Write the remainder back to this digit.
  $F4E3,$0B Increase the place value in *#R$6417.
  $F4EE,$02 Jump to #R$F4BE.

c $F4F0 Print Score
@ $F4F0 label=Draw_StatusIcons_Branch
D $F4F0 Prints the score digits and copies a new high score when
. the stored score is lower.
  $F4F0,$07 Write #N($0000,$04,$04) to *#R$6417.
  $F4F7,$06 Write #N$3C00 to *#SKOOLKID$5C36(CHARS).
  $F4FD,$05 Write #INK$07 to *#SKOOLKID$5C8F(ATTR_T).
  $F502,$09 Print the five digits at #R$64B5(#N$64BB).
  $F50B,$08 Compare those digits with #R$64B5.
@ $F513 label=Draw_StatusIcons_Target3
  $F513,$04 Jump to #R$F51B if this pair matches.
  $F517,$02 Jump to #R$F528 if the stored score is lower.
  $F519,$02 Jump to #R$F51F.
@ $F51B label=Draw_StatusIcons_Skip2
  $F51B,$04 Advance both pointers and loop back to #R$F513.
@ $F51F label=Draw_StatusIcons_Target4
  $F51F,$09 Print the five digits at #R$64B5.
@ $F528 label=Draw_StatusIcons_Branch2
  $F528,$0B Copy the new score over the stored score.
  $F533,$02 Jump to #R$F51F.
@ $F535 label=Draw_StatusIcons_Target5
  $F535,$03 Call #R$F5C4.
  $F538,$02 #REGb=#N$05.
@ $F53A label=Draw_StatusIcons_Target6
  $F53A,$03 Convert the digit into a character.
  $F53D,$03 Call #R$F60A.
  $F540,$03 Advance the digit pointer and loop back to #R$F53A
. until all five digits are printed.
  $F543,$01 Return.

c $F544 Print Message
@ $F544 label=Print_Message
D $F544 Prints a control-byte string: bytes below #N$C8 are characters, #N$D8
. sets #SKOOLKID$5C8F(ATTR_T), other values set the print position, and #N$FF
. terminates.
R $F544 HL Message address
  $F544,$05 Jump to #R$F55C if this byte is a character.
  $F549,$03 Return if the terminator is reached.
  $F54C,$04 Jump to #R$F562 if this byte sets
. #SKOOLKID$5C8F(ATTR_T).
N $F550 Else this is a print-position pair.
  $F550,$06 Fetch the column and row into #REGbc.
  $F556,$03 Call #R$F5C4.
  $F559,$01 Advance the message pointer.
  $F55A,$02 Jump to #R$F544.
@ $F55C label=Print_Message_Branch
  $F55C,$03 Call #R$F60A.
  $F55F,$01 Advance the message pointer.
  $F560,$02 Jump to #R$F544.
@ $F562 label=Print_Message_Skip
  $F562,$01 Advance the message pointer.
  $F563,$04 Write the next byte to *#SKOOLKID$5C8F(ATTR_T).
  $F567,$01 Advance the message pointer.
  $F568,$02 Jump to #R$F544.

c $F56A Initialise Display
@ $F56A label=Initialise_Display
D $F56A Opens the upper screen, builds the line-address table and fills the IM
. #N$02 vector page at #N$FD00 with #N$FE.
E $F56A View the equivalent code in #BOOTY$CD14.
  $F56A,$05 Write #N$00 to *#SKOOLKID$5C6B(DF_SZ).
  $F56F,$05 Open channel #N$02 via #SKOOLKID$1601(CHAN_OPEN).
N $F574 Build #N$19 display-file addresses from #SKOOLKID$0DD9(CL_SET).
  $F574,$03 #REGhl=#N$FF04.
  $F577,$03 #REGbc=#N$0121.
  $F57A,$01 Stash the table pointer on the stack.
@ $F57B label=Initialise_Display_Continue
  $F57B,$01 Stash the position on the stack.
  $F57C,$03 Call #SKOOLKID$0DD9(CL_SET).
  $F57F,$0A Fetch *#SKOOLKID$5C84(DF_CC) and add #N$21.
  $F589,$06 Store that address in the table.
  $F58F,$06 Increase the row and jump to #R$F57B until #N$19
. rows are stored.
  $F595,$01 Drop the leftover table pointer.
  $F596,$0E Write the default clip window to *#R$6419.
  $F5A4,$0D Clear seven bytes at #SKOOLKID$5CB6(CHINFO).
  $F5B1,$05 Write #N$00 to *#R$643E.
  $F5B6,$0D Fill #N$0100 bytes at #N$FD00 with #N$FE.
  $F5C3,$01 Return.

c $F5C4 Set Print Position
@ $F5C4 label=Set_PrintPosition
D $F5C4 Sets the print position from #REGbc.
  $F5C4,$04 Write #REGbc to *#SKOOLKID$5C88(S_POSN).
  $F5C8,$01 Switch to the shadow registers.
  $F5C9,$05 Fetch the stored position; #REGe=the row.
  $F5CE,$03 Clear #REGa, #REGd and #REGb.
  $F5D1,$06 Look up the line address from the table at #N$FF02.
  $F5D7,$09 Subtract the column and write *#SKOOLKID$5C84(DF_CC).
  $F5E0,$04 Rotate the high byte into an attribute offset.
  $F5E4,$02,b$01 Keep only bits 0-1.
  $F5E6,$04 Write the offset to *#R$6412.
  $F5EA,$01 Switch back.
  $F5EB,$01 Return.

c $F5EC Delay
@ $F5EC label=Delay
D $F5EC Delay for #REGbc iterations.
E $F5EC View the equivalent code in #BOOTY$F8C0.
R $F5EC BC Length of loop
  $F5EC,$01 Stash #REGbc on the stack.
@ $F5ED label=Delay_Continue
  $F5ED,$05 Decrease #REGbc and jump to #R$F5ED until it is
. zero.
  $F5F2,$01 Restore #REGbc from the stack.
  $F5F3,$01 Return.

c $F5F4 Get Random Number
@ $F5F4 label=Get_RandomNumber
D $F5F4 (((#REGb + #REGc) % #N$100 + #N$AB) % #N$100) * #N$100 +
. (#REGc + #N$CD) % #N$100
E $F5F4 View the equivalent code in #BOOTY$E349.
R $F5F4 O:A The random number
  $F5F4,$01 Stash #REGbc on the stack.
  $F5F5,$04 #REGbc=*#R$64B2.
  $F5F9,$03 #REGb=#REGb+#REGc.
  $F5FC,$04 #REGc=#N$CD+#REGc.
  $F600,$04 #REGb+=#N$AB.
  $F604,$04 Write the updated #REGbc to *#R$64B2.
  $F608,$01 Restore #REGbc from the stack.
  $F609,$01 Return.

c $F60A Print Character
@ $F60A label=Print_Character
D $F60A Prints one character using *#SKOOLKID$5C36(CHARS).
E $F60A View the equivalent code in #BOOTY$E6DC.
R $F60A A Character to print
  $F60A,$03 Stash the character and #REGix on the stack.
  $F60D,$01 Switch to the shadow registers.
  $F60E,$06 #REGhl=the character code*#N$08.
  $F614,$05 #REGhl=*#SKOOLKID$5C36(CHARS)+#REGhl.
  $F619,$0A Advance *#SKOOLKID$5C84(DF_CC) and leave #REGde on
. the cell just claimed.
N $F623 Copy the eight pixel rows into the screen buffer.
  $F623,$02 Set the pixel-row counter to #N$08.
@ $F625 label=Print_Character_Target
  $F625,$04 Copy one pixel row and move down one screen line.
  $F629,$02 Decrease the row counter and loop back to #R$F625
. until all #N$08 rows are written.
N $F62B Write *#SKOOLKID$5C8F(ATTR_T) into the matching
. attribute cell.
  $F62B,$09 Decrease the print column in *#SKOOLKID$5C88(S_POSN).
  $F634,$06 Point #REGhl at the matching attribute cell.
  $F63A,$02,b$01 Keep only bits 0-1 of the display-file high
. byte.
  $F63C,$02,b$01 Set the attribute-file bit.
  $F63E,$01 Merge the attribute-file high byte.
  $F63F,$06 Jump to #R$F64E if *#SKOOLKID$5C91(P_FLAG) is set.
  $F645,$04 Write *#SKOOLKID$5C8F(ATTR_T) to that attribute
. cell.
  $F649,$01 Switch back.
  $F64A,$03 Restore #REGix and the character from the stack.
  $F64D,$01 Return.
@ $F64E label=Print_Character_Continue
  $F64E,$03 Merge the existing attribute through the mask.
  $F651,$06 Keep the paper bits from *#SKOOLKID$5C8F(ATTR_T).
  $F657,$02,b$01 Invert the mask.
  $F659,$04 Merge the ink bits and write the attribute.
  $F65D,$01 Switch back.
  $F65E,$03 Restore #REGix and the character from the stack.
  $F661,$01 Return.

c $F662 Print Clipped
@ $F662 label=Print_Clipped
D $F662 Prints a clipped rectangular run of characters.
  $F662,$01 Keep the tile ID in #REGl.
  $F663,$04 Store the width in *#R$6416.
@ $F667 label=Print_Clipped_Target
  $F667,$04 Reload the remaining width from *#R$6416.
  $F66B,$06 Jump to #R$F677 if this row is inside *#R$6419.
@ $F671 label=Print_Clipped_Continue
  $F671,$06 Skip down until the row is inside the clip window.
@ $F677 label=Print_Clipped_Branch
  $F677,$05 Return if this row is below *#R$641A.
  $F67C,$05 Return if this column is past *#R$641C.
  $F681,$01 Stash the position on the stack.
  $F682,$06 Jump to #R$F68F if this column is inside
. *#R$641B.
@ $F688 label=Print_Clipped_Branch2
  $F688,$07 Skip left until the column is inside the clip
. window.
@ $F68F label=Print_Clipped_Branch3
  $F68F,$03 Copy #REGbc to the shadow registers (using the
. stack).
  $F692,$03 Call #R$F6AA.
  $F695,$01 Switch back.
  $F696,$01 #REGa=the tile ID.
  $F697,$03 Call #R$F6C6.
  $F69A,$0A Move left one column and loop back to #R$F68F
. until the row is done.
@ $F6A4 label=Print_Clipped_Skip
  $F6A4,$01 Restore the position from the stack.
  $F6A5,$02 Return if the remaining height is zero.
  $F6A7,$01 Move up one row.
  $F6A8,$02 Jump to #R$F667.

c $F6AA Convert Coordinate
@ $F6AA label=Convert_Coordinate
D $F6AA Converts a column/row pair into an offset.
E $F6AA View the equivalent code in #BOOTY$A86E.
  $F6AA,$03 Clear #REGa, #REGd and #REGl.
  $F6AD,$03 #REGa=#N$18-#REGb.
  $F6B0,$0D Multiply the row by #N$20 into #REGhl.
  $F6BD,$04 #REGe=#N$21-#REGc.
  $F6C1,$04 Add the column and write *#R$6412.
  $F6C5,$01 Return.

c $F6C6 Write Tile
@ $F6C6 label=Write_Tile
D $F6C6 Writes one tile and its attribute into the room buffers.
  $F6C6,$03 Stash the tile, #REGde and #REGhl on the stack.
  $F6C9,$07 Increase *#R$6412 by one.
  $F6D0,$05 Point #REGhl at that #R$5DCE cell.
  $F6D5,$04 Point #REGhl at the matching #R$60EE cell.
  $F6D9,$04 Write *#SKOOLKID$5C8F(ATTR_T) there.
  $F6DD,$03 Restore the stashed registers from the stack.
  $F6E0,$01 Return.

c $F6E1 Move Entity
@ $F6E1 label=Move_Entity
D $F6E1 Moves an entity and erases the vacated cells.
  $F6E1,$04 Write #N$00 to *#R$643D.
  $F6E5,$06 Jump to #R$F6F7 if the column matches *#REGix+#N$0A.
  $F6EB,$07 Call #R$F71C when the column moved left.
  $F6F2,$03 Call #R$F73C if the column moved right.
  $F6F5,$02 Jump to #R$F702.
@ $F6F7 label=Move_Entity_Skip
  $F6F7,$06 Jump to #R$F702 if the fine-X matches *#REGix+#N$0C.
  $F6FD,$05 Call #R$F73C when the fine-X wrapped to #N$07.
@ $F702 label=Move_Entity_Skip2
  $F702,$06 Jump to #R$F712 if the row matches *#REGix+#N$0B.
  $F708,$07 Call #R$F788 when the row moved up.
  $F70F,$03 Jump to #R$F761 if the row moved down, else return.
@ $F712 label=Move_Entity_Skip3
  $F712,$05 Return if the fine-Y matches *#REGix+#N$0D.
  $F717,$05 Jump to #R$F761 when the fine-Y wrapped to #N$07,
. else return.
N $F71C Erase the left-hand column that has just been vacated.
@ $F71C label=Move_Entity_Target
  $F71C,$02 Stash the new position and size.
  $F71E,$05 Write #N$FF to *#R$643D.
  $F723,$0B Fill a one-column strip at the old column and row.
  $F72E,$08 Increase the height when the old fine-Y is not
. #N$07.
@ $F736 label=Move_Entity_Skip4
  $F736,$03 Call #R$FA9E.
  $F739,$02 Restore the registers from the stack.
  $F73B,$01 Return.
N $F73C Erase the right-hand column that has just been vacated.
@ $F73C label=Move_Entity_Target2
  $F73C,$05 Write #N$01 to *#R$643D.
  $F741,$02 Stash the new position and size.
  $F743,$08 #REGc=the old right-hand column.
  $F74B,$08 #REGb=the old row, #REGd=the height, width #N$01.
  $F753,$08 Increase the height when the old fine-Y is not
. #N$07.
@ $F75B label=Move_Entity_Skip5
  $F75B,$03 Call #R$FA9E.
  $F75E,$02 Restore the registers from the stack.
  $F760,$01 Return.
N $F761 Erase the bottom row that has just been vacated.
@ $F761 label=Move_Entity_Branch
  $F761,$02 Stash the new position and size.
  $F763,$08 #REGb=the old bottom row.
  $F76B,$08 #REGe=the width, #REGc=the old column, height #N$01.
  $F773,$08 Increase the width when the fine-X is not #N$07.
@ $F77B label=Move_Entity_Skip6
  $F77B,$07 Increase the width again when *#R$643D is set.
@ $F782 label=Move_Entity_Skip7
  $F782,$03 Call #R$FA9E.
  $F785,$02 Restore the registers from the stack.
  $F787,$01 Return.
N $F788 Erase the top row that has just been vacated.
@ $F788 label=Move_Entity_Target3
  $F788,$02 Stash the new position and size.
  $F78A,$0B Fill a one-row strip at the old column and row.
  $F795,$08 Increase the width when the old fine-X is not
. #N$07.
@ $F79D label=Move_Entity_Skip8
  $F79D,$07 Increase the width again when *#R$643D is set.
@ $F7A4 label=Move_Entity_Skip9
  $F7A4,$03 Call #R$FA9E.
  $F7A7,$02 Restore the registers from the stack.
  $F7A9,$01 Return.

c $F7AA Print Sprite
@ $F7AA label=Print_Sprite
D $F7AA Prints a sprite of width #REGe and height #REGd.
E $F7AA View the equivalent code in #BOOTY$EA93.
R $F7AA A Sprite ID
R $F7AA B Vertical co-ordinate
R $F7AA C Horizontal co-ordinate
R $F7AA D Height (in character blocks)
R $F7AA E Width (in character blocks)
  $F7AA,$02 Keep the sprite ID minus one in #REGl.
  $F7AC,$04 Store the width in *#R$6416.
@ $F7B0 label=Print_Sprite_Target
  $F7B0,$04 Reload the remaining width from *#R$6416.
  $F7B4,$06 Jump to #R$F7C8 if this row is inside *#R$6419.
@ $F7BA label=Print_Sprite_Continue
  $F7BA,$0E Skip down until the row is inside the clip window.
@ $F7C8 label=Print_Sprite_Branch
  $F7C8,$05 Return if this row is below *#R$641A.
  $F7CD,$05 Return if this column is past *#R$641C.
  $F7D2,$07 Jump to #R$F7E1 if this column is inside
. *#R$641B.
@ $F7D9 label=Print_Sprite_Branch2
  $F7D9,$08 Skip left until the column is inside the clip
. window.
@ $F7E1 label=Print_Sprite_Branch3
  $F7E1,$03 Call #R$F5C4.
  $F7E4,$05 Call #R$F60A with the next glyph.
  $F7E9,$03 Call #R$F6C6.
  $F7EC,$0A Move left one column and loop back to #R$F7E1
. until the row is done.
@ $F7F6 label=Print_Sprite_Skip
  $F7F6,$01 Restore the position from the stack.
  $F7F7,$02 Return if the remaining height is zero.
  $F7F9,$01 Move up one row.
  $F7FA,$02 Jump to #R$F7B0.
@ $F7FC label=Print_Sprite_Branch4
  $F7FC,$03 Jump to #R$F7F6 if the remaining width is zero.
  $F7FF,$03 Advance the glyph past the clipped cells.
  $F802,$02 Jump to #R$F7F6.

c $F804 Advance Entity
@ $F804 label=Advance_Entity
D $F804 Advances an entity by its stored deltas.
E $F804 View the equivalent code in #BOOTY$EEA6.
R $F804 IX Entity data
R $F804 O:B Updated row
R $F804 O:C Updated column
R $F804 O:D Updated fine-Y
R $F804 O:E Updated fine-X
  $F804,$06 #REGc=the column and #REGb=the row.
  $F80A,$06 Add *#REGix+#N$08 to the fine-X.
  $F810,$04 Jump to #R$F81D if the fine-X is still in range.
  $F814,$04 Jump to #R$F81A if the entity moved left.
  $F818,$02 Step the column two right, then...
@ $F81A label=Advance_Entity_Branch
  $F81A,$01 ...one left.
  $F81B,$02,b$01 Keep only bits 0-2.
@ $F81D label=Advance_Entity_Branch2
  $F81D,$01 Store the fine-X.
  $F81E,$06 Add *#REGix+#N$09 to the fine-Y.
  $F824,$04 Jump to #R$F831 if the fine-Y is still in range.
  $F828,$04 Jump to #R$F82E if the entity moved up.
  $F82C,$02 Step the row two down, then...
@ $F82E label=Advance_Entity_Branch3
  $F82E,$01 ...one up.
  $F82F,$02,b$01 Keep only bits 0-2.
@ $F831 label=Advance_Entity_Branch4
  $F831,$01 Store the fine-Y.
  $F832,$01 Return.

c $F833 Shift Sprite Left
@ $F833 label=Advance_Entity_Target
D $F833 Draws a left-facing entity by shifting each tile left.
  $F833,$02,b$01 Keep only bits 0-6.
  $F835,$03 Write the colour to *#SKOOLKID$5C8F(ATTR_T).
  $F838,$08 Add #N$08 to the shift count at #R$F916(#N$F917)
. and write it to #R$F86F(#N$F870).
  $F840,$04 #REGde=*#SKOOLKID$5C36(CHARS).
  $F844,$06 Copy the stored stride from #R$F935(#N$F936) into
. the add at #R$F88D(#N$F88E).
  $F84A,$05 Clear the self-modified OR at #R$F881.
  $F84F,$0C Point #REGhl at the last source tile of this
. frame.
  $F85B,$06 #REGde=the sprite width and height.
  $F861,$03 Copy #REGhl to #REGix (using the stack).
  $F864,$03 #REGhl=#N$5CBE.
@ $F867 label=Advance_Entity_Continue
  $F867,$03 Stash the source pointer and remaining size.
@ $F86A label=Advance_Entity_Continue2
  $F86A,$02 Stash the source pointer on the stack.
  $F86C,$02 #REGb=#N$08.
@ $F86E label=Advance_Entity_Target2
  $F86E,$01 Stash the row count.
@ $F86F label=Advance_Entity_ShiftCount
  $F86F,$02 #REGb=the shift count (self-modified).
  $F871,$05 Load the next source byte.
@ $F876 label=Advance_Entity_Target3
  $F876,$08 Shift one source bit into the overflow bytes.
  $F87E,$03 Write the overflow bits to the next column.
@ $F881 label=Advance_Entity_Merge
  $F881,$01 Self-modified: NOP or OR (HL).
  $F882,$01 Write the rotated byte.
  $F883,$05 Advance the destination and source pointers.
  $F888,$01 Restore the row count from the stack.
  $F889,$02 Decrease the count and loop back to #R$F86E.
  $F88B,$02 Restore the source pointer from the stack.
@ $F88D label=Advance_Entity_Stride
  $F88D,$03 #REGbc=the stored stride (self-modified).
  $F890,$05 Advance to the next source column and loop back
. to #R$F86A.
  $F895,$05 Write OR (HL) into *#R$F881.
  $F89A,$01 #REGa=#N$00.
  $F89B,$02 #REGb=#N$08.
@ $F89D label=Advance_Entity_Target4
  $F89D,$09 Clear one overflow byte and loop back to #R$F89D.
  $F8A6,$0B Step back one source character and loop back to
. #R$F867.
  $F8B1,$03 Jump to #R$F959.

c $F8B4 Draw Entity
@ $F8B4 label=Draw_Entity
D $F8B4 Draws the entity pointed to by #REGix.
E $F8B4 View the equivalent code in #BOOTY$EED7.
R $F8B4 IX Entity data
  $F8B4,$04 Clear the self-modified OR at #R$F929.
  $F8B8,$06 Stash *#SKOOLKID$5C36(CHARS) on the stack.
  $F8BE,$04 Stash #REGiy and #REGix on the stack.
  $F8C2,$08 Write #N$07-*#REGix+#N$02 to the shift count at
. #R$F916(#N$F917).
  $F8CA,$06 #REGde=the sprite width and height.
  $F8D0,$10 #REGiy=#N$5CBE+(height+#N$01)*#N$08.
  $F8E0,$0A Write the width*#N$08 to the stride at
. #R$F935(#N$F936).
  $F8EA,$08 Jump to #R$F833 if bit 7 of the colour is set.
  $F8F2,$03 Write the colour to *#SKOOLKID$5C8F(ATTR_T).
  $F8F5,$04 #REGde=*#SKOOLKID$5C36(CHARS).
  $F8F9,$09 Point #REGhl at this frame's source UDGs.
  $F902,$06 #REGde=the sprite width and height.
  $F908,$03 Copy #REGhl to #REGix (using the stack).
  $F90B,$03 #REGhl=#N$5CBE.
@ $F90E label=Draw_Entity_Continue
  $F90E,$03 Stash the source pointer and remaining size.
@ $F911 label=Draw_Entity_Continue2
  $F911,$02 Stash the source pointer on the stack.
  $F913,$02 #REGb=#N$08.
@ $F915 label=Draw_Entity_Target
  $F915,$01 Stash the row count.
@ $F916 label=Draw_Entity_ShiftCount
  $F916,$02 #REGb=the shift count (self-modified).
  $F918,$01 #REGa=#N$00.
  $F919,$01 Test the shift count.
  $F91A,$01 #REGc=#N$00.
  $F91B,$03 #REGa=the next source byte.
  $F91E,$02 Jump to #R$F926 if the shift count is zero.
@ $F920 label=Draw_Entity_Target2
  $F920,$06 Shift one source bit into the overflow byte.
@ $F926 label=Draw_Entity_Skip
  $F926,$03 Write the overflow bits to the next column.
@ $F929 label=Draw_Entity_Merge
  $F929,$01 Self-modified: NOP or OR (HL).
  $F92A,$01 Write the rotated byte.
  $F92B,$05 Advance the destination and source pointers.
  $F930,$01 Restore the row count from the stack.
  $F931,$02 Decrease the count and loop back to #R$F915.
  $F933,$02 Restore the source pointer from the stack.
@ $F935 label=Draw_Entity_Stride
  $F935,$03 #REGbc=the stored stride (self-modified).
  $F938,$05 Advance to the next source column and loop back
. to #R$F911.
  $F93D,$05 Write OR (HL) into *#R$F929.
  $F942,$01 #REGa=#N$00.
  $F943,$02 #REGb=#N$08.
@ $F945 label=Draw_Entity_Target3
  $F945,$09 Clear one overflow byte and loop back to #R$F945.
  $F94E,$0B Step to the next source character and loop back
. to #R$F90E.
@ $F959 label=Draw_Entity_Target4
  $F959,$0E Point *#SKOOLKID$5C36(CHARS) at the shifted
. workspace plus the fine-Y.
  $F967,$03 #REGd=the entity height.
  $F96A,$0B Increase the printed width when the fine-X is not
. #N$07.
@ $F975 label=Draw_Entity_Skip2
  $F975,$05 Store the printed height in *#R$6414.
  $F97A,$08 Decrease the height when the fine-Y is #N$07.
@ $F982 label=Draw_Entity_Continue3
  $F982,$0B Call #R$F992 at the entity column and row.
  $F98D,$01 Restore *#SKOOLKID$5C36(CHARS) from the stack.
  $F98E,$03 Write it back to *#SKOOLKID$5C36(CHARS).
  $F991,$01 Return.
N $F992 Print the shifted sprite inside the clip window.
@ $F992 label=Draw_Entity_Target5
  $F992,$06 Write the remaining width into the load at
. #R$F999(#N$F99A).
@ $F998 label=Draw_Entity_Target6
  $F998,$01 Advance the glyph base.
@ $F999 label=Draw_Entity_Width
  $F999,$02 #REGe=the remaining width (self-modified).
  $F99B,$06 Jump to #R$F9AA if this row is inside *#R$6419.
@ $F9A1 label=Draw_Entity_Target7
  $F9A1,$09 Skip down until the row is inside the clip window.
@ $F9AA label=Draw_Entity_Branch
  $F9AA,$05 Return if this column is past *#R$641C.
  $F9AF,$05 Return if this row is below *#R$641A.
  $F9B4,$07 Jump to #R$F9D1 if this column is inside
. *#R$641B.
  $F9BB,$01 Copy the glyph base into #REGh.
@ $F9BC label=Draw_Entity_Branch2
  $F9BC,$03 Jump to #R$F9E8 if the remaining width is zero.
  $F9BF,$0C Skip left until the column is inside the clip
. window.
  $F9CB,$03 Call #R$F5C4.
  $F9CE,$01 #REGa=the clipped glyph.
  $F9CF,$02 Jump to #R$F9D5.
@ $F9D1 label=Draw_Entity_Branch3
  $F9D1,$04 Call #R$F5C4 with the unclipped glyph.
@ $F9D5 label=Draw_Entity_Continue4
  $F9D5,$04 Call #R$F60A and keep the glyph in #REGh.
  $F9D9,$08 Jump to #R$F9E8 if this column is past *#R$641C.
  $F9E1,$07 Advance the glyph and loop back to #R$F9D5.
@ $F9E8 label=Draw_Entity_Skip3
  $F9E8,$01 Restore the position from the stack.
  $F9E9,$02 Return if the remaining height is zero.
  $F9EB,$01 Move up one row.
  $F9EC,$02 Jump to #R$F998.

c $F9EE Erase Entity
@ $F9EE label=Erase_Entity
D $F9EE Tests whether the entity overlaps the player.
  $F9EE,$05 Return if *#R$6411 is already set.
  $F9F3,$0C Fetch the column, row, width and height.
  $F9FF,$03 Call #R$FA6A.
  $FA02,$05 Return if the clipped width or height is zero.
  $FA07,$0B Write the width*#N$08+#N$10 into the compare at
. #R$FA34(#N$FA35).
  $FA12,$06 Write the height*#N$08+#N$18 into the compare at
. #R$FA4E(#N$FA4F).
  $FA18,$06 Point #REGiy at the player at #R$64A4.
  $FA1E,$16 Jump to #R$FA57 unless the entity overlaps the
. player horizontally.
@ $FA34 label=Erase_Entity_WidthCompare
  $FA34,$04 Compare against the stored width and jump to
. #R$FA57 if there is no overlap.
  $FA38,$16 Jump to #R$FA57 unless the entity overlaps the
. player vertically.
@ $FA4E label=Erase_Entity_HeightCompare
  $FA4E,$04 Compare against the stored height and jump to
. #R$FA57 if there is no overlap.
  $FA52,$05 Write #N$01 to *#R$6411.
@ $FA57 label=Erase_Entity_Branch
  $FA57,$02 Restore #REGiy from the stack.
  $FA59,$01 Return.

c $FA5A Fill Attributes
@ $FA5A label=Fill_Attributes
D $FA5A Fills attributes starting at #REGhl.
R $FA5A A Attribute to write
R $FA5A HL Attribute-file address
R $FA5A B Height
R $FA5A C Width
  $FA5A,$03 Stash #REGbc and #REGhl and copy the width into
. #REGb.
@ $FA5D label=Fill_Attributes_Target
  $FA5D,$04 Write #REGa across this attribute row.
  $FA61,$08 Move #REGhl down one attribute row and loop back
. to #R$FA5A.
  $FA69,$01 Return.

c $FA6A Clip Rectangle
@ $FA6A label=Next_PrintCell
D $FA6A Clips the print rectangle against *#R$6419.
  $FA6A,$06 Jump to #R$FA76 if this row is inside *#R$6419.
@ $FA70 label=Next_PrintCell_Continue
  $FA70,$06 Skip down until the row is inside the clip window.
@ $FA76 label=Next_PrintCell_Branch
  $FA76,$07 #REGl=the bottom row of this rectangle.
@ $FA7D label=Next_PrintCell_Target
  $FA7D,$08 Shrink the height until the bottom is inside
. *#R$641A.
@ $FA85 label=Next_PrintCell_Branch2
  $FA85,$03 #REGa=*#R$641B.
@ $FA88 label=Next_PrintCell_Target2
  $FA88,$08 Skip left until the column is inside *#R$641B.
@ $FA90 label=Next_PrintCell_Branch3
  $FA90,$07 #REGl=the right-hand column of this rectangle.
@ $FA97 label=Next_PrintCell_Target3
  $FA97,$07 Shrink the width until the right edge is inside
. *#R$641C.

c $FA9E Fill Tiles
@ $FA9E label=Fill_Tiles
D $FA9E Fills a rectangle of tiles from the room buffers.
  $FA9E,$04 Stash #REGaf, #REGbc, #REGde and #REGhl.
  $FAA2,$0A Switch *#SKOOLKID$5C36(CHARS) to *#R$640E.
N $FAAC Clip the fill rectangle.
  $FAAC,$04 Store the width in *#R$6416.
  $FAB0,$03 Call #R$FA6A.
  $FAB3,$09 Jump to #R$FAF5 if the clipped size is zero.
  $FABC,$04 Store the starting column in *#R$6414(#N$6415).
@ $FAC0 label=Fill_Tiles_Target
  $FAC0,$04 #REGe=*#R$6416.
  $FAC4,$04 #REGc=*#R$6414(#N$6415).
  $FAC8,$03 Call #R$F5C4.
@ $FACB label=Fill_Tiles_Continue
  $FACB,$08 Advance *#R$6412.
  $FAD3,$05 Fetch that #R$5DCE tile into #REGa.
  $FAD8,$03 Call #R$F60A with the stored tile.
  $FADB,$0D Copy the matching #R$60EE attribute to the
. screen.
  $FAE8,$05 Move left one column and loop back to #R$FACB.
  $FAED,$01 Decrease the remaining height.
  $FAEE,$02 Jump to #R$FAF5 if it is zero.
  $FAF0,$02 Copy #REGde to #REGde (using the stack).
  $FAF2,$01 Move up one row.
  $FAF3,$02 Jump to #R$FAC0.
@ $FAF5 label=Fill_Tiles_Skip
  $FAF5,$01 Restore *#SKOOLKID$5C36(CHARS) from the stack.
  $FAF6,$03 Write it back to *#SKOOLKID$5C36(CHARS).
  $FAF9,$04 Restore the stashed registers from the stack.
  $FAFD,$01 Return.

c $FAFE Spawn Entity
@ $FAFE label=Spawn_Entity
D $FAFE Spawns or resets the entity at #REGix.
R $FAFE IX Entity data
R $FAFE B Row
R $FAFE C Column
R $FAFE D Height
R $FAFE E Width
R $FAFE A Sprite ID
R $FAFE L Colour
  $FAFE,$0C Write the column and row into the current and
. stored slots.
  $FB0A,$09 Write the width, height and sprite ID.
  $FB13,$03 Write the colour.
  $FB16,$10 Write #N$07 as both fine offsets.
  $FB26,$08 Clear the movement deltas.
  $FB2E,$01 Return.

c $FB2F Draw Actor
@ $FB2F label=Draw_Actor
D $FB2F Draws the actor pointed to by #REGix.
R $FB2F IX Actor data
  $FB2F,$05 Write #N$FF to the mask at #R$FBC4(#N$FBC5).
  $FB34,$09 Fetch the column, row and width.
  $FB3D,$02 Height #N$01.
  $FB3F,$08 Increase the width when the fine-X is not #N$07.
@ $FB47 label=Draw_Actor_Skip
  $FB47,$08 Increase the height when the fine-Y is below
. #N$03.
@ $FB4F label=Draw_Actor_Branch
  $FB4F,$03 Call #R$FA6A.
  $FB52,$07 Jump to #R$FB68 if the clipped size is zero.
  $FB59,$01 Stash the clipped size on the stack.
  $FB5A,$03 Call #R$F6AA.
  $FB5D,$04 Point #REGhl at the attribute cell in #N$5800.
  $FB61,$03 #REGa=the actor colour.
  $FB64,$01 Restore the clipped size into #REGbc.
  $FB65,$03 Call #R$FA5A.
@ $FB68 label=Draw_Actor_Skip2
  $FB68,$0F Fill #R$6440 with #N$FF for the actor width.
  $FB77,$02 Write #N$00 after the mask.
  $FB79,$04 Load the fine-X and increase it by one.
@ $FB7D label=Draw_Actor_Target
  $FB7D,$04 Build a left-hand mask of (fine-X+#N$01) bits.
N $FB81 Write the mask to both ends of #R$6440.
  $FB81,$04 Write the mask to *#R$6440.
  $FB85,$06 Point #REGhl at the other end of #R$6440.
  $FB8B,$02,b$01 Invert the mask.
  $FB8D,$01 Write it.
  $FB8E,$02 Jump to #R$FB94.

c $FB90 Update Actor
@ $FB90 label=Update_Actor
D $FB90 Stamps the actor mask onto the display file.
R $FB90 IX Actor data
  $FB90,$04 Write #N$00 to the mask at #R$FBC4(#N$FBC5).
@ $FB94 label=Update_Actor_Target
  $FB94,$09 Convert the actor column into a pixel column.
  $FB9D,$0C Convert the actor row and fine-Y into a pixel
. row.
  $FBA9,$02 #REGe=#N$04.
@ $FBAB label=Update_Actor_Continue
  $FBAB,$07 Jump to #R$FBCB if this pixel row is off-screen.
  $FBB2,$03 Call #SKOOLKID$22AA(PIXEL_ADD).
  $FBB5,$0B Increase the copy width when the fine-X is not
. #N$07.
@ $FBC0 label=Update_Actor_Skip
  $FBC0,$03 #REGde=#R$6440.
@ $FBC3 label=Update_Actor_Target2
  $FBC3,$01 #REGa=*#REGde.
@ $FBC4 label=Update_Actor_Mask
  $FBC4,$02,b$01 Merge the mask (self-modified AND).
  $FBC6,$05 Write the byte and loop back to #R$FBC3.
@ $FBCB label=Update_Actor_Branch
  $FBCB,$07 Move up one pixel row and loop back to #R$FBAB.

u $FBD2

c $FEFE Alias: Interrupt Jump Dispatcher
@ $FEFE label=AliasInterruptRedirect
D $FEFE IM #N$02 lands at this address. #R$D5AC writes a jump to #R$E46C here.
E $FEFE View the equivalent code in #BOOTY$FEFE.
  $FEFE,$03 Jump to #R$E46C.

u $FF01
