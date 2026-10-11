class ShapeItem {
  final String name;
  final String path;
  final String category;
  ShapeItem({required this.name, required this.path, required this.category});
}

class ShapeData {
  static List<ShapeItem> getAllShapes() {
    final List<ShapeItem> shapes = [];

    // 01 - Classic Shapes
    final classic = ['01_circle','02_square','03_rounded_square','04_triangle','05_pentagon','06_hexagon','07_octagon','08_diamond','09_oval','10_rectangle','11_trapezoid','12_parallelogram','13_rhombus','14_kite','15_cross','16_plus','17_minus','18_arrow','19_chevron','20_star'];
    for (var n in classic) {
      shapes.add(ShapeItem(name: n, path: 'assets/01_classic_shapes/$n.png', category: 'كلاسيكية'));
    }

    // 02 - Stars
    final stars = ['01_5_point_star','02_6_point_star','03_7_point_star','04_8_point_star','05_4_point_star','06_12_point_star','07_burst_star','08_sparkle_star','09_shooting_star','10_falling_star','11_star_outline','12_star_filled','13_star_half','14_star_double','15_star_triple','16_star_cluster','17_star_burst','18_star_explosion','19_star_twinkle','20_star_shine'];
    for (var n in stars) {
      shapes.add(ShapeItem(name: n, path: 'assets/02_stars/$n.png', category: 'نجوم'));
    }

    // 03 - Hearts
    final hearts = ['01_classic_heart','02_rounded_heart','03_sharp_heart','04_double_heart','05_heart_outline','06_heart_filled','07_heart_half','08_heart_broken','09_heart_arrow','10_heart_wings','11_heart_crown','12_heart_diamond','13_heart_flower','14_heart_star','15_heart_circle','16_heart_square','17_heart_triple','18_heart_cluster','19_heart_pulse','20_heart_beat'];
    for (var n in hearts) {
      shapes.add(ShapeItem(name: n, path: 'assets/03_hearts/$n.png', category: 'قلوب'));
    }

    // 04 - Circles
    final circles = ['01_full_circle','02_circle_outline','03_double_circle','04_triple_circle','05_ring','06_donut','07_bubble','08_ball','09_sphere','10_orb','11_dot','12_dot_cluster','13_circle_burst','14_circle_wave','15_circle_ripple','16_circle_target','17_circle_cross','18_circle_plus','19_circle_minus','20_circle_arrow'];
    for (var n in circles) {
      shapes.add(ShapeItem(name: n, path: 'assets/04_circles/$n.png', category: 'دوائر'));
    }

    // 05 - Hexagons (لم نتحقق منها، لكن سنفترض الشكل التالي)
    final hexagons = ['01_hexagon','02_hexagon_outline','03_hexagon_filled','04_double_hexagon','05_triple_hexagon','06_hexagon_rounded','07_hexagon_sharp','08_hexagon_long','09_hexagon_wide','10_hexagon_3d','11_hexagon_flat','12_hexagon_grid','13_hexagon_cluster','14_hexagon_burst','15_hexagon_star','16_hexagon_heart','17_hexagon_diamond','18_hexagon_circle','19_hexagon_square','20_hexagon_triangle'];
    for (var n in hexagons) {
      shapes.add(ShapeItem(name: n, path: 'assets/05_hexagons/$n.png', category: 'سداسية'));
    }

    // 06 - Diamonds
    final diamonds = ['01_classic_diamond','02_diamond_outline','03_double_diamond','04_diamond_filled','05_diamond_rounded','06_diamond_sharp','07_diamond_long','08_diamond_wide','09_diamond_3d','10_diamond_flat','11_diamond_grid','12_diamond_cluster','13_diamond_burst','14_diamond_star','15_diamond_heart','16_diamond_circle','17_diamond_square','18_diamond_hexagon','19_diamond_triangle','20_diamond_cross'];
    for (var n in diamonds) {
      shapes.add(ShapeItem(name: n, path: 'assets/06_diamonds/$n.png', category: 'ماسية'));
    }

    // 07 - Waves (لم نتحقق)
    final waves = ['01_wave','02_wave_outline','03_wave_filled','04_double_wave','05_triple_wave','06_wave_rounded','07_wave_sharp','08_wave_long','09_wave_short','10_wave_zigzag','11_wave_curve','12_wave_spiral','13_wave_ripple','14_wave_burst','15_wave_cluster','16_wave_star','17_wave_heart','18_wave_circle','19_wave_diamond','20_wave_cross'];
    for (var n in waves) {
      shapes.add(ShapeItem(name: n, path: 'assets/07_waves/$n.png', category: 'موجات'));
    }

    // 08 - Flowers
    final flowers = ['01_simple_flower','02_flower_outline','03_flower_filled','04_flower_double','05_flower_triple','06_flower_rose','07_flower_tulip','08_flower_daisy','09_flower_lotus','10_flower_sunflower','11_flower_lily','12_flower_orchid','13_flower_cherry','14_flower_plum','15_flower_peach','16_flower_apricot','17_flower_jasmine','18_flower_lavender','19_flower_violet','20_flower_iris'];
    for (var n in flowers) {
      shapes.add(ShapeItem(name: n, path: 'assets/08_flowers/$n.png', category: 'زهور'));
    }

    // 09 - Crystals (لم نتحقق)
    final crystals = ['01_crystal','02_crystal_outline','03_crystal_filled','04_crystal_shard','05_crystal_cluster','06_crystal_point','07_crystal_gem','08_crystal_diamond','09_crystal_ruby','10_crystal_emerald','11_crystal_sapphire','12_crystal_amethyst','13_crystal_topaz','14_crystal_opal','15_crystal_pearl','16_crystal_quartz','17_crystal_jade','18_crystal_onyx','19_crystal_amber','20_crystal_coral'];
    for (var n in crystals) {
      shapes.add(ShapeItem(name: n, path: 'assets/09_crystals/$n.png', category: 'كريستال'));
    }

    // 10 - Snow (لم نتحقق)
    final snow = ['01_snowflake','02_snow_crystal','03_snow_star','04_snow_hexagon','05_snow_diamond','06_snow_burst','07_snow_cluster','08_snow_simple','09_snow_complex','10_snow_3d','11_snow_ice','12_snow_frost','13_snow_chill','14_snow_winter','15_snow_cold','16_snow_white','17_snow_blue','18_snow_silver','19_snow_grey','20_snow_pure'];
    for (var n in snow) {
      shapes.add(ShapeItem(name: n, path: 'assets/10_snow/$n.png', category: 'ثلج'));
    }

    // 11 - Fire
    final fire = ['01_flame','02_fire','03_spark','04_ember','05_blaze','06_inferno','07_torch','08_candle','09_campfire','10_bonfire','11_wildfire','12_fireball','13_firework','14_firework_burst','15_firework_spark','16_firework_star','17_firework_heart','18_firework_circle','19_firework_diamond','20_firework_cross'];
    for (var n in fire) {
      shapes.add(ShapeItem(name: n, path: 'assets/11_fire/$n.png', category: 'نار'));
    }

    // 12 - Leaves (لم نتحقق)
    final leaves = ['01_leaf','02_leaf_outline','03_leaf_filled','04_double_leaf','05_triple_leaf','06_leaf_maple','07_leaf_oak','08_leaf_birch','09_leaf_willow','10_leaf_palm','11_leaf_fern','12_leaf_clover','13_leaf_ivy','14_leaf_vine','15_leaf_bamboo','16_leaf_lotus','17_leaf_rose','18_leaf_tulip','19_leaf_daisy','20_leaf_sunflower'];
    for (var n in leaves) {
      shapes.add(ShapeItem(name: n, path: 'assets/12_leaves/$n.png', category: 'أوراق'));
    }

    // 13 - Arrows (لم نتحقق)
    final arrows = ['01_arrow_up','02_arrow_down','03_arrow_left','04_arrow_right','05_arrow_up_left','06_arrow_up_right','07_arrow_down_left','08_arrow_down_right','09_double_arrow','10_triple_arrow','11_arrow_curved','12_arrow_zigzag','13_arrow_circle','14_arrow_square','15_arrow_diamond','16_arrow_star','17_arrow_heart','18_arrow_cross','19_arrow_plus','20_arrow_minus'];
    for (var n in arrows) {
      shapes.add(ShapeItem(name: n, path: 'assets/13_arrows/$n.png', category: 'أسهم'));
    }

    // 14 - Squares
    final squares = ['01_square','02_square_outline','03_square_filled','04_square_rounded','05_square_sharp','06_square_double','07_square_triple','08_square_grid','09_square_cluster','10_square_burst','11_square_star','12_square_heart','13_square_circle','14_square_diamond','15_square_hexagon','16_square_triangle','17_square_cross','18_square_plus','19_square_minus','20_square_arrow'];
    for (var n in squares) {
      shapes.add(ShapeItem(name: n, path: 'assets/14_squares/$n.png', category: 'مربعة'));
    }

    // 15 - Triangles
    final triangles = ['01_triangle','02_triangle_outline','03_triangle_filled','04_triangle_rounded','05_triangle_sharp','06_triangle_double','07_triangle_triple','08_triangle_grid','09_triangle_cluster','10_triangle_burst','11_triangle_star','12_triangle_heart','13_triangle_circle','14_triangle_diamond','15_triangle_hexagon','16_triangle_square','17_triangle_cross','18_triangle_plus','19_triangle_minus','20_triangle_arrow'];
    for (var n in triangles) {
      shapes.add(ShapeItem(name: n, path: 'assets/15_triangles/$n.png', category: 'مثلثة'));
    }

    // 16 - Complex Geometric
    final complex = ['01_mandala','02_kaleidoscope','03_geometric_pattern','04_sacred_geometry','05_flower_of_life','06_metatron_cube','07_sri_yantra','08_yin_yang','09_om_symbol','10_infinity','11_spiral','12_helix','13_dna','14_atom','15_molecule','16_crystal_grid','17_star_grid','18_circle_grid','19_square_grid','20_triangle_grid'];
    for (var n in complex) {
      shapes.add(ShapeItem(name: n, path: 'assets/16_complex_geometric/$n.png', category: 'معقدة'));
    }

    // 17 - Nature
    final nature = ['01_tree','02_pine_tree','03_palm_tree','04_cactus','05_mountain','06_hill','07_rock','08_stone','09_pebble','10_sand','11_cloud','12_rain','13_thunder','14_lightning','15_rainbow','16_sun','17_moon','18_planet','19_earth','20_galaxy'];
    for (var n in nature) {
      shapes.add(ShapeItem(name: n, path: 'assets/17_nature/$n.png', category: 'طبيعية'));
    }

    // 18 - Crystals 2
    final crystals2 = ['01_crystal_ball','02_crystal_wand','03_crystal_sword','04_crystal_shield','05_crystal_crown','06_crystal_ring','07_crystal_necklace','08_crystal_bracelet','09_crystal_earring','10_crystal_pendant','11_crystal_brooch','12_crystal_tiara','13_crystal_scepter','14_crystal_orb','15_crystal_sphere','16_crystal_cube','17_crystal_pyramid','18_crystal_cone','19_crystal_cylinder','20_crystal_prism'];
    for (var n in crystals2) {
      shapes.add(ShapeItem(name: n, path: 'assets/18_crystals_2/$n.png', category: 'كريستال 2'));
    }

    // 19 - Metallic
    final metallic = ['01_gold','02_silver','03_bronze','04_copper','05_iron','06_steel','07_platinum','08_titanium','09_brass','10_chrome','11_metal_bar','12_metal_coin','13_metal_ring','14_metal_shield','15_metal_sword','16_metal_crown','17_metal_key','18_metal_lock','19_metal_gear','20_metal_chain'];
    for (var n in metallic) {
      shapes.add(ShapeItem(name: n, path: 'assets/19_metallic/$n.png', category: 'معدنية'));
    }

    // 20 - Night
    final night = ['01_moon','02_crescent','03_full_moon','04_half_moon','05_starry_night','06_night_sky','07_night_cloud','08_night_star','09_night_planet','10_night_galaxy','11_night_comet','12_night_meteor','13_night_aurora','14_night_eclipse','15_night_constellation','16_night_nebula','17_night_black_hole','18_night_supernova','19_night_milky_way','20_night_universe'];
    for (var n in night) {
      shapes.add(ShapeItem(name: n, path: 'assets/20_night/$n.png', category: 'ليلية'));
    }

    // 21 - Seasonal
    final seasonal = ['01_spring_flower','02_summer_sun','03_autumn_leaf','04_winter_snow','05_spring_rain','06_summer_heat','07_autumn_wind','08_winter_ice','09_spring_blossom','10_summer_beach','11_autumn_harvest','12_winter_frost','13_spring_butterfly','14_summer_bird','15_autumn_squirrel','16_winter_bear','17_spring_lamb','18_summer_fish','19_autumn_fox','20_winter_owl'];
    for (var n in seasonal) {
      shapes.add(ShapeItem(name: n, path: 'assets/21_seasonal/$n.png', category: 'موسمية'));
    }

    // 22 - Alphabet
    final alpha = ['01_letter_a','02_letter_b','03_letter_c','04_letter_d','05_letter_e','06_letter_f','07_letter_g','08_letter_h','09_letter_i','10_letter_j','11_letter_k','12_letter_l','13_letter_m','14_letter_n','15_letter_o','16_letter_p','17_letter_q','18_letter_r','19_letter_s','20_letter_t'];
    for (var n in alpha) {
      shapes.add(ShapeItem(name: n, path: 'assets/22_alphabet_shapes/$n.png', category: 'حروف'));
    }

    // 23 - Special
    final special = ['01_infinity','02_spiral','03_helix','04_wave','05_pulse','06_heartbeat','07_fingerprint','08_dna','09_atom','10_molecule','11_orbit','12_planet','13_rocket','14_satellite','15_telescope','16_microscope','17_compass','18_clock','19_hourglass','20_key'];
    for (var n in special) {
      shapes.add(ShapeItem(name: n, path: 'assets/23_special_shapes/$n.png', category: 'خاصة'));
    }

    // 24 - Fantasy
    final fantasy = ['01_dragon','02_phoenix','03_unicorn','04_mermaid','05_fairy','06_wizard','07_witch','08_knight','09_king','10_queen','11_castle','12_tower','13_sword','14_shield','15_crown','16_throne','17_potion','18_spellbook','19_crystal_ball','20_magic_wand'];
    for (var n in fantasy) {
      shapes.add(ShapeItem(name: n, path: 'assets/24_fantasy/$n.png', category: 'خيالية'));
    }

    // 25 - Abstract
    final abstract = ['01_blob','02_splash','03_drop','04_bubble','05_foam','06_mist','07_fog','08_smoke','09_steam','10_cloud','11_wave','12_ripple','13_pulse','14_vibration','15_frequency','16_signal','17_wave_2','18_beam','19_ray','20_glow'];
    for (var n in abstract) {
      shapes.add(ShapeItem(name: n, path: 'assets/25_abstract/$n.png', category: 'مجردة'));
    }

    return shapes;
  }
}
