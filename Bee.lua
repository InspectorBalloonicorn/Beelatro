--- STEAMODDED HEADER
--- MOD_NAME: Beelatro
--- MOD_ID: Beelatro
--- MOD_AUTHOR: [InspectorB and MarioFan597]
--- MOD_DESCRIPTION: This Mod adds BEES!
--- PREFIX: bee
--- BADGE_COLOUR: 708b91
--- DEPENDENCIES:Cryptid>=0.5.3<=0.5.5
--- VERSION: 0.9.2

----------------------------------------------
------------MOD CODE -------------------------
---
---
---
local Global_Cap = 1000000
local lastBeeCount = nil  -- Initialize to nil to detect first-time calls
math.randomseed(os.time() + os.clock() * 100000)

function GetBees()
	local beeCount = 0
	if G.jokers ~= nil then
		for i = 1, #G.jokers.cards do
			if 
				G.jokers.cards[i]:bonus_bees() > 0 and not G.jokers.cards[i].debuff
			then
				beeCount = beeCount + G.jokers.cards[i]:bonus_bees()
			elseif
				G.jokers.cards[i]:is_bee() and not G.jokers.cards[i].debuff
			then
				beeCount = beeCount + 1
			end
		end
	end
	
	return beeCount
end

function beeCountChangedPositive()
	local beeCount = GetBees()
	if lastBeeCount == nil or lastBeeCount < beeCount then
		lastBeeCount = beeCount  -- Update lastBeeCount only when there's a change
		return true
	end
	return false
end

function beeCountChangedNegative()
	local beeCount = GetBees()
	if lastBeeCount == nil or lastBeeCount > beeCount then
		lastBeeCount = beeCount  -- Update lastBeeCount only when there's a change
		return true
	end
	return false
end

local function pickNewWord(card)
	local word_list = { "BUG", "BUZZ", "BEE", "BOOP", "BANANA", "BALATRO"}
	card.ability.extra.word = word_list[math.random(#word_list)]
	card.ability.extra.progress = ""
end

function HasMaximized()
	local has_maximized = false
	for i = 1, #G.jokers.cards do
		if G.jokers.cards[i].config.center_key == "j_cry_maximized" then
			has_maximized = true
		end
	end
	return has_maximized
end

function Card:is_bee()
	local check = false

	--self.ability.extra ~= nil and 
	if (not is_number(self.ability.extra) and self.ability.extra ~= nil and self.ability.extra.bee) or self.ability.bee_apian == true then
		check = true
	return check

	end
end

function Card:bonus_bees()
	if (not is_number(self.ability.extra) and self.ability.extra ~= nil and self.ability.extra.total_bees) then
		return self.ability.extra.total_bees
	else
		return 0
	end
end

function Get_random_bee_card()

	if math.random(2) ~= 1 then --1 in 2 chance to use primary generation
    	-- Define standard cards (each appears once per cycle)
    	local bee_cards = {
        	"j_bee_jimbee", "j_bee_ctrlplusbee", "j_bee_beebeedagger", "j_bee_spellingbee",
        	"j_bee_ballofbees", "j_bee_kingbee", "j_bee_beehive", "j_bee_jollybee",
        	"j_bee_bigbee", "j_bee_larva", "j_bee_honeycomb", 
        	"j_bee_honeypot", "j_bee_nostalgic_jimbee", "j_bee_twobee",
			"j_bee_bottleobees"
    	}

    	-- Define rare cards with their individual frequency (1 in X cycles)
    	local rare_cards = {
			{name = "j_bee_weebee", chance = 3},
        	{name = "j_bee_beesknees", chance = 3},
        	{name = "j_bee_queenbee", chance = 3},
			{name = "j_bee_grim_queen", chance = 3},
			{name = "j_bee_buzzkill", chance = 3},
        	{name = "j_bee_hivemind", chance = 5},
        	{name = "j_bee_benson", chance = 100}
    	}

    	-- Check if the player has a Showman Joker
    	local has_showman = next(find_joker("Showman")) ~= nil

    	-- Function to check if a card is already in the player's hand
    	local function is_in_hand(card_name)
        	for _, card in ipairs(G.jokers.cards) do
            	if card and card.key == card_name then
                	return true
            	end
        	end
        	return false
    	end

    	-- Generate a fresh pool of Bee Jokers every time the function is called
    	local available_bee_cards = {}

    	-- Add standard cards if they haven't been used or held (unless Showman exists)
    	for _, card in ipairs(bee_cards) do
        	if has_showman or (not G.GAME.used_jokers[card] and not is_in_hand(card)) then
            	table.insert(available_bee_cards, card)
        	end
    	end

    	-- Add rare cards with their probability
    	for _, rare in ipairs(rare_cards) do
        	if math.random(rare.chance) == 1 then
            	if has_showman or (not G.GAME.used_jokers[rare.name] and not is_in_hand(rare.name)) then
                	table.insert(available_bee_cards, rare.name)
            	end
        	end
    	end

    	-- Ensure there is at least one card in the pool
    	if #available_bee_cards == 0 then
        	for _, card in ipairs(bee_cards) do
            	table.insert(available_bee_cards, card)
        	end
    	end

   	 	-- Shuffle the available cards
  		for i = #available_bee_cards, 2, -1 do
     	   local j = math.random(i)
     	   available_bee_cards[i], available_bee_cards[j] = available_bee_cards[j], available_bee_cards[i]
   		end

   		 -- Select a random card
   	 	local chosen_card = available_bee_cards[1]

    	return create_card(nil, G.pack_cards, nil, nil, true, true, chosen_card, nil)

	else -- 1 in 2 chance to use this side generation
		card = create_card("Joker", G.pack_cards, nil, nil, true, true, nil, nil)
		if not card:is_bee() then
			card.ability.bee_apian = true
			return card
		else
			return card
		end
	end
end

----------Defining Atlases------------------
SMODS.Atlas {
	key = "beeatlas",
	path = "beeatlas.png",
	px = 71,
	py = 95
}

SMODS.Atlas {
	key = "beeatlas2",
	path = "beeatlas2.png",
	px = 71,
	py = 95
}

SMODS.Atlas{
	key = "honeydrop",
	path = "honeydrop.png",
	px = 71,
	py = 95
}

SMODS.Atlas{
	key = "bottleobees",
	path = "bottleobees.png",
	px = 71,
	py = 95
}

SMODS.Atlas {
	key = "beepackatlas",
	path = "beepackatlas.png",
	px = 71,
	py = 95
}

SMODS.Atlas {
	key = "beemiscatlas",
	path = "beemiscatlas.png",
	px = 71,
	py = 95
}

SMODS.Atlas {
	key = "modicon",
	path = "modicon.png",
	px = 34,
	py = 34
}

SMODS.Atlas {
	key = "beestickeratlas",
	path = "beesticker.png",
	px = 71,
	py = 95
}

SMODS.Atlas {
	key = "beeblindatlas",
	path = "beeblinds.png",
	atlas_table = "ANIMATION_ATLAS",
	frames = 21,
	px = 34,
	py = 34
}

----------Defining Sounds------------------

SMODS.Sound{
	key = "e_striped",
	path = "e_striped.ogg"
}

----------Defining Blinds------------------
SMODS.Blind{
	key = "smoker",
	atlas = "beeblindatlas",    
	pos = { x = 0, y = 0 },
	boss_colour = HEX("cac2b1"),
	boss = {
		min = 1,
		max = 10,
	},
	recalc_debuff = function(self, card, from_blind)
		if (card.area == G.jokers) and not G.GAME.blind.disabled and card:is_bee() == true then --card.is_bee()
			return true
		end
		return false
	end,
}

----------Defining Shaders and Editions------------------
SMODS.Shader{ key = 'striped', path = 'striped.fs' }

SMODS.Edition{
	key = "striped",
	config = { extra = {values = 1.4, scale = 0.4, chips = 0, mult = 0} },
    discovered = true,
    unlocked = true,
    shader = 'striped',
    in_shop = true,
    weight = 15,
    extra_cost = 4,
    apply_to_float = true,
	sound = {
		sound = "bee_e_striped",
		per = 1,
		vol = 0.7,
	},
	loc_vars = function(self, info_queue, card)
		return { vars = {self.config.extra.values, self.config.extra.scale, self.config.extra.chips, self.config.extra.mult} }
	end,
	get_weight = function(self)
 		return G.GAME.edition_rate * self.weight
 	end,
	--  on_apply = function(card)
	-- 	local beeCount = GetBees()
	-- 	card.values = 1 + (0.4 * (beeCount + 1))
	
	-- 	Cryptid.with_deck_effects(card, function(card)
	-- 		Cryptid.misprintize(card, {
	-- 			min = card.values,
	-- 			max = card.values,
	-- 		}, nil, true)
	-- 	end)
	
	-- 	card.ability.bee_striped = true
	-- end,
	-- on_remove = function(card)
	-- 	Cryptid.with_deck_effects(card, function(card)
	-- 		Cryptid.misprintize(card, { min = 1, max = 1 }, true)
	-- 		Cryptid.misprintize(card) 
	-- 	end)
	-- 	card.ability.bee_striped = nil
	-- 	card.last_applied_mult = nil
	-- end,
	calculate = function(self, card, context)
		-- if beeCountChangedPositive() or beeCountChangedNegative() then
			
		-- end
		if
			(
				context.edition -- for when on jonklers
				and context.cardarea == G.jokers -- checks if should trigger
				and card.config.trigger -- fixes double trigger
			) or (
				context.main_scoring -- for when on playing cards
				and context.cardarea == G.play
			)
		then
			local beeCount = GetBees()
			self.config.extra.values = card.values
			self.config.extra.chips = 0
			self.config.extra.mult = 0
			local isChips = false
			

			for i = 1, beeCount do
				local randomcheck = (math.random() < 0.5)
			
				-- Only increase chips if we haven't hit the cap
				if randomcheck and self.config.extra.chips < 100 then
					self.config.extra.chips = self.config.extra.chips + 20
			
				-- Only increase mult if we haven't hit the cap
				elseif self.config.extra.mult < 20 then
					self.config.extra.mult = self.config.extra.mult + 4
				end
			end
			

			--Caps for chips and mult... just in case
			if self.config.extra.chips > 100 then 
				self.config.extra.chips = 100
			end

			if self.config.extra.mult > 20 then
				self.config.extra.mult = 20
			end

			if (self.config.extra.mult > 0 and self.config.extra.chips > 0) then
				return { 
					mult = self.config.extra.mult,
					chips = self.config.extra.chips,
				}
			elseif (self.config.extra.mult == 0 and self.config.extra.chips > 0) then
				return { 
					chips = self.config.extra.chips
				}
			elseif (self.config.extra.mult > 0 and self.config.extra.chips == 0) then
				return {
					mult = self.config.extra.mult
				}
			end
		end
		if context.joker_main then
			card.config.trigger = true -- context.edition triggers twice, this makes it only trigger once (only for jonklers)
		end

		if context.after then
			card.config.trigger = nil
		end
	end
}



----------Defining Boosterpacks------------------
SMODS.Booster {
	key = "normal_pack",
	kind = "Bee",
	atlas = "beepackatlas",
	pos = { x = 0, y = 0 },
	order = 5,
	config = { choose = 1, extra = 2 },
	cost = 4,
	weight = 2 * (0.5), 
	create_card = function(self, card)
		return Get_random_bee_card()
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
	group_key = "k_bee_pack",
	cry_credits = {
		idea = {
			"Inspector_B",
		},
		art = {
			"MarioFan597",
		},
		code = {
			"Inspector_B",
		},
	},
}

SMODS.Booster {
	key = "alt_pack",
	kind = "Bee",
	atlas = "beepackatlas",
	pos = { x = 0, y = 1 },
	order = 5,
	config = { choose = 1, extra = 2 },
	cost = 4,
	weight = 2 * (0.5), 
	create_card = function(self, card)
		return Get_random_bee_card()
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
	group_key = "k_bee_pack",
	cry_credits = {
		idea = {
			"Inspector_B",
		},
		art = {
			"MarioFan597",
		},
		code = {
			"Inspector_B",
		},
	},
}

SMODS.Booster {
	key = "jumbo_pack",
	kind = "Bee",
	atlas = "beepackatlas",
	pos = { x = 1, y = 0 },
	order = 6,
	config = { choose = 1, extra = 4 },
	cost = 6,
	weight = 2 * (0.4), 
	create_card = function(self, card)
		return Get_random_bee_card()
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
	group_key = "k_bee_pack",
	cry_credits = {
		idea = {
			"Inspector_B",
		},
		art = {
			"MarioFan597",
		},
		code = {
			"Inspector_B",
		},
	},
}

SMODS.Booster {
	key = "mega_pack",
	kind = "Bee",
	atlas = "beepackatlas",
	pos = { x = 2, y = 0 },
	order = 7,
	config = { choose = 2, extra = 5 },
	cost = 8,
	weight = 2 * (0.3), 
	create_card = function(self, card)
		return Get_random_bee_card()
	end,
	loc_vars = function(self, info_queue, card)
		return { vars = { card.config.center.config.choose, card.ability.extra } }
	end,
	group_key = "k_bee_pack",
	cry_credits = {
		idea = {
			"Inspector_B",
		},
		art = {
			"MarioFan597",
		},
		code = {
			"Inspector_B",
		},
	},
}

---------------Defining Seals-------------------

SMODS.Seal {
	key = "honey",
	badge_colour = HEX("f08a0e"),
	config = { beePerRetrigger = 2, retriggers = 1 },
	loc_vars = function(self, info_queue)
		return { vars = { self.config.beePerRetrigger or 2, retriggers or 1 } }
	end,
	atlas = "beemiscatlas",
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
		if  context.repetition
			then
			local beeCount = GetBees()
			
			return {
				message = localize("k_again_ex"),
				repetitions = math.floor(beeCount / self.config.beePerRetrigger),
				card = card,
			}
		end
	end,
	group_key = "k_bee_pack"
}


----------Defining Stickers------------------

SMODS.Sticker {
	key = "apian",
	badge_colour = HEX("f08a0e"),
	sets = {
		Joker = true
	},
	atlas = 'beestickeratlas',
	pos = { x = 0, y = 0 },
	rate = 0.3
}

----------Defining Consumables------------------

SMODS.Consumable {
	key = "egregore",
	set = "Spectral",
	atlas = 'beemiscatlas',
	pos = { x = 2, y = 0 },
	cost = 3,
	config = {
		-- This will add a tooltip.
		mod_conv = "bee_honey_seal",
		-- Tooltip args
		max_highlighted = 1,
		bees = 2
	},
	loc_vars = function (self, info_queue, center)
		info_queue[#info_queue + 1] = { key = "bee_honey_seal", set = "Other", vars = {self.config.bees or 2, self.config.retriggers or 1}}
		return { vars = {center and center.ability.max_highlighted or 1} }
	end,
	use = function(self, card, area, copier)
		local used_consumable = copier or card

		for i = 1, #G.hand.highlighted do
			local highlighted = G.hand.highlighted[i]
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound("tarot1")
					highlighted:juice_up(0.3, 0.5)
					return true
				end,
			}))
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.1,
				func = function()
					if highlighted then
						highlighted:set_seal("bee_honey")
					end
					return true
				end
			}))
			delay(0.5)
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.2,
				func = function()
					G.hand:unhighlight_all()
					return true
				end,
			}))
		end
	end,
	cry_credits = {
		idea = {
			"MarioFan597",
		},
		art = {
			"MarioFan597",
		},
		code = {
			"Inspector_B",
		},
	},
}


SMODS.Consumable {
	key = "infestation",
	set = "Spectral",
	atlas = 'beemiscatlas',
	pos = { x = 3, y = 0 },
	cost = 3,
	loc_vars = function (self, info_queue, center)
		info_queue[#info_queue + 1] = { key = "bee_apian", set = "Other", vars = {} }
	end,
	can_use = function(self, card)
		return #G.jokers.highlighted == 1 and G.jokers.highlighted[1]:is_bee() ~= true
	end,
	use = function(self, card, area, copier)
		local used_consumable = copier or card
		local highlighted = G.jokers.highlighted[1]
		--flip card
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.1,
			func = function()	
				if highlighted then				
					highlighted:flip()
				end
				return true
			end,
		}))

		--play sound
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.3,
			func = function()
				play_sound("gold_seal", 1.2, 0.4)
				highlighted:juice_up(0.3, 0.3)
				return true
			end,
		}))

		--add sticker to joker
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.1,
			func = function()
				if highlighted then
					highlighted.ability.bee_apian = true	
				end
				return true
			end,
		}))

		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.1,
			func = function()	
				if highlighted then				
					highlighted:flip()
				end
				return true
			end,
		}))
	end,
	cry_credits = {
		idea = {
			"Inspector_B",
		},
		art = {
			"MarioFan597",
		},
		code = {
			"Inspector_B",
		},
	},

}

SMODS.Consumable {
	key = "bug",
	set = "Code",
	name = "c_bee_bug",
	atlas = 'beemiscatlas',
	pos = { x = 1, y = 0 },
	cost = 3,
	loc_vars = function (self, info_queue, center)
		info_queue[#info_queue + 1] = { key = "bee_apian", set = "Other", vars = {} }
		info_queue[#info_queue + 1] = { key = "cry_perishable_voucher", set = "Other", vars = {5,5}}
		info_queue[#info_queue + 1] = G.P_CENTERS.e_cry_glitched
	end,
	can_use = function(self, card)
		return #G.jokers.highlighted == 1
	end,
	use = function(self, card, area, copier)
		local used_consumable = copier or card
		local highlighted = G.jokers.highlighted[1]
		--flip card
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.1,
			func = function()	
				if highlighted then				
					highlighted:flip()
				end
				return true
			end,
		}))
		--add stickers to joker
		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.1,
			func = function()
				if highlighted then
					if not highlighted:is_bee() then 
						highlighted.ability.bee_apian = true
					end	
				end
				return true
			end,
		}))

		

		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.1,
			func = function()	
				if highlighted then				
					highlighted:flip()
				end
				return true
			end,
		}))

		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.1,
			func = function()	
				if highlighted then				
					highlighted:set_edition({ cry_glitched = true })
				end
				return true
			end,
		}))

		G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.1,
			func = function()
				if highlighted then
					highlighted.ability.perishable = true
					highlighted.ability.perish_tally = G.GAME.perishable_rounds
				end
				return true
			end,
		}))
		
	end,
	cry_credits = {
		idea = {
			"Mr. Dingus",
		},
		art = {
			"Inspector_B",
		},
		code = {
			"Mr. Dingus and Inspector_B",
		},
	},
}

----------Defining Jokers------------------

SMODS.Joker {
	key = 'jimbee',
	config = { extra = { mult = 4, bee = true, bold = 1} },
	rarity = 1,
	atlas = 'beeatlas',
	blueprint_compat = true,
	pools = {["Bee"] = true},
	pos = { x = 0, y = 0 },
	cost = 2,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and math.min(card.ability.extra.mult, Global_Cap), card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = math.min(card.ability.extra.mult, Global_Cap),
                message = localize { type = 'variable', key = 'a_mult', vars = { math.min(card.ability.extra.mult, Global_Cap) } }
			}
		end
    end,
    cry_credits = {
			idea = {
				"Inspector_B"
			},
			art = {
				"Kryppe"
			},
			code = {
				"Inspector_B"
			}
		},
}

SMODS.Joker {
	key = 'ctrlplusbee',
	config = { extra = { mult = 0, mult_mod = 2, bee = true, bold = 5} },
	rarity = 2,
	atlas = 'beeatlas',
	pos = { x = 1, y = 1 },
	pools = {["Bee"] = true},
	cost = 5,
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and math.min(card.ability.extra.mult, Global_Cap), card and math.min(card.ability.extra.mult_mod, Global_Cap), card and card.ability.extra.bee, card and card.ability.extra.bold }	}
	end,
	calculate = function(self, card, context)

		local boldCount = 0
		for i = 1, #G.jokers.cards do
			if
				G.jokers.cards[i]:is_bee()
			then
				if G.jokers.cards[i].ability.bee_apian == true then
					boldCount = boldCount + 2
				else
					boldCount = boldCount + G.jokers.cards[i].ability.extra.bold
				end
			end
		end
		card.ability.extra.mult = card.ability.extra.mult_mod * boldCount

		if context.joker_main then			
			return {
				mult_mod = math.min(card.ability.extra.mult, Global_Cap),
                message = localize { type = 'variable', key = 'a_mult', vars = { math.min(card.ability.extra.mult, Global_Cap) } }
			}
		end
    end,
    cry_credits = {
			idea = {
				"Inspector_B"
			},
			art = {
				"George the Rat"
			},
			code = {
				"Inspector_B"
			}
		},
}

SMODS.Joker {
    key = "beebeedagger",
    pos = { x = 2, y = 0 },
    rarity = 2,
    cost = 8,
	config = { extra = {jimbeeCount = 3, bee = true, bold = 4} },
    atlas = "beeatlas",
	pools = {["Bee"] = true},
    blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and math.min(100,card.ability.extra.jimbeeCount), card and card.ability.extra.bee, card and card.ability.extra.bold }	}
	end,
    calculate = function(self, card, context)
        local my_pos = nil
		for i = 1, #G.jokers.cards do
			if G.jokers.cards[i] == card then
				my_pos = i
				break
			end
		end
		if
			context.setting_blind
			and not (context.blueprint_card or self).getting_sliced
			and my_pos
			and G.jokers.cards[my_pos + 1]
			and not G.jokers.cards[my_pos + 1].ability.eternal
			and not G.jokers.cards[my_pos + 1].getting_sliced
			and not G.jokers.cards[my_pos + 1]:is_bee()
		then
			local sliced_card = G.jokers.cards[my_pos + 1]
			sliced_card.getting_sliced = true
			if sliced_card.config.center.rarity == "cry_exotic" then --Taken from Cryptid
				check_for_unlock({ type = "what_have_you_done" })
			end
			G.GAME.joker_buffer = G.GAME.joker_buffer - 1
			G.E_MANAGER:add_event(Event({
				func = function()
					G.GAME.joker_buffer = 0
					card:juice_up(0.8, 0.8)
					sliced_card:start_dissolve({ HEX("f6fa00") }, nil, 1.6)
					play_sound("slice1", 0.96 + math.random() * 0.08)
					return true
				end,
			}))
			for i = 1, math.min(100,card.ability.extra.jimbeeCount) do
				local card = create_card("Joker", G.joker, nil, nil, nil, nil, "j_bee_jimbee")
				card:add_to_deck()
				G.jokers:emplace(card)
			end
			
			return nil, true
		end
    end,
    cry_credits = {
			idea = {
				"Inspector_B"
			},
			art = {
				"MarioFan597"
			},
			code = {
				"Inspector_B"
			}
		},
}

-- if context.end_of_round			
		-- and not context.repetition
		-- and not context.individual
		-- and not card.ability.extra.active
		-- and not context.blueprint
		-- then
		-- 	local beeCount = GetBees()
			
		-- 	card.ability.extra.chips = math.min((card.ability.extra.chips + card.ability.extra.chip_mod * beeCount), Global_Cap)
		-- 	card_eval_status_text(
		-- 		card,
		-- 		"extra",
		-- 		nil,
		-- 		nil,
		-- 		nil,
		-- 		{
		-- 			message = localize({ type = "variable", key = "a_chips", vars = { math.min((card.ability.extra.chip_mod * beeCount), Global_Cap)} }),
		-- 			colour = G.C.CHIPS,
		-- 		}
		-- 	)
		-- end

		-- if context.joker_main then
		-- 	if card.ability.extra.chips > 0 then
		-- 		return {
		-- 			chip_mod =  math.min(card.ability.extra.chips, Global_Cap),
		-- 			message = localize { type = 'variable', key = 'a_chips', vars = { math.min(card.ability.extra.chips, Global_Cap) } }
		-- 		}
		-- 	end
		-- end

