ON INIT {
  SET �rune_name aam
  SET_MATERIAL STONE
  SET_GROUP PROVISIONS
  SET_PRICE 1000
  SET_STEAL 50
  SET_WEIGHT 0
  ACCEPT
}

ON INITEND {
  // ------------------------- start mod part 1 -------------------------

  SET �EXCLUDE_ME 0

  // exclude if not in demo mode
  IF (^DEMO == 0) {
    // "mega" rune on level 15 that is only visible in the demo version
    IF (^ME == "rune_aam_0003") {
      SET �EXCLUDE_ME 1
    }

    // "vista" rune on level 15 that is only visible in the demo version
    IF (^ME == "rune_aam_0004") {
      SET �EXCLUDE_ME 1
    }
  }

  IF (�EXCLUDE_ME == 0) {
    GOSUB MOD_RR_INIT

    // step 3: use up all the mod_rr_rune_* variables, then subsequent runes can be completely random
    IF (#MOD_RR_MANDATORY_RUNES_REMAINING >= 0) {
      SET �rune_name $MOD_RR_RUNE_~#MOD_RR_MANDATORY_RUNES_REMAINING~
      DEC #MOD_RR_MANDATORY_RUNES_REMAINING 1
    } ELSE {
      SET �random_value ^rnd_20
      
      IF (�random_value ==  0) SET �rune_name "aam"
      IF (�random_value ==  1) SET �rune_name "cetrius"
      IF (�random_value ==  2) SET �rune_name "comunicatum"
      IF (�random_value ==  3) SET �rune_name "cosum"
      IF (�random_value ==  4) SET �rune_name "folgora"
      IF (�random_value ==  5) SET �rune_name "fridd"
      IF (�random_value ==  6) SET �rune_name "kaom"
      IF (�random_value ==  7) SET �rune_name "mega"
      IF (�random_value ==  8) SET �rune_name "morte"
      IF (�random_value ==  9) SET �rune_name "movis"
      IF (�random_value == 10) SET �rune_name "nhi"
      IF (�random_value == 11) SET �rune_name "rhaa"
      IF (�random_value == 12) SET �rune_name "spacium"
      IF (�random_value == 13) SET �rune_name "stregum"
      IF (�random_value == 14) SET �rune_name "taar"
      IF (�random_value == 15) SET �rune_name "tempus"
      IF (�random_value == 16) SET �rune_name "tera"
      IF (�random_value == 17) SET �rune_name "vista"
      IF (�random_value == 18) SET �rune_name "vitae"
      IF (�random_value == 19) SET �rune_name "yok"
    }
  }

  // ------------------------- end of mod part 1 -------------------------
  
  SETNAME [system_~�rune_name~] 
  TWEAK ICON rune_~�rune_name~[icon]
  TWEAK SKIN "item_rune_aam" item_rune_~�rune_name~
  ACCEPT
}

// ------------------------- start mod part 2 -------------------------

// removal of unsorted_rune_<random_idx>:
// while random_idx < remaining_runes do:
//   unsorted_rune_<random_idx> = unsorted_rune_<random_idx + 1>
//   random_idx++
>>WHILE_RANDOM_IDX_NOT_EQ_REMAINING_RUNES {
  IF (�RANDOM_IDX >= �REMAINING_RUNES) {
    RETURN
  }

  SET �NEXT_IDX �RANDOM_IDX
  INC �NEXT_IDX 1
  
  SET �UNSORTED_RUNE_~�RANDOM_IDX~ �UNSORTED_RUNE_~�NEXT_IDX~
  
  INC �RANDOM_IDX 1
  GOSUB WHILE_RANDOM_IDX_NOT_EQ_REMAINING_RUNES

  RETURN
}

