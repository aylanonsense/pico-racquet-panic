pico-8 cartridge // http://www.pico-8.com
version 8
__lua__
-- constants
tile_width=4
tile_height=4
num_cols=32
num_rows=13
game_top=0
game_bottom=num_rows*tile_height
game_left=0
game_right=num_cols*tile_width
game_mid=flr((num_cols/2)*tile_width)
camera_offset_y=32
entity_classes={
	["player"]={
		["width"]=16,
		["height"]=24,
		["swing_id"]=0,
		["swings"]={
			["forehand"]={
				["charge"]={
					["sprites"]={false,192,193,194,false,false,208,209,210,false,false,224,225,226,false}
				},
				["startup"]={
					["frames"]=2,
					["sprites"]={false,195,196,197,false,false,211,212,213,false,false,227,228,229,false}
				},
				["active"]={
					["frames"]=2,
					["sprites"]={false,198,199,200,false,false,214,215,216,false,false,230,231,232,false},
					["hitboxes"]={
						{["dimensions"]={10,13,4,4},["dir"]={{1,-0.14},{1,-0.14},{1,-0.14}},["is_sweet"]=true},
						{["dimensions"]={5,11,12,9},["dir"]={{1,-0.14},{1,-0.14},{1,-0.14}}},
						{["dimensions"]={1,11,4,8},["dir"]={{1,-0.14},{1,-0.14},{1,-0.14}},["is_sour"]=true}
					}
				},
				["recovery"]={
					["frames"]=8,
					["sprites"]={false,false,201,202,203,false,false,217,218,219,false,false,233,234,235}
				}
			},
			["spike"]={
				["charge"]={
					["sprites"]={false,4,5,6,false,false,20,21,22,false,false,36,37,38,false}
				},
				["startup"]={
					["frames"]=1,
					["sprites"]={false,7,8,9,false,false,23,24,25,false,false,39,40,41,false}
				},
				["active"]={
					["frames"]=1,
					["sprites"]={false,false,10,11,12,false,false,26,27,28,false,false,42,43,44}
				},
				["recovery"]={
					["frames"]=1,
					["sprites"]={false,false,13,14,15,false,false,29,30,31,false,false,45,46,47}
				}
			},
			["lob"]={
				["charge"]={
					["sprites"]={64,65,66,false,false,80,81,82,false,false,96,97,98,false,false}
				},
				["startup"]={
					["frames"]=1,
					["sprites"]={67,68,69,false,false,83,84,85,false,false,99,100,101,false,false}
				},
				["active"]={
					["frames"]=1,
					["sprites"]={false,70,71,72,false,false,86,87,88,false,false,102,103,104,false}
				},
				["recovery"]={
					["frames"]=1,
					["sprites"]={false,false,73,74,75,false,false,89,90,91,false,false,105,106,107}
				}
			}
		},
		["init"]=function(entity,args)
			entity.x=args.x
			entity.y=args.y
			entity.is_grounded=false
			entity.state='standing'
			entity.state_frames=0
			entity.swing='forehand'
			entity.swing_power_level=1 -- min=1 max=5
		end,
		["pre_update"]=function(entity)
			entity.vy+=0.1
			entity.state_frames+=1
			if entity.is_grounded then
				-- swing when z is pressed
				if entity.state=='standing' or entity.state=='walking' then
					if btn(4) then
						entity.state='charging'
						entity.state_frames=0
						if btn(2) then
							entity.swing='spike'
						elseif btn(3) then
							entity.swing='lob'
						else
							entity.swing='forehand'
						end
						entity.swing_power_level=2
					end
				end
				if entity.state=='charging' then
					entity.swing_power_level=min(flr(2+entity.state_frames/15),4)
					if not btn(4) then
						entity.state='swinging'
						entity.state_frames=0
						entity.swing_id+=1
					end
				end
				if entity.state=='swinging' then
					local swing=entity.swings[entity.swing]
					if entity.state_frames>=swing.startup.frames+swing.active.frames+swing.recovery.frames then
						entity.state='standing'
						entity.state_frames=0
					end
				end
				-- move left/right when arrow keys are pressed
				entity.vx=0
				if entity.state=='standing' or entity.state=='walking' then
					if btn(0) then
						entity.vx-=2
					end
					if btn(1) then
						entity.vx+=2
					end
					if entity.state=='standing' and entity.vx!=0 then
						entity.state='walking'
						entity.state_frames=0
					elseif entity.state=='walking' and entity.vx==0 then
						entity.state='standing'
						entity.state_frames=0
					end
				end
			end
			entity.is_grounded=false
		end,
		["update"]=function(entity)
			entity.x+=entity.vx
			entity.y+=entity.vy
			-- land on the bottom of the play area
			if entity.y>game_bottom-entity.height then
				entity.y=game_bottom-entity.height
				entity.vy=min(entity.vy,0)
				entity.is_grounded=true
			end
			-- hit the left wall of the play area
			if entity.x<game_left then
				entity.x=game_left
				entity.vx=max(entity.vx,0)
			end
			-- hit the right wall of the play area
			if entity.x>game_mid-entity.width then
				entity.x=game_mid-entity.width
				entity.vx=min(entity.vx,0)
			end
		end,
		["post_update"]=function(entity)
			if entity.state=='swinging' then
				local swing=entity.swings[entity.swing]
				local swing_part
				if entity.state_frames<swing.startup.frames then
					swing_part=swing.startup
				elseif entity.state_frames<swing.startup.frames+swing.active.frames then
					swing_part=swing.active
				else
					swing_part=swing.recovery
				end
				local i
				for i=1,#balls do
					local ball=balls[i]
					local ball_left=ball.x
					local ball_right=ball.x+ball.width/2
					local ball_top=ball.y+ball.height/2
					local ball_bottom=ball.y+ball.height
					local j
					if ball.swing_id!=entity.swing_id and swing_part.hitboxes then
						for j=1,#swing_part.hitboxes do
							local hitbox=swing_part.hitboxes[j]
							local hitbox_left=entity.x+hitbox.dimensions[1]
							local hitbox_right=entity.x+hitbox.dimensions[1]+hitbox.dimensions[3]
							local hitbox_top=entity.y+hitbox.dimensions[2]
							local hitbox_bottom=entity.y+hitbox.dimensions[2]+hitbox.dimensions[4]
							if hitbox_left<=ball_right and ball_left<=hitbox_right and hitbox_top<=ball_bottom and ball_top<=hitbox_bottom then
								ball.vx=hitbox.dir[entity.swing_power_level-1][1]
								ball.vy=hitbox.dir[entity.swing_power_level-1][2]
								local power_level=entity.swing_power_level
								if power_level>=4 then
									power_level=5
								end
								if hitbox.is_sweet then
									power_level=max(2*power_level-2,3)
								elseif hitbox.is_sour then
									power_level=2
								end
								ball.set_power_level(ball,power_level)
								ball.swing_id=entity.swing_id
								ball.has_hit_court=false
								ball.can_hit_court=false
								ball.should_downgrade_power=false
								freeze_frames=3
								if hitbox.is_sweet then
									freeze_frames=45
								end
								break
								-- entity.state_frames=swing.startup+swing.active-1
								-- create_entity("swing_hit_effect",{
								-- 	["x"]=ball.x+0.5+ball.width/2,
								-- 	["y"]=ball.y+0.5+ball.height/2
								-- })
							end
						end
					end
				end
			end
		end,
		["draw"]=function(entity)
			-- local x=entity.x+0.5
			-- local y=entity.y+0.5
			-- local sprites={}
			-- local offset_x=0
			-- local offset_y=0
			-- if entity.state=='charging' then
			-- 	if entity.swing=='spike' then
			-- 		sprites={4,5,6,20,21,22,36,37,38}
			-- 	elseif entity.swing=='lob' then
			-- 		sprites={64,65,66,80,81,82,96,97,98}
			-- 		offset_x=-8
			-- 	else
			-- 		sprites={192,193,194,208,209,210,224,225,226}
			-- 	end
			-- elseif entity.state=='swinging' then
			-- 	local swing=entity.swings[entity.swing]
			-- 	if entity.state_frames<swing.startup then
			-- 		if entity.swing=='spike' then
			-- 			sprites={7,8,9,23,24,25,39,40,41}
			-- 		elseif entity.swing=='lob' then
			-- 			sprites={67,68,69,83,84,85,99,100,101}
			-- 			offset_x=-8
			-- 		else
			-- 			sprites={195,196,197,211,212,213,227,228,229}
			-- 		end
			-- 	elseif entity.state_frames<swing.startup+swing.active then
			-- 		if entity.swing=='spike' then
			-- 			sprites={10,11,12,26,27,28,42,43,44}
			-- 			offset_x=8
			-- 		elseif entity.swing=='lob' then
			-- 			sprites={70,71,72,86,87,88,102,103,104}
			-- 		else
			-- 			sprites={198,199,200,214,215,216,230,231,232}
			-- 		end
			-- 		-- rectfill(x+swing.hitbox[1],y+swing.hitbox[2],x+swing.hitbox[3]-1,y+swing.hitbox[4]-1,8)
			-- 	else
			-- 		if entity.swing=='spike' then
			-- 			sprites={13,14,15,29,30,31,45,46,47}
			-- 			offset_x=8
			-- 		elseif entity.swing=='lob' then
			-- 			sprites={73,74,75,89,90,91,105,106,107}
			-- 			offset_x=8
			-- 		else
			-- 			sprites={201,202,203,217,218,219,233,234,235}
			-- 			offset_x=8
			-- 		end
			-- 	end
			-- elseif entity.vx>0 then
			-- 	if entity.state_frames%12<6 then
			-- 		sprites={131,132,133,147,148,149,163,164,165}
			-- 	else
			-- 		sprites={134,135,136,150,151,152,166,167,168}
			-- 	end
			-- elseif entity.vx<0 then
			-- 	if entity.state_frames%12<6 then
			-- 		sprites={137,138,139,153,154,155,169,170,171}
			-- 	else
			-- 		sprites={140,141,142,156,157,158,172,173,174}
			-- 	end
			-- else
			-- 	sprites={128,129,130,144,145,146,160,161,162}
			-- end
			-- -- draw the sprites
			-- local i
			-- for i=1,#sprites do
			-- 	if sprites[i]!=nil then
			-- 		spr(sprites[i],x+8*((i-1)%3)+offset_x,y+8*flr((i-1)/3)+offset_y)
			-- 	end
			-- end
			local x=entity.x+0.5
			local y=entity.y+0.5
			local sprites={}
			-- draw a silly rectangle
			-- rectfill(x,y,x+entity.width-1,y+entity.height-1,14)
			-- determine sprites based on state
			local swing=entity.swings[entity.swing]
			local swing_part
			if entity.state=='swinging' then
				if entity.state_frames<swing.startup.frames then
					swing_part=swing.startup
				elseif entity.state_frames<swing.startup.frames+swing.active.frames then
					swing_part=swing.active
				else
					swing_part=swing.recovery
				end
			elseif entity.state=='charging' then
				swing_part=swing.charge
			else
				sprites={false,128,129,130,false,false,144,145,146,false,false,160,161,162,false}
			end
			if swing_part then
				sprites=swing_part.sprites
			end
			-- draw the sprites
			local i
			for i=1,#sprites do
				if sprites[i] then
					spr(sprites[i],x+8*((i-1)%5)-12,y+8*flr((i-1)/5))
				end
			end
			-- visualize hitboxes
			if swing_part and swing_part.hitboxes then
				local i
				for i=#swing_part.hitboxes,1,-1 do
					local hitbox=swing_part.hitboxes[i]
					local d=hitbox.dimensions
					if hitbox.is_sour then
						color(8)
					elseif hitbox.is_sweet then
						color(14)
					else
						color(9)
					end
					rect(x+d[1],y+d[2],x+d[1]+d[3]-1,y+d[2]+d[4]-1)
				end
			end
		end
	},
	["ball"]={
		["width"]=3,
		["height"]=3,
		["swing_id"]=-1,
		["speeds_by_power_level"]={2,2.75,5,7},
		["gravity_by_power_level"]={0.06,0.05,0.02,0},
		["init"]=function(entity,args)
			entity.x=args.x
			entity.y=args.y
			entity.vx=args.vx
			entity.vy=args.vy
			entity.power_level=1
			entity.gravity=entity.gravity_by_power_level[min(entity.power_level,4)]
			entity.should_downgrade_power=false
			entity.can_hit_court=false
			entity.has_hit_court=false
			entity.vertical_energy=0.5*entity.vy*entity.vy+entity.gravity*(num_rows*tile_height-entity.height-entity.y)
			entity.col_left=x_to_col(entity.x)
			entity.col_right=x_to_col(entity.x+entity.width-1)
			entity.row_top=y_to_row(entity.y)
			entity.row_bottom=y_to_row(entity.y+entity.height-1)
		end,
		["pre_update"]=function(entity)
			entity.prev_x=entity.x
			entity.prev_y=entity.y
			entity.vy+=entity.gravity
		end,
		["update"]=function(entity)
			entity.x+=entity.vx
			entity.y+=entity.vy
			check_for_tile_collisions(entity)
			-- todo this code could cause bugs if bounds get desynced
			-- hit the bottom of the play area
			if entity.y>game_bottom-entity.height then
				entity.y=game_bottom-entity.height
				if entity.vy>0 then
					if entity.x+entity.width/2<game_mid and entity.can_hit_court then
						entity.has_hit_court=true
					end
					entity.check_for_power_level_change(entity)
					entity.do_bounce(entity,'bottom')
				end
			end
			-- hit the top of the play area
			if entity.y<game_top then
				entity.y=game_top
				if entity.vy<0 then
					entity.can_hit_court=true
					entity.check_for_power_level_change(entity)
					entity.do_bounce(entity,'top')
				end
			end
			-- hit the left wall of the play area
			if entity.x<game_left then
				entity.x=game_left
				if entity.vx<0 then
					entity.should_downgrade_power=true
					entity.can_hit_court=true
					entity.check_for_power_level_change(entity)
					entity.do_bounce(entity,'left')
				end
			end
			-- hit the right wall of the play area
			if entity.x>game_right-entity.width then
				entity.x=game_right-entity.width
				if entity.vx>0 then
					entity.should_downgrade_power=true
					entity.can_hit_court=true
					entity.check_for_power_level_change(entity)
					entity.do_bounce(entity,'right')
				end
			end
		end,
		["can_collide_against_tile"]=function(entity,tile)
			return true -- return true to indicate a collision
		end,
		["on_collide_with_tiles"]=function(entity,tiles_hit,dir)
			entity.can_hit_court=true
			entity.should_downgrade_power=true
			local max_tiles_hit=999 -- ceil(entity.height/tile_height)
			-- if dir=='top' or dir=='bottom' then
			-- 	max_tiles_hit=ceil(entity.width/tile_width)
			-- end
			-- if entity.power_level>2 then
			-- 	max_tiles_hit=999
			-- end
			local num_tiles_hit=0
			foreach(tiles_hit,function(tile)
				if num_tiles_hit<max_tiles_hit then
					num_tiles_hit+=1
					freeze_frames=2
					tile.on_hit(tile,entity,dir)
				end
			end)
			local old_power_level=entity.power_level
			entity.check_for_power_level_change(entity)
			if old_power_level<=2 then
				-- change directions
				entity.do_bounce(entity,dir)
			end
			return true -- return true to end movement
		end,
		["check_for_power_level_change"]=function(entity)
			-- check to see if the power level has changed
			local new_power_level=entity.power_level
			if entity.power_level>1 and entity.has_hit_court then
				entity.set_power_level(entity,1)
				entity.has_hit_court=false
			elseif entity.power_level>2 and entity.should_downgrade_power then
				entity.set_power_level(entity,entity.power_level-1)
				entity.should_downgrade_power=false
			end
		end,
		["do_bounce"]=function(entity,dir)
			-- change velocities
			if dir=='left' or dir=='right' then
				entity.vx*=-1
			end
			if dir=='top' or dir=='bottom' then
				local v=sqrt(2*(entity.vertical_energy-entity.gravity*(num_rows*tile_height-entity.height-entity.y)))
				if entity.vy>0 then
					entity.vy=-v
				else
					entity.vy=v
				end
			end
		end,
		["set_power_level"]=function(entity,power_level)
			entity.power_level=power_level
			local curr_speed=sqrt(entity.vx*entity.vx+entity.vy*entity.vy)
			if curr_speed>0 then
				entity.vx*=entity.speeds_by_power_level[min(entity.power_level,4)]/curr_speed
				entity.vy*=entity.speeds_by_power_level[min(entity.power_level,4)]/curr_speed
			end
			entity.gravity=entity.gravity_by_power_level[min(entity.power_level,4)]
			entity.vertical_energy=max(0.75,0.5*entity.vy*entity.vy+entity.gravity*(num_rows*tile_height-entity.height-entity.y))
		end,
		["draw"]=function(entity)
			local x=entity.x+0.5
			local y=entity.y+0.5
			if entity.power_level<=1 then
				color(7)
			elseif entity.power_level<=2 then
				color(10)
			elseif entity.power_level<=3 then
				color(9)
			elseif entity.power_level<=4 then
				color(8)
			else
				color(14)
			end
			rectfill(x,y,x+entity.width-1,y+entity.height-1)
			-- line((entity.col_left-1)*tile_width-1,entity.y-5,(entity.col_left-1)*tile_width-1,entity.y+entity.height+4,7)
			-- line((entity.col_right)*tile_width,entity.y-5,(entity.col_right)*tile_width,entity.y+entity.height+4,15)
			-- line(entity.x-5,(entity.row_top-1)*tile_height-1,entity.x+entity.width+4,(entity.row_top-1)*tile_height-1,7)
			-- line(entity.x-5,(entity.row_bottom)*tile_height,entity.x+entity.width+4,(entity.row_bottom)*tile_height,15)
		end
	},
	["tile_death_effect"]={
		["init"]=function(entity,args)
			entity.x=args.x
			entity.y=args.y
		end,
		["update"]=function(entity)
			entity.x+=entity.vx
			entity.y+=entity.vy
			entity.vx*=0.99
			entity.vy*=0.99
			if entity.frames_alive>1 then
				entity.is_alive=false
			end
		end,
		["draw"]=function(entity)
			local x=entity.x+0.5
			local y=entity.y+0.5
			if entity.frames_alive<1 then
				rectfill(x,y,x+entity.width-1,y+entity.height-1,7)
			elseif entity.frames_alive<2 then
				rect(x,y,x+entity.width-1,y+entity.height-1,7)
			end
		end
	},
	["swing_hit_effect"]={
		["init"]=function(entity,args)
			entity.x=args.x
			entity.y=args.y
		end,
		["draw"]=function(entity)
			-- circ(entity.x,entity.y,entity.frames_alive*1,7)
			-- circ(entity.x,entity.y,entity.frames_alive*2,12)
			-- circ(entity.x,entity.y,entity.frames_alive*3,8)
			-- circ(entity.x,entity.y,entity.frames_alive*4,11)
			-- circ(entity.x,entity.y,entity.frames_alive*5,10)
		end	
	}
}
tile_legend={
	["g"]={
		["sprite"]=6,
		["hp"]=1
	},
	["r"]={
		["sprite"]=7,
		["hp"]=1
	}
}
levels={
	{
		["tile_map"]={
			"                                ",
			"                          ggg   ",
			"                         gggg   ",
			"                          ggg   ",
			"                          gggg  ",
			"                         ggggg  ",
			"                         gg ggg ",
			"                       ggg   gg ",
			"                      ggg    gg ",
			"                    rrrr     gg ",
			"                   rrrr r    gg ",
			"                   rrrr r   gg  ",
			"                   rrrrrr  ggg  ",
			"                   rrrrrr  gg   ",
			"                    rrrr rrrr   ",
			"                        rrrr r  ",
			"                        rrrr r  ",
			"                        rrrrrr  ",
			"                        rrrrrr  ",
			"                         rrrr   ",
			"                                ",
		}
	}
}