SMODS.Joker {
	key = 'spellingbee',
	config = { extra = {word = "", progress = "", bee = true, bold = 4} },
	rarity = 1,
	atlas = 'beeatlas',
	blueprint_compat = true,
	pools = {["Bee"] = true},
	pos = { x = 3, y = 0 },
	cost = 2,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.word, card and card.ability.extra.progress} }
	end,
	add_to_deck = function(self, card, context)
		pickNewWord(card)
	end,
	remove_from_deck = function(self, card, context)
		-- Clear values when the Joker leaves the deck
		card.ability.extra.word = ""
		card.ability.extra.progress = ""
	end,
	calculate = function(self, card, context)
		if context.joker_main and not context.blueprint and not context.repetition then
			local rank 
			local scoredLetter
			local inProgressLetter = 0
			
			for i = 1, #context.full_hand do
				rank = SMODS.Ranks[context.full_hand[i].base.value].key
	
				if rank == "King" or rank == "Queen" or rank == "Jack" or rank == "10" then 
					inProgressLetter = inProgressLetter + 10
				elseif rank == "9" then
					inProgressLetter = inProgressLetter + 9
				elseif rank == "8" then
					inProgressLetter = inProgressLetter + 8
				elseif rank == "7" then
					inProgressLetter = inProgressLetter + 7
				elseif rank == "6" then
					inProgressLetter = inProgressLetter + 6
				elseif rank == "5" then
					inProgressLetter = inProgressLetter + 5
				elseif rank == "4" then
					inProgressLetter = inProgressLetter + 4
				elseif rank == "3" then
					inProgressLetter = inProgressLetter + 3
				elseif rank == "2" then
					inProgressLetter = inProgressLetter + 2
				elseif rank == "Ace" then
					inProgressLetter = inProgressLetter + 1
				end
			end
	
			local clampedValue = math.min(inProgressLetter, 26)
			print (clampedValue)
			if clampedValue >= 1 then
				scoredLetter = string.char(64 + clampedValue)

				local progress = card.ability.extra.progress or ""
				local word = card.ability.extra.word or ""
				local next_expected = word:sub(#progress + 1, #progress + 1)

				if scoredLetter == next_expected then
					card.ability.extra.progress = progress .. scoredLetter
				else
					pickNewWord(card) -- Reset everything on failure
				end
			end
			
			-- Check if the word is successfully spelled
			if card.ability.extra.progress == card.ability.extra.word then
				print("Yippie") -- Successfully spelled the word
				pickNewWord(card) -- Reset everything
			end
		end
    end,
    cry_credits = {
			idea = {
				"Inspector_B"
			},
			art = {
				"MarioFan597"
			},
			code = {
				"Inspector_B"
			}
		},
}

SMODS.Joker {
	key = 'bigbee',
	config = { extra = { mult = 0, mult_mod = 2, bee = true, bold = 4} },
	rarity = 1,
	atlas = 'beeatlas',
	pos = { x = 4, y = 0 },
	cost = 2,
	pools = {["Bee"] = true},
	blueprint_compat = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and math.min(card.ability.extra.mult, Global_Cap), card and math.min(card.ability.extra.mult_mod, Global_Cap),
		card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round			
		and not context.repetition
		and not context.individual
		and not card.ability.extra.active
		and not context.blueprint
		then
			local beeCount = GetBees()
			
			card.ability.extra.mult =  math.min(card.ability.extra.mult + card.ability.extra.mult_mod * beeCount, Global_Cap)
			card_eval_status_text(
				card,
				"extra",
				nil,
				nil,
				nil,
				{
					message = localize({ type = "variable", key = "a_mult", vars = { math.min((card.ability.extra.mult_mod * beeCount), Global_Cap)} }),
					colour = G.C.MULT,
				}
			)
		end

		if context.joker_main then
			if card.ability.extra.mult > 0 then
				return {
					mult_mod = math.min(card.ability.extra.mult, Global_Cap),
					message = localize { type = 'variable', key = 'a_mult', vars = { math.min(card.ability.extra.mult, Global_Cap) } }
				}
			end
		end
    end,
    cry_credits = {
			idea = {
				"Inspector_B"
			},
			art = {
				"Kryppe"
			},
			code = {
				"Inspector_B"
			}
		},
}

SMODS.Joker {
	key = 'ballofbees',
	config = {extra = { beecount = 1, bee = true, bold = 5, jim = 4} },
	rarity = 2,
	atlas = 'beeatlas',
	pools = {["Bee"] = true},
	blueprint_compat = true,
	pos = { x = 4, y = 1 },
	cost = 6,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and math.min(100, card.ability.extra.beecount), card and card.ability.extra.bee, card and card.ability.extra.bold} }
	end,
	calculate = function(self, card, context)
		if context.before and not context.debuff and (#G.jokers.cards + G.GAME.joker_buffer) < G.jokers.config.card_limit then
			if context.scoring_name == "Straight" then 
				for i = 1, math.min(100, card.ability.extra.beecount) do				
					local card = create_card("Joker", G.joker, nil, nil, nil, nil, "j_bee_jimbee")
					card:add_to_deck()
					G.jokers:emplace(card)								
				end

			return {message = 'Bzzzzz! Bzzzzz!', colour = G.C.FILTER,}
			end
		end

		if (context.retrigger_joker_check and not context.retrigger_joker and context.other_card ~= self and G.GAME.last_hand_played == 'Flush') then
			if (context.other_card:is_bee()) then
				return {
					message = localize("k_again_ex"),
					repetitions = 1,
					card = card,
				}
			end
		end
    end,
    cry_credits = {
			idea = {
				"Inspector_B"
			},
			art = {
				"Shadow"
			},
			code = {
				"Inspector_B"
			}
		},
}

SMODS.Joker {
	key = 'hivemind',
	config = { extra = { slots = 2, bee = true, bold = 6, beeCount = 1, activeSlots = 0} },
	rarity = "cry_epic",
	atlas = 'beeatlas',
	blueprint_compat = false,
	pos = { x = 1, y = 0 },
	immutable = true,
	cost = 15,
	pools = {["Bee"] = true},
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.slots, card and card.ability.extra.activeSlots, card and card.ability.extra.bee, card and card.ability.extra.bold, } }
	end,
	add_to_deck = function(self, card, context)
		card.ability.extra.beeCount = GetBees()

		card.ability.extra.activeSlots = card.ability.extra.slots * card.ability.extra.beeCount
		G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.activeSlots
    end,
	remove_from_deck = function(self, card, context)
		G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.activeSlots
    end,
    cry_credits = {
		idea = {
			"Inspector_B"
		},
		art = {
			"MarioFan597"
		},
		code = {
			"Inspector_B"
		}
	},
}


SMODS.Joker {
	key = 'kingbee',
	config = { extra = { mult = 0, mult_mod = 1, bee = true, bold = 5} },
	rarity = 2,
	atlas = 'beeatlas',
	blueprint_compat = true,
	pos = { x = 0, y = 1 },
	cost = 5,
	pools = {["Bee"] = true},
	loc_vars = function(self, info_queue, card)
		return { vars = { card and math.min(card.ability.extra.mult, Global_Cap), card and math.min(card.ability.extra.mult_mod, Global_Cap),
		card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.play and context.individual and not context.blueprint
		then
			local rank = SMODS.Ranks[context.other_card.base.value].key
			
			if rank == "King" or ((rank == "Queen" or rank == "Jack") and HasMaximized()) then
				local beeCount = GetBees()
	
				card.ability.extra.mult = math.min((card.ability.extra.mult + card.ability.extra.mult_mod * beeCount), Global_Cap)
				card_eval_status_text(
					card,
					"extra",
					nil,
					nil,
					nil,
					{
						message = localize({ type = "variable", key = "a_mult", vars = { math.min((card.ability.extra.mult_mod * beeCount), Global_Cap)} }),
						colour = G.C.MULT,
					}
	
				)
			end
		end

		if context.joker_main and card.ability.extra.mult ~= 0 then
			return {
				mult_mod = math.min(card.ability.extra.mult, Global_Cap),
				message = localize { type = 'variable', key = 'a_mult', vars = { math.min(card.ability.extra.mult, Global_Cap) } }
			}
		end
    end,
    cry_credits = {
			idea = {
				"Inspector_B"
			},
			art = {
				"Glitchkat10"
			},
			code = {
				"Inspector_B"
			}
		},
}

SMODS.Joker {
	key = 'queenbee',
	config = { extra = { extra = 0.1, x_mult = 1 , bee = true, bold = 4} },
	rarity = 3,
	atlas = 'beeatlas',
	blueprint_compat = true,
	pos = { x = 0, y = 2 },
	cost = 5,
	pools = {["Bee"] = true},
	loc_vars = function(self, info_queue, card)
		return { vars = { card and math.min(card.ability.extra.extra, Global_Cap), card and math.min(card.ability.extra.x_mult, Global_Cap), card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.play and context.individual and not context.blueprint
		then
			local rank = SMODS.Ranks[context.other_card.base.value].key

			if rank == "Queen" and not (HasMaximized()) then
				local beeCount = GetBees()
	
				card.ability.extra.x_mult = math.min((card.ability.extra.x_mult + card.ability.extra.extra * beeCount), Global_Cap)
				card_eval_status_text(
				card,
				"extra",
				nil,
				nil,
				nil,
				{ message = localize({ type = "variable", key = "a_xmult", vars = { math.min(card.ability.extra.x_mult, Global_Cap) } }) }
				)
			end
		end

		if context.joker_main then
			return {
				message = localize({ type = "variable", key = "a_xmult", vars = { math.min(card.ability.extra.x_mult, Global_Cap) } }),
				Xmult_mod = math.min(card.ability.extra.x_mult, Global_Cap),
			}
		end
    end,
    cry_credits = {
			idea = {
				"Inspector_B"
			},
			art = {
				"MarioFan597"
			},
			code = {
				"Inspector_B"
			}
		},
}

SMODS.Joker {
	key = 'beesknees',
	config = { extra = { extra = 0.06, x_mult = 1 , bee = true, bold = 4} },
	rarity = 3,
	atlas = 'beeatlas',
	blueprint_compat = true,
	pools = {["Bee"] = true},
	pos = { x = 2, y = 3 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and math.min(card.ability.extra.extra, Global_Cap), card and math.min(card.ability.extra.x_mult, Global_Cap), card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.after
		and not context.before			
		and not context.repetition
		and not context.blueprint
		then
			local beeCount = GetBees()
			card.ability.extra.x_mult = math.min((card.ability.extra.x_mult + card.ability.extra.extra * beeCount), Global_Cap)
			card_eval_status_text(
				card,
				"extra",
				nil,
				nil,
				nil,
				{ message = localize({ type = "variable", key = "a_xmult", vars = { math.min(card.ability.extra.x_mult, Global_Cap) } }) }
			)
			return nil, true	
		end

		if context.joker_main then
			return {
				message = localize({ type = "variable", key = "a_xmult", vars = { math.min(card.ability.extra.x_mult, Global_Cap) } }),
				Xmult_mod = math.min(card.ability.extra.x_mult, Global_Cap),
			}
		end
    end,
    cry_credits = {
			idea = {
				"Inspector_B"
			},
			art = {
				"Unexian and MarioFan597"
			},
			code = {
				"Inspector_B"
			}
		},
}

SMODS.Joker {
	key = 'beehive',
	config = { extra = { jimbeeCount = 1, bee = false, bold = 1} },
	rarity = 1,
	pools = {["Bee"] = true},
	atlas = 'beeatlas',
	blueprint_compat = true,
	pos = { x = 2, y = 1 },
	cost = 2,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and math.min(100, card.ability.extra.jimbeeCount), card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round			
		and not context.repetition
		and not context.individual
		and not card.ability.extra.active
		and (#G.jokers.cards + G.GAME.joker_buffer) < G.jokers.config.card_limit
		then
			for i = 1, math.min(100, card.ability.extra.jimbeeCount) do				
				local card = create_card("Joker", G.joker, nil, nil, nil, nil, "j_bee_jimbee")
				card:add_to_deck()
				G.jokers:emplace(card)								
			end

			return {message = 'Created!', colour = G.C.FILTER,}
		end
    end,
    cry_credits = {
			idea = {
				"Inspector_B"
			},
			art = {
				"Shadow"
			},
			code = {
				"Inspector_B"
			}
		},
}

SMODS.Joker {
	key = 'jollybee',
	config = { extra = { rounds = 0, active = false, bee = true, bold = 5, isJiggling = false} }, --check exists to prevent constant overjiggling
	rarity = 2,
	atlas = 'beeatlas',
	pos = { x = 5, y = 0 },
	cost = 5,
	pools = {["Bee"] = true},
	immutable = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.rounds, card and card.ability.extra.active }}
	end,
	calculate = function(self, card, context)
		if card.ability.extra.rounds == 0
		then
			card.ability.extra.active = true
			if not card.ability.extra.isJiggling 
			then
				local eval = function(card)
					return card.ability.extra.active
				end
				juice_card_until(card, eval, false)
				card.ability.extra.isJiggling = true
			end
		end

		if
			context.cardarea == G.jokers
			and context.before
			and not context.blueprint_card
			and not context.retrigger_joker
		then
			if context.scoring_name == "Pair" and card.ability.extra.active
			then
				card_eval_status_text(
				card,
				"extra",
				nil,
				nil,
				nil,
				{ message = "M!" }
				)
				
				for i = 1, #context.scoring_hand do
					local _card = context.scoring_hand[i]
					_card:set_edition({ cry_m = true })

				G.E_MANAGER:add_event(Event({
					delay = 0.6,
					func = function()	
						_card:juice_up()
						play_sound("tarot1")
						return true
					end,
				}))
				end				

				local beeCount = GetBees()
				card.ability.extra.rounds = math.max(1, (5 - beeCount))
				card.ability.extra.active = false
				card.ability.extra.isJiggling = false
			end
		end	

		if 
			context.end_of_round and not context.individual and not context.repetition and not context.blueprint and card.ability.extra.rounds > 0
		then
			card.ability.extra.rounds = card.ability.extra.rounds - 1
		end
    end,
    cry_credits = {
			idea = {
				"Inspector_B"
			},
			art = {
				"MarioFan597"
			},
			code = {
				"Inspector_B"
			}
		},
}

SMODS.Joker {
	key = 'larva',
	config = { extra = { rounds = 2, bee = true, bold = 2} },
	rarity = 1,
	atlas = 'beeatlas',
	pos = { x = 3, y = 1 },
	cost = 0,
	pools = {["Bee"] = true},
	immutable = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.rounds, card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if
			context.end_of_round
			and not context.blueprint
			and not context.individual
			and not context.repetition
			and not context.retrigger_joker
		then
			card.ability.extra.rounds = card.ability.extra.rounds - 1
			if card.ability.extra.rounds > 0 then
				return {
					message = { localize("cry_minus_round") },
					colour = G.C.FILTER,
				}
			else
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound("tarot1")
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true
							end,
						}))
						return true
					end,
				}))
				local card = create_card(
					"Joker",
					G.jokers,
					nil,
					nil,
					nil,
					nil,
					"j_bee_jimbee"
				)
				card:set_edition({holo = true})
				card:add_to_deck()
				G.jokers:emplace(card)
				return {
					message = localize("k_extinct_ex"),
					colour = G.C.FILTER,
				}
			end
		end
	end,
    cry_credits = {
			idea = {
				"Inspector_B"
			},
			art = {
				"George the Rat"
			},
			code = {
				"Inspector_B"
			}
		},
}

