return {
    ["Low Apartment"] = {
        doorCoords = vec4(266.17, -1007.61, -101.01, 180.0),
        iplPos = vec3(261.4586, -998.8196, -99.00863),
        alarm = {
            model = `prop_phone_proto`,
            position = vector4(264.14, -1002.76, -98.51, 90.0),
            chance = 0,
        },
        ghost = vector4(263.63, -996.22, -99.01, 186.71),
        peds = {
            {
                chance = 100,
                model = `a_f_m_tramp_01`,
                weapon = `WEAPON_PISTOL`,
                coords = vector4(260.38, -996.58, -99.01, 100.07),
                anim = {
                    dict = 'switch@franklin@stripclub',
                    name = '002113_02_fras_15_stripclub_idle'
                }
            }
        },
        electricityBox = {
            model = `m23_1_prop_m31_controlpanel_02a`,
            position = vector4(255.92, -998.28, -98.01, 92.08),
            animation = {
                dict = 'basegame',
                name = 'work_base'
            }
        },
        securityCamChance = 0, -- chance that a spot will have a security camera (meaning they need to wear a mask)
        objects = {
            {
                model = `prop_toaster_02`, -- model that will spawn
                -- defaultModel = `prop_toaster_02`, -- model that exist on mlo by default, we need this to delete it, use it if you using diff model
                position = vec3(266.37, -995.32, -99.04),
                carry = true, -- if you want to carry it
                item = "toaster",
                anim = {
                    dict = 'missmechanic',
                    name = 'work2_base'
                }
            },
            {
                model = `prop_boombox_01`,
                position = vec3(263.36, -994.69, -98.8),
                item = "boombox"
            },
            {
                model = `prop_tv_03`,
                position = vec4(256.73, -995.45, -98.86, 45.74),
                item = "television1"
            },
            {
                model = `prop_vcr_01`,
                position = vec4(256.67, -995.38, -99.31, 45.74),
                item = "vcr"
            },
            {
                model = `prop_tv_flat_03`,
                position = vec3(262.69, -1001.85, -99.29),
                item = "television2"
            },
            {
                model = `prop_console_01`,
                position = vec3(263.29, -1001.85, -99.3),
                item = "console"
            },
            {
                model = `prop_micro_02`,
                position = vec3(266.47, -944.72, -98.9),
                item = "microwave"
            },
        },
        spots = {
            {
                name = 'Stove',
                position = vec4(266, -996, -99.0, 0.0),
                size = vec3(1.0, 1.0, 1.0),
                lootTypes = {
                    "misc",
                    "food"
                }
            },
            {
                name = 'Fridge',
                position = vec4(266.26, -997.55, -99.0, 0.0),
                size = vec3(1.0, 1.0, 2.0),
                lootTypes = {
                    "misc",
                    "food"
                }
            },
            {
                name = 'Cabinets',
                position = vec4(263.84, -995.09, -99.0, 0.0),
                size = vec3(2.0, 1.0, 2.0),
                lootTypes = {
                    "misc",
                    "food",
                    "drugs"
                }
            },
            {
                name = 'Under Bed',
                position = vec4(262.55, -1004.15, -99.65, 0.0),
                size = vec3(2.0, 1.5, 0.7),
                lootTypes = {
                    "misc",
                    "food",
                    "drugs",
                    "weapons",
                    "crime"
                }
            },
            {
                name = 'TV Stand',
                position = vec4(256.75, -995.35, -99.15, 0.0),
                size = vec3(1.1, 0.4, 1.2),
                lootTypes = {
                    "misc",
                    "food",
                    "drugs",
                    "weapons",
                    "crime"
                }
            },
            {
                name = 'Bedroom Dresser',
                position = vec4(261.4, -1002.05, -99.45, 0.0),
                size = vec3(1.0, 0.35, 0.9),
                lootTypes = {
                    "misc",
                    "food",
                    "drugs",
                    "weapons",
                    "crime"
                }
            },
            {
                name = 'Bedroom Closet',
                position = vec4(259.75, -1004.5, -98.8, 0.0),
                size = vec3(1.25, 0.4, 1.95),
                lootTypes = {
                    "misc",
                    "food",
                    "drugs",
                    "weapons",
                    "crime"
                }
            },
        }
    },

    ["Mid Apartment"] = {
        doorCoords = vector4(346.51, -1013.24, -99.2, 354.65),
        iplPos = vector3(347.2686, -999.2955, -99.19622),
        alarm = {
            model = `prop_ld_keypad_01`,
            position = vector4(345.3378, -1011.1, -98.7, 90.0),
            chance = 0,
        },

        securityCamChance = 50, -- chance that a spot will have a security camera (meaning they need to wear a mask)

        objects = {
            {
                model = `v_res_m_lampstand`,
                position = vector3(344.08, -993.74, -100.21),
                rotation = vector3(0.0, 0.0, 0.0),
                item = "floor_lamp"
            },
            {
                model = `prop_coffee_mac_02`,
                position = vector3(342.77, -1004.03, -98.98),
                rotation = vector3(0.0, 0.0, 180.0),
                item = "coffee_machine",
            },
            {
                model = `prop_toaster_01`,
                position = vector3(341.76, -1004.02, -99.09),
                rotation = vector3(0.0, 0.0, 67.5),
                item = "toaster",
            },
            {
                model = `prop_wok`,
                position = vector3(344.83, -1003.0, -99.09),
                rotation = vector3(0.0, 0.0, 47.5),
                item = "wok",
            },
            {
                model = `prop_micro_01`,
                position = vector3(344.85, -1002.04, -99.16),
                rotation = vector3(0.0, 0.0, -85.0),
                item = "microwave",
            },
            {
                model = `v_res_m_lampstand`,
                position = vector3(352.36, -999.93, -100.21),
                rotation = vector3(0.0, 0.0, 0.0),
                item = "floor_lamp",
            },
            {
                model = `prop_plant_int_03a`,
                position = vector3(352.69, -993.52, -100.21),
                rotation = vector3(0.0, 0.0, 17.0),
                item = "tall_plant_vase",
            },
        },
        spots = {
            {
                name = 'Cupboard',
                position = vector4(345.65, -1001.7, -99.75, 0.0),
                size = vector3(0.6, 1.4, 1.0),
                lootTypes = {
                    "materials",
                    "misc",
                    "trash"
                }
            },
            {
                name = 'Fridge',
                position = vector4(344.6, -1001.25, -99.2, 0.0),
                size = vector3(0.6, 1.05, 1.95),
                lootTypes = {
                    "food",
                    "materials",
                    "trash"
                }
            },
            {
                name = 'Stove',
                position = vector4(344.7, -1002.85, -99.7, 0.0),
                size = vector3(0.6, 0.75, 1.05),
                lootTypes = {
                    "food",
                    "trash"
                }
            },
            {
                name = 'Overhead Cabinet',
                position = vector4(345.0, -1003.05, -98.25, 0.0),
                size = vector3(0.6, 2.55, 1.05),
                lootTypes = {
                    "materials",
                    "food",
                    "misc",
                    "crime"
                }
            },
            {
                name = 'Counter',
                position = vector4(343.0, -1003.85, -99.7, 0.0),
                size = vector3(2.85, 0.75, 1.0),
                lootTypes = {
                    "materials",
                    "misc",
                    "food",
                    "crime"
                }
            },
            {
                name = 'Shelf',
                position = vector4(340.85, -1004.1, -99.0, 0.0),
                size = vector3(1.1, 0.55, 2.75),
                lootTypes = {
                    "materials",
                    "misc",
                    "drugs",
                    "crime",
                    "jewelry"
                }
            },
            {
                name = 'Small Drawer',
                position = vector4(339.3, -1003.95, -99.8, 0.0),
                size = vector3(0.7, 0.55, 0.85),
                lootTypes = {
                    "materials",
                    "misc",
                    "food",
                    "clothing",
                    "crime"
                }
            },
            {
                name = 'Left TV Shelf',
                position = vector4(337.6, -998.4, -98.7, 0.0),
                size = vector3(0.5, 0.75, 2.95),
                lootTypes = {
                    "materials",
                    "misc",
                    "crime",
                    "drugs",
                    "jewelry"
                }
            },
            {
                name = 'Right TV Shelf',
                position = vector4(337.6, -995.05, -98.7, 0.0),
                size = vector3(0.5, 0.75, 2.95),
                lootTypes = {
                    "materials",
                    "misc",
                    "crime",
                    "jewelry"
                }
            },
            {
                name = 'Bottom TV Shelf',
                position = vector4(337.6, -996.7, -99.85, 0.0),
                size = vector3(0.55, 2.75, 0.6),
                lootTypes = {
                    "materials",
                    "misc",
                    "crime",
                    "drugs",
                    "jewelry"
                }
            },
            {
                name = 'Coffee Table',
                position = vector4(341.4, -996.15, -99.8, 0.0),
                size = vector3(0.95, 1.6, 0.6),
                lootTypes = {
                    "materials",
                    "jewelry",
                    "misc",
                    "crime",
                }
            },
            {
                name = 'Shelves',
                position = vector4(345.7, -997.05, -98.7, 0.0),
                size = vector3(0.4, 1.35, 3.0),
                lootTypes = {
                    "materials",
                    "misc",
                    "crime",
                    "jewelry"
                }
            },
            {
                name = 'Shelves',
                position = vector4(345.7, -994.5, -98.7, 0.0),
                size = vector3(0.4, 1.35, 3.0),
                lootTypes = {
                    "materials",
                    "misc",
                    "crime",
                    "drugs",
                    "jewelry"
                }
            },
            {
                name = 'Shelves',
                position = vector4(345.7, -993.2, -98.7, 0.0),
                size = vector3(0.4, 1.35, 3.0),
                lootTypes = {
                    "materials",
                    "misc",
                    "crime",
                    "jewelry"
                }
            },
            {
                name = 'Bedroom Dresser',
                position = vector4(351.25, -1000.0, -99.65, 0.0),
                size = vector3(1.45, 0.95, 1),
                lootTypes = {
                    "materials",
                    "misc",
                    "clothing",
                    "jewelry"
                }
            },
            {
                name = 'Bedroom Chest',
                position = vector4(352.5, -998.8, -99.8, 0.0),
                size = vector3(0.75, 1.1, 0.5),
                lootTypes = {
                    "jewelry",
                    "misc",
                    "drugs",
                    "crime",
                    "weapons"
                }
            },
            {
                name = 'Bedroom Closet',
                position = vector4(350.7, -992.95, -99.0, 0.0),
                size = vector3(2.2, 0.6, 2.0),
                lootTypes = {
                    "materials",
                    "misc",
                    "clothing",
                    "crime",
                    "drugs"
                }
            },
            {
                name = 'Bedroom Side Table',
                position = vector4(348.75, -995.55, -99.75, 0.0),
                size = vector3(0.7, 0.75, 0.55),
                lootTypes = {
                    "materials",
                    "misc",
                    "crime",
                    "drugs"
                }
            },
        }
    },

    ["High Apartment"] = {
        doorCoords = vec4(-758.22, 619.05, 144.14, 105.59),
        iplPos = vec3(-763.107, 615.906, 144.1401),
        alarm = {
            model = `prop_ld_keypad_01`,
            position = vec4(-758.8531494140625, 616.40771484375, 144.4819793701172, -144.7908172607422),
            chance = 0,
        },

        securityCamChance = 80, -- chance that a spot will have a security camera (meaning they need to wear a mask)

        objects = {
            {
                model = `prop_micro_02`,
                position = vec3(-760.26, 608.83, 144.24),
                rotation = vec3(0.0, 0.0, 0.0),
                item = "microwave"
            },
            {
                model = `prop_toaster_01`,
                position = vec3(-757.09, 610.99, 144.23),
                rotation = vec3(0.0, 0.0, 0.0),
                item = "toaster"
            },
            {
                model = `prop_bong_01`,
                position = vec3(-772.62, 609.18, 143.2),
                rotation = vec3(0.0, 0.0, 0.0),
                item = "bong"
            },
            {
                model = `prop_t_telescope_01b`,
                position = vec3(-744.76, 604.73, 143.33),
                rotation = vec3(0.0, 0.0, 0.0),
                item = "telescope"
            },
            {
                model = `prop_mp3_dock`,
                position = vec3(-772.98, 614.06, 140.29),
                rotation = vec3(0.0, 0.0, 0.0),
                item = "boombox"
            },
            {
                model = `prop_printer_01`,
                position = vec3(-767.06, 619.23, 136.26),
                rotation = vec3(0.0, 0.0, 0.0),
                item = "printer"
            },
            {
                model = `prop_laptop_01a`,
                position = vec3(-765.27, 613.56, 136.25),
                rotation = vec3(0.0, 0.0, 0.0),
                item = "laptop"
            },
            {
                model = `v_res_mm_audio`,
                position = vec3(-760.29, 614.13, 136.25),
                rotation = vec3(0.0, 0.0, 0.0),
                item = "radio"
            },
            {
                model = `prop_npc_phone`,
                position = vec3(-772.44, 614.24, 143.77),
                rotation = vec3(0.0, 0.0, 0.0),
                item = "phone"
            },
        },
        spots = {
            {
                name = 'Living Room Cabinet',
                position = vec4(-773.0, -1001.7, -99.75, 0.0),
                size = vec3(1.8, 1, 0.6),
                lootTypes = {
                    "materials",
                    "misc",
                    "crime",
                    "drugs",
                    "jewelry"
                }
            },
            {
                name = 'Living Room TV Stand',
                position = vec4(-771.65, 605.05, 143.15, 19.0),
                size = vec3(2.65, 0.35, 0.65),
                lootTypes = {
                    "materials",
                    "misc",
                    "crime",
                    "drugs",
                    "jewelry"
                }
            },
            {
                name = 'Living Room Books',
                position = vec4(-768.55, 608.35, 143.4, 19.0),
                size = vec3(2.65, 0.35, 0.65),
                lootTypes = {
                    "materials",
                    "misc",
                    "crime",
                }
            },
            {
                name = 'Living Room Books',
                position = vec4(-768.2, 606.75, 144.25, 17.0),
                size = vec3(0.25, 0.75, 0.5),
                lootTypes = {
                    "materials",
                    "misc",
                    "crime",
                }
            },
            {
                name = 'Dining Room Cabinet',
                position = vec4(-768.9, 615.5, 143.45, 18.75),
                size = vec3(3.0, 1, 0.65),
                lootTypes = {
                    "materials",
                    "food",
                    "crime",
                }
            },
            {
                name = 'Kitchen Cabinet',
                position = vec4(-758.6, 609.35, 143.7, 19.5),
                size = vec3(0.8, 0.9, 0.8),
                lootTypes = {
                    "materials",
                    "food",
                    "crime",
                }
            },
            {
                name = 'Kitchen Cabinet2',
                position = vec4(-761.0, 610.9, 143.7, 32.0),
                size = vec3(0.5, 0.9, 0.8),
                lootTypes = {
                    "materials",
                    "food",
                    "crime",
                }
            },
            {
                name = 'Kitchen Fridge',
                position = vec4(-758.8, 615.05, 144.55, 17.25),
                size = vec3(1, 1.75, 2.55),
                lootTypes = {
                    "materials",
                    "food",
                    "crime",
                }
            },
            {
                name = 'Bedroom Table',
                position = vec4(-773.55, 613.85, 139.95, 18.5),
                size = vec3(2.85, 0.7, 0.65),
                lootTypes = {
                    "materials",
                    "misc",
                    "crime",
                    "drugs",
                    "jewelry"
                }
            },
            {
                name = 'Bedroom Side Table',
                position = vec4(-769.15, 605.7, 139.8, 19.0),
                size = vec3(2.85, 0.7, 0.65),
                lootTypes = {
                    "materials",
                    "misc",
                    "crime",
                    "drugs",
                    "jewelry"
                }
            },
            {
                name = 'Bedroom Closet',
                position = vec4(-765.95, 611.45, 139.75, 18.75),
                size = vec3(1.0, 2.25, 0.7),
                lootTypes = {
                    "clothing",
                    "misc",
                    "crime",
                    "drugs",
                    "jewelry"
                }
            },
            {
                name = 'Bathroom Cabinet',
                position = vec4(-758.5, 610.6, 139.75, 19.25),
                size = vec3(1.0, 2.55, 0.6),
                lootTypes = {
                    "materials",
                    "misc",
                    "crime",
                    "trash",
                    "drugs",
                    "jewelry"
                }
            },
            {
                name = 'Office Shelf',
                position = vec4(-761.2, 619.1, 136.1, 18.5),
                size = vec3(1.4, 2.4, 0.8),
                lootTypes = {
                    "misc",
                    "high_criminal",
                    "materials",
                    "drugs",
                }
            },
            {
                name = 'Office Shelf',
                position = vec4(-764.45, 620.9, 137.05, 18.5),
                size = vec3(1.5, 1, 0.8),
                lootTypes = {
                    "materials",
                    "misc",
                    "high_criminal",
                    "drugs",
                }
            },
            {
                name = 'Office Desk',
                position = vec4(-765.2, 613.7, 136.0, 18.5),
                size = vec3(1, 1.2, 0.7),
                lootTypes = {
                    "misc",
                    "crime",
                    "high_criminal",
                    "drugs",
                }
            },
            {
                name = 'Hallway Table',
                position = vec4(-754.5, 618.15, 136.2, 18.5),
                size = vec3(1.1, 2.0, 1.1),
                lootTypes = {
                    "materials",
                    "misc",
                    "crime",
                    "trash",
                    "drugs",
                    "jewelry"
                }
            },
            {
                name = 'Hallway Vases',
                position = vec4(-760.9, 618.9, 136.75, 19.0),
                size = vec3(0.75, 1.2, 2.25),
                lootTypes = {
                    "materials",
                    "misc",
                    "crime",
                    "trash",
                    "drugs",
                    "jewelry"
                }
            }
        }
    },
}