-- input vars
curr_btns={}
prev_btns={}


-- scene vars
actual_frame=0
scene=nil -- "title_screen" / "game"
scene_frame=0
bg_color=0


-- game vars
freeze_frames=0
level=nil
tiles={}
balls={}
entities={}
new_entities={}


-- top-level methods
function _init()
	init_game()
end

function _update()
	actual_frame+=1
	if actual_frame%1>0 then
		return
	end
	-- record current button presses
	prev_btns=curr_btns
	curr_btns={}
	local i
	for i=0,6 do
		curr_btns[i]=btn(i)
	end
	-- update whatever the active scene is
	scene_frame+=1
	if scene=="title_screen" then
		update_title_screen()
	elseif scene=="game" then
		update_game()
	end
end

function _draw()
	-- reset the canvas
	camera()
	rectfill(0,0,127,127,bg_color)

	-- draw the active scene
	if scene=="title_screen" then
		draw_title_screen()
	elseif scene=="game" then
		draw_game()
	end
end


-- title screen methods
function init_title_screen()
	scene="title_screen"
	scene_frame=0
	bg_color=0
end

function update_title_screen()
end

function draw_title_screen()
	-- debug
	print("title_screen",1,1,7)
end


-- game methods
function init_game()
	scene="game"
	scene_frame=0
	bg_color=1
	balls={}
	entities={}
	new_entities={}
	init_blank_tiles()
	-- load the level
	level=levels[1]
	create_tiles_from_map(level.tile_map)
	create_entity("player",{
		["x"]=13,
		["y"]=60
	})
	create_entity("ball",{
		["x"]=50,
		["y"]=30,
		["vx"]=-0.5,
		["vy"]=-1
	})
	foreach(new_entities,add_entity_to_game)
	new_entities={}