SMODS.Joker {
	key = 'honeycomb',
	config = { extra = { dollars = 3, bee = false, bold = 3} },
	rarity = 2,
	atlas = 'beeatlas',
	blueprint_compat = true,
	pools = {["Bee"] = true},
	pos = { x = 5, y = 1 },
	cost = 5,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and math.min(card.ability.extra.dollars, Global_Cap) ,card and card.ability.extra.bee, card and card.ability.extra.bold} }
	end,
	calc_dollar_bonus = function (self, card)
		local beeCount = GetBees()

		if beeCount > 0 then
			return math.min((card.ability.extra.dollars * beeCount), Global_Cap)
		end
    end,
    cry_credits = {
			idea = {
				"Inspector_B"
			},
			art = {
				"George the Rat"
			},
			code = {
				"Inspector_B"
			}
		},
}

SMODS.Joker {
	key = 'benson',                    
	config = { extra = { bee = true, bold = 24} },
	rarity = 4,
	atlas = 'beeatlas',
	blueprint_compat = true,
	pools = {["Bee"] = true},
	pos = { x = 2, y = 2 },
	soul_pos = { x = 3, y = 2 },
	cost = 25,
	immutable = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if 
			context.before and not context.repetition and not context.individual and
			#G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit
		then
			local editions = {
				{negative = true},
				{cry_astral = true},
				{polychrome = true},
				{cry_noisy = true},
				{cry_mosaic = true},
				{cry_glitched = true},
				{cry_oversat = true},
				{cry_blur = true},
				{cry_glass = true},
				{cry_gold = true},
				{holo = true},
				{foil = true}
			}

			local randomIndex = math.random(1, #editions)
			local selectedEdition = editions[randomIndex]

			local card = create_card(
					"Joker",
					G.jokers,
					nil,
					nil,
					nil,
					nil,
					"j_bee_jimbee"
				)
			
			card:set_edition(selectedEdition)
			card:add_to_deck()
			G.jokers:emplace(card)

			return {message = "You like jazz?",
			colour = G.C.FILTER}

		elseif context.before and not context.repetition and not context.individual and
		#G.jokers.cards + G.GAME.joker_buffer >= G.jokers.config.card_limit 
		then

			local card = create_card(
				"Joker",
				G.jokers,
				nil,
				nil,
				nil,
				nil,
				"j_bee_jimbee"
			)

			card:set_edition({negative = true})
			card:add_to_deck()
			G.jokers:emplace(card)

			return {message = "You like jazz?",
			colour = G.C.FILTER}
		end
    end,
    cry_credits = {
			idea = {
				"Inspector_B and MarioFan597"
			},
			art = {
				"MarioFan597"
			},
			code = {
				"Inspector_B"
			}
		},
}

SMODS.Joker {
	key = 'weebee',
	config = { extra = { chips = 0, chip_mod = 4, bee = true, bold = 5} },
	rarity = 3,
	atlas = 'beeatlas',
	blueprint_compat = true,
	pools = {["Bee"] = true},
	pos = { x = 1, y = 2 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and math.min(card.ability.extra.chips, Global_Cap), card and math.min(card.ability.extra.chip_mod, Global_Cap),
		card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.cardarea == G.play and context.individual and not context.blueprint
		then
			local rank = SMODS.Ranks[context.other_card.base.value].key

			if rank == "2" then
				local beeCount = GetBees()
	
				card.ability.extra.chips = math.min((card.ability.extra.chips + card.ability.extra.chip_mod * beeCount), Global_Cap)
				card_eval_status_text(
					card,
					"extra",
					nil,
					nil,
					nil,
					{ 
						message = localize({ type = "variable", key = "a_chips", vars = { math.min((card.ability.extra.chip_mod * beeCount), Global_Cap) } }),
						colour = G.C.CHIPS,
					}
				)
			end
		end

		if context.joker_main then
			if card.ability.extra.chips > 0 then
				return {
					chip_mod = math.min(card.ability.extra.chips, Global_Cap),
					message = localize { type = 'variable', key = 'a_chips', vars = { math.min(card.ability.extra.chips, Global_Cap) } }
					}
			end
		end
	end,
    cry_credits = {
			idea = {
				"Inspector_B"
			},
			art = {
				"MarioFan597"
			},
			code = {
				"MarioFan597"
			}
		},
}

SMODS.Joker {
	key = 'honeypot',
	config = { extra = { mult = 30, mult_mod = 5, mult_loss = 10, bold = 5} },
	rarity = 2,
	atlas = 'beeatlas',
	pos = { x = 4, y = 2 },
	cost = 7,
	immutable = true,
	pools = {["Bee"] = true},
	blueprint_compat = true,
	pools = { ["Food"] = true },
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.mult, card and card.ability.extra.mult_mod, card and card.ability.extra.mult_loss, card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round			
		and not context.repetition
		and not context.individual
		and not card.ability.extra.active
		then
			local beeCount = GetBees()
			local mult_total_loss = 0
			card.ability.extra.mult = card.ability.extra.mult + (card.ability.extra.mult_mod * beeCount) - card.ability.extra.mult_loss
			if card.ability.extra.mult > 0 and card.ability.extra.mult_mod * beeCount - card.ability.extra.mult_loss >= 0
			then
			card_eval_status_text(
				card,
				"extra",
				nil,
				nil,
				nil,
				{
						message = localize({ type = "variable", key = "a_mult", vars = { (card.ability.extra.mult_mod * beeCount) - card.ability.extra.mult_loss} }),
						colour = G.C.MULT
				}
			)
			else if card.ability.extra.mult > 0 and card.ability.extra.mult_mod * beeCount - card.ability.extra.mult_loss < 0
			then
				mult_total_loss = (card.ability.extra.mult_mod * beeCount) - card.ability.extra.mult_loss
				card_eval_status_text(
				card,
				"extra",
				nil,
				nil,
				nil,
				{message =  ""..mult_total_loss, colour = G.C.MULT}
			)
			--This part borrowed from SMOD Example Jokers
			else
				-- This part plays the animation.
				G.E_MANAGER:add_event(Event({
					func = function()
						play_sound('tarot1')
						card.T.r = -0.2
						card:juice_up(0.3, 0.4)
						card.states.drag.is = true
						card.children.center.pinch.x = true
						-- This part destroys the card.
						G.E_MANAGER:add_event(Event({
							trigger = 'after',
							delay = 0.3,
							blockable = false,
							func = function()
								G.jokers:remove_card(card)
								card:remove()
								card = nil
								return true;
							end
						}))
						return true
				end
				}))
				return {
					message = 'Eaten!'
				}
			end
		end
	end
		
		if context.joker_main then
			if card.ability.extra.mult > 0 then
				return {
					mult_mod = card.ability.extra.mult,
					message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult } }
					}
				end
		end	
end,
    cry_credits = {
			idea = {
				"Inspector_B"
			},
			art = {
				"MarioFan597"
			},
			code = {
				"MarioFan597"
			}
		},
}

SMODS.Joker {
	key = 'nostalgic_jimbee',
	config = { extra = { mult = 4, bee = true, bold = 2} },
	rarity = 1,
	atlas = 'beeatlas',
	blueprint_compat = true,
	pools = {["Bee"] = true},
	pos = { x = 5, y = 2 },
	cost = 3,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and math.min(card.ability.extra.mult, Global_Cap), card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				mult_mod = math.min(card.ability.extra.mult, Global_Cap),
                message = localize { type = 'variable', key = 'a_mult', vars = { math.min(card.ability.extra.mult, Global_Cap) } }
			}
		end
		-- and context.other_card.ability.name == "j_bee_jimbee"
		if (context.retrigger_joker_check and not context.retrigger_joker and 
			(context.other_card.ability.name == "j_bee_jimbee" or context.other_card.ability.name == "j_bee_nostalgic_jimbee")) then
				return {
					message = localize("k_again_ex"),
					repetitions = 1,
					card = card,
				}
		end
    end,
    cry_credits = {
			idea = {
				"MarioFan597"
			},
			art = {
				"Inspector_B"
			},
			code = {
				"Inspector_B"
			}
		},
}

