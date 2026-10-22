; Copyright Bubble Bus Software 1986, 2026 ArcadeGeek LTD.
; NOTE: Disassembly is Work-In-Progress.
; Label naming is loosely based on Action_ActionName_SubAction
; e.g. Print_HighScore_Loop.

> $4000 @rom
> $4000 @start
> $4000 @expand=#DEF1(#SKOOLKID(addr)(name)#HTML(<a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/#IF({{mode[base]}}==16)(hex/)asm/#IF({{mode[base]}}==16)(#EVAL({addr},16,4),#EVAL({addr})).html">){name}#HTML(</a>))
> $4000 @expand=#DEF(#POKE()(anchor,text) #LINK(Pokes#$anchor)($text))
> $4000 @expand=#DEF(#ANIMATE(delay,count=$50)(name=$a)#FRAMES#(($name-1,$delay;#FOR$02,$count||x|$name-x|;||))($name-animation))
> $4000 @expand=#DEF(#INK(id)#LET(bright=$id&$40)#LET(flash=$id&$80)#LET(ink=$id&$07)#IF({ink}>=$00)(#MAP({ink})(UNKNOWN,0:BLACK,1:BLUE,2:RED,3:MAGENTA,4:GREEN,5:CYAN,6:YELLOW,7:WHITE))#IF({bright}>$00)( (BRIGHT))#IF({flash}>$00)( (FLASH: ON)))
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
T $5D32,$20 #STR(#PC,$04,$20)
T $5D52,$14 #STR(#PC,$04,$14)

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
D $6426 Two-byte #N$FF-terminated records. See #R$DBC9.
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
D $644D Used by the room-#N$07 bats and the room-#N$16 special.
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
D $647D Set to #N$FF by #R$D7FF when all four collection slots hold
. #N$09.
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