end

function update_game()
	if freeze_frames>0 then
		freeze_frames-=1
		return
	end

	-- update entities
	foreach(entities,function(entity)
		entity.frames_alive+=1
		entity.pre_update(entity)
	end)
	foreach(entities,function(entity)
		entity.update(entity)
	end)
	foreach(entities,function(entity)
		entity.post_update(entity)
	end)

	-- new entities get added at the end of the frame
	foreach(new_entities,add_entity_to_game)
	new_entities={}

	-- get rid of any dead entities
	balls=filter_list(balls,is_alive)
	entities=filter_list(entities,is_alive)
end

function draw_game()
	camera(0,-camera_offset_y)

	-- draw the tiles
	foreach_tile(draw_tile)

	-- draw entities
	foreach(entities,draw_entity)

	-- draw some ui
	camera()
	local y_bottom=camera_offset_y+tile_height*num_rows
	rectfill(0,0,127,camera_offset_y-1,0)
	rectfill(0,y_bottom,127,127,0)
	line(0,y_bottom,game_mid,y_bottom,12)
end


-- tile methods
function init_blank_tiles()
	tiles={}
	local c
	for c=1,num_cols do
		tiles[c]={}
		local r
		for r=1,num_rows do
			tiles[c][r]=false
		end
	end
end

function create_tiles_from_map(map,key)
	local r
	for r=1,min(num_rows,#map) do
		local c
		for c=1,min(num_cols,#map[r]) do
			local symbol=sub(map[r],c,c)
			if symbol==" " then
				tiles[c][r]=false
			else
				tiles[c][r]=create_tile(symbol,c,r)
			end
		end
	end
end

function tile_exists(col,row)
	return tiles[col] and tiles[col][row]
end

function create_tile(symbol,col,row)
	local tile_def=tile_legend[symbol]
	return {
		["col"]=col,
		["row"]=row,
		["sprite"]=tile_def["sprite"],
		["hp"]=tile_def["hp"],
		["on_hit"]=function(tile,ball,dir)
			tile.hp-=1
			if tile.hp<=0 then
				tiles[tile.col][tile.row]=false
			end
			create_entity("tile_death_effect",{
				["x"]=(tile.col-1)*tile_width,
				["y"]=(tile.row-1)*tile_height,
			})
		end
	}
end

function draw_tile(tile)
	if tile.sprite!=nil then
		local x=tile_width*(tile.col-1)
		local y=tile_height*(tile.row-1)
		spr(tile.sprite,x-2,y-2)
		-- rectfill(x,y,x+tile_width-1,y+tile_height-1,7)
	end
end

function foreach_tile(func)
	local c
	for c=1,num_cols do
		if tiles[c] then
			local r
			for r=1,num_rows do
				if tiles[c][r] then
					func(tiles[c][r])
				end
			end
		end
	end
end


-- entity methods
function create_entity(class_name,args)
	local class_def=entity_classes[class_name]
	local entity={
		["class_name"]=class_name,
		-- position
		["x"]=0,
		["y"]=0,
		-- velocity
		["vx"]=0,
		["vy"]=0,
		-- size
		["width"]=class_def.width or tile_width,
		["height"]=class_def.height or tile_height,
		-- methods
		["pre_update"]=class_def.pre_update or noop,
		["update"]=class_def.update or noop,
		["post_update"]=class_def.post_update or noop,
		["draw"]=class_def.draw or noop,
		["can_collide_against_tile"]=class_def.can_collide_against_tile or noop,
		["on_collide_with_tiles"]=class_def.on_collide_with_tiles or noop,
		-- other properties
		["is_alive"]=true,
		["frames_alive"]=0
	}
	local k
	local v
	for k,v in pairs(class_def) do
		if not entity[k] then
			entity[k]=v
		end
	end
	if class_def.init then
		class_def.init(entity,args)
	end
	add(new_entities,entity)
	return entity
end

function add_entity_to_game(entity)
	add(entities,entity)
	if entity.class_name=="ball" then
		add(balls,entity)
	end
	return entity
end

function draw_entity(entity)
	-- rectfill(entity.x+0.5,entity.y+0.5,entity.x+0.5+entity.width-1,entity.y+0.5+entity.height-1,9)
	entity.draw(entity)
	-- print(entity.col_left,entity.x+0.5-10,entity.y+0.5,13)
	-- print(entity.row_top,entity.x+0.5,entity.y+0.5-10,13)
	-- print(entity.col_right,entity.x+0.5+entity.width-1+5,entity.y+0.5+entity.height-1,13)
	-- print(entity.row_bottom,entity.x+0.5+entity.width-1,entity.y+0.5+entity.height-1+5,13)
end

function check_for_tile_collisions(entity)
	local x=entity.prev_x
	local y=entity.prev_y
	local i
	for i=1,50 do
		local dx=entity.x-x
		local dy=entity.y-y

		-- if we are not moving, we are done
		if dx==0 and dy==0 then
			break
		end

		-- find the next vertical bound along the ball's path
		local bound_x=nil
		-- vertical bound is to the right of the ball
		if dx>0 then
			bound_x=tile_width*entity.col_right-entity.width
			x=min(x,bound_x)
		-- vertical bound is to the left of the ball
		elseif dx<0 then
			bound_x=tile_width*(entity.col_left-1)
			x=max(x,bound_x)
		end

		-- find the next horizontal bound along the ball's path
		local bound_y=nil
		-- horizontal bound is below the ball
		if dy>0 then
			bound_y=tile_height*entity.row_bottom-entity.height
			y=min(y,bound_y)
		-- horizontal bound is above the ball
		elseif dy<0 then
			bound_y=tile_height*(entity.row_top-1)
			y=max(y,bound_y)
		end

		-- ball will reach the next vertical bound first
		if bound_y==nil or (bound_x!=nil and (bound_x-x)/dx<(bound_y-y)/dy) then
			local bound_dx=bound_x-x
			local can_reach_bound=(abs(bound_dx)<=abs(dx))
			-- move to the bound
			if can_reach_bound then
				x=bound_x
				y+=dy*bound_dx/dx
			-- move to the end of the movement
			else
				x=entity.x
				y=entity.y
			end
			-- update non-leading edges
			if dy>0 then
				entity.row_top=y_to_row(y)
			elseif dy<0 then
				entity.row_bottom=y_to_row(y+entity.height-1)
			end
			if dx>0 then
				entity.col_left=x_to_col(x)
			elseif dx<0 then
				entity.col_right=x_to_col(x+entity.width-1)
			end
			if can_reach_bound then
				-- figure out what the bound's column would be
				local col
				if dx>0 then
					col=entity.col_right+1
				elseif dx<0 then
					col=entity.col_left-1
				end
				-- find all tiles that could be in the way
				local tiles_to_collide_with={}
				local row
				for row=entity.row_top,entity.row_bottom do
					if tile_exists(col,row) and entity.can_collide_against_tile(entity,tiles[col][row]) then
						add(tiles_to_collide_with,tiles[col][row])
					end
				end
				-- collide against all of those tiles
				local dir='right'
				if dx<0 then
					dir='left'
				end
				local temp_x=entity.x
				local temp_y=entity.y
				entity.x=x
				entity.y=y
				if #tiles_to_collide_with>0 and entity.on_collide_with_tiles(entity,tiles_to_collide_with,dir) then
					break
				-- update the leading bound if we are not done yet
				else
					entity.x=temp_x
					entity.y=temp_y
					if dx>0 then
						entity.col_right=col
					elseif dx<0 then
						entity.col_left=col
					end
				end
			else
				break
			end
		-- ball will reach the next horizontal bound first
		else
			local bound_dy=bound_y-y
			local can_reach_bound=(abs(bound_dy)<=abs(dy))
			-- move to the bound
			if can_reach_bound then
				x+=dx*bound_dy/dy
				y=bound_y
			-- move to the end of the movement
			else
				x=entity.x
				y=entity.y
			end
			-- update non-leading edges
			if dy>0 then
				entity.row_top=y_to_row(y)
			elseif dy<0 then
				entity.row_bottom=y_to_row(y+entity.height-1)
			end
			if dx>0 then
				entity.col_left=x_to_col(x)
			elseif dx<0 then
				entity.col_right=x_to_col(x+entity.width-1)
			end
			if can_reach_bound then
				-- figure out what the bound's row would be
				local row
				if dy>0 then
					row=entity.row_bottom+1
				elseif dy<0 then
					row=entity.row_top-1
				end
				-- find all tiles that could be in the way
				local tiles_to_collide_with={}
				local col
				for col=entity.col_left,entity.col_right do
					if tile_exists(col,row) and entity.can_collide_against_tile(entity,tiles[col][row]) then
						add(tiles_to_collide_with,tiles[col][row])
					end
				end
				-- collide against all of those tiles
				local dir='bottom'
				if dy<0 then
					dir='top'
				end
				local temp_x=entity.x
				local temp_y=entity.y
				entity.x=x
				entity.y=y
				if #tiles_to_collide_with>0 and entity.on_collide_with_tiles(entity,tiles_to_collide_with,dir) then
					break
				-- update the leading bound if we are not done yet
				else
					entity.x=temp_x
					entity.y=temp_y
					if dy>0 then
						entity.row_bottom=row
					elseif dy<0 then
						entity.row_top=row
					end
				end
			else
				break
			end
		end
	end
	entity.x=x
	entity.y=y
end


-- helper methods
function noop() end

function side_to_vec(dir,len)
	len=len or 1
	if dir=='left' then
		return -len,0
	elseif dir=='right' then
		return len,0
	elseif dir=='top' then
		return 0,-len
	elseif dir=='bottom' then
		return 0,len
	else
		return 0,0
	end
end

function btnp2(i)
	return curr_btns[i] and not prev_btns[i]
end

function ceil(n)
	return -flr(-n)
end

function filter_list(list,func)
	local l={}
	local i
	for i=1,#list do
		if func(list[i]) then
			add(l,list[i])
		end
	end
	return l
end

function is_alive(x)
	return x.is_alive
end

function is_colliding(x1,y1,w1,h1,x2,y2,w2,h2)
	return x1<=x2+w2-1 and x2<=x1+w1-1 and y1<=y2+h2-1 and y2<=y1+h1-1
end

function x_to_col(x)
	return flr(x/tile_width)+1
end

function y_to_row(y)
	return flr(y/tile_height)+1
end


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000c00000c00000000000000000000000000000000000000000000000000000000000000000000000000000000000007770000000000000000000000000000
00000ccccccc000000eee80000000000000000000000000000000000000000777770000000000000000000000000000777777000000000000000000000000000
00000cc1cc1c000000e8880000000000000000000000000000000000000007777777000000000000000000000000000777777000000000000000000000000000
00000cc1cc1c000000888200000000000000000c00000000c0000000000007777c77770000c00000000000000000000777777000000000000000000000000000
00000cc1cc1c000000822200000000000000000cccccccccc0000000000007777cccccccccc00000000c00000000c07777777000000000000000000000000000
00000ccccccc000000000000000000000000000ccc1ccc1cc0000000000000777ccc1ccc1cc00000000cccccccccc0777777000000000c00000000c000000000
000000cc0000000000000000000000000000000ccc1ccc1cc0000000000000077ccc1ccc1cc00000000ccc1ccc1cc0777770000000000cccccccccc000000000
0000ccccc000000000000000000000000000000ccc1ccc1cc0000000000000000ccc1ccc1cc00000000ccc1ccc1cc0777700000000000ccc1ccc1cc000000000
000cccccc000000000000000000000000000000cccccccccc0000000000000000cccccccccc00000000ccc1ccc1cc7700000000000000ccc1ccc1cc000000000
000cccccc700000000dd5500006d560000000070cccccccc000000000000000000cccccccc000000000cccccccccc7000000000000000ccc1ccc1cc000000000
000ccccc0077770000d5d50000655d000000077000ccc00000000000000000000000ccc0000000000000cccccccc70000000000000000cccccccccc000000000
000ccccc00777770005d55000055d600007777000ccccc000000000000000000000ccccc00000000000000ccc000000000000000000000cccccccc0000000000
0000ccc00007777000555500006d6d00077777000cccccc0000000000000000000ccccccc00000000000cccccc000000000000000000000ccc00000000000000
00000cc0000077700000000000000000777777000ccccccc000000000000000000ccccccc0000000000ccccccc0000000000000000000cccccc0000000000000
00000c0c0000000000000000000000007777700000cccccc000000000000000000ccccccc0000000000ccccccc000000000000000000ccccccc0077000000000
000000000000000000000000000000007777700000cccccc000000000000000000cccccc0000000000cccccccc000000000000000000ccccccc0007777700000
000000000000000000000000000000007777700000cccccc00000000000000000ccccccc0000000000ccccccc0000000000000000000cccccc00000777777000
00777c000066650000d66d0000766600077700000cccccccc0000000000000000ccccccc0000000000ccccccc0000000000000000000cccccc00000777777700
007ccc000066560000665d0000677500000000000cccccccc0000000000000000ccccccc0000000000ccccccc0000000000000000000cccccc00000077777700
00ccc10000656500006d6d0000675600000000000cccc0ccc0000000000000000ccccccc0000000000ccccccc00000000000000000000ccccc00000077777700
00c111000055550000d5d50000567500000000000ccc00ccc0000000000000000ccc00cc0000000000ccc00cc00000000000000000000ccccc00000000777000
0000000000000000000000000000000000000000ccc000cc00000000000000000cc000cc000000000ccc000cc0000000000000000000000ccc00000000000000
0000000000000000000000000000000000000000c000000c0000000000000000c000000c000000000000000c00000000000000000000000c00c0000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0076d6000077d5000077d50000766700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00d76d00006d1700006d170000677500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
006d760000d1d10000d1d10000677500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00d66d00001576000015760000755600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000c00000000c000777000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000c00000000c0000000cccccccccc077777700000000000000000000000000000000000000
000000000000c00000000c0000000000000000000000000000000000cccccccccc0000000ccc1ccc1cc077777700000000000000000000000000000000000000
000000000000cccccccccc0000000000000000c00000000c00000000ccc1ccc1cc0000000ccc1ccc1cc777777700000000000000000000000000000000000000
000000000000ccc1ccc1cc0000000000000000cccccccccc00000000ccc1ccc1cc0000000ccc1ccc1cc777777000000000000000000000000000000000000000
000000000000ccc1ccc1cc0000000000000000ccc1ccc1cc00000000ccc1ccc1cc0000000cccccccccc777770000000000000000000000000000000000000000
000000000000ccc1ccc1cc0000000000000000ccc1ccc1cc00000000cccccccccc00000000cccccccc0777700000000000000000000000000000000000000000
000000000000cccccccccc0000000000000000ccc1ccc1cc000000000cccccccc00000000000ccc0000700000000000000000000000000000000000000000000
0000000000000cccccccc00000000000000000cccccccccc00000000000ccc0000000000000ccccc007000000000000000000000000000000000000000000000
000000000000000ccc000000000000000000000cccccccc00000000000cccccc00000000000cccccc00000000000000000000000000000000000000000000000
00000000000000cccccc000000000000000000000ccc00000000000000cccccc00000000000cccccc00000000000000000000000000000000000000000000000
00000000000000cccccc00000000000000000000ccccc0000000000000ccccc700000000000cccccc00000000000000000000000000000000000000000000000
00000000000000cccccc00000000000000000000ccccc0000000000000cccccc7700000000ccccccc00000000000000000000000000000000000000000000000
00000777707770ccccccc00000000000000000007ccccc00000000000ccccccc7777770000ccccccc00000000000000000000000000000000000000000000000
00007777777000ccccccc0000000000000000077ccccccc0000000000ccccccc0777777000ccccccc00000000000000000000000000000000000000000000000
000077777700000ccccccc000000000000077777ccccccc0000000000ccccccc0777777700ccccccc00000000000000000000000000000000000000000000000
00007777700000cccccccc000000000000777770cccccccc000000000ccccccc0077777700ccc0ccc00000000000000000000000000000000000000000000000
00000777000000cccc0cccc00000000000777770cccccccc000000000ccc0ccc007777770ccc00ccc00000000000000000000000000000000000000000000000
00000000000000cc00000cc0000000000077777cccc000cc000000000cc000cc000077700cc000cc000000000000000000000000000000000000000000000000
00000000000000c00000000c00000000007770ccc000000c00000000c000000c00000000c000000c000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000c00000000c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000c00000000c000000000000000cccccccccc00000000000000c00000000c000000000000c00000000c00000000000000c00000000c000000000000000
00000000cccccccccc000000000000000ccc1ccc1cc00000000000000cccccccccc000000000000cccccccccc00000000000000cccccccccc000000000000000
00000000ccc1ccc1cc000000000000000ccc1ccc1cc00000000000000ccc1ccc1cc000000000000ccc1ccc1cc00000000000000ccc1ccc1cc000000000000000
00000000ccc1ccc1cc000000000000000ccc1ccc1cc00000000000000ccc1ccc1cc000000000000ccc1ccc1cc00000000000000ccc1ccc1cc000000000000000
00000000ccc1ccc1cc000000000000000cccccccccc00000000000000ccc1ccc1cc000000000000ccc1ccc1cc00000000000000ccc1ccc1cc000000000000000
00000000cccccccccc0000000000000000cccccccc000000000000000cccccccccc000000000000cccccccccc00000000000000cccccccccc000000000000000
000000000cccccccc0000000000000000000ccc0000000000000000000cccccccc00000000000000cccccccc0000000000000000cccccccc0000000000000000
00000000000ccc000000000000000777000cccc000000000000000000000ccc0000000000000000000ccc000000000000000000000ccc0000000000000000000
0000000000ccccc0000000000000777770cccccc000000000000077700ccccc000000000000000000ccccc0000000000000000000ccccc000000000000000000
000000000ccccccc0000000000007777777cccccc0000000000077777ccccccc0000000000000000ccccccc00000000000000000ccccccc00000000000000000
000000000c77cccc0000000000007777777cccccc000000000007777777cccccc000000000000000cccc77770000000000000000cccc77770000000000000000
00000007777ccccc00000000000007777cccccccc000000000007777777cccccc000000000000000ccccc7777770000000000000ccccc7777770000000000000
0000007777cccccc00000000000000000ccccccc00000000000007777cccccccc000000000000000cccccc777770000000000000cccccc777770000000000000
0000007777cccccc00000000000000000ccccccc00000000000000000ccccccc0000000000000000cccccc777770000000000000cccccc777770000000000000
000000777ccccccc00000000000000000ccccccc00000000000000000ccccccc0000000000000000ccccccc77770000000000000ccccccc77770000000000000
000000000ccccccc0000000000000000ccccccccc00000000000000000cccccc0000000000000000cccccccc0000000000000000ccccc1cc0000000000000000
000000000ccc0ccc000000000000000ccccc00cccc000000000000000cccccc000000000000000000ccc0cccc0000000000000000ccccccc0000000000000000
000000000cc000cc000000000000000000000000000000000000000000000cc00000000000000000cccc00ccc00000000000000000ccc0000000000000000000
000000000c00000c00000000000000000000000000000000000000000000c0000000000000000000000000000c000000000000000000c0000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aaab0000eee80000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000abbb0000e8880000000000
0000000000000000000000000000000000000000000000000000000000000000000000000c00000000c00000000000000000000000bbb3000088820000000000
00000c00000000c0000000000000000c00000000c000000000000000c00000000c0000000cccccccccc00000000000000000000000b333000082220000000000
00000cccccccccc0000000000000000cccccccccc000000000000000cccccccccc0000000ccc1ccc1cc000000000000000000000000000000000000000000000
00000ccc1ccc1cc0000000000000000ccc1ccc1cc000000000000000ccc1ccc1cc0000000ccc1ccc1cc000000000000000000000000000000000000000000000
07770ccc1ccc1cc0000000000000000ccc1ccc1cc000000000000000ccc1ccc1cc0000000ccc1ccc1cc000000000000000000000000000000000000000000000
07777ccc1ccc1cc0000000000000000ccc1ccc1cc000000000000000ccc1ccc1cc0000000cccccccccc000777000000000000000000000000000000000000000
07777cccccccccc0000000000000000cccccccccc000000000000000cccccccccc00000000cccccccc0007777700000000ab3b0000aaa90000dd5500006d5600
077770cccccccc000000000000000000cccccccc00000000000000000cccccccc00000000000ccc0000077777700000000b3330000a9990000d5d50000655d00
07777000ccc00000000000000000000000ccc0000000000000000000000ccc0000000000000ccccc000777777700000000333b0000999400005d55000055d600
0077700ccccc000000000000077770000ccccc00000000000000000000c777c00000000000ccccccc07777777000000000b3bb000094440000555500006d6d00
000777ccccccc0000000000077777700ccccccc0000000000000000000c777700000000000cccccc770007700000000000000000000000000000000000000000
000007ccccccc0000000000077777770ccccccc000000000000000000cc7777c0000000000ccccccc00000000000000000000000000000000000000000000000
0000007cccccc00000000000777777777cccccc000000000000000000ccc77770000000000ccccccc00000000000000000000000000000000000000000000000
000000ccccccc000000000000777770ccccccc0000000000000000000ccc77770000000000ccccccc00000000000000000000000000000000000000000000000
0000000ccccccc00000000000000000ccccccc0000000000000000000cccc77c0000000000ccccccc00000000000000000000000000000000000000000000000
0000000ccccccc00000000000000000ccccccc000000000000000000cccccccc00000000ccccccccc00000000000000000000000000000000000000000000000
000000ccccccccc0000000000000000cccccccc00000000000000000cccccccc000000000cccc0ccc00000000000000000000000000000000000000000000000
000000cccc00ccc000000000000000cccc00ccc0000000000000000cccc00ccc00000000000000ccc00000000000000000000000000000000000000000000000
000000cc00000cc000000000000000ccc0000ccc000000000000000ccc0000cc00000000000000cc000000000000000000000000000000000000000000000000
000000c00000000c00000000000000c00000000c00000000000000c00000000c000000000000000c000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344