SMODS.Joker {
	key = 'grim_queen',
	config = { extra = { mult = 4, bee = true, bold = 4} },
	rarity = 3,
	atlas = 'beeatlas',
	blueprint_compat = false,
	pools = {["Bee"] = true},
	pos = { x = 1, y = 3 },
	immutable = true,
	cost = 8,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_stone

		return { vars = { card and card.ability.extra.mult, card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if
			context.cardarea == G.jokers
			and context.before
			and not context.blueprint_card
			and not context.retrigger_joker
		then
			local beeCount = GetBees()
			local converted = false

			for i = 1, #context.scoring_hand do	
			converted = true
			if beeCount < i then break end
			local _card = context.scoring_hand[i]
				local enhancement = "m_stone"
				if _card.ability.effect ~= "Stone Card" then
					_card:set_ability(G.P_CENTERS[enhancement], nil, true)
				end
				G.E_MANAGER:add_event(Event({
					delay = 0.6,
					func = function()	
						_card:juice_up()
						play_sound("tarot1")
						return true
					end,
				}))
			end

			if converted then
				return {message = 'Stoned!', colour = G.C.FILTER,}
			end
		end
    end,
    cry_credits = {
			idea = {
				"MarioFan597"
			},
			art = {
				"MarioFan597"
			},
			code = {
				"Inspector_B"
			}
		},
}

SMODS.Joker {
	key = 'buzzkill',
	config = { extra = {bee = false,} },
	rarity = 3,
	atlas = 'beeatlas',
	blueprint_compat = false,
	pools = {["Bee"] = true},
	pos = { x = 0, y = 3 },
	cost = 8,
	immutable = true,
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue+1] = G.P_TAGS.tag_buffoon
	end,
	calculate = function(self, card, context)
		if context.selling_self and not context.blueprint
		then
			local tag_count = 0
			for i = 1, #G.jokers.cards do
				if
					G.jokers.cards[i]:is_bee()
				then
					add_tag(Tag('tag_buffoon'))
					local sliced_card = G.jokers.cards[i]
					sliced_card.getting_sliced = true
					if sliced_card.config.center.rarity == "cry_exotic" 
					then
						check_for_unlock({ type = "what_have_you_done" })
					end
					G.GAME.joker_buffer = G.GAME.joker_buffer - 1
					G.E_MANAGER:add_event(Event({
					func = function()
					G.GAME.joker_buffer = 0
					card:juice_up(0.8, 0.8)
					sliced_card:start_dissolve({ HEX("f6fa00") }, nil, 1.6)
					play_sound("slice1", 0.96 + math.random() * 0.08)
					return true
					end,
					}))
				end
			end

		end
	end,
    cry_credits = {
			idea = {
				"Inspector_B"
			},
			art = {
				"MarioFan597"
			},
			code = {
				"MarioFan597"
			}
		},
}
SMODS.Joker {
	key = 'trenchcoat',
	config = { extra = {bee = true, total_bees = 4129, bold = 2} },
	rarity = "cry_exotic",
	atlas = 'beeatlas',
	blueprint_compat = false,
	pools = {["Bee"] = true},
	pos = { x = 3, y = 3 },
	soul_pos = { x = 5, y = 3, extra = { x = 4, y = 3 } },
	cost = 50,
	immutable = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.total_bees} }
	end,
    cry_credits = {
			idea = {
				"Inspector_B"
			},
			art = {
				"MarioFan597"
			},
			code = {
				"MarioFan597"
			}
		},
}

SMODS.Joker {
	key = 'honeydrops',
	config = { extra = {bee = true, chips = 50, chip_mod = 5, total_bees = 0, last_threshold = 50, bold = 2} },
	rarity = "cry_candy",
	atlas = 'honeydrop',
	blueprint_compat = false,
	immutable = true,
	pools = {["Bee"] = true},
	pos = { x = 0, y = 0 },
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and card.ability.extra.chips, card and card.ability.extra.chip_mod, card and card.ability.extra.total_bees} }
	end,
	calculate = function(self, card, context)
		if context.after and not context.repetition then
			-- Store the previous chip value before modification
			local previous_chips = card.ability.extra.chips
	
			-- Apply the chip modifier to the chips value
			card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.chip_mod
	
			-- Check if we crossed a multiple of 10 threshold (i.e., from 45 to 40, 35 to 30, etc.)
			-- Calculate the previous and new multiples of 10
			local prev_multiple_of_10 = math.floor(previous_chips / 10) * 10
			local new_multiple_of_10 = math.floor(card.ability.extra.chips / 10) * 10
	
			-- If we crossed into a new multiple of 10, increment total_bees
			if new_multiple_of_10 < prev_multiple_of_10 then
				-- Increment the total_bees for each crossed multiple of 10
				local crossed_thresholds = (prev_multiple_of_10 - new_multiple_of_10) / 10
				card.ability.extra.total_bees = (card.ability.extra.total_bees or 0) + crossed_thresholds
				-- Changes art to match the current bee count
				card.children.center:set_sprite_pos({x = (card.ability.extra.total_bees), y = 0})
				return {message = 'Bee Added', colour = G.C.FILTER,}
				-- Display "Bee Added" message
			end
	
			-- Display evaluation message (for chips)
			card_eval_status_text(
				card,
				"extra",
				nil,
				nil,
				nil,
				{
					message = localize({ type = "variable", key = "a_chips_minus", vars = { card.ability.extra.chip_mod } }),
				}
			)
		end

		if card.ability.extra.chips <= 0 then
			G.E_MANAGER:add_event(Event({
				func = function()
					play_sound('tarot1')
					card.T.r = -0.2
					card:juice_up(0.3, 0.4)
					card.states.drag.is = true
					card.children.center.pinch.x = true
					-- This part destroys the card.
					G.E_MANAGER:add_event(Event({
						trigger = 'after',
						delay = 0.3,
						blockable = false,
						func = function()
							G.jokers:remove_card(card)
							card:remove()
							card = nil
							return true;
						end
					}))
					return true
			end
			}))
			return {
				message = 'Eaten!'
			}
		end
		
		if context.joker_main then
			if card.ability.extra.chips > 0 then
				return {
					chip_mod = card.ability.extra.chips,
					message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
				}
			end
		end

	end,
    cry_credits = {
			idea = {
				"Luigicat11"
			},
			art = {
				"MarioFan597"
			},
			code = {
				"Inspector_B"
			}
		},
}

SMODS.Joker {
	key = 'twobee',
	config = { extra = {bee = true, total_bees = 1, bold = 5}, odds = 2 },
	rarity = 1,
	atlas = 'beeatlas2',
	blueprint_compat = false,
	pools = {["Bee"] = true},
	pos = { x = 1, y = 0 },
	cost = 4,
	immutable = true,
	loc_vars = function(self, info_queue, card)
		return { vars = {cry_prob(card.ability.cry_prob, card.ability.odds, card.ability.cry_rigged), card and card.ability.odds, card and card.ability.extra.total_bees} }
	end,
	calculate = function(self, card, context)
		if 
			context.setting_blind
			and (
					pseudorandom("2bee") < cry_prob(card.ability.cry_prob, card.ability.odds, card.ability.cry_rigged) / card.ability.odds
				)	
		then
			card.ability.extra.total_bees = 2 
			card_eval_status_text(
				card,
				"extra",
				nil,
				nil,
				nil,
				{ message = "Two Bee!" }
				)
		elseif
		context.setting_blind
		then
			card.ability.extra.total_bees = 1
			card_eval_status_text(
				card,
				"extra",
				nil,
				nil,
				nil,
				{ message = "Not Two Bee!" }
				)
		end
	end,
    cry_credits = {
			idea = {
				"MarioFan597"
			},
			art = {
				"MarioFan597"
			},
			code = {
				"Inspector_B"
			}
		},
}