// step 2: counting down from 20 to 0 using remaining_runes as the index:
//   pick a random unsorted_rune_* variable and assign it to mod_rr_rune_<remaining_runes>
>>DO_WHILE_REMAINING_RUNES_GTE_0 {
  // a random integer is picked between 0 and remaining_runes (random(20) = [0..19], random(0) = 0)
  // the picked random integer is stored as random_idx
  //
  // avoiding ^rnd_0, as prior to Arx Libertatis 1.3 it causes an infinite loop and the game just hangs
  // in AL 1.3 it returns 0
  IF (�REMAINING_RUNES == 0) {
    SET �RANDOM_IDX 0
  } ELSE {
    SET �RANDOM_IDX ^rnd_~�REMAINING_RUNES~
  }

  // a new variable called mod_rr_rune_<remaining_runes> gets the value of unsorted_rune_<random_idx>
  SET $MOD_RR_RUNE_~�REMAINING_RUNES~ �UNSORTED_RUNE_~�RANDOM_IDX~

  DEC �REMAINING_RUNES 1

  // remove unsorted_rune_<random_idx> so it cannot be picked again
  GOSUB WHILE_RANDOM_IDX_NOT_EQ_REMAINING_RUNES

  // recursion
  IF (�REMAINING_RUNES >= 0) {
    GOSUB DO_WHILE_REMAINING_RUNES_GTE_0
  }

  RETURN
}

>>MOD_RR_INIT {
  // make sure this code block only runs once
  IF (#MOD_RR_INITED == 1) {
    RETURN
  }
  
  SET #MOD_RR_INITED 1
  
  SET #MOD_RR_MANDATORY_RUNES_REMAINING 19

  // step 1: generate 20 variables, each holding the name of a rune
  SET �UNSORTED_RUNE_0 "aam"
  SET �UNSORTED_RUNE_1 "cetrius"
  SET �UNSORTED_RUNE_2 "comunicatum"
  SET �UNSORTED_RUNE_3 "cosum"
  SET �UNSORTED_RUNE_4 "folgora"
  SET �UNSORTED_RUNE_5 "fridd"
  SET �UNSORTED_RUNE_6 "kaom"
  SET �UNSORTED_RUNE_7 "mega"
  SET �UNSORTED_RUNE_8 "morte"
  SET �UNSORTED_RUNE_9 "movis"
  SET �UNSORTED_RUNE_10 "nhi"
  SET �UNSORTED_RUNE_11 "rhaa"
  SET �UNSORTED_RUNE_12 "spacium"
  SET �UNSORTED_RUNE_13 "stregum"
  SET �UNSORTED_RUNE_14 "taar"
  SET �UNSORTED_RUNE_15 "tempus"
  SET �UNSORTED_RUNE_16 "tera"
  SET �UNSORTED_RUNE_17 "vista"
  SET �UNSORTED_RUNE_18 "vitae"
  SET �UNSORTED_RUNE_19 "yok"

  SET �REMAINING_RUNES 20

  GOSUB DO_WHILE_REMAINING_RUNES_GTE_0

  RETURN
}

// ------------------------- end of mod part 2 -------------------------

ON INVENTORYUSE {
  PLAY "system2"
  RUNE -a ~�rune_name~
  IF (#TUTORIAL_MAGIC < 9) INC #TUTORIAL_MAGIC 3
  IF (#TUTORIAL_MAGIC == 8) GOTO TUTO
  IF (#TUTORIAL_MAGIC == 7) GOTO TUTO
  IF (#TUTORIAL_MAGIC == 6) {
    >>TUTO
    SET #TUTORIAL_MAGIC 9
    PLAY "system"
    HEROSAY [system_tutorial_6bis]
    QUEST [system_tutorial_6bis]
    DESTROY SELF
    ACCEPT
  }
  DESTROY SELF
  ACCEPT
}

ON INVENTORYIN {
  IF (#TUTORIAL_MAGIC > 1) ACCEPT
  INC #TUTORIAL_MAGIC 1
  IF (#TUTORIAL_MAGIC == 2) {
    PLAY "system"
    HEROSAY [system_tutorial_6]
    QUEST [system_tutorial_6]
    ACCEPT
  }
  ACCEPT
}