g $64A1 Collected Count
@ $64A1 label=CollectedCount
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
B $64A6,$04
@ $64AA label=Player_SpriteFrame
B $64AA,$01 Sprite frame
@ $64AB label=Player_Facing
B $64AB,$01 Facing / state
@ $64AC label=Player_StoredState
B $64AC,$02

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
D $64C1 Four digits shown on room #N$00. #N$09 in every slot sets
. #R$647D.
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
. #UDGTABLE
. { #FONT$8470,attr=$07,chars=$80(font-bank-1) }
. UDGTABLE#
  $8470,$08 #UDGTABLE(default,centre)
. { #N((#PC-$8470)/$08) } { #UDG(#PC) }
. UDGTABLE#
L $8470,$08,$80

b $8870 Graphics: Font Bank 2
@ $8870 label=Graphics_FontBank2
D $8870 Copied to #R$7C70 by #R$ED39.
. #UDGTABLE
. { #FONT$8870,attr=$07,chars=$80(font-bank-2) }
. UDGTABLE#
  $8870,$08 #UDGTABLE(default,centre)
. { #N((#PC-$8870)/$08) } { #UDG(#PC) }
. UDGTABLE#
L $8870,$08,$80

b $8C70 Graphics: Font Bank 3
@ $8C70 label=Graphics_FontBank3
D $8C70 Copied to #R$7C70 by #R$ED45.
. #UDGTABLE
. { #FONT$8C70,attr=$07,chars=$80(font-bank-3) }
. UDGTABLE#
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
  $D637,$0B Write #INK$38 to *#SKOOLKID$5C8F(ATTR_T) when Kempston
. is selected.
@ $D642 label=Print_Menu_Keyboard
  $D642,$06 Print the messaging at #R$E750.
  $D648,$0B Write #INK$38 to *#SKOOLKID$5C8F(ATTR_T) when the
. keyboard is selected.
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
  $D6B4,$0B Highlight the current slot in #INK$38.
@ $D6BF label=DefineKeys_PrintSlot
  $D6BF,$0B #REGhl=#R$647F+#REGbc.
  $D6CA,$08 Print the glyph from #R$E802 for this slot.
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
  $D6F0,$0A Write the key into the current slot at #R$647F.
  $D6FA,$08 Increase *#R$647E by one.
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
N $D730 Start a new game from room #N$00.
@ $D730 label=Start_Game
E $D730 View the equivalent code in #BOOTY$D08A.
  $D730,$06 Write #N$03E8 to *#R$E82A.
  $D736,$02 #REGa=#N$FF.
@ $D738 label=Change_Room
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
  $D794,$03 Call #R$F433.
  $D797,$02,b$01 Keep only bits 0-3.
  $D799,$01 Copy that room nibble into #REGe.
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
  $D7F0,$08 Set bit 7 of the record and jump to #R$E9FF.
@ $D7F8 label=Handler_Collectibles_Next
  $D7F8,$05 #REGix+=#N($0003,$04,$04).
  $D7FD,$02 Jump to #R$D7D6.

c $D7FF Handler: Housekeeping
@ $D7FF label=Handler_Housekeeping
D $D7FF Marks the game complete when all four #R$64C1 slots are
. #N$09, then ticks #R$6489.
  $D7FF,$07 Test the four collection slots for #N$09.
@ $D806 label=Handler_Housekeeping_SlotLoop
  $D806,$04 Jump to #R$D818 if any slot differs.
  $D80A,$07 Jump to #R$D818 unless *#R$64A1 is #N$10.
  $D811,$07 Write #N$FF to *#R$647D.
@ $D818 label=Handler_Housekeeping_Timer
  $D818,$04 Return if *#R$6489 is zero.
  $D81C,$05 Decrease *#R$6489 by one.
  $D821,$01 Return if the timer is still running.
  $D822,$04 Jump to #R$DF22.
N $D826 Read the Kempston port twice and return if the two reads
. match (the port is stable).
@ $D826 label=Read_Kempston
  $D826,$05 Read from the Kempston joystick port twice.
  $D82B,$01 Return if the two reads differ.
  $D82C,$01 Return.
N $D82D Demo / Kempston movement for the player.
@ $D82D label=Controls_Kempston
  $D82D,$03 #REGhl=*#R$6486.
  $D830,$09 Call #R$DF44 if left matches the stored mask.
@ $D839 label=Controls_Kempston_Right
  $D839,$09 Call #R$DF69 if right matches the stored mask.
@ $D842 label=Controls_Kempston_Up
  $D842,$0A Call #R$E06A if up (bit 3) is pressed.
@ $D84C label=Controls_Kempston_Down
  $D84C,$0A Call #R$E013 if down (bit 2) is pressed.
@ $D856 label=Controls_Kempston_Action
  $D856,$03 Jump to #R$E28C if the port is unstable.
  $D859,$05 Call #R$DF8E if fire (bit 4) is pressed.
  $D85E,$06 Jump to #R$E28C.
N $D864 Kempston climbing controls.
@ $D864 label=Controls_Kempston_Climb
  $D864,$03 Jump to #R$E358 if the port is unstable.
  $D867,$05 Jump to #R$E145 if up is pressed.
  $D86C,$05 Jump to #R$E130 if down is pressed.
  $D871,$03 Jump to #R$E358.

c $D877 Handler: Room Pause
@ $D877 label=Handler_RoomPause
D $D877 Pauses using the per-room delay at #R$E82A.
  $D877,$0E #REGbc=*#R$E82A+(*#R$64A2)*#N$02.
  $D885,$03 Jump to #R$F430.
@ $D888 label=Demo_RoomCount
B $D888,$01 Remaining demo rooms before returning to the menu.
N $D889 Select keyboard (A=#N$00) or Kempston (A=#N$FF).
@ $D889 label=Select_Keyboard
  $D889,$03 #REGa=#N$00.
  $D88C,$02 Jump to #R$D88E.
@ $D88C label=Select_Kempston
  $D88C,$02 #REGa=#N$FF.
@ $D88E label=Select_ControlMethod
  $D88E,$03 Write #REGa to *#R$647E.
  $D891,$03 Jump to #R$D62B.

c $D894 Handler: Moving Objects
@ $D894 label=Handler_MovingObjects
D $D894 Animates the #N$13-byte records at *#R$642A.
  $D894,$04 #REGix=*#R$642A.
@ $D898 label=Handler_MovingObjects_Loop
  $D898,$05 Jump to #R$D8FC if the terminator #N$FF is reached.
  $D89D,$04 Jump to #R$D8F5 if this object is inactive.
  $D8A1,$08 Deactivate the object if its timer is zero.
  $D8A9,$06 Jump to #R$D8F5.
@ $D8AF label=Handler_MovingObjects_Draw
  $D8AF,$0B Use #R$7C70, or #R$9070 when the stored font ID differs.
@ $D8BA label=Handler_MovingObjects_Font
  $D8BA,$03 Write #REGhl to *#SKOOLKID$5C36(CHARS).
  $D8BD,$0A Write the object's clip window to *#R$6419.
  $D8C7,$03 Call #R$F448.
  $D8CA,$07 Compare the moving edge against the stored limit.
  $D8D1,$04 Jump to #R$D8E9 if they differ.
@ $D8D2 label=Handler_MovingObjects_LimitHit
  $D8D5,$02 Call #R$DC37.
  $D8D7,$12 Swap the two limit bytes and call #R$F448 again.
@ $D8E9 label=Handler_MovingObjects_Update
  $D8E9,$03 Call #R$F424.
  $D8EC,$03 Call #R$F442.
  $D8EF,$03 Call #R$F44B.
  $D8F2,$03 Call #R$F44E.
@ $D8F5 label=Handler_MovingObjects_Next
  $D8F5,$05 #REGix+=#N($0013,$04,$04).
  $D8FA,$02 Jump to #R$D898.
@ $D8FC label=Handler_MovingObjects_Done
  $D8FC,$07 Write #N$0218 to *#R$6419.
  $D903,$01 Return.

c $D904 Handler: Room Sixteen
@ $D904 label=Handler_RoomSixteen
D $D904 Special actor for room #N$16.
  $D904,$05 Return if *#R$64A2 is not #N$16.
  $D909,$05 #REGix=#R$644D.
  $D90E,$07 Write #N$051D to *#R$641B.
  $D915,$04 Jump to #R$D994 if the actor is already active.
  $D919,$09 Jump to #R$D92B if the player row is #N$07, #N$14 or
. #N$11.
  $D922,$09 Jump to #R$D9AE.
@ $D92B label=Handler_RoomSixteen_Column
  $D92B,$08 Jump to #R$D9AE unless the player column is #N$0F-#N$16.
  $D933,$07 Return to #R$D9AE unless #R$F433 is less than #N$DC.
  $D93A,$08 Call #R$F457 with sprite #N$E6.
  $D942,$06 Jump to #R$D95D if #R$F433 is #N$80 or higher.
  $D948,$0F Write the left-moving frame into the actor.
  $D957,$06 Jump to #R$D969.
@ $D95D label=Handler_RoomSixteen_Right
  $D95D,$0C Write the right-moving frame into the actor.
@ $D969 label=Handler_RoomSixteen_Sound
  $D969,$07 Call #R$E4B1 with #REGb=#N$FF and #REGd=#N$32.
  $D970,$07 Jump to #R$D982 if the player row is #N$14.
  $D977,$04 Jump to #R$D98C if the player row is #N$11.
  $D97B,$07 Jump to #R$D98C if #R$F433 is #N$80 or higher.
@ $D982 label=Handler_RoomSixteen_RowLow
  $D982,$08 Write row #N$13 into the actor.
  $D98A,$02 Jump to #R$D994.
@ $D98C label=Handler_RoomSixteen_RowHigh
  $D98C,$08 Write row #N$10 into the actor.
@ $D994 label=Handler_RoomSixteen_Draw
  $D994,$03 Call #R$F448.
  $D997,$03 Call #R$F424.
  $D99A,$03 Call #R$F442.
  $D99D,$03 Call #R$F44B.
  $D9A0,$03 Call #R$F44E.
  $D9A3,$0B Deactivate the actor once column #N$23 is passed.
@ $D9AE label=Handler_RoomSixteen_Done
  $D9AE,$07 Write #N$0121 to *#R$641B.
  $D9B5,$01 Return.

c $D9B6 Handler: Room Seven
@ $D9B6 label=Handler_RoomSeven
D $D9B6 Two bats in room #N$07, stored at #R$644D.
  $D9B6,$04 #REGix=#R$644D.
  $D9BA,$05 Return if *#R$64A2 is not #N$07.
  $D9BF,$06 Write #N$0E to *#R$641A.
  $D9C5,$02 #REGb=#N$02.
@ $D9C7 label=Handler_RoomSeven_Loop
  $D9C7,$01 Stash the bat count on the stack.
  $D9C8,$07 Jump to #R$D9EB if this bat is already active.
  $D9CF,$07 Jump to #R$DA07 if #R$F433 is #N$BE or higher.
  $D9D6,$11 Spawn the bat with sprite #N$E7.
  $D9E7,$04 Write #N$FA to the bat timer.
@ $D9EB label=Handler_RoomSeven_Move
  $D9EB,$0B Deactivate the bat if it has reached row #N$0C.
  $D9F6,$02 Jump to #R$DA07.
@ $D9F8 label=Handler_RoomSeven_Draw
  $D9F8,$03 Call #R$F448.
  $D9FB,$03 Call #R$F424.
  $D9FE,$03 Call #R$F442.
  $DA01,$03 Call #R$F44B.
  $DA04,$03 Call #R$F44E.
@ $DA07 label=Handler_RoomSeven_Next
  $DA07,$01 Restore the bat count from the stack.
  $DA08,$05 #REGix+=#N($000E,$04,$04).
  $DA0D,$02 Decrease the bat count and loop back to #R$D9C7.
  $DA0F,$05 Write #N$02 to *#R$641A.
  $DA14,$01 Return.
N $DA15 Draw the collected-item icons along the top of the screen.
@ $DA15 label=Print_CollectionBar
  $DA15,$06 Write #R$7C70 to *#SKOOLKID$5C36(CHARS).
  $DA1B,$06 Call #R$F42D at column #N$01, row #N$19.
  $DA21,$07 Write #INK$07 to *#SKOOLKID$5C8F(ATTR_T).
@ $DA28 label=Print_CollectionBar_Loop
  $DA28,$0B Highlight the current icon in #INK$38.
@ $DA33 label=Print_CollectionBar_Glyph
  $DA33,$05 Print glyph #N$E4.
  $DA38,$04 Jump to #R$DA28 until #N$10 icons are printed.
  $DA3C,$03 Return.

c $DA3F Handler: Carried Object
@ $DA3F label=Handler_CarriedObject
D $DA3F Draws #R$648B and drops it when it lines up with a slot.
  $DA3F,$06 Write #R$7C70 to *#SKOOLKID$5C36(CHARS).
  $DA45,$04 #REGix=#R$648B.
  $DA49,$05 Return if bit 7 is set (nothing carried).
  $DA4E,$08 Stash the current clip window on the stack.
  $DA56,$10 Use the object's own clip window.
  $DA66,$03 Call #R$F448.
  $DA69,$03 Call #R$F424.
  $DA6C,$03 Call #R$F44B.
  $DA6F,$07 Restore the clip window from the stack.
  $DA76,$0E Return unless the object is at the drop cell.
  $DA84,$0E Return unless it matches the stored drop mark.
  $DA92,$0F Call #R$F445 to stamp the object into the room.
  $DAA1,$07 Set bit 7 (no longer carried).
  $DAA8,$06 Return unless the object ID is #N$D9.
  $DAAE,$0B Convert the drop cell into a #R$5DCE offset.
  $DAB9,$0A Write #N$0E/#N$0F into that tile and return.
@ $DAC3 label=Pendulum_Position
B $DAC3,$01
@ $DAC4 label=Pendulum_Delta
B $DAC4,$01
N $DAC5 Animate the pendulum in rooms #N$09-#N$0B.
@ $DAC5 label=Handler_Pendulum
  $DAC5,$11 Reset the pendulum to #N$D8 / #N$02 if it holds #N$FF.
@ $DAD6 label=Handler_Pendulum_Step
  $DAD6,$0B Add the delta to the position.
  $DAE1,$08 Jump to #R$DAFA at either end-stop.
  $DAE9,$05 Jump to #R$DB24 if the room is #N$0A.
  $DAEE,$09 Mirror the position for the other rooms.
  $DAF7,$03 Jump to #R$DB24.
@ $DAFA label=Handler_Pendulum_Bounce
  $DAFA,$09 Negate *#R$DAC4.
  $DB03,$02 Jump to #R$DAD6.

c $DB05 Handler: Pendulum
@ $DB05 label=Handler_PendulumRooms
D $DB05 Rooms #N$09-#N$0B share a swinging pendulum.
  $DB05,$05 Return if *#R$64A2 is #N$0C or higher.
  $DB0A,$04 Return if *#R$64A2 is lower than #N$09.
  $DB0E,$04 Jump to #R$DAC5 if the room is #N$0A or #N$0B.
  $DB12,$07 #REGa=*#R$64A4-#N$04 and #REGb=#N$E0.
@ $DB19 label=Handler_PendulumRooms_NextRoom
  $DB19,$0A Subtract #N$06 until #REGa is negative, decreasing
. #REGb by two each pass.
@ $DB23 label=Handler_Pendulum_DrawPair
  $DB23,$01 #REGc=#REGb.
N $DB24 Draw one pendulum pair.
@ $DB24 label=Draw_Pendulum
  $DB24,$05 Write #INK$47 to *#SKOOLKID$5C8F(ATTR_T).
  $DB29,$0C Draw the first bob at #N$12,#N$14.
  $DB35,$0A Jump to #R$F445 for the second bob at #N$12,#N$10.
N $DB3F Test the player against one actor pointed to by #REGiy.
@ $DB3F label=Test_ActorCollision
  $DB3F,$06 Jump to #R$DB57 if the actor is moving vertically.
  $DB45,$0D Call #R$E43B if the actor lines up horizontally.
  $DB52,$05 Jump to #R$DB67.
@ $DB57 label=Test_ActorCollision_Vertical
  $DB57,$10 Call #R$E43B if the actor lines up vertically.
@ $DB67 label=Test_ActorCollision_Bounds
  $DB67,$05 Return if *#R$6410 is set.
  $DB6C,$0A Convert the actor row and fine-Y into a pixel row.
  $DB76,$11 Convert the player row the same way and return
. unless the difference is less than #N$04.
  $DB87,$0D Convert the actor column and fine-X into a pixel
. column.
  $DB94,$1B Compare the player footprint at #R$6448 and return
. unless the ranges overlap.
  $DBAF,$08 Store the actor state in *#R$64AC and write #N$03.
  $DBB7,$0A Write the actor pointer to *#R$644B.
@ $DBC1 label=Handler_PendulumRooms_StoreActor
  $DBC1,$08 Write the actor pointer to *#R$644B.

c $DBC9 Handler: Inventory Items
@ $DBC9 label=Handler_InventoryItems
D $DBC9 Picks up a two-byte record when the player stands on it.
  $DBC9,$06 Write #R$7C70 to *#SKOOLKID$5C36(CHARS).
  $DBCF,$04 #REGix=*#R$6426.
  $DBD3,$03 #REGc=*#R$64A4.
  $DBD6,$01 Copy the player column into #REGc.
@ $DBD7 label=Handler_InventoryItems_Loop
  $DBD7,$05 Return if the terminator #N$FF is reached.
  $DBDC,$03 Jump to #R$DC20 if this item is already taken.
  $DBDF,$07 Jump to #R$DC20 unless the player column matches.
@ $DBE8 label=Handler_InventoryItems_Row
  $DBE8,$06 Jump to #R$DC20 unless the player row matches.
  $DBEE,$0B Clear a #N$02 by #N$02 hole in the tile buffer.
  $DBF9,$09 Mark the record collected.
  $DC02,$08 Increase *#R$64A1 by one.
  $DC0A,$0A Call #R$E501 (pickup sound).
  $DC14,$0C Jump to #R$DA15.
@ $DC20 label=Handler_InventoryItems_Next
  $DC20,$04 Increase #REGix by two.
  $DC24,$02 Jump to #R$DBD7.

c $DC26 Handler: Event Timer
@ $DC26 label=Handler_EventTimer
D $DC26 Counts *#R$649F down and fires *#R$64A0 through #R$E9FF.
  $DC26,$04 Return if *#R$649F is zero.
  $DC2A,$05 Decrease *#R$649F by one.
  $DC2F,$01 Return if the timer is still running.
  $DC30,$07 Jump to #R$E9FF with *#R$64A0.
N $DC37 Reverse an object's horizontal/vertical direction.
@ $DC37 label=Reverse_Direction
  $DC37,$0C Negate (IX+#N$09) and (IX+#N$08).
  $DC43,$03 Return if the vertical delta is now zero.
  $DC46,$06 Toggle bit 7 of (IX+#N$07).
  $DC4C,$07 Return.
N $DC53 Pause when leaving a non-zero room.
@ $DC53 label=Pause_LeavingRoom
  $DC53,$01 Stash #REGaf on the stack.
  $DC54,$06 Jump to #R$DC60 if *#R$64A2 is zero.
  $DC5A,$06 Call #R$F430 with a pause of #N$03E8.
@ $DC60 label=Pause_LeavingRoom_Done
  $DC60,$02 Restore #REGaf from the stack and return.

c $DC62 Handler: Enemies
@ $DC62 label=Handler_Enemies
D $DC62 Animates the #N$0E-byte records at *#R$6432.
E $DC62 View the equivalent code in #BOOTY$E22D.
  $DC62,$06 Write #R$9070 to *#SKOOLKID$5C36(CHARS).
  $DC68,$04 #REGix=*#R$6432.
@ $DC6C label=Handler_Enemies_Loop
  $DC6C,$05 Return if the terminator #N$FF is reached.
  $DC71,$08 Call #R$DC53 and jump to #R$DCED if inactive.
  $DC79,$07 Jump to #R$DC92 if the sprite ID is #N$E2 or higher.
  $DC80,$05 #REGc=the sprite ID+#N$06 and #REGb=#N$24.
@ $DC85 label=Handler_Enemies_BelowPlayer
  $DC85,$07 Subtract #N$24 until the frame is in range.
@ $DC8C label=Handler_Enemies_AbovePlayer
  $DC8C,$03 #REGc=#REGc-#N$24.
@ $DC8F label=Handler_Enemies_CommitFrame
  $DC8F,$03 Write the wrapped sprite ID.
@ $DC92 label=Handler_Enemies_Probe
  $DC92,$07 Jump to #R$DCDE unless the fine-X is #N$07.
  $DC99,$06 Jump to #R$DCBC if the enemy is facing left.
  $DC9F,$0B Probe the cell above and to the right.
  $DCAA,$12 Call #R$F42D and reverse if that #R$5DCE tile is
. solid.
@ $DCBC label=Handler_Enemies_ProbeLeft
  $DCBC,$0E Jump to #R$DCDE if the enemy is past column #N$23.
  $DCCA,$14 Call #R$F42D to the left and reverse if that tile
. is solid.
@ $DCDE label=Handler_Enemies_Update
  $DCDE,$03 Call #R$F448.
  $DCE1,$03 Call #R$F424.
  $DCE4,$03 Call #R$F442.
  $DCE7,$03 Call #R$F44B.
  $DCEA,$03 Call #R$F44E.
@ $DCED label=Handler_Enemies_Next
  $DCED,$05 #REGix+=#N($000E,$04,$04).
  $DCF2,$03 Jump to #R$DC6C.
N $DCF5 Move to the next room (wrapping from #N$16 to #N$00).
@ $DCF5 label=Cheat_NextRoom
  $DCF5,$01 Restore #REGbc from the stack.
  $DCF6,$09 #REGa=*#R$64A2+1, or #N$00 after room #N$16.
  $DCFF,$04 Jump to #R$D738.
N $DD03 Move to the previous room (wrapping from #N$00 to #N$16).
@ $DD03 label=Cheat_PreviousRoom
  $DD03,$01 Restore #REGbc from the stack.
  $DD04,$0B #REGa=*#R$64A2-1, or #N$16 before room #N$00.
  $DD0F,$03 Jump to #R$D738.
N $DD12 Point #REGix at #R$647C and set #REGde to the number of
. bytes through to #N$7C67.
@ $DD12 label=Tape_BlockRange
  $DD12,$0A #REGde=#N$7C67-#R$647C.
  $DD1C,$03 #REGa=#N$FF.
  $DD1F,$03 Return.
N $DD22 Save the game to tape.
@ $DD22 label=Tape_Save
  $DD22,$06 Write the checksum from #R$DD6C to *#R$6488.
  $DD28,$01 Restore #REGbc from the stack.
  $DD29,$03 Call #R$DD12.
  $DD2C,$03 Call #SKOOLKID$04C2(SA_BYTES).
  $DD2F,$08 Set bit 7 of *#R$64A2 and jump to #R$D738.
N $DD37 Load a saved game from tape.
@ $DD37 label=Tape_Load
  $DD37,$06 Write #N$3C00 to *#SKOOLKID$5C36(CHARS).
  $DD3D,$06 Print the messaging at #R$E7E4.
@ $DD43 label=Tape_Load_Wait
  $DD43,$06 Call #R$F430 with a pause of #N$2710.
  $DD49,$03 Call #SKOOLKID$028E(KEY_SCAN).
  $DD4C,$05 Jump to #R$DD43 if no key is pressed.
  $DD51,$04 Jump to #R$DD64 unless "2" was pressed.
  $DD55,$01 Restore #REGbc from the stack.
  $DD56,$03 Call #R$DD12.
  $DD59,$04 Call #SKOOLKID$0556(LD_BYTES) with carry set.
  $DD5D,$07 Jump to #R$D5D5 if the checksum does not match.
@ $DD64 label=Tape_Load_Resume
  $DD64,$08 Set bit 7 of *#R$64A2 and jump to #R$D738.
N $DD6C Add every byte from #R$647C through the tape block.
@ $DD6C label=Tape_Checksum
  $DD6C,$03 Call #R$DD12.
  $DD6F,$08 #REGa=#N$00 and clear *#R$6488.
@ $DD77 label=Tape_Checksum_Loop
  $DD77,$0C Add *(#REGix) into #REGa until #REGde is zero.
  $DD83,$01 Return.
N $DD84 Wait for any key.
@ $DD84 label=Wait_Keypress
  $DD84,$06 Call #R$F430 with a pause of #N$2710.
  $DD8A,$03 Call #SKOOLKID$028E(KEY_SCAN).
  $DD8D,$04 Jump to #R$DD84 if no key is pressed.
  $DD91,$01 Return.
N $DD92 Fire event #N$09 (suicide / restart).
@ $DD92 label=Cheat_LoseLife
  $DD92,$05 Jump to #R$E9FF with event #N$09.

c $DD97 Handler: Keyboard
@ $DD97 label=Handler_Keyboard
D $DD97 In-game keypresses: save, load, pause, and the hidden room
. cheats when *#N$FFFF is #N$0A.
  $DD97,$03 Call #SKOOLKID$028E(KEY_SCAN).
  $DD9A,$01 #REGa=the keypress.
  $DD9B,$04 Jump to #R$DD22 if "S" was pressed.
  $DD9F,$04 Jump to #R$DD37 if "J" was pressed.
  $DDA3,$04 Jump to #R$DD84 if "H" was pressed.
  $DDA7,$04 Jump to #R$DD92 if "Q" was pressed.
  $DDAB,$05 Return unless *#N$FFFF is #N$0A.
  $DDB0,$0D Cap *#R$64B4 at #N$03.
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
  $DE43,$0C Keep the player's fine-Y in range #N$00-#N$03.
  $DE4F,$14 Call #R$F42D for the cell above the player.
@ $DE63 label=Probe_Ceiling_Ready
  $DE63,$0A Point #REGhl at that #R$5DCE tile and #REGde at #R$643A.
  $DE6D,$03 #REGde=#R$643A.
  $DE70,$02 #REGb=#N$03.
@ $DE72 label=Probe_Ceiling_Loop
  $DE72,$04 Jump to #R$DE85 if this mask byte is zero.
  $DE76,$0A Stop the jump if the tile is solid (#N$10 or higher).
  $DE80,$05 Clear (IX+#N$09) and return.
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
  $DE96,$16 #REGhl=#R$B5D8+(*#R$64AA)*#N$08.
  $DEAC,$0F Mirror the mask when the player is facing left.
  $DEBB,$15 Shift the mask down by the player's fine-Y.
@ $DEC1 label=Build_PlayerMask_Shift
  $DED0,$17 Walk left from the player column until a set bit is found.
@ $DEDD label=Build_PlayerMask_Scan
  $DEE7,$08 Clear *#R$6448 and return if none is set.
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
  $DF17,$0A Set the player flash bits in *#R$64AB.
  $DF21,$01 Return.
N $DF22 Lose a life and restart the room.
@ $DF22 label=Lose_Life
E $DF22 View the equivalent code in #BOOTY$E3A4.
  $DF22,$0E Force any pending event to fire first.
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
  $DF4A,$08 Face left and set frame #N$60.
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
  $DF6F,$08 Face right and set frame #N$60.
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
  $DF9A,$0E Jump to #R$DFC2 unless it matches the player cell.
  $DFA8,$10 Fire any pending event before using this furniture.
@ $DFB8 label=Player_Action_Use
  $DFB8,$0A Jump to #R$D738 with the furniture event ID.
@ $DFC2 label=Player_Action_Next
  $DFC2,$04 #REGhl+=#N($0005,$04,$04).
  $DFC6,$02 Jump to #R$DF91.
@ $DFC8 label=Player_Action_Doors
  $DFC8,$05 Return if *#R$649F is running.
  $DFCD,$03 #REGhl=*#R$6422.
@ $DFD0 label=Player_Action_DoorLoop
  $DFD0,$04 Return if the terminator #N$FF is reached.
  $DFD4,$04 Jump to #R$E00C if this door is inactive.
  $DFD8,$0B Jump to #R$E00C unless the door column matches.
@ $DFE3 label=Player_Action_DoorMatch
  $DFE3,$0E Jump to #R$E00C unless the door row matches.
@ $DFF1 label=Player_Action_DoorUse
  $DFF1,$0B Bump the door use count when it is not #N$FF.
@ $DFFC label=Player_Action_DoorEvent
  $DFFC,$07 Jump to #R$E9FF unless the event is #N$2A.
  $E003,$09 Write #N($0001,$04,$04) to *#R$E82A and jump to #R$E9FF.
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
  $E029,$0D Jump to #R$E065 unless the player is on the
. right-hand half.
@ $E036 label=Player_ClimbDown_Start
  $E036,$0A Jump to #R$E065 unless the player is three rows
. below the ladder.
  $E040,$0D Write the ladder row to *#R$648A and start climbing
. down.
  $E04D,$06 Jump to #R$E05C unless the ladder column matches.
  $E053,$09 Write the remaining fine-X as the horizontal delta
. and return.
@ $E05C label=Player_ClimbDown_Offset
  $E05C,$09 Write the opposite climb delta and return.
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
  $E087,$0D Jump to #R$E0C9 unless the player is on the
. right-hand half.
@ $E094 label=Player_ClimbUp_Start
  $E094,$08 Return if the player is already at the top.
  $E09C,$08 Jump to #R$E0C9 unless the player is two rows
. below the top.
  $E0A4,$0D Write the ladder row to *#R$648A and start climbing
. up.
  $E0B1,$06 Jump to #R$E0C0 unless the ladder column matches.
  $E0B7,$09 Write the remaining fine-X as the horizontal delta
. and return.
@ $E0C0 label=Player_ClimbUp_Offset
  $E0C0,$09 Write the opposite climb delta and return.
@ $E0C9 label=Player_ClimbUp_Next
  $E0C9,$03 Increase #REGhl by three.
  $E0CC,$02 Jump to #R$E079.
@ $E0CE label=Player_Jump
  $E0CE,$09 Write #N$07 to *#R$6410 and start the jump.
  $E0D7,$0F Choose a left-facing jump frame.
@ $E0E6 label=Player_Jump_Right
  $E0E6,$09 Choose a right-facing jump frame.
N $E0EF Stop climbing when the stored ladder row is left.
@ $E0EF label=Player_ClimbStop
  $E0EF,$07 Jump to #R$E110 unless the fine-Y is #N$07.
  $E0F6,$0A Jump to #R$E107 if the player is two rows below
. *#R$648A.
  $E100,$07 Jump to #R$E110 unless the player is three rows
. above that point.
@ $E107 label=Player_ClimbStop_Clear
  $E107,$09 Return after restoring the walk frame.
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
  $E13B,$0A Store the frame, write #N$FE as the vertical delta
. and jump to #R$E358.
N $E145 Animate climbing up.
@ $E145 label=Player_ClimbUp_Anim
  $E145,$0B Step the climb frame up.
@ $E150 label=Player_ClimbUp_StoreFrame
  $E150,$0A Store the frame, write #N$02 as the vertical delta
. and jump to #R$E358.
N $E15A Flash and drop the player after a hit.
. #HTML(#AUDIO0(bonus.wav)(#INCLUDE(Bonus)))
@ $E15A label=Player_Hit
  $E15A,$10 Award a bonus if the hit timer is still #N$32.
@ $E16A label=Player_Hit_Fall
  $E16A,$0D Advance, store and erase the falling player.
  $E177,$0E Clip the draw against *#R$644A and call #R$F44B.
  $E185,$0D Decrease *#R$6435 and jump to #R$DF22 when it hits
. zero.
  $E192,$01 Return.
N $E193 Animate the jump frames from *#R$6410.
@ $E193 label=Player_JumpAnim
  $E193,$08 Decrease *#R$6410 and point at #R$E292.
  $E19B,$06 Use frame #N$30 while the timer is #N$06 or higher.
  $E1A1,$07 Use frame #N$36 while the timer is #N$04 or higher.
  $E1A8,$07 Use frame #N$3C while the timer is #N$03 or higher.
  $E1AF,$07 Use frame #N$42 while the timer is #N$01 or higher.
  $E1B6,$05 Use frame #N$12 for the last tick.
  $E1BB,$01 Return.
N $E1BC Start the hit sequence.
@ $E1BC label=Player_StartHit
  $E1BC,$0D Write #N$32 to *#R$6435 and store the ceiling row.
  $E1C9,$03 Jump to #R$E292.

c $E1CC Handler: Player
@ $E1CC label=Handler_Player
D $E1CC Moves, collides and draws the player entity at #R$64A4.
E $E1CC View the equivalent code in #BOOTY$EBD8.
  $E1CC,$05 Return if *#R$646F is set (demo / intro).
  $E1D1,$06 Write #R$B5B1 to *#SKOOLKID$5C36(CHARS).
  $E1D7,$04 #REGix=#R$64A4.
  $E1DB,$0A Erase the player while *#R$6489 is running.
  $E1E5,$07 Jump to #R$E15A if *#R$6435 is set.
  $E1EC,$07 Jump to #R$E193 if *#R$6410 is set.
  $E1F3,$07 Call #R$E0EF if *#R$648A is set.
  $E1FA,$03 Call #R$DE96.
  $E1FD,$0B Start a fall if *#R$6434 is not a collision.
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
  $E22C,$0D Probe the ceiling while the vertical delta is negative.
  $E239,$0D Increase *#R$6438 and honour a collision.
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
  $E2BE,$08 #REGa=#N$03, or #N$02 when fine-Y is #N$07.
  $E2C6,$09 Convert that cell into a #R$5DCE pointer.
@ $E2CF label=Handler_Player_ProbeUp
  $E2CF,$05 Jump to #R$E2DF if this tile is solid (#N$10 or
. higher).
  $E2D4,$04 Clear the vertical delta.
  $E2D8,$07 Jump to #R$E33F until the probe count is zero,
. then clear the sprite.
@ $E2DF label=Handler_Player_ProbeUpNext
  $E2DF,$03 Advance the tile pointer and loop back to #R$E2CF.
N $E2E2 Probe the tiles to the right while moving right.
@ $E2E2 label=Handler_Player_Horizontal
  $E2E2,$03 Call #R$F448.
  $E2E5,$07 Jump to #R$E322 if the horizontal delta is
. negative.
  $E2EC,$06 Jump to #R$E358 if the column has not changed.
  $E2F2,$08 #REGa=#N$04, or #N$03 when fine-Y is #N$07.
  $E2FA,$0C Convert that cell into a #R$5DCE pointer.
@ $E306 label=Handler_Player_ProbeRight
  $E306,$05 Jump to #R$E31D if this tile is solid (#N$10 or
. higher).
  $E30B,$04 Clear the horizontal delta.
  $E30F,$06 Jump to #R$E31D if *#R$6410 is zero.
  $E315,$08 Write #N$00 to *#R$6410 and clear the sprite.
@ $E31D label=Handler_Player_ProbeRightNext
  $E31D,$05 Step down one row and loop back to #R$E306, then
. jump to #R$E358.
N $E322 Probe the tiles to the left while moving left.
@ $E322 label=Handler_Player_Left
  $E322,$06 Jump to #R$E358 if the column has not changed.
  $E328,$0A Point two columns left; #REGa=#N$04, or #N$03
. when fine-Y is #N$07.
  $E332,$0C Convert that cell into a #R$5DCE pointer.
@ $E33E label=Handler_Player_ProbeLeft
@ $E33F label=Handler_Player_ProbeLeftTest
  $E33E,$05 Jump to #R$E355 if this tile is solid (#N$10 or
. higher).
  $E343,$04 Clear the horizontal delta.
  $E347,$06 Jump to #R$E355 if *#R$6410 is zero.
  $E34D,$08 Write #N$00 to *#R$6410 and clear the sprite.
@ $E355 label=Handler_Player_ProbeLeftNext
  $E355,$03 Step down one row and loop back to #R$E33E.
@ $E358 label=Handler_Player_Commit
  $E358,$03 Call #R$F448.
  $E35B,$0B Jump to #R$E398 if the new column is off-screen.
  $E366,$0D Start a fall if the new row is #N$1A.
@ $E373 label=Handler_Player_Paint
  $E373,$09 Store, move and draw the player.
  $E37C,$0E Draw a collided actor through #R$F45A.
@ $E38A label=Handler_Player_Reset
  $E38A,$1A Clear movement when the player is not jumping.
@ $E398 label=Handler_Player_ClearDeltas
@ $E3A4 label=Handler_Player_Floor
  $E3A4,$0C Jump to #R$DEFB when standing on the floor.
@ $E3B0 label=Handler_Player_Award
  $E3B0,$03 Jump to #R$DEFB.
N $E3B3 Clear the play area and the room buffers.
@ $E3B3 label=Clear_PlayArea
E $E3B3 View the equivalent code in #BOOTY$D4BE.
  $E3B3,$04 Write #INK$00 to *#SKOOLKID$5C8F(ATTR_T).
  $E3B7,$03 Call #SKOOLKID$1CAD(CL_ALL).
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
  $E3EE,$0B Copy #REGix to #REGiy (using the stack) and test the player.
  $E3F9,$03 Call #R$F45D.
  $E3FC,$10 Restore the stored row when bit 7 of (IX+#N$07) is set.
@ $E40C label=Handler_Actors_Commit
  $E40C,$12 Store the new position and call #R$F45A.
@ $E41E label=Handler_Actors_Next
  $E41E,$05 #REGix+=#N($000D,$04,$04).
  $E423,$02 Jump to #R$E3E5.
  $E425,$01 Return.
N $E426 Lock or reverse an actor after a collision.
@ $E426 label=Actor_AfterCollision
  $E426,$05 Jump to #R$E436 if the actor type is #N$02.
  $E42B,$0B Clear the actor deltas and return.
@ $E436 label=Actor_Lock
  $E436,$05 Set bit 7 of (IY+#N$07) and return.
@ $E43B label=Actor_Reverse
  $E43B,$06 Jump to #R$E426 if (IY+#N$0C) is set.
@ $E441 label=Actor_SwapDestination
  $E441,$0C Swap (IY+#N$05) with (IY+#N$0A).
  $E44D,$0C Swap (IY+#N$06) with (IY+#N$0B).
  $E459,$04 #REGa=(IY+#N$08)-#N$01.
  $E45D,$02,b$01 Invert every bit.
  $E45F,$03 Write the new horizontal delta.
  $E462,$04 #REGa=(IY+#N$09)-#N$01.
  $E466,$02,b$01 Invert every bit.
  $E468,$04 Write the new vertical delta and return.

c $E46C Handler: Interrupts
@ $E46C label=Handler_Interrupts
D $E46C IM #N$02 lands here from #R$FEFE. Plays the next tune note every five
. ticks and services any pending sound.
E $E46C View the equivalent code in #BOOTY$FE69.
  $E46C,$06 Stash #REGaf, #REGbc, #REGde, #REGhl and #REGix.
  $E472,$05 Return unless bit 7 of the refresh register is set.
  $E477,$0B Increase *#R$646E and return unless it reached #N$05.
  $E482,$04 Write #N$00 to *#R$646E.
  $E486,$08 Call #R$E4D3 if bit 4 of *#R$6472 is set.
  $E48E,$07 Jump to #R$E4A3 if *#R$6473 is set.
  $E495,$06 Call #R$E666 with note length #N$1106.
@ $E49B label=Handler_Interrupts_Done
  $E49B,$08 Restore the stashed registers and return.
@ $E4A3 label=Handler_Interrupts_Beep
N $E4A3 #HTML(#AUDIO0(beep.wav)(#INCLUDE(Beep)))
  $E4A3,$0B Decrease *#R$6473 and play a short beep.
  $E4AE,$03 Jump to #R$E49B.
N $E4B1 Click the speaker #REGd times using a random delay.
. #HTML(#AUDIO0(click.wav)(#INCLUDE(Click)))
@ $E4B1 label=Play_Click
  $E4B1,$10 Toggle bit 4 of the speaker for #REGd iterations.
@ $E4C1 label=Play_Click_Delay
  $E4C1,$0D Delay by a random count masked with #REGb.
@ $E4CA label=Play_Click_Wait
@ $E4CE label=Play_Click_Done
  $E4CE,$04 #REGa=*#R$641D.
  $E4D2,$01 Return.
N $E4D3 Falling-pitch score sound.
. #HTML(#AUDIO0(score.wav)(#INCLUDE(Score)))
@ $E4D3 label=Sound_Score
  $E4D3,$0E Clear bit 4 of *#R$6472 and jump to #R$E4E1.
N $E4E1 Square-wave sound while #REGde and #REGbc count down.
@ $E4E1 label=Sound_Square
  $E4E1,$1C Toggle the speaker until both counters are zero.
@ $E4FD label=Sound_Square_Done
  $E4FD,$03 #REGa=*#R$6472.
  $E500,$01 Return.
N $E501 Rising-pitch pickup sound.
. #HTML(#AUDIO0(pickup.wav)(#INCLUDE(Pickup)))
@ $E501 label=Sound_Pickup
  $E501,$1C Toggle the speaker while increasing #REGbc.

c $E51D Animate Introduction
@ $E51D label=Animate_Introduction
D $E51D Animates the bats and moon on the introduction screen until a key is
. pressed or *#R$6470 reaches zero.
E $E51D View the equivalent code in #BOOTY$D0AC.
  $E51D,$06 Call #R$E666 with note length #N$0A14.
  $E523,$0A Decrease *#R$6470 and jump to #R$E65B when it is zero.
  $E52D,$0D Call #R$F430 when *#R$647C is set.
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
  $E5BF,$05 Point at #N$40D7 and copy #N$04 pixel rows.
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
  $E66D,$12 Read the next #R$B370 byte, wrapping at #N$FF.
@ $E67F label=Play_Tune_StorePitch
  $E67F,$18 Store the pitch and read the matching #R$B491 duration.
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
B $E6F3,$49

t $E73C Messaging: Menu
@ $E73C label=Messaging_Menu
B $E73C,$14

t $E750 Messaging: Keyboard
@ $E750 label=Messaging_Keyboard
B $E750,$12

t $E762 Messaging: Kempston
@ $E762 label=Messaging_Kempston
B $E762,$2D

t $E78F Messaging: Define Keys
@ $E78F label=Messaging_DefineKeys
B $E78F,$55

t $E7E4 Messaging: Load Game
@ $E7E4 label=Messaging_LoadGame
B $E7E4,$1E

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
  $EA2D,$0A Write #N$00 to *#R$64A1 and *#R$647D.
  $EA37,$0A #REGhl=#R$BC11, #REGix=#R$64C5, #REGde=#R$64F7.
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
  $EA91,$09 Store the final pointer and jump to #R$EAA6.
@ $EA9A label=Copy_TerminatedField
  $EA9A,$04 Copy the next byte and advance both pointers.
  $EA9E,$02 Return if that byte was #N$FF.
  $EAA0,$06 Copy the remaining #REGbc bytes and jump to
. #R$EA9A.
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
  $EAE5,$02 Restore the room pointer into #REGix.
  $EAE7,$06 Write #R$7C70 to *#SKOOLKID$5C36(CHARS).
  $EAED,$03 Call #R$ED51.
  $EAF0,$07 Write #INK$01 to *#R$641D and the border.
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
  $EB1B,$07 #REGix+=#N($0006,$04,$04) and jump to #R$EB0F.
N $EB22 Draw each visible furniture record into *#R$6420.
@ $EB22 label=Load_Room_Furniture
  $EB22,$06 Write #REGix to *#R$6420.
@ $EB28 label=Load_Room_Furniture_Target
  $EB28,$07 Jump to #R$EB3D if the terminator #N$FF is reached.
  $EB2F,$04 Jump to #R$EB36 if this record is hidden.
  $EB33,$03 Call #R$ED82.
@ $EB36 label=Load_Room_Furniture_Continue
  $EB36,$07 #REGix+=#N($0005,$04,$04) and jump to #R$EB28.
N $EB3D Draw each visible door record into *#R$6422.
@ $EB3D label=Load_Room_Doors
  $EB3D,$06 Write #REGix to *#R$6422.
@ $EB43 label=Load_Room_Doors_Target
  $EB43,$07 Jump to #R$EB58 if the terminator #N$FF is reached.
  $EB4A,$04 Jump to #R$EB51 if this record is hidden.
  $EB4E,$03 Call #R$ED9A.
@ $EB51 label=Load_Room_Doors_Continue
  $EB51,$07 #REGix+=#N($0005,$04,$04) and jump to #R$EB43.
N $EB58 Skip each collectible record into *#R$6424.
@ $EB58 label=Load_Room_Collectibles
  $EB58,$06 Write #REGix to *#R$6424.
@ $EB5E label=Load_Room_Collectibles_Target
  $EB5E,$07 Jump to #R$EB6C if the terminator #N$FF is reached.
  $EB65,$07 #REGix+=#N($0003,$04,$04) and jump to #R$EB5E.
N $EB6C Draw each visible inventory item into *#R$6426.
@ $EB6C label=Load_Room_Inventory
  $EB6C,$06 Write #REGix to *#R$6426.
@ $EB72 label=Load_Room_Inventory_Target
  $EB72,$07 Jump to #R$EB97 if the terminator #N$FF is reached.
  $EB79,$04 Jump to #R$EB91 if this record is hidden.
  $EB7D,$07 Call #R$F42D at the item's column and row.
  $EB84,$05 Write #INK$07 to *#SKOOLKID$5C8F(ATTR_T).
  $EB89,$08 Call #R$F445 with glyph #N$80 and size #N$02 by
. #N$02.
@ $EB91 label=Load_Room_Inventory_Continue
  $EB91,$06 Advance #REGix by two and jump to #R$EB72.
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
  $EBCB,$08 Advance #REGix by three and jump to #R$EB9D.
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
  $EBFD,$07 #REGix+=#N($0006,$04,$04) and jump to #R$EBD9.
N $EC04 Draw each visible actor into *#R$6430.
@ $EC04 label=Load_Room_Actors
  $EC04,$06 Write #REGix to *#R$6430.
@ $EC0A label=Load_Room_Actors_Target
  $EC0A,$07 Jump to #R$EC1F if the terminator #N$FF is reached.
  $EC11,$04 Jump to #R$EC18 if this record is hidden.
  $EC15,$03 Call #R$F45A.
@ $EC18 label=Load_Room_Actors_Continue
  $EC18,$07 #REGix+=#N($000D,$04,$04) and jump to #R$EC0A.
N $EC1F Draw each visible enemy into *#R$6432.
@ $EC1F label=Load_Room_Enemies
  $EC1F,$06 Write #R$9070 to *#SKOOLKID$5C36(CHARS).
  $EC25,$06 Write #REGix to *#R$6432.
@ $EC2B label=Load_Room_Enemies_Target
  $EC2B,$07 Jump to #R$EC40 if the terminator #N$FF is reached.
  $EC32,$04 Jump to #R$EC39 if this record is hidden.
  $EC36,$03 Call #R$F44B.
@ $EC39 label=Load_Room_Enemies_Continue
  $EC39,$07 #REGix+=#N($000E,$04,$04) and jump to #R$EC2B.
N $EC40 Draw each visible moving object into *#R$642A.
@ $EC40 label=Load_Room_Movers
  $EC40,$06 Write #REGix to *#R$642A.
@ $EC46 label=Load_Room_Movers_Target
  $EC46,$07 Jump to #R$EC65 if the terminator #N$FF is reached.
  $EC4D,$04 Jump to #R$EC5E if this record is hidden.
  $EC51,$0A Write the object's clip window to *#R$6419.
  $EC5B,$03 Call #R$F44B.
@ $EC5E label=Load_Room_Movers_Continue
  $EC5E,$07 #REGix+=#N($0013,$04,$04) and jump to #R$EC46.
N $EC65 Draw the status bar and reset the per-room flags.
@ $EC65 label=Load_Room_Status
  $EC65,$02 Advance past the terminator.
  $EC67,$06 Convert column #N$21, row #N$02 into a #R$5DCE
. offset.
  $EC6D,$04 Point #REGhl at the matching attribute cell.
  $EC71,$08 Fill #N$0220 attribute cells with #INK$08.
  $EC79,$03 Call #R$ECF2.
  $EC7C,$0C Write #R$7C70 to *#SKOOLKID$5C36(CHARS) and call
. #R$F427.
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
  $ED03,$06 Point #REGhl at #R$64C1 and set #REGb=#N$04.
@ $ED09 label=Print_Inventory_Target
  $ED09,$05 Jump to #R$ED0F unless this digit is #N$09.
  $ED0E,$01 Increase the "#N$09" count.
@ $ED0F label=Print_Inventory_Continue
  $ED0F,$05 Convert the digit into ASCII and call #R$F436.
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
  $ED6F,$02 Restore #REGaf from the stack and return.

c $ED71 Reset Player
@ $ED71 label=Reset_Player
  $ED71,$06 Place the player at column #N$12, row #N$12.
  $ED77,$04 Use sprite #N$60 and colour #INK$45.
  $ED7B,$07 Point #REGix at #R$64A4 and jump to #R$F457.

c $ED82 Draw Furniture
@ $ED82 label=Draw_FurnitureItem
  $ED82,$09 Call #R$F42D at the furniture column and row.
  $ED8B,$06 Write the furniture colour to
. *#SKOOLKID$5C8F(ATTR_T).
  $ED91,$09 Jump to #R$F445 with the stored glyph and size
. #N$04 by #N$03.

c $ED9A Draw Door
@ $ED9A label=Draw_Door
  $ED9A,$09 Call #R$F42D at the door column and row.
  $EDA3,$06 Write the door colour to *#SKOOLKID$5C8F(ATTR_T).
  $EDA9,$08 Jump to #R$F445 with glyph #N$84 and size #N$02
. by #N$02.

c $EDB1 Draw Header Furniture
@ $EDB1 label=Draw_HeaderFurniture
  $EDB1,$06 Fetch the print row and the stored column.
  $EDB7,$02,b$01 Keep only bits 0-6.
  $EDB9,$04 Call #R$F42D at that column and row.
  $EDBD,$06 Write the furniture colour to
. *#SKOOLKID$5C8F(ATTR_T).
  $EDC3,$03 #REGb=the remaining height.
@ $EDC6 label=Draw_HeaderFurniture_Target
  $EDC6,$06 Fetch the starting glyph and the remaining width.
@ $EDCC label=Draw_HeaderFurniture_Continue
  $EDCC,$06 Call #R$F436 and #R$F43F.
  $EDD2,$04 Increase the glyph and loop back to #R$EDCC
. until this row is drawn.
  $EDD6,$02 Decrease the height and loop back to #R$EDC6.
  $EDD8,$01 Return.

c $EDD9 Handler: Events
@ $EDD9 label=Handler_Events
D $EDD9 Dispatches the event ID in #REGa. Each ID is a collectible, door or
. scenery action for the current room.
  $EDD9,$06 Stash #REGix and *#SKOOLKID$5C36(CHARS) on the
. stack.
  $EDDF,$04 Push #R$EECA as the return address.
  $EDE3,$06 Write #R$7C70 to *#SKOOLKID$5C36(CHARS).
  $EDE9,$03 Return if the event is #N$26.
  $EDEC,$06 Return if *#R$649F is already running.
  $EDF2,$04 Jump to #R$EDFB if this is a collectible event.
  $EDF6,$05 Write #N$10 to *#R$6472.
N $EDFB Jump to the handler for this event ID.
@ $EDFB label=Handler_Events_Dispatch
  $EDFB,$01 Copy the event ID into #REGa.
  $EDFC,$02,b$01 Keep only bits 0-6.
  $EDFE,$04 Jump to #R$EFE6 if the event is #N$00.
  $EE02,$05 Jump to #R$EFF5 if the event is #N$01.
  $EE07,$05 Jump to #R$F000 if the event is #N$03.
  $EE0C,$05 Jump to #R$F011 if the event is #N$02.
  $EE11,$05 Jump to #R$F350 if the event is #N$04.
  $EE16,$05 Jump to #R$F03E if the event is #N$05.
  $EE1B,$05 Jump to #R$EEFA if the event is #N$06.
  $EE20,$05 Jump to #R$F0C0 if the event is #N$07.
  $EE25,$05 Jump to #R$EF8A if the event is #N$08.
  $EE2A,$05 Jump to #R$F395 if the event is #N$09.
  $EE2F,$05 Jump to #R$F06A if the event is #N$0A.
  $EE34,$05 Jump to #R$F1C4 if the event is #N$0B.
  $EE39,$05 Jump to #R$F1D4 if the event is #N$0C.
  $EE3E,$05 Jump to #R$F26A if the event is #N$0D.
  $EE43,$05 Jump to #R$EFD3 if the event is #N$0E.
  $EE48,$05 Jump to #R$F28F if the event is #N$0F.
  $EE4D,$05 Jump to #R$F22C if the event is #N$11.
  $EE52,$05 Jump to #R$F2E0 if the event is #N$12.
  $EE57,$05 Jump to #R$F31D if the event is #N$13.
  $EE5C,$05 Jump to #R$EEE5 if the event is #N$14.
  $EE61,$05 Jump to #R$F328 if the event is #N$15.
  $EE66,$05 Jump to #R$F2B2 if the event is #N$16.
  $EE6B,$05 Jump to #R$F072 if the event is #N$17.
  $EE70,$05 Jump to #R$F164 if the event is #N$18.
  $EE75,$05 Jump to #R$F0E4 if the event is #N$19.
  $EE7A,$05 Jump to #R$EF3A if the event is #N$1A.
  $EE7F,$05 Jump to #R$F125 if the event is #N$1B.
  $EE84,$05 Jump to #R$EF5C if the event is #N$1C.
  $EE89,$05 Jump to #R$F361 if the event is #N$1D.
  $EE8E,$05 Jump to #R$F1EE if the event is #N$1E.
  $EE93,$05 Jump to #R$F217 if the event is #N$1F.
  $EE98,$05 Jump to #R$F249 if the event is #N$20.
  $EE9D,$05 Jump to #R$F244 if the event is #N$21.
  $EEA2,$05 Jump to #R$F188 if the event is #N$22.
  $EEA7,$05 Jump to #R$F24E if the event is #N$23.
  $EEAC,$05 Jump to #R$F07D if the event is #N$24.
  $EEB1,$05 Jump to #R$F253 if the event is #N$25.
  $EEB6,$05 Jump to #R$F006 if the event is #N$27.
  $EEBB,$05 Jump to #R$F0B4 if the event is #N$28.
  $EEC0,$05 Jump to #R$F1B6 if the event is #N$29.
  $EEC5,$05 Jump to #R$EED2 if the event is #N$2A.
@ $EECA label=Handler_Events_Done
  $EECA,$08 Restore *#SKOOLKID$5C36(CHARS) and #REGix, then return.
N $EED2 Event #N$2A: hide the first two enemies.
@ $EED2 label=Event_HideEnemies
  $EED2,$06 Call #R$F006 and #R$F164.
  $EED8,$04 #REGix=*#R$6432.
  $EEDC,$08 Set bit 7 on the first two enemy records.
  $EEE4,$01 Return.
N $EEE5 Event #N$14: reveal two decorations.
@ $EEE5 label=Event_RevealDecorations
  $EEE5,$06 #REGix=*#R$642E and #REGb=#N$02.
@ $EEEB label=Event_RevealDecorations_Target
  $EEEB,$04 Stash the count and call #R$F193.
  $EEEF,$08 Advance to the next decoration and loop back to
. #R$EEEB.
  $EEF7,$03 Jump to #R$F164.
N $EEFA Event #N$06: reveal the room-header item.
@ $EEFA label=Event_RevealHeader
  $EEFA,$04 #REGix=*#R$641E.
  $EEFE,$05 Return if this header item is already visible.
  $EF03,$07 Write #N$2020 to *#R$6472.
  $EF0A,$04 Clear bit 7 of the header record.
  $EF0E,$11 Fetch the column, row, width and colour.
  $EF1F,$07 Point #REGix at #R$648B and call #R$F457.
  $EF26,$03 Call #R$F333.
  $EF29,$04 Write #N$01 as the horizontal delta.
  $EF2D,$0C Subtract the width from the column and store it.
  $EF39,$01 Return.
N $EF3A Event #N$1A: reveal two decorations and a mover.
@ $EF3A label=Event_RevealPair
  $EF3A,$09 #REGix=*#R$642E+#N($000C,$04,$04).
  $EF43,$03 Call #R$F193.
  $EF46,$08 Advance one decoration and call #R$F193 again.
  $EF4E,$0D Clear bit 7 of *#R$642A+#N($0026,$04,$04).
  $EF5B,$01 Return.
N $EF5C Event #N$1C: reveal three decorations and three movers.
@ $EF5C label=Event_RevealTriple
  $EF5C,$09 #REGix=*#R$642E+#N($0018,$04,$04).
  $EF65,$02 #REGb=#N$03.
@ $EF67 label=Event_RevealTriple_Target
  $EF67,$0C Call #R$F193 and advance to the next decoration.
  $EF73,$0E #REGix=*#R$642A+#N($0039,$04,$04) and #REGb=#N$03.
@ $EF81 label=Event_RevealTriple_Target2
  $EF81,$08 Clear bit 7 of each mover and loop back to
. #R$EF81.
  $EF89,$01 Return.
N $EF8A Event #N$08: start an actor walking.
@ $EF8A label=Event_StartActor
  $EF8A,$04 #REGix=*#R$6430.
@ $EF8E label=Event_StartActor_Target
  $EF8E,$06 Return if the terminator #N$FF is reached.
  $EF94,$04 Jump to #R$EFCC if this actor is hidden.
  $EF98,$08 Jump to #R$EFCC if the actor already has a delta.
  $EFA0,$06 Jump to #R$EFB7 if there is no horizontal
. destination.
  $EFA6,$05 Jump to #R$EFB1 if the actor is left of the
. destination.
  $EFAB,$06 Write #N$FE as the horizontal delta and jump to
. #R$EFCC.
@ $EFB1 label=Event_StartActor_Branch
  $EFB1,$06 Write #N$02 as the horizontal delta and jump to
. #R$EFCC.
@ $EFB7 label=Event_StartActor_Skip
  $EFB7,$06 Jump to #R$EFCC if there is no vertical
. destination.
  $EFBD,$05 Jump to #R$EFC8 if the actor is above the
. destination.
  $EFC2,$06 Write #N$FE as the vertical delta and jump to
. #R$EFCC.
@ $EFC8 label=Event_StartActor_Branch2
  $EFC8,$04 Write #N$02 as the vertical delta.
@ $EFCC label=Event_StartActor_Continue
  $EFCC,$07 #REGix+=#N($000D,$04,$04) and jump to #R$EF8E.
N $EFD3 Event #N$0E: swap the left/right keys.
@ $EFD3 label=Event_SwapKeys
  $EFD3,$09 Swap *#R$647F with *#R$6480.
  $EFDC,$09 Swap the two bytes at *#R$6486.
  $EFE5,$01 Return.
N $EFE6 Event #N$00: draw the first header item.
@ $EFE6 label=Event_DrawHeader
  $EFE6,$04 #REGix=*#R$641E.
@ $EFEA label=Event_DrawHeader_Body
  $EFEA,$03 #REGa=the header record.
  $EFED,$02,b$01 Keep only bits 0-6.
  $EFEF,$06 Write it back and jump to #R$EDB1.
N $EFF5 Event #N$01: draw the next header item.
@ $EFF5 label=Event_DrawHeaderNext
  $EFF5,$04 #REGix=*#R$641E.
  $EFF9,$07 #REGix+=#N($0006,$04,$04) and jump to #R$EFEA.
N $F000 Event #N$03: draw the first two header items.
@ $F000 label=Event_DrawHeaderPair
  $F000,$03 Call #R$EFE6.
  $F003,$03 Jump to #R$EFF5.
N $F006 Event #N$27: draw the fourth header item.
@ $F006 label=Event_DrawHeaderFourth
  $F006,$04 #REGix=*#R$641E.
  $F00A,$07 #REGix+=#N($0012,$04,$04) and jump to #R$EFEA.
N $F011 Event #N$02: nudge the first actor.
@ $F011 label=Event_NudgeActor
  $F011,$04 #REGix=*#R$6430.
@ $F015 label=Event_NudgeActor_Target
  $F015,$05 Return if the terminator #N$FF is reached.
  $F01A,$05 Return if the actor already has a vertical delta.
  $F01F,$06 Jump to #R$F037 if there is no stored destination.
  $F025,$08 Jump to #R$F033 if the actor is above the
. destination.
  $F02D,$06 Write #N$FE as the vertical delta and jump to
. #R$F037.
@ $F033 label=Event_NudgeActor_Branch
  $F033,$04 Write #N$02 as the vertical delta.
@ $F037 label=Event_NudgeActor_Skip
  $F037,$07 #REGix+=#N($000D,$04,$04) and jump to #R$F015.
N $F03E Event #N$05: start the first enemy.
@ $F03E label=Event_StartEnemy
  $F03E,$07 Write #N$2614 to *#R$649F.
  $F045,$04 #REGix=*#R$6432.
@ $F049 label=Event_StartEnemy_Target
  $F049,$05 Return if the terminator #N$FF is reached.
  $F04E,$04 Jump to #R$F063 if this enemy is hidden.
  $F052,$04 Negate the horizontal delta.
  $F056,$02,b$01 Invert the subtracted byte.
  $F058,$03 Write the new horizontal delta.
  $F05B,$03 #REGa=(IX+#N$07).
  $F05E,$02,b$01 Toggle bit 7.
  $F060,$03 Write the facing flag back.
@ $F063 label=Event_StartEnemy_Continue
  $F063,$07 #REGix+=#N($000E,$04,$04) and jump to #R$F049.
N $F06A Event #N$0A: start a short event timer.
@ $F06A label=Event_ShortTimer
  $F06A,$07 Write #N$021C to *#R$649F.
  $F071,$01 Return.
N $F072 Event #N$17: draw two header items and start a timer.
@ $F072 label=Event_HeaderAndTimer
  $F072,$03 Call #R$F000.
  $F075,$07 Write #N$246E to *#R$649F.
  $F07C,$01 Return.
N $F07D Event #N$24: hide two header items.
@ $F07D label=Event_HideHeaderPair
  $F07D,$06 #REGb=#N$02 and #REGix=*#R$641E.
@ $F083 label=Event_HideHeaderPair_Target
  $F083,$0A Call #R$F090 and advance to the next header
. record.
  $F08D,$02 Decrease the count and loop back to #R$F083.
  $F08F,$01 Return.
N $F090 Hide one header item by overprinting #N$C8.
@ $F090 label=Hide_HeaderItem
  $F090,$03 #REGa=the header record.
  $F093,$02,b$01 Keep only bits 0-6.
  $F095,$0B Set bit 7 and call #R$F42D at that column and
. row.
  $F0A0,$03 #REGb=the remaining height.
@ $F0A3 label=Hide_HeaderItem_Target
  $F0A3,$03 #REGc=the remaining width.
@ $F0A6 label=Hide_HeaderItem_Continue
  $F0A6,$08 Print #N$C8 and write it into the room buffer.
  $F0AE,$03 Decrease the width and loop back to #R$F0A6.
  $F0B1,$02 Decrease the height and loop back to #R$F0A3.
  $F0B3,$01 Return.
N $F0B4 Event #N$28: hide the fourth header item.
@ $F0B4 label=Event_HideHeaderFourth
  $F0B4,$04 #REGix=*#R$641E.
  $F0B8,$08 #REGix+=#N($0012,$04,$04) and jump to #R$F090.
N $F0C0 Event #N$07: reveal three header items.
@ $F0C0 label=Event_RevealHeaderTriple
  $F0C0,$07 Write #N$2614 to *#R$649F.
  $F0C7,$06 #REGb=#N$03 and #REGix=*#R$641E.
@ $F0CD label=Event_RevealHeaderTriple_Target
  $F0CD,$0E Call #R$EFEA if the item is hidden, or #R$F090
. if it is already visible.
  $F0DB,$08 Advance to the next header record and loop back
. to #R$F0CD.
  $F0E3,$01 Return.
N $F0E4 Event #N$19: reveal the first furniture item.
@ $F0E4 label=Event_RevealFurniture
  $F0E4,$04 #REGix=*#R$6420.
  $F0E8,$05 Return if this furniture item is already visible.
  $F0ED,$04 Clear bit 7 of the furniture record.
  $F0F1,$07 Write #N$1E08 to *#R$6472.
  $F0F8,$10 Fetch the column, row, colour and glyph.
  $F108,$07 Point #REGix at #R$648B and call #R$F457.
  $F10F,$03 Call #R$F333.
  $F112,$12 Store the drop row four cells above the furniture.
  $F124,$01 Return.
N $F125 Event #N$1B: reveal the first ladder.
@ $F125 label=Event_RevealLadder
  $F125,$04 #REGix=*#R$6428.
  $F129,$05 Return if this ladder is already visible.
  $F12E,$04 Clear bit 7 of the ladder record.
  $F132,$07 Write #N$2207 to *#R$6472.
  $F139,$0E Fetch the column, row and colour; glyph #N$D9.
  $F147,$07 Point #REGix at #R$648B and call #R$F457.
  $F14E,$03 Call #R$F333.
  $F151,$12 Store the drop row five cells above the ladder.
  $F163,$01 Return.
N $F164 Event #N$18: show the first hidden enemy.
@ $F164 label=Event_ShowEnemy
  $F164,$04 #REGix=*#R$6432.
@ $F168 label=Event_ShowEnemy_Target
  $F168,$06 Return if the terminator #N$FF is reached.
  $F16E,$04 Jump to #R$F181 if this enemy is already visible.
  $F172,$02,b$01 Keep only bits 0-6.
  $F174,$0D Write the visible ID and call #R$F463.
@ $F181 label=Event_ShowEnemy_Skip
  $F181,$07 #REGix+=#N($000E,$04,$04) and jump to #R$F168.
N $F188 Event #N$22: award a combination digit.
@ $F188 label=Event_AwardDigit
  $F188,$03 Call #R$F249.
  $F18B,$07 Write #N$2005 to *#R$649F.
  $F192,$01 Return.
N $F193 Hide one decoration by filling its tiles with #N$C8.
@ $F193 label=Reveal_Decoration
  $F193,$01 Restore the return address from the stack.
  $F194,$05 Return if this decoration is already hidden.
  $F199,$0E Set bit 7 and convert the decoration cell.
  $F1A7,$04 Point #REGhl at that #R$5DCE tile.
  $F1AB,$0B Jump to #R$F454 with #N$C8.
N $F1B6 Event #N$29: test the second header item.
@ $F1B6 label=Event_TestHeader
  $F1B6,$04 #REGix=*#R$641E.
  $F1BA,$0A Return if bit 7 of the next header record is
. clear.
N $F1C4 Event #N$0B: reveal a decoration and a mover.
@ $F1C4 label=Event_RevealDecorAndMover
  $F1C4,$04 #REGix=*#R$642E.
  $F1C8,$03 Call #R$F193.
  $F1CB,$08 Clear bit 7 of *#R$642A.
  $F1D3,$01 Return.
N $F1D4 Event #N$0C: reveal the next decoration and mover.
@ $F1D4 label=Event_RevealNextPair
  $F1D4,$09 #REGix=*#R$642E+#N($0006,$04,$04).
  $F1DD,$03 Call #R$F193.
  $F1E0,$0D Clear bit 7 of *#R$642A+#N($0013,$04,$04).
  $F1ED,$01 Return.
N $F1EE Event #N$1E: reveal three decorations.
@ $F1EE label=Event_RevealThreeDecorations
  $F1EE,$06 #REGix=*#R$642E and #REGb=#N$03.
@ $F1F4 label=Event_RevealThreeDecorations_Target
  $F1F4,$08 Jump to #R$F20F if this decoration is hidden.
  $F1FC,$13 Call #R$F463 with the stored size and set bit 7.
@ $F20F label=Event_RevealThreeDecorations_Continue
  $F20F,$08 Advance to the next decoration and loop back to
. #R$F1F4.
N $F217 Event #N$1F: show every moving object.
@ $F217 label=Event_ShowMovers
  $F217,$04 #REGix=*#R$642A.
@ $F21B label=Event_ShowMovers_Target
  $F21B,$06 Return if the terminator #N$FF is reached.
  $F221,$04 Clear bit 7 of this mover.
  $F225,$07 #REGix+=#N($0013,$04,$04) and jump to #R$F21B.
N $F22C Event #N$11: hide the first furniture item.
@ $F22C label=Event_HideFurniture
  $F22C,$04 #REGix=*#R$6420.
  $F230,$03 #REGa=the furniture record.
  $F233,$02,b$01 Keep only bits 0-6.
  $F235,$09 Set bit 7 and fetch the furniture row.
  $F23E,$06 Jump to #R$F463 with size #N$04 by #N$03.
N $F244 Event #N$21: increment combination digit 3.
@ $F244 label=Event_DigitThree
  $F244,$05 #REGhl=#R$64C3 and jump to #R$F256.
N $F249 Event #N$20: increment combination digit 4.
@ $F249 label=Event_DigitFour
  $F249,$05 #REGhl=#R$64C4 and jump to #R$F256.
N $F24E Event #N$23: increment combination digit 2.
@ $F24E label=Event_DigitTwo
  $F24E,$05 #REGhl=#R$64C2 and jump to #R$F256.
N $F253 Event #N$25: increment combination digit 1.
@ $F253 label=Event_DigitOne
  $F253,$03 #REGhl=#R$64C1.
@ $F256 label=Event_BumpDigit
  $F256,$07 Write #N$2614 to *#R$649F.
  $F25D,$08 Increase *(#REGhl) and jump to #R$ECF2 unless it
. wrapped.
  $F265,$05 Write #N$00 and jump to #R$ECF2.
N $F26A Event #N$0D: hide a later actor.
@ $F26A label=Event_HideLaterActor
  $F26A,$09 #REGix=*#R$6430+#N($0027,$04,$04).
  $F273,$06 Return if this actor is already hidden.
  $F279,$03 Call #R$F45D.
  $F27C,$03 #REGa=the actor record.
  $F27F,$02,b$01 Set bit 7.
  $F281,$03 Hide the actor.
N $F284 Clear *#R$6434 after a collision.
@ $F284 label=Hide_ActorRecord
  $F284,$06 Return unless *#R$6434 is #N$03.
  $F28A,$04 Write #N$00 to *#R$6434.
  $F28E,$01 Return.
N $F28F Event #N$0F: hide the first active actor.
@ $F28F label=Event_HideActor
  $F28F,$03 Call #R$F284.
  $F292,$04 #REGix=*#R$6430.
@ $F296 label=Event_HideActor_Target
  $F296,$06 Return if the terminator #N$FF is reached.
  $F29C,$04 Jump to #R$F2AB if this actor is hidden.
  $F2A0,$03 Call #R$F45D.
  $F2A3,$08 Set bit 7 of the actor record.
@ $F2AB label=Event_HideActor_Continue
  $F2AB,$07 #REGix+=#N($000D,$04,$04) and jump to #R$F296.
N $F2B2 Event #N$16: randomise the combination.
@ $F2B2 label=Event_RandomCombination
  $F2B2,$07 Write #N$013A to *#R$649F.
  $F2B9,$06 Call #R$F2D9 and write the digit to *#R$64C1.
  $F2BF,$06 Call #R$F2D9 and write the digit to *#R$64C2.
  $F2C5,$06 Call #R$F2D9 and write the digit to *#R$64C3.
  $F2CB,$03 Call #R$F2D9.
  $F2CE,$02 Reset bit 0.
  $F2D0,$02,b$01 Keep only bits 0-2.
  $F2D2,$07 Write #N$01-#N$08 to *#R$64C4 and jump to
. #R$ECF2.
@ $F2D9 label=Event_RandomCombination_Target
  $F2D9,$03 Call #R$F433.
  $F2DC,$02,b$01 Keep only bits 0-2.
  $F2DE,$02 Increase #REGa by one and return.
N $F2E0 Event #N$12: reveal the first door.
@ $F2E0 label=Event_RevealDoor
  $F2E0,$04 #REGix=*#R$6422.
@ $F2E4 label=Event_RevealDoor_Body
  $F2E4,$05 Return if this door is already visible.
  $F2E9,$04 Clear bit 7 of the door record.
  $F2ED,$01 Halt.
  $F2EE,$07 Write #N$1006 to *#R$6472.
  $F2F5,$0E Fetch the column, row and colour; glyph #N$84.
  $F303,$07 Point #REGix at #R$648B and call #R$F457.
  $F30A,$03 Call #R$F333.
  $F30D,$0F Store the drop row two cells below the door.
  $F31C,$01 Return.
N $F31D Event #N$13: reveal the next door.
@ $F31D label=Event_RevealNextDoor
  $F31D,$04 #REGix=*#R$6422.
  $F321,$07 #REGix+=#N($0005,$04,$04) and jump to #R$F2E4.
N $F328 Event #N$15: reveal the third door.
@ $F328 label=Event_RevealThirdDoor
  $F328,$04 #REGix=*#R$6422.
  $F32C,$07 #REGix+=#N($000A,$04,$04) and jump to #R$F2E4.
N $F333 Copy the carried-object destination into the working
. slot.
@ $F333 label=Copy_ActorDestination
  $F333,$0C Copy the column and row into (IX+#N$0E) and
. (IX+#N$0F).
  $F33F,$10 Write the default clip window #N$18/#N$02/#N$21/
. #N$02.
  $F34F,$01 Return.
N $F350 Event #N$04: print the event message.
@ $F350 label=Event_PrintMessage
  $F350,$06 Write #N$3C00 to *#SKOOLKID$5C36(CHARS).
  $F356,$05 Write #INK$3A to *#SKOOLKID$5C8F(ATTR_T).
  $F35B,$06 Jump to #R$F460 with the messaging at #R$F3A5.
N $F361 Event #N$1D: reveal every decoration.
@ $F361 label=Event_RevealAllDecorations
  $F361,$04 #REGix=*#R$642E.
@ $F365 label=Event_RevealAllDecorations_Target
  $F365,$06 Return if the terminator #N$FF is reached.
  $F36B,$04 Jump to #R$F38E if this decoration is already
. visible.
  $F36F,$0D Clear bit 7 and call #R$F42D at that cell.
  $F37C,$06 Write the decoration colour to
. *#SKOOLKID$5C8F(ATTR_T).
  $F382,$0C Call #R$F445 with the stored glyph and size.
@ $F38E label=Event_RevealAllDecorations_Skip
  $F38E,$07 #REGix+=#N($0006,$04,$04) and jump to #R$F365.
N $F395 Event #N$09: toggle the silent-tune flag.
@ $F395 label=Event_ToggleTune
  $F395,$03 #REGa=*#R$647C.
  $F398,$02,b$01 Invert every bit.
  $F39A,$03 Write #REGa to *#R$647C.
  $F39D,$07 Write #N$2614 to *#R$649F.
  $F3A4,$01 Return.

t $F3A5 Messaging: Event
@ $F3A5 label=Messaging_Event
D $F3A5 Printed by event #N$04 at #R$F350.
B $F3A5,$2B

u $F3D0

c $F424 Jump Table: Graphics
@ $F424 label=JumpTable_StorePosition
  $F424,$03 Jump to #R$F466.
@ $F427 label=JumpTable_DrawStatus
  $F427,$03 Jump to #R$F4A8.

c $F42A Jump Table: Utilities
@ $F42A label=JumpTable_InitialiseDisplay
D $F42A Jump-table stubs used throughout the game.
  $F42A,$03 Jump to #R$F56A.
@ $F42D label=JumpTable_SetPrintPosition
  $F42D,$03 Jump to #R$F5C4.
@ $F430 label=JumpTable_Delay
  $F430,$03 Jump to #R$F5EC.
@ $F433 label=JumpTable_GetRandomNumber
  $F433,$03 Jump to #R$F5F4.
@ $F436 label=JumpTable_PrintCharacter
  $F436,$03 Jump to #R$F60A.
@ $F439 label=JumpTable_PrintClipped
  $F439,$03 Jump to #R$F662.
@ $F43C label=JumpTable_ConvertCoordinate
  $F43C,$03 Jump to #R$F6AA.
@ $F43F label=JumpTable_WriteTile
  $F43F,$03 Jump to #R$F6C6.
@ $F442 label=JumpTable_MoveEntity
  $F442,$03 Jump to #R$F6E1.
@ $F445 label=JumpTable_PrintSprite
  $F445,$03 Jump to #R$F7AA.
@ $F448 label=JumpTable_AdvanceEntity
  $F448,$03 Jump to #R$F804.
@ $F44B label=JumpTable_DrawEntity
  $F44B,$03 Jump to #R$F8B4.
@ $F44E label=JumpTable_EraseEntity
  $F44E,$03 Jump to #R$F9EE.
@ $F451 label=JumpTable_FillTiles
  $F451,$03 Jump to #R$FA9E.
@ $F454 label=JumpTable_FillAttributes
  $F454,$03 Jump to #R$FA5A.
@ $F457 label=JumpTable_SpawnEntity
  $F457,$03 Jump to #R$FAFE.
@ $F45A label=JumpTable_DrawActor
  $F45A,$03 Jump to #R$FB2F.
@ $F45D label=JumpTable_UpdateActor
  $F45D,$03 Jump to #R$FB90.
@ $F460 label=JumpTable_PrintMessage
  $F460,$03 Jump to #R$F544.
@ $F463 label=JumpTable_DrawBox
  $F463,$03 Jump to #R$F48B.
N $F466 Remember the previous position, then write the new one.
@ $F466 label=Store_EntityPosition
  $F466,$09 Store the old column and write #REGc as the new column.
  $F46F,$09 Store the old row and write #REGb as the new row.
  $F478,$09 Store the old fine-X and write #REGe as the new fine-X.
  $F481,$09 Store the old fine-Y and write #REGd as the new fine-Y.
  $F48A,$01 Return.
N $F48B Draw a box of character #N$C8.
@ $F48B label=Draw_Box
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
  $F4A5,$03 Move up one row and jump to #R$F493.
N $F4A8 Draw one life icon for each remaining life, then a blank.
@ $F4A8 label=Draw_StatusIcons
E $F4A8 View the equivalent code in #BOOTY$E064.
  $F4A8,$03 Call #R$F5C4.
  $F4AB,$06 Jump to #R$F4B9 if *#R$64B4 is the last life.
  $F4B1,$03 Set the remaining-life count and the #N$E3 icon.
@ $F4B4 label=Draw_StatusIcons_Target
  $F4B4,$03 Call #R$F60A.
  $F4B7,$02 Decrease the life count and loop back to #R$F4B4
. until all lives are drawn.
@ $F4B9 label=Draw_StatusIcons_Skip
  $F4B9,$05 Print a blank #N$C8 cell and return.
N $F4BE Add *#R$6417 into the score digits at #R$64B5(#N$64BA).
@ $F4BE label=Draw_StatusIcons_Target2
  $F4BE,$05 Return if *#R$6417 is zero.
  $F4C3,$14 Point at the digit that matches the place value.
  $F4D7,$02 Jump to #R$F4F0 if that digit is already in range.
  $F4D9,$07 Add the low byte into the digit, wrapping at #N$0A.
  $F4E0,$10 Carry into the next place and jump to #R$F4BE.
@ $F4F0 label=Draw_StatusIcons_Branch
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
  $F528,$0D Copy the new score over the stored score and jump
. to #R$F51F.
@ $F535 label=Draw_StatusIcons_Target5
  $F535,$03 Call #R$F5C4.
  $F538,$02 #REGb=#N$05.
@ $F53A label=Draw_StatusIcons_Target6
  $F53A,$06 Convert the digit into a character and print it.
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
  $F559,$03 Advance the message pointer and jump to #R$F544.
@ $F55C label=Print_Message_Branch
  $F55C,$03 Call #R$F60A.
  $F55F,$03 Advance the message pointer and jump to #R$F544.
@ $F562 label=Print_Message_Skip
  $F562,$01 Advance the message pointer.
  $F563,$04 Write the next byte to *#SKOOLKID$5C8F(ATTR_T).
  $F567,$03 Advance the message pointer and jump to #R$F544.

c $F56A Initialise Display
@ $F56A label=Initialise_Display
D $F56A Opens the upper screen, builds the line-address table and fills the IM
. #N$02 vector page at #N$FD00 with #N$FE.
E $F56A View the equivalent code in #BOOTY$CD14.
  $F56A,$05 Write #N$00 to *#SKOOLKID$5C6B(DF_SZ).
  $F56F,$05 Open channel #N$02 via #SKOOLKID$1601(CHAN_OPEN).
N $F574 Build #N$19 display-file addresses from #SKOOLKID$0DD9(CL_SET).
  $F574,$07 Point at the line-address table and start at column
. #N$01, row #N$21.
@ $F57B label=Initialise_Display_Continue
  $F57B,$04 Stash the position and call #SKOOLKID$0DD9(CL_SET).
  $F57F,$0A Fetch *#SKOOLKID$5C84(DF_CC) and add #N$21.
  $F589,$06 Store that address in the table.
  $F58F,$06 Increase the row and jump to #R$F57B until #N$19
. rows are stored.
  $F595,$01 Drop the leftover table pointer.
  $F596,$0E Write the default clip window to *#R$6419.
  $F5A4,$0D Clear seven bytes at #SKOOLKID$5CB6(UDG).
  $F5B1,$05 Write #N$00 to *#R$643E.
  $F5B6,$0D Fill #N$0100 bytes at #N$FD00 with #N$FE.
  $F5C3,$01 Return.
N $F5C4 Set the print position from #REGbc.
@ $F5C4 label=Set_PrintPosition
  $F5C4,$04 Write #REGbc to *#SKOOLKID$5C88(S_POSN).
  $F5C8,$01 Switch to the shadow registers.
  $F5C9,$08 Fetch the stored position and clear #REGa, #REGd and
. #REGb.
  $F5D1,$06 Look up the line address from the table at #N$FF02.
  $F5D7,$09 Subtract the column and write *#SKOOLKID$5C84(DF_CC).
  $F5E0,$04 Rotate the high byte into an attribute offset.
  $F5E4,$02,b$01 Keep only bits 0-1.
  $F5E6,$04 Write the offset to *#R$6412.
  $F5EA,$02 Switch back and return.
N $F5EC Delay for #REGbc iterations.
@ $F5EC label=Delay
E $F5EC View the equivalent code in #BOOTY$F8C0.
R $F5EC BC Length of loop
  $F5EC,$01 Stash #REGbc on the stack.
@ $F5ED label=Delay_Continue
  $F5ED,$05 Decrease #REGbc and jump to #R$F5ED until it is
. zero.
  $F5F2,$02 Restore #REGbc from the stack and return.
N $F5F4 (((#REGb + #REGc) % #N$100 + #N$AB) % #N$100) * #N$100 +
. (#REGc + #N$CD) % #N$100
@ $F5F4 label=Get_RandomNumber
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
N $F60A Print one character using *#SKOOLKID$5C36(CHARS).
@ $F60A label=Print_Character
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
  $F63F,$06 Jump to #R$F64E if *#SKOOLKID$5C91(MASK_T) is set.
  $F645,$04 Write *#SKOOLKID$5C8F(ATTR_T) to that attribute
. cell.
  $F649,$05 Switch back, restore #REGix and the character, and
. return.
@ $F64E label=Print_Character_Continue
  $F64E,$03 Merge the existing attribute through the mask.
  $F651,$06 Keep the paper bits from *#SKOOLKID$5C8F(ATTR_T).
  $F657,$02,b$01 Invert the mask.
  $F659,$04 Merge the ink bits and write the attribute.
  $F65D,$05 Switch back, restore #REGix and the character, and
. return.
N $F662 Print a clipped rectangular run of characters.
@ $F662 label=Print_Clipped
  $F662,$05 Store the width in *#R$6416 and keep the tile ID
. in #REGl.
@ $F667 label=Print_Clipped_Target
  $F667,$04 Reload the remaining width from *#R$6416.
  $F66B,$06 Jump to #R$F677 if this row is inside *#R$6419.
@ $F671 label=Print_Clipped_Continue
  $F671,$06 Skip down until the row is inside the clip window.
@ $F677 label=Print_Clipped_Branch
  $F677,$05 Return if this row is below *#R$641A.
  $F67C,$05 Return if this column is past *#R$641C.
  $F681,$07 Jump to #R$F68F if this column is inside
. *#R$641B.
@ $F688 label=Print_Clipped_Branch2
  $F688,$07 Skip left until the column is inside the clip
. window.
@ $F68F label=Print_Clipped_Branch3
  $F68F,$06 Call #R$F6AA for this cell.
  $F695,$05 Call #R$F6C6 with the tile ID.
  $F69A,$0A Move left one column and loop back to #R$F68F
. until the row is done.
@ $F6A4 label=Print_Clipped_Skip
  $F6A4,$06 Restore the position, move up one row and jump to
. #R$F667.
N $F6AA Convert a column/row pair into an offset.
@ $F6AA label=Convert_Coordinate
E $F6AA View the equivalent code in #BOOTY$A86E.
  $F6AA,$03 Clear #REGa, #REGd and #REGl.
  $F6AD,$03 #REGa=#N$18-#REGb.
  $F6B0,$0D Multiply the row by #N$20 into #REGhl.
  $F6BD,$04 #REGe=#N$21-#REGc.
  $F6C1,$04 Add the column and write *#R$6412.
  $F6C5,$01 Return.
N $F6C6 Write one tile and its attribute into the room buffers.
@ $F6C6 label=Write_Tile
  $F6C6,$03 Stash the tile, #REGde and #REGhl on the stack.
  $F6C9,$07 Increase *#R$6412 by one.
  $F6D0,$05 Point #REGhl at that #R$5DCE cell.
  $F6D5,$04 Point #REGhl at the matching #R$60EE cell.
  $F6D9,$04 Write *#SKOOLKID$5C8F(ATTR_T) there.
  $F6DD,$04 Restore the stashed registers and return.

N $F6E1 Move an entity and erase the vacated cells.
@ $F6E1 label=Move_Entity
  $F6E1,$04 Write #N$00 to *#R$643D.
  $F6E5,$06 Jump to #R$F6F7 if the column matches (IX+#N$0A).
  $F6EB,$07 Call #R$F71C when the column moved left.
  $F6F2,$05 Call #R$F73C when the column moved right and jump
. to #R$F702.
@ $F6F7 label=Move_Entity_Skip
  $F6F7,$06 Jump to #R$F702 if the fine-X matches (IX+#N$0C).
  $F6FD,$05 Call #R$F73C when the fine-X wrapped to #N$07.
@ $F702 label=Move_Entity_Skip2
  $F702,$06 Jump to #R$F712 if the row matches (IX+#N$0B).
  $F708,$07 Call #R$F788 when the row moved up.
  $F70F,$03 Jump to #R$F761 if the row moved down, else return.
@ $F712 label=Move_Entity_Skip3
  $F712,$05 Return if the fine-Y matches (IX+#N$0D).
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
  $F736,$06 Call #R$FA9E and restore the registers.
N $F73C Erase the right-hand column that has just been vacated.
@ $F73C label=Move_Entity_Target2
  $F73C,$05 Write #N$01 to *#R$643D.
  $F741,$02 Stash the new position and size.
  $F743,$10 Fill a one-column strip at the old right-hand edge.
  $F753,$08 Increase the height when the old fine-Y is not
. #N$07.
@ $F75B label=Move_Entity_Skip5
  $F75B,$06 Call #R$FA9E and restore the registers.
N $F761 Erase the bottom row that has just been vacated.
@ $F761 label=Move_Entity_Branch
  $F761,$02 Stash the new position and size.
  $F763,$10 Fill a one-row strip at the old bottom edge.
  $F773,$08 Increase the width when the fine-X is not #N$07.
@ $F77B label=Move_Entity_Skip6
  $F77B,$07 Increase the width again when *#R$643D is set.
@ $F782 label=Move_Entity_Skip7
  $F782,$06 Call #R$FA9E and restore the registers.
N $F788 Erase the top row that has just been vacated.
@ $F788 label=Move_Entity_Target3
  $F788,$02 Stash the new position and size.
  $F78A,$0B Fill a one-row strip at the old column and row.
  $F795,$08 Increase the width when the old fine-X is not
. #N$07.
@ $F79D label=Move_Entity_Skip8
  $F79D,$07 Increase the width again when *#R$643D is set.
@ $F7A4 label=Move_Entity_Skip9
  $F7A4,$06 Call #R$FA9E and restore the registers.
N $F7AA Print a sprite of width #REGe and height #REGd.
@ $F7AA label=Print_Sprite
E $F7AA View the equivalent code in #BOOTY$EA93.
R $F7AA A Sprite ID
R $F7AA B Vertical co-ordinate
R $F7AA C Horizontal co-ordinate
R $F7AA D Height (in character blocks)
R $F7AA E Width (in character blocks)
  $F7AA,$06 Store the width in *#R$6416 and keep the sprite ID
. minus one in #REGl.
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
  $F7F6,$06 Restore the position, move up one row and jump to
. #R$F7B0.
@ $F7FC label=Print_Sprite_Branch4
  $F7FC,$08 Advance the glyph past the clipped cells and jump
. to #R$F7F6.
N $F804 Advance an entity by its stored deltas.
@ $F804 label=Advance_Entity
E $F804 View the equivalent code in #BOOTY$EEA6.
R $F804 IX Entity data
R $F804 O:B Updated row
R $F804 O:C Updated column
R $F804 O:D Updated fine-Y
R $F804 O:E Updated fine-X
  $F804,$06 #REGc=the column and #REGb=the row.
  $F80A,$06 Add (IX+#N$08) to the fine-X.
  $F810,$04 Jump to #R$F81D if the fine-X is still in range.
  $F814,$04 Jump to #R$F81A if the entity moved left.
  $F818,$02 Step the column two right, then...
@ $F81A label=Advance_Entity_Branch
  $F81A,$01 ...one left.
  $F81B,$02,b$01 Keep only bits 0-2.
@ $F81D label=Advance_Entity_Branch2
  $F81D,$07 Store the fine-X and add (IX+#N$09) to the fine-Y.
  $F824,$04 Jump to #R$F831 if the fine-Y is still in range.
  $F828,$04 Jump to #R$F82E if the entity moved up.
  $F82C,$02 Step the row two down, then...
@ $F82E label=Advance_Entity_Branch3
  $F82E,$01 ...one up.
  $F82F,$02,b$01 Keep only bits 0-2.
@ $F831 label=Advance_Entity_Branch4
  $F831,$02 Store the fine-Y and return.
N $F833 Draw a left-facing entity by shifting each tile left.
@ $F833 label=Advance_Entity_Target
  $F833,$02,b$01 Keep only bits 0-6.
  $F835,$03 Write the colour to *#SKOOLKID$5C8F(ATTR_T).
  $F838,$08 Add #N$08 to the stored shift count at
. #R$F915(#N$F917).
  $F840,$04 #REGde=*#SKOOLKID$5C36(CHARS).
  $F844,$06 Copy the stored stride from #R$F8B4(#N$F936) into
. the add at #R$F833(#N$F88E).
  $F84A,$05 Clear the self-modified OR at #R$F833(#N$F881).
  $F84F,$0C Point #REGhl at the last source tile of this
. frame.
  $F85B,$06 #REGde=the sprite width and height.
  $F861,$06 #REGix=#REGhl and #REGhl=#N$5CBE.
@ $F867 label=Advance_Entity_Continue
  $F867,$03 Stash the source pointer and remaining size.
@ $F86A label=Advance_Entity_Continue2
  $F86A,$04 Stash the source pointer and set #REGb=#N$08.
@ $F86E label=Advance_Entity_Target2
  $F86E,$08 Stash the row count and load the next source byte.
@ $F876 label=Advance_Entity_Target3
  $F876,$08 Shift one source bit into the overflow bytes.
  $F87E,$03 Write the overflow bits to the next column.
  $F881,$01 Self-modified: NOP or OR (HL).
  $F882,$09 Write the rotated byte and advance the pointers.
  $F88B,$0A Advance to the next source column and loop back
. to #R$F86A.
  $F895,$08 Write OR (HL) into *#R$F833(#N$F881) and clear
. eight overflow bytes.
@ $F89D label=Advance_Entity_Target4
  $F89D,$09 Clear one overflow byte and loop back to #R$F89D.
  $F8A6,$0E Step back one source character and loop back to
. #R$F867, then jump to #R$F959.
N $F8B4 Draw the entity pointed to by #REGix.
@ $F8B4 label=Draw_Entity
E $F8B4 View the equivalent code in #BOOTY$EED7.
R $F8B4 IX Entity data
  $F8B4,$04 Clear the self-modified OR at #R$F8B4(#N$F929).
  $F8B8,$06 Stash *#SKOOLKID$5C36(CHARS) on the stack.
  $F8BE,$04 Stash #REGiy and #REGix on the stack.
  $F8C2,$08 Write #N$07-(IX+#N$02) to the shift count at
. #R$F915(#N$F917).
  $F8CA,$06 #REGde=the sprite width and height.
  $F8D0,$10 #REGiy=#N$5CBE+(height+#N$01)*#N$08.
  $F8E0,$0A Write the width*#N$08 to the stride at
. #R$F8B4(#N$F936).
  $F8EA,$08 Jump to #R$F833 if bit 7 of the colour is set.
  $F8F2,$03 Write the colour to *#SKOOLKID$5C8F(ATTR_T).
  $F8F5,$04 #REGde=*#SKOOLKID$5C36(CHARS).
  $F8F9,$09 Point #REGhl at this frame's source UDGs.
  $F902,$0C #REGde=the size, #REGix=#REGhl and
. #REGhl=#N$5CBE.
@ $F90E label=Draw_Entity_Continue
  $F90E,$03 Stash the source pointer and remaining size.
@ $F911 label=Draw_Entity_Continue2
  $F911,$04 Stash the source pointer and set #REGb=#N$08.
@ $F915 label=Draw_Entity_Target
  $F915,$0B Stash the row count and load the next source byte.
@ $F920 label=Draw_Entity_Target2
  $F920,$06 Shift one source bit into the overflow byte.
@ $F926 label=Draw_Entity_Skip
  $F926,$03 Write the overflow bits to the next column.
  $F929,$01 Self-modified: NOP or OR (HL).
  $F92A,$09 Write the rotated byte and advance the pointers.
  $F933,$0A Advance to the next source column and loop back
. to #R$F911.
  $F93D,$08 Write OR (HL) into *#R$F8B4(#N$F929) and clear
. eight overflow bytes.
@ $F945 label=Draw_Entity_Target3
  $F945,$09 Clear one overflow byte and loop back to #R$F945.
  $F94E,$0B Step to the next source character and loop back
. to #R$F90E.
@ $F959 label=Draw_Entity_Target4
  $F959,$0E Point *#SKOOLKID$5C36(CHARS) at the shifted
. workspace plus the fine-Y.
  $F967,$0E Increase the printed width when the fine-X is not
. #N$07.
@ $F975 label=Draw_Entity_Skip2
  $F975,$05 Store the printed height in *#R$6414.
  $F97A,$08 Decrease the height when the fine-Y is #N$07.
@ $F982 label=Draw_Entity_Continue3
  $F982,$0B Call #R$F992 at the entity column and row.
  $F98D,$05 Restore *#SKOOLKID$5C36(CHARS) and return.
N $F992 Print the shifted sprite inside the clip window.
@ $F992 label=Draw_Entity_Target5
  $F992,$06 Write the remaining width into the load at
. #R$F998(#N$F99A).
@ $F998 label=Draw_Entity_Target6
  $F998,$03 Advance the glyph base and reload the width.
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
  $F9CB,$06 Call #R$F5C4 and jump to #R$F9D5 with the
. clipped glyph.
@ $F9D1 label=Draw_Entity_Branch3
  $F9D1,$04 Call #R$F5C4 with the unclipped glyph.
@ $F9D5 label=Draw_Entity_Continue4
  $F9D5,$04 Call #R$F60A and keep the glyph in #REGh.
  $F9D9,$08 Jump to #R$F9E8 if this column is past *#R$641C.
  $F9E1,$07 Advance the glyph and loop back to #R$F9D5.
@ $F9E8 label=Draw_Entity_Skip3
  $F9E8,$06 Restore the position, move up one row and jump
. to #R$F998.
N $F9EE Test whether the entity overlaps the player.
@ $F9EE label=Erase_Entity
  $F9EE,$05 Return if *#R$6411 is already set.
  $F9F3,$0C Fetch the column, row, width and height.
  $F9FF,$03 Call #R$FA6A.
  $FA02,$05 Return if the clipped width or height is zero.
  $FA07,$0B Write the width*#N$08+#N$10 into the compare at
. #R$F9EE(#N$FA35).
  $FA12,$06 Write the height*#N$08+#N$18 into the compare at
. #R$F9EE(#N$FA4F).
  $FA18,$06 Point #REGiy at the player at #R$64A4.
  $FA1E,$1A Jump to #R$FA57 unless the entity overlaps the
. player horizontally.
  $FA38,$1A Jump to #R$FA57 unless the entity overlaps the
. player vertically.
  $FA52,$05 Write #N$01 to *#R$6411.
@ $FA57 label=Erase_Entity_Branch
  $FA57,$03 Restore #REGiy and return.
N $FA5A Fill attributes starting at #REGhl.
@ $FA5A label=Fill_Attributes
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
N $FA6A Clip the print rectangle against *#R$6419.
@ $FA6A label=Next_PrintCell
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
N $FA9E Fill a rectangle of tiles from the room buffers.
@ $FA9E label=Fill_Tiles
  $FA9E,$04 Stash #REGaf, #REGbc, #REGde and #REGhl.
  $FAA2,$0A Switch *#SKOOLKID$5C36(CHARS) to *#R$640E.
  $FAAC,$07 Store the width in *#R$6416 and call #R$FA6A.
  $FAB3,$09 Jump to #R$FAF5 if the clipped size is zero.
  $FABC,$04 Store the starting column in *#R$6414(#N$6415).
@ $FAC0 label=Fill_Tiles_Target
  $FAC0,$0B Reload the width and column and call #R$F5C4.
@ $FACB label=Fill_Tiles_Continue
  $FACB,$0D Advance *#R$6412 and point #REGhl at that
. #R$5DCE tile.
  $FAD8,$03 Call #R$F60A with the stored tile.
  $FADB,$0D Copy the matching #R$60EE attribute to the
. screen.
  $FAE8,$05 Move left one column and loop back to #R$FACB.
  $FAED,$08 Move up one row and jump to #R$FAC0.
@ $FAF5 label=Fill_Tiles_Skip
  $FAF5,$09 Restore *#SKOOLKID$5C36(CHARS) and the stashed
. registers.
N $FAFE Spawn or reset the entity at #REGix.
@ $FAFE label=Spawn_Entity
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
  $FB26,$09 Clear the movement deltas and return.
N $FB2F Draw the actor pointed to by #REGix.
@ $FB2F label=Draw_Actor
R $FB2F IX Actor data
  $FB2F,$05 Write #N$FF to the mask at #R$FB90(#N$FBC5).
  $FB34,$0B Fetch the column, row and width; height #N$01.
  $FB3F,$08 Increase the width when the fine-X is not #N$07.
@ $FB47 label=Draw_Actor_Skip
  $FB47,$08 Increase the height when the fine-Y is below
. #N$03.
@ $FB4F label=Draw_Actor_Branch
  $FB4F,$03 Call #R$FA6A.
  $FB52,$07 Jump to #R$FB68 if the clipped size is zero.
  $FB59,$0F Call #R$FA5A with the actor colour at that
. attribute cell.
@ $FB68 label=Draw_Actor_Skip2
  $FB68,$0F Fill #R$6440 with #N$FF for the actor width.
  $FB77,$06 Write #N$00 after the mask and load the fine-X.
@ $FB7D label=Draw_Actor_Target
  $FB7D,$04 Build a left-hand mask of (fine-X+#N$01) bits.
  $FB81,$0F Write the mask to both ends of #R$6440 and jump
. to #R$FB94.
N $FB90 Stamp the actor mask onto the display file.
@ $FB90 label=Update_Actor
R $FB90 IX Actor data
  $FB90,$04 Write #N$00 to the mask at #R$FB90(#N$FBC5).
@ $FB94 label=Update_Actor_Target
  $FB94,$15 Convert the actor column and row into a pixel
. address.
  $FBA9,$02 #REGe=#N$04.
@ $FBAB label=Update_Actor_Continue
  $FBAB,$07 Jump to #R$FBCB if this pixel row is off-screen.
  $FBB2,$03 Call #SKOOLKID$22AA(PIXEL_ADD).
  $FBB5,$0B Increase the copy width when the fine-X is not
. #N$07.
@ $FBC0 label=Update_Actor_Skip
  $FBC0,$03 #REGde=#R$6440.
@ $FBC3 label=Update_Actor_Target2
  $FBC3,$08 Copy one mask byte to the screen (AND is
. self-modified).
@ $FBCB label=Update_Actor_Branch
  $FBCB,$07 Move up one pixel row and loop back to #R$FBAB.

u $FBD2

c $FEFE Alias: Interrupt Jump Dispatcher
@ $FEFE label=AliasInterruptRedirect
D $FEFE IM #N$02 lands at this address. #R$D5AC writes a jump to #R$E46C here.
E $FEFE View the equivalent code in #BOOTY$FEFE.
  $FEFE,$03 Jump to #R$E46C.

u $FF01