SMODS.Joker {
	key = 'bottleobees',
	config = { extra = { total_bees = 0, bee = false, bold = 1} },
	rarity = 1,
	atlas = 'bottleobees',
	blueprint_compat = false,
	pools = {["Bee"] = true},
	pos = { x = 0, y = 0 },
	cost = 2,
	immutable = true,
	loc_vars = function(self, info_queue, card)
		return { vars = { card and math.min(card.ability.extra.total_bees, 100), card and card.ability.extra.bee, card and card.ability.extra.bold } }
	end,
	calculate = function(self, card, context)
		if context.selling_card and context.card:is_bee() and not (card.ability.extra.total_bees >= 5) then
			if not context.blueprint then
				card.ability.extra.total_bees = card.ability.extra.total_bees + 1
				-- Changes art to match the current bee count
				card.children.center:set_sprite_pos({x = (card.ability.extra.total_bees), y = 0})
				card_eval_status_text(
				card,
				"extra",
				nil,
				nil,
				nil,
				{ message = "Bottled Bee!" }
				)
			end
		end
		if context.setting_blind then
			-- Makes sure the art is right even after saving and quiting
			card.children.center:set_sprite_pos({x = (card.ability.extra.total_bees), y = 0})
		end
    end,
    cry_credits = {
			idea = {
				"Inspector_B"
			},
			art = {
				"MarioFan597"
			},
			code = {
				"Inspector_B"
			}
		},
}

-- SMODS.Joker {
-- 	key = 'buggedbee',
-- 	config = { extra = { bee = true, bold = 3.14159} },
-- 	rarity = 3,
-- 	atlas = 'beeatlas',
-- 	blueprint_compat = false,
-- 	pools = {["Bee"] = true},
-- 	pos = { x = 0, y = 0 },
-- 	cost = 2,
-- 	loc_vars = function(self, info_queue, card) --Taken from Cryptids Machine Code
-- 		return {
-- 			main_start = {
-- 				Cryptid.randomchar(codechars2),
-- 				Cryptid.randomchar(codechars4),
-- 				Cryptid.randomchar(codechars6),
-- 				Cryptid.randomchar(codechars6),
-- 				Cryptid.randomchar(codechars6),
-- 				Cryptid.randomchar(codechars6),
-- 				Cryptid.randomchar(codechars6),
-- 				Cryptid.randomchar(codechars6),
-- 				Cryptid.randomchar(codechars6),
-- 				Cryptid.randomchar(codechars6),
-- 				Cryptid.randomchar(codechars6),
-- 				Cryptid.randomchar(codechars6),
-- 				Cryptid.randomchar(codechars6),
-- 				Cryptid.randomchar(codechars6),
-- 				Cryptid.randomchar(codechars6),
-- 				Cryptid.randomchar(codechars6),
-- 				Cryptid.randomchar(codechars5),
-- 			},
-- 		}
-- 	end,
-- 	calculate = function(self, card, context)
-- 		if context.using_consumeable and context.consumeable.ability.set == "Code"then
-- 			print ("Bingo")
-- 		end
--     end,
-- 	init = function(self)
-- 		--Machine Code rendering
-- 		codechars2 = { "!", "'", ",", ".", ":", ";", "i", "l", "|", "¡", "¦", "ì", "í", "ı" }
-- 		codechars4 = { " ", "(", ")", "[", "]", "j", "î", "ī", "ĭ" }
-- 		codechars5 = { '"', "*", "<", ">", "{", "}", "¨", "°", "º", "×" }
-- 		codechars6 = {
-- 			"$",
-- 			"%",
-- 			"+",
-- 			"-",
-- 			"/",
-- 			"0",
-- 			"1",
-- 			"2",
-- 			"3",
-- 			"4",
-- 			"5",
-- 			"6",
-- 			"7",
-- 			"8",
-- 			"9",
-- 			"=",
-- 			"?",
-- 			"A",
-- 			"B",
-- 			"C",
-- 			"D",
-- 			"E",
-- 			"F",
-- 			"G",
-- 			"H",
-- 			"I",
-- 			"J",
-- 			"K",
-- 			"L",
-- 			"N",
-- 			"O",
-- 			"P",
-- 			"R",
-- 			"S",
-- 			"T",
-- 			"U",
-- 			"V",
-- 			"Y",
-- 			"Z",
-- 			"\\",
-- 			"^",
-- 			"_",
-- 			"a",
-- 			"b",
-- 			"c",
-- 			"d",
-- 			"e",
-- 			"f",
-- 			"g",
-- 			"h",
-- 			"k",
-- 			"n",
-- 			"o",
-- 			"p",
-- 			"q",
-- 			"r",
-- 			"s",
-- 			"t",
-- 			"u",
-- 			"v",
-- 			"y",
-- 			"z",
-- 			"~",
-- 			"¢",
-- 			"¥",
-- 			"§",
-- 			"¬",
-- 			"±",
-- 			"¿",
-- 			"À",
-- 			"Á",
-- 			"Â",
-- 			"Ã",
-- 			"Ä",
-- 			"Å",
-- 			"Ç",
-- 			"È",
-- 			"É",
-- 			"Ê",
-- 			"Ë",
-- 			"Ì",
-- 			"Í",
-- 			"Î",
-- 			"Ï",
-- 			"Ñ",
-- 			"Ò",
-- 			"Ó",
-- 			"Ô",
-- 			"Õ",
-- 			"Ö",
-- 			"Ù",
-- 			"Ú",
-- 			"Û",
-- 			"Ü",
-- 			"Ý",
-- 			"Þ",
-- 			"à",
-- 			"á",
-- 			"â",
-- 			"ã",
-- 			"ä",
-- 			"å",
-- 			"ç",
-- 			"è",
-- 			"é",
-- 			"ê",
-- 			"ë",
-- 			"ï",
-- 			"ñ",
-- 			"ò",
-- 			"ó",
-- 			"ô",
-- 			"õ",
-- 			"ö",
-- 			"÷",
-- 			"ù",
-- 			"ú",
-- 			"û",
-- 			"ü",
-- 			"ý",
-- 			"þ",
-- 			"ÿ",
-- 			"Ā",
-- 			"ā",
-- 			"Ă",
-- 			"ă",
-- 			"Ć",
-- 			"ć",
-- 			"Ē",
-- 			"ē",
-- 			"Ĕ",
-- 			"ĕ",
-- 			"Ğ",
-- 			"ğ",
-- 			"Ī",
-- 			"Ĭ",
-- 			"İ",
-- 			"ł",
-- 			"Ń",
-- 			"ń",
-- 			"Ō",
-- 			"ō",
-- 			"Ŏ",
-- 			"ŏ",
-- 			"Ś",
-- 			"ś",
-- 			"Ş",
-- 			"ş",
-- 			"Ū",
-- 			"ū",
-- 			"Ŭ",
-- 			"ŭ",
-- 			"Ÿ",
-- 			"Ź",
-- 			"ź",
-- 			"Ż",
-- 			"ż",
-- 			"Ǔ",
-- 			"ǔ",
-- 			"μ",
-- 		}
-- 		codechars7 = { "#", "Q", "X", "x", "£", "ß", "Ą", "ą", "Đ", "đ", "Ę", "ę" }
-- 		codechars8 = { "M", "W", "m", "w", "¤", "¶", "Ø", "ø", "Ł" }
-- 		codechars9 = { "&", "@", "©", "«", "®", "»" }
-- 		codechars10 = { "Æ", "æ", "Œ", "œ" }
-- 		function Cryptid.randomchar(arr)
-- 			return {
-- 				n = G.UIT.O,
-- 				config = {
-- 					object = DynaText({
-- 						string = arr,
-- 						colours = { G.C.BLACK },
-- 						pop_in_rate = 9999999,
-- 						silent = true,
-- 						random_element = true,
-- 						pop_delay = 0.1,
-- 						scale = 0.4,
-- 						min_cycle_time = 0,
-- 					}),
-- 				},
-- 			}
-- 		end
-- 	end,
--     cry_credits = {
-- 			idea = {
-- 				"Inspector_B"
-- 			},
-- 			art = {
-- 				"Inspector_B"
-- 			},
-- 			code = {
-- 				"Inspector_B"
-- 			}
-- 		},
-- }


----------------------------------------------
------------MOD CODE END----------------------
