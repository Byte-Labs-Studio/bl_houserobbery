return {
    default = 'Low Apartment', -- if a house don't have a interior, we'll use this instead

    ["Low Apartment"] = {
        doorCoords = { x = 266.17, y = -1007.61, z = -101.01, w = 180.0 },
        iplPos = { x = 261.4586, y = -998.8196, z = -99.00863 },
        emptyChance = 15, -- chance that a spot will be empty

        alarm = {
            hash = `prop_ld_keypad_01`,
            position = { x = 345.3378, y = -1011.1, z = -98.7, w = 90.0 },
            chance = 0,
        },

        securityCamChance = 0, -- chance that a spot will have a security camera (meaning they need to wear a mask)

        objects = {
            {
                hash = `prop_toaster_02`,
                position = { x = 266.67, y = -995.32, z = -99.04 },
                rotation = { x = 0.0, y = 0.0, z = 0.0 },
                item = "toaster"
            },
            {
                hash = `prop_boombox_01`,
                position = { x = 263.36, y = -994.69, z = -98.8 },
                rotation = { x = 0.0, y = 0.0, z = 0.0 },
                item = "boombox"
            },
            {
                hash = `prop_tv_03`,
                position = { x = 256.73, y = -995.45, z = -98.86 },
                rotation = { x = 0.0, y = 0.0, z = 0.0 },
                item = "television1"
            },
            {
                hash = `prop_vcr_01`,
                position = { x = 256.67, y = -995.38, z = -99.31 },
                rotation = { x = 0.0, y = 0.0, z = 0.0 },
                item = "vcr"
            },
            {
                hash = `prop_tv_flat_03`,
                position = { x = 262.69, y = -1001.85, z = -99.29 },
                rotation = { x = 0.0, y = 0.0, z = 0.0 },
                item = "television2"
            },
            {
                hash = `prop_console_01`,
                position = { x = 263.29, y = -1001.85, z = -99.3 },
                rotation = { x = 0.0, y = 0.0, z = 0.0 },
                item = "console"
            },
            {
                hash = `prop_micro_02`,
                position = { x = 266.47, y = -944.72, z = -98.9 },
                rotation = { x = 0.0, y = 0.0, z = 0.0 },
                item = "microwave"
            },
            
        },
        spots = {
            {
                name = 'Stove',
                position = { x = 266, y = -996, z = -99.0, w = 0.0 },
                size = { x = 1.0, y = 1.0, z = 1.0 },
                lootTypes = {
                    "misc",
                    "food"
                }
            },
            {
                name = 'Fridge',
                position = { x = 266.26, y = -997.55, z = -99.0, w = 0.0 },
                size = { x = 1.0, y = 1.0, z = 2.0 },
                lootTypes = {
                    "misc",
                    "food"
                }
            },
            {
                name = 'Cabinets',
                position = { x = 263.84, y = -995.09, z = -99.0, w = 0.0 },
                size = { x = 2.0, y = 1.0, z = 2.0 },
                lootTypes = {
                    "misc",
                    "food",
                    "drugs"
                }
            },
            {
                name = 'Under Bed',
                position = { x = 262.55, y = -1004.15, z = -99.65, w = 0.0 },
                size = { x = 2.0, y = 1.5, z = 0.7 },
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
                position = { x = 256.75, y = -995.35, z = -99.15, w = 0.0 },
                size = { x = 1.1, y = 0.4, z = 1.2 },
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
                position = { x = 261.4, y = -1002.05, z = -99.45, w = 0.0 },
                size = { x = 1.0, y = 0.35, z = 0.9 },
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
                position = { x = 259.75, y = -1004.5, z = -98.8, w = 0.0 },
                size = { x = 1.25, y = 0.4, z = 1.95 },
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
        doorCoords = { x = 346.51, y = -1013.24, z = -99.2, w = 354.65 },
        iplPos = { x = 347.2686, y = -999.2955, z = -99.19622 },
        emptyChance = 10, -- chance that a spot will be empty

        alarm = {
            hash = `prop_ld_keypad_01`,
            position = { x = 345.3378, y = -1011.1, z = -98.7, w = 90.0 },
            chance = 0,
        },

        securityCamChance = 50, -- chance that a spot will have a security camera (meaning they need to wear a mask)

        objects = {
            {
                hash = `v_res_m_lampstand`,
                position = { x = 344.08, y = -993.74, z = -100.21 },
                rotation = { x = 0.0, y = 0.0, z = 0.0 },
                item = "floor_lamp"
            },
            {
                hash = `prop_coffee_mac_02`,
                position = { x = 342.77, y = -1004.03, z = -98.98 },
                rotation = { x = 0.0, y = 0.0, z = 180.0 },
                item = "coffee_machine",
            },
            {
                hash = `prop_toaster_01`,
                position = { x = 341.76, y = -1004.02, z = -99.09 },
                rotation = { x = 0.0, y = 0.0, z = 67.5 },
                item = "toaster",
            },
            {
                hash = `prop_wok`,
                position = { x = 344.83, y = -1003.0, z = -99.09 },
                rotation = { x = 0.0, y = 0.0, z = 47.5 },
                item = "wok",
            },
            {
                hash = `prop_micro_01`,
                position = { x = 344.85, y = -1002.04, z = -99.16 },
                rotation = { x = 0.0, y = 0.0, z = -85.0 },
                item = "microwave",
            },
            {
                hash = `v_res_m_lampstand`,
                position = { x = 352.36, y = -999.93, z = -100.21 },
                rotation = { x = 0.0, y = 0.0, z = 0.0 },
                item = "floor_lamp",
            },
            {
                hash = `prop_plant_int_03a`,
                position = { x = 352.69, y = -993.52, z = -100.21 },
                rotation = { x = 0.0, y = 0.0, z = 17.0 },
                item = "tall_plant_vase",
            },
            -- how you define cusotm objects
            -- {
            --     hash = `safe`,
            --     position = { x = 352.69, y = -993.52, z = -100.21 },
            --     rotation = { x = 0.0, y = 0.0, z = 17.0 },
            --     item = "safe",
            --     custom = true,
            --     chance = 1,
            -- },
        },
        spots = {
            {
                name = 'Cupboard',
                position = { x = 345.65, y = -1001.7, z = -99.75, w = 0.0 },
                size = { x = 0.6, y = 1.4, z = 1.0 },
                lootTypes = {
                    "materials",
                    "misc",
                    "trash"
                }
            },
            {
                name = 'Fridge',
                position = { x = 344.6, y = -1001.25, z = -99.2, w = 0.0 },
                size = { x = 0.6, y = 1.05, z = 1.95 },
                lootTypes = {
                    "food",
                    "materials",
                    "trash"
                }
            },
            {
                name = 'Stove',
                position = { x = 344.7, y = -1002.85, z = -99.7, w = 0.0 },
                size = { x = 0.6, y = 0.75, z = 1.05 },
                lootTypes = {
                    "food",
                    "trash"
                }
            },
            {
                name = 'Overhead Cabinet',
                position = { x = 345.0, y = -1003.05, z = -98.25, w = 0.0 },
                size = { x = 0.6, y = 2.55, z = 1.05 },
                lootTypes = {
                    "materials",
                    "food",
                    "misc",
                    "crime"
                }
            },
            {
                name = 'Counter',
                position = { x = 343.0, y = -1003.85, z = -99.7, w = 0.0 },
                size = { x = 2.85, y = 0.75, z = 1.0 },
                lootTypes = {
                    "materials",
                    "misc",
                    "food",
                    "crime"
                }
            },
            {
                name = 'Shelf',
                position = { x = 340.85, y = -1004.1, z = -99.0, w = 0.0 },
                size = { x = 1.1, y = 0.55, z = 2.75 },
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
                position = { x = 339.3, y = -1003.95, z = -99.8, w = 0.0 },
                size = { x = 0.7, y = 0.55, z = 0.85 },
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
                position = { x = 337.6, y = -998.4, z = -98.7, w = 0.0 },
                size = { x = 0.5, y = 0.75, z = 2.95 },
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
                position = { x = 337.6, y = -995.05, z = -98.7, w = 0.0 },
                size = { x = 0.5, y = 0.75, z = 2.95 },
                lootTypes = {
                    "materials",
                    "misc",
                    "crime",
                    "jewelry"
                }
            },
            {
                name = 'Bottom TV Shelf',
                position = { x = 337.6, y = -996.7, z = -99.85, w = 0.0 },
                size = { x = 0.55, y = 2.75, z = 0.6 },
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
                position = { x = 341.4, y = -996.15, z = -99.8, w = 0.0 },
                size = { x = 0.95, y = 1.6, z = 0.6 },
                lootTypes = {
                    "materials",
                    "jewelry",
                    "misc",
                    "crime",
                }
            },
            {
                name = 'Shelves',
                position = { x = 345.7, y = -997.05, z = -98.7, w = 0.0 },
                size = { x = 0.4, y = 1.35, z = 3.0 },
                lootTypes = {
                    "materials",
                    "misc",
                    "crime",
                    "jewelry"
                }
            },
            {
                name = 'Shelves',
                position = { x = 345.7, y = -994.5, z = -98.7, w = 0.0 },
                size = { x = 0.4, y = 1.35, z = 3.0 },
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
                position = { x = 345.7, y = -993.2, z = -98.7, w = 0.0 },
                size = { x = 0.4, y = 1.35, z = 3.0 },
                lootTypes = {
                    "materials",
                    "misc",
                    "crime",
                    "jewelry"
                }
            },
            {
                name = 'Bedroom Dresser',
                position = { x = 351.25, y = -1000.0, z = -99.65, w = 0.0 },
                size = { x = 1.45, y = 0.95, z = 1 },
                lootTypes = {
                    "materials",
                    "misc",
                    "clothing",
                    "jewelry"
                }
            },
            {
                name = 'Bedroom Chest',
                position = { x = 352.5, y = -998.8, z = -99.8, w = 0.0 },
                size = { x = 0.75, y = 1.1, z = 0.5 },
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
                position = { x = 350.7, y = -992.95, z = -99.0, w = 0.0 },
                size = { x = 2.2, y = 0.6, z = 2.0 },
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
                position = { x = 348.75, y = -994.85, z = -99.75, w = 0.0 },
                size = { x = 0.65, y = 0.65, z = 0.65 },
                lootTypes = {
                    "materials",
                    "misc",
                    "crime",
                    "drugs",
                    "weapons"
                }
            },
            {
                name = 'Bathroom Sink',
                position = { x = 346.8, y = -994.15, z = -99.55, w = 1.25 },
                size = { x = 0.45, y = 0.6, z = 0.65 },
                lootTypes = {
                    "materials",
                    "misc",
                    "crime",
                    "drugs"
                }
            }
        }
    },
    
    ["High Apartment"] = {
        doorCoords = { x = -758.22, y = 619.05, z = 144.14, w = 105.59 },
        iplPos = { x = -763.107, y = 615.906, z = 144.1401 },
        emptyChance = 10, -- chance that a spot will be empty

        alarm = {
            hash = `prop_ld_keypad_01`,
            position = { x = -758.8531494140625, y = 616.40771484375, z = 144.4819793701172, w = -144.7908172607422 },
            chance = 0,
        },

        securityCamChance = 80, -- chance that a spot will have a security camera (meaning they need to wear a mask)

        objects = {
            {
                hash = `prop_micro_02`,
                position = { x = -760.26, y = 608.83, z = 144.24 },
                rotation = { x = 0.0, y = 0.0, z = 0.0 },
                item = "microwave"
            },
            {
                hash = `prop_toaster_01`,
                position = { x = -757.09, y = 610.99, z = 144.23 },
                rotation = { x = 0.0, y = 0.0, z = 0.0 },
                item = "toaster"
            },
            {
                hash = `prop_bong_01`,
                position = { x = -772.62, y = 609.18, z = 143.2 },
                rotation = { x = 0.0, y = 0.0, z = 0.0 },
                item = "bong"
            },
            {
                hash = `prop_t_telescope_01b`,
                position = { x = -744.76, y = 604.73, z = 143.33 },
                rotation = { x = 0.0, y = 0.0, z = 0.0 },
                item = "telescope"
            },
            {
                hash = `prop_mp3_dock`,
                position = { x = -772.98, y = 614.06, z = 140.29 },
                rotation = { x = 0.0, y = 0.0, z = 0.0 },
                item = "boombox"
            },
            {
                hash = `prop_printer_01`,
                position = { x = -767.06, y = 619.23, z = 136.26 },
                rotation = { x = 0.0, y = 0.0, z = 0.0 },
                item = "printer"
            },
            {
                hash = `prop_laptop_01a`,
                position = { x = -765.27, y = 613.56, z = 136.25 },
                rotation = { x = 0.0, y = 0.0, z = 0.0 },
                item = "laptop"
            },
            {
                hash = `v_res_mm_audio`,
                position = { x = -760.29, y = 614.13, z = 136.25 },
                rotation = { x = 0.0, y = 0.0, z = 0.0 },
                item = "radio"
            },
            {
                hash = `prop_npc_phone`,
                position = { x = -772.44, y = 614.24, z = 143.77 },
                rotation = { x = 0.0, y = 0.0, z = 0.0 },
                item = "phone"
            },
        },
        spots = {
            {
                name = 'Living Room Cabinet',
                position = { x = -773.0, y = -1001.7, z = -99.75, w = 0.0 },
                size = { x = 1.8, y = 1, z = 0.6 },
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
                position = { x = -771.65, y = 605.05, z = 143.15, w = 19.0 },
                size = { x = 2.65, y = 0.35, z = 0.65 },
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
                position = { x = -768.55, y = 608.35, z = 143.4, w = 19.0 },
                size = { x = 2.65, y = 0.35, z = 0.65 },
                lootTypes = {
                    "materials",
                    "misc",
                    "crime",
                }
            },
            {
                name = 'Living Room Books',
                position = { x = -768.2, y = 606.75, z = 144.25, w = 17.0 },
                size = { x = 0.25, y = 0.75, z = 0.5 },
                lootTypes = {
                    "materials",
                    "misc",
                    "crime",
                }
            },
            {
                name = 'Dining Room Cabinet',
                position = { x = -768.9, y = 615.5, z = 143.45, w = 18.75 },
                size = { x = 3.0, y = 1, z = 0.65 },
                lootTypes = {
                    "materials",
                    "food",
                    "crime",
                }
            },
            {
                name = 'Kitchen Cabinet',
                position = { x = -758.6, y = 609.35, z = 143.7, w = 19.5 },
                size = { x = 0.8, y = 0.9, z = 0.8 },
                lootTypes = {
                    "materials",
                    "food",
                    "crime",
                }
            },
            {
                name = 'Kitchen Cabinet2',
                position = { x = -761.0, y = 610.9, z = 143.7, w = 32.0 },
                size = { x = 0.5, y = 0.9, z = 0.8 },
                lootTypes = {
                    "materials",
                    "food", 
                    "crime",
                }
            },
            {
                name = 'Kitchen Fridge',
                position = { x = -758.8, y = 615.05, z = 144.55, w = 17.25 },
                size = { x = 1, y = 1.75, z = 2.55 },
                lootTypes = {
                    "materials",
                    "food",
                    "crime",
                }
            },
            {
                name = 'Bedroom Table',
                position = { x = -773.55, y = 613.85, z = 139.95, w = 18.5 },
                size = { x = 2.85, y = 0.7, z = 0.65 },
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
                position = { x = -769.15, y = 605.7, z = 139.8, w = 19.0 },
                size = { x = 2.85, y = 0.7, z = 0.65 },
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
                position = { x = -765.95, y = 611.45, z = 139.75, w = 18.75 },
                size = { x = 1.0, y = 2.25, z = 0.7 },
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
                position = { x = -758.5, y = 610.6, z = 139.75, w = 19.25 },
                size = { x = 1.0, y = 2.55, z = 0.6 },
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
                position = { x = -761.2, y = 619.1, z = 136.1, w = 18.5 },
                size = { x = 1.4, y = 2.4, z = 0.8 },
                lootTypes = {
                    "misc",
                    "high_criminal",
                    "materials",
                    "drugs",
                }
            },
            {
                name = 'Office Shelf',
                position = { x = -764.45, y = 620.9, z = 137.05, w = 18.5 },
                size = { x = 1.5, y = 1, z = 0.8 },
                lootTypes = {
                    "materials",
                    "misc",
                    "high_criminal",
                    "drugs",
                }
            },
            {
                name = 'Office Desk',
                position = { x = -765.2, y = 613.7, z = 136.0, w = 18.5 },
                size = { x = 1, y = 1.2, z = 0.7 },
                lootTypes = {
                    "misc",
                    "crime",
                    "high_criminal",
                    "drugs",
                }
            },
            {
                name = 'Hallway Table',
                position = { x = -754.5, y = 618.15, z = 136.2, w = 18.5 },
                size = { x = 1.1, y = 2.0, z = 1.1 },
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
                position = { x = -760.9, y = 618.9, z = 136.75, w = 19.0 },
                size = { x = 0.75, y = 1.2, z = 2.25 },
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