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
		["swing_part"]=1,
		["swing_charge_level"]=1,
		["swings"]={
			["forehand"]={
				["charge"]={
					["sprites"]={0,129,130,0,0,  144,145,146,0,0,  0,161,162,0,0}
				},
				["parts"]={
					{
						["frames"]=2,
						["sprites"]={0,131,132,0,0,  0,147,148,149,0,  0,163,164,0,0},
						["hitboxes"]={
							{["dimensions"]={1,12,8,8},["dir"]={{1,0.15},{1,0.05},{1,0.05}}},
							{["dimensions"]={-1,12,2,8},["dir"]={{0.4,-1},{0.4,-1},{0.4,-1}},["is_sour"]=true}
						}
					},
					{
						["frames"]=2,
						["sprites"]={0,134,135,136,0,  0,150,151,152,0,  0,166,167,0,0},
						["hitboxes"]={
							{["dimensions"]={12,13,4,4},["dir"]={{1,-0.08},{1,-0.05},{1,-0.05}},["is_sweet"]=true},
							{["dimensions"]={5,11,12,8},["dir"]={{1,-0.15},{1,-0.08},{1,-0.05}}},
							{["dimensions"]={1,11,4,8},["dir"]={{0.4,-1},{0.4,-1},{0.4,-1}},["is_sour"]=true}
						}
					},
					{
						["frames"]=2,
						["sprites"]={0,137,138,139,0,  0,153,154,155,156,  0,169,170,0,0},
						["hitboxes"]={
							{["dimensions"]={15,9,11,8},["dir"]={{1,-0.4},{1,-0.2},{1,-0.15}}},
							{["dimensions"]={11,11,9,8},["dir"]={{-0.2,-1},{-0.2,-1},{-0.2,-1}},["is_sour"]=true}
						}
					},
					{
						["frames"]=6,
						["sprites"]={0,137,138,139,0,  0,153,154,157,156,  0,169,170,0,0}
					}
				}
			},
			["spike"]={
				["charge"]={
					["sprites"]={0,192,193,194,0,  0,208,209,0,0,  0,224,225,0,0}
				},
				["parts"]={
					{
						["frames"]=3,
						["sprites"]={0,195,196,197,0,  0,211,212,213,0,  0,227,228,0,0},
						["hitboxes"]={
							{["dimensions"]={5,0,7,7},["dir"]={{1,-0.1},{1,0},{1,0.1}}},
							{["dimensions"]={1,2,5,7},["dir"]={{-0.2,-1},{-0.2,-1},{-0.2,-1}},["is_sour"]=true},
						}
					},
					{
						["frames"]=1,
						["sprites"]={0,0,199,200,201,  0,214,215,216,0,  0,0,231,0,0},
						["hitboxes"]={
							{["dimensions"]={21,4,6,5},["dir"]={{1,0.8},{1,1},{1,1}},["is_sweet"]=true},
							{["dimensions"]={19,2,9,8},["dir"]={{1,0.35},{1,0.6},{1,0.7}}},
							{["dimensions"]={12,0,14,7},["dir"]={{1,0.1},{1,0.3},{1,0.4}}},
							{["dimensions"]={8,0,4,7},["dir"]={{-0.2,-1},{-0.2,-1},{-0.2,-1}},["is_sour"]=true}
						}
					},
					{
						["frames"]=2,
						["sprites"]={0,0,202,203,204,  0,0,218,219,220,  0,0,234,235,236},
						["hitboxes"]={
							{["dimensions"]={23,5,7,14},["dir"]={{1,1},{0.6,1},{0.2,1}}},
							{["dimensions"]={21,6,6,16},["dir"]={{-0.1,-1},{-0.1,-1},{-0.1,-1}},["is_sour"]=true}
						}
					},
					{
						["frames"]=10,
						["sprites"]={0,0,202,203,0,  0,0,218,219,0,  0,0,234,235,237}
					}
				}
			},
			["lob"]={
				["charge"]={
					["sprites"]={0,65,66,0,0,  80,81,82,0,0,  96,97,98,0,0}
				},
				["parts"]={
					{
						["frames"]=3,
						["sprites"]={0,67,68,0,0,  0,83,84,0,0,  0,99,100,0,0},
						["hitboxes"]={
							{["dimensions"]={-1,17,9,7},["dir"]={{1,-0.2},{1,-0.3},{1,-0.4}}},
							{["dimensions"]={-3,16,6,8},["dir"]={{0.2,-1},{0.2,-1},{0.2,-1}},["is_sour"]=true}
						}
					},
					{
						["frames"]=3,
						["sprites"]={0,69,70,71,0,  0,85,86,87,0,  0,101,102,103,0},
						["hitboxes"]={
							{["dimensions"]={17,16,4,4},["dir"]={{1,-0.5},{1,-0.8},{0.9,-1}},["is_sweet"]=true},
							{["dimensions"]={11,15,13,9},["dir"]={{1.1,-1},{1.1,-1},{0.9,-1}}},
							{["dimensions"]={8,14,10,10},["dir"]={{-0.2,-1},{-0.2,-1},{-0.2,-1}},["is_sour"]=true}
						}
					},
					{
						["frames"]=2,
						["sprites"]={0,72,73,74,0,  0,88,89,90,0,  0,104,105,106,0},
						["hitboxes"]={
							{["dimensions"]={15,4,9,13},["dir"]={{0.4,-1},{0.3,-1},{0.2,-1}}},
							{["dimensions"]={13,9,11,15},["dir"]={{-0.1,-1},{-0.1,-1},{-0.1,-1}},["is_sour"]=true}
						}
					},
					{
						["frames"]=9,
						["sprites"]={0,72,73,74,0,  0,88,89,91,0,  0,104,105,0,0}
					}
				}
			}
		},
		["init"]=function(entity,args)
			entity.x=args.x
			entity.y=args.y
			entity.is_grounded=false
			entity.state="standing"
			entity.state_frames=0
			entity.swing="forehand"
		end,
		["pre_update"]=function(entity)
			entity.vy+=0.1
			entity.state_frames+=1
			if entity.is_grounded then
				-- swing when z is pressed
				if entity.state=="standing" or entity.state=="walking" then
					if btn(4) then
						entity.state="charging"
						entity.state_frames=0
						if btn(2) then
							entity.swing="spike"
						elseif btn(3) then
							entity.swing="lob"
						else
							entity.swing="forehand"
						end
						entity.swing_charge_level=1
					end
				end
				if entity.state=="charging" then
					entity.swing_charge_level=min(flr(1+entity.state_frames/15),3)
					if not btn(4) then
						entity.state="swinging"
						entity.state_frames=0
						entity.swing_id+=1
					end
				end
				if entity.state=="swinging" then
					local frames=0
					local i
					for i=1,#entity.swings[entity.swing].parts do
						frames+=entity.swings[entity.swing].parts[i].frames
						if entity.state_frames<frames then
							entity.swing_part=i
							break
						end
					end
					if entity.state_frames>=frames then
						entity.state="standing"
						entity.state_frames=0
					end
				end
				-- move left/right when arrow keys are pressed
				entity.vx=0
				if entity.state=="standing" or entity.state=="walking" then
					if btn(0) then
						entity.vx-=2
					end
					if btn(1) then
						entity.vx+=2
					end
					if entity.state=="standing" and entity.vx!=0 then
						entity.state="walking"
						entity.state_frames=0
					elseif entity.state=="walking" and entity.vx==0 then
						entity.state="standing"
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
			if entity.state=="swinging" then
				local hitboxes=entity.swings[entity.swing].parts[entity.swing_part].hitboxes
				local i
				for i=1,#balls do
					local ball=balls[i]
					local ball_left=ball.x
					local ball_right=ball.x+ball.width/2
					local ball_top=ball.y+ball.height/2
					local ball_bottom=ball.y+ball.height
					local j
					if ball.swing_id!=entity.swing_id and hitboxes then
						for j=1,#hitboxes do
							local hitbox=hitboxes[j]
							local hitbox_left=entity.x+hitbox.dimensions[1]
							local hitbox_right=entity.x+hitbox.dimensions[1]+hitbox.dimensions[3]
							local hitbox_top=entity.y+hitbox.dimensions[2]
							local hitbox_bottom=entity.y+hitbox.dimensions[2]+hitbox.dimensions[4]
							if hitbox_left<=ball_right and ball_left<=hitbox_right and hitbox_top<=ball_bottom and ball_top<=hitbox_bottom then
								ball.vx=hitbox.dir[entity.swing_charge_level][1]
								ball.vy=hitbox.dir[entity.swing_charge_level][2]
								local power_level=entity.swing_charge_level+1
								if power_level>=4 then
									power_level=5
								end
								if hitbox.is_sweet then
									power_level=max(2*power_level-2,3)
								elseif hitbox.is_sour then
									power_level=1
								end
								ball.set_power_level(ball,power_level)
								ball.swing_id=entity.swing_id
								ball.has_hit_court=false
								ball.can_hit_court=false
								ball.should_downgrade_power=false
								freeze_frames=max(freeze_frames,3)
								if hitbox.is_sweet then
									freeze_frames=max(freeze_frames,45)
								end
								break
							end
						end
					end
				end
			end
		end,
		["draw"]=function(entity)
			local x=entity.x+0.5
			local y=entity.y+0.5
			local sprites
			local hitboxes
			-- draw a silly rectangle
			-- rectfill(x,y,x+entity.width-1,y+entity.height-1,14)
			-- determine sprites based on state
			if entity.state=="swinging" then
				local swing_part=entity.swings[entity.swing].parts[entity.swing_part]
				sprites=swing_part.sprites
				hitboxes=swing_part.hitboxes
			elseif entity.state=="charging" then
				sprites=entity.swings[entity.swing].charge.sprites
			elseif entity.vx>0 then
				if entity.state_frames%12<6 then
					sprites={0,0,5,6,0,  0,20,21,22,0,  0,36,37,38,0}
				else
					sprites={0,7,8,9,0,  0,23,24,25,0,  0,39,40,41,0}
				end
			elseif entity.vx<0 then
				if entity.state_frames%12<6 then
					sprites={0,10,11,12,0,  0,26,27,28,0,  0,42,43,44,0}
				else
					sprites={0,13,14,15,0,  0,29,30,31,0,  0,45,46,0,0}
				end
			else
				sprites={0,1,2,0,0,  0,17,18,19,0,  0,33,34,0,0}
			end
			-- draw the sprites
			local i
			for i=1,#sprites do
				if sprites[i]>0 then
					spr(sprites[i],x+8*((i-1)%5)-9,y+8*flr((i-1)/5))
				end
			end
			-- visualize hitboxes
			-- if hitboxes then
			-- 	local i
			-- 	for i=#hitboxes,1,-1 do
			-- 		local hitbox=hitboxes[i]
			-- 		local d=hitbox.dimensions
			-- 		if hitbox.is_sour then
			-- 			color(8)
			-- 		elseif hitbox.is_sweet then
			-- 			color(14)
			-- 		else
			-- 			color(9)
			-- 		end
			-- 		rect(x+d[1],y+d[2],x+d[1]+d[3]-1,y+d[2]+d[4]-1)
			-- 	end
			-- end
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
					entity.do_bounce(entity,"bottom")
				end
			end
			-- hit the top of the play area
			if entity.y<game_top then
				entity.y=game_top
				if entity.vy<0 then
					entity.can_hit_court=true
					entity.check_for_power_level_change(entity)
					entity.do_bounce(entity,"top")
				end
			end
			-- hit the left wall of the play area
			if entity.x<game_left then
				entity.x=game_left
				if entity.vx<0 then
					entity.should_downgrade_power=true
					entity.can_hit_court=true
					entity.check_for_power_level_change(entity)
					entity.do_bounce(entity,"left")
				end
			end
			-- hit the right wall of the play area
			if entity.x>game_right-entity.width then
				entity.x=game_right-entity.width
				if entity.vx>0 then
					entity.should_downgrade_power=true
					entity.can_hit_court=true
					entity.check_for_power_level_change(entity)
					entity.do_bounce(entity,"right")
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
			-- if dir=="top" or dir=="bottom" then
			-- 	max_tiles_hit=ceil(entity.width/tile_width)
			-- end
			-- if entity.power_level>2 then
			-- 	max_tiles_hit=999
			-- end
			local num_tiles_hit=0
			foreach(tiles_hit,function(tile)
				if num_tiles_hit<max_tiles_hit then
					num_tiles_hit+=1
					freeze_frames=max(freeze_frames,3)
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
			if dir=="left" or dir=="right" then
				entity.vx*=-1
			end
			if dir=="top" or dir=="bottom" then
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
	["explosion"]={
		["init"]=function(entity,args)
			entity.x=(args.col-2)*tile_width
			entity.y=(args.row-2)*tile_height
			entity.col=args.col
			entity.row=args.row
		end,
		["update"]=function(entity)
			if entity.frames_alive==2 then
				freeze_frames=max(freeze_frames,3)
				local c
				for c=entity.col-1,entity.col+1 do
					local r
					for r=entity.row-1,entity.row+1 do
						if c!=entity.col or r!=entity.row then
							if tile_exists(c,r) then
								tiles[c][r].on_hit(tiles[c][r],nil,nil)
							end
						end
					end
				end
			end
			if entity.frames_alive>7 then
				entity.is_alive=false
			end
		end,
		["draw"]=function(entity)
			-- todo get an actual sprite
			rect(entity.x,entity.y,entity.x+3*tile_width-1,entity.y+3*tile_height-1,7)
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
	["r"]={ -- red gem
		["sprite"]=48,
		["hp"]=1
	},
	["g"]={ -- green gem
		["sprite"]=49,
		["hp"]=1
	},
	["y"]={ -- yellow gem
		["sprite"]=50,
		["hp"]=1
	},
	["s"]={ -- steel
		["sprite"]=51,
		["hp"]=2
	},
	["e"]={ -- explosive
		["sprite"]=53,
		["hp"]=1,
		["on_hit"]=function(tile,ball,dir)
			create_entity("explosion", {
				["col"]=tile.col,
				["row"]=tile.row	
			})
		end
	}
}
levels={
	{
		["tile_map"]={
			"                          ggg   ",
			"                y      yygggg   ",
			"                    yyyyyyggg   ",
			"                g         gggg  ",
			"                     eeeeggggg  ",
			"                r    eeeegg ggg ",
			"                gy s   ggg   gg ",
			"                ey    ggg    gg ",
			"                ry  rrrr     gg ",
			"                 ssrrrr r    gg ",
			"                 ssrrrr r   gg  ",
			"                 ssrrrrrr  ggg  ",
			"                 ssrrrrrr  gg   "
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
	bg_color=0
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
			else
				tile.sprite+=1
			end
			create_entity("tile_death_effect",{
				["x"]=(tile.col-1)*tile_width,
				["y"]=(tile.row-1)*tile_height,
			})
			if tile_def.on_hit then
				tile_def.on_hit(tile,ball,dir)
			end
		end
	}
end

function draw_tile(tile)
	if tile.sprite!=nil then
		local x=tile_width*(tile.col-1)
		local y=tile_height*(tile.row-1)
		spr(tile.sprite,x-2,y-2)
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
				local dir="right"
				if dx<0 then
					dir="left"
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
				local dir="bottom"
				if dy<0 then
					dir="top"
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
	if dir=="left" then
		return -len,0
	elseif dir=="right" then
		return len,0
	elseif dir=="top" then
		return 0,-len
	elseif dir=="bottom" then
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
08000800000000000000000008000800080008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00808000000000000000000000808000008080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00080000000000000000000000080000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00808000000000000000000000808000008080000000000000000000000000000022222220000000000000000000000000000000000000000000000000000000
08000800000000000000000008000800080008000022222220000000000000002222222222200000000000002222222000000000000000002222222000000000
0000000000000002222222000000000000000000222222222220000000000000222bbbbbbbbb0000000000222222222220000000000000222222222220000000
0000000000000222222222220000000000000000222bbbbbbbbb0000000002232bb42443bbbbb000000000222bbbbbbbbb000000000000222bbbbbbbbb000000
0000000000000222bbbbbbbbb0000000000022232bb42443bbbbb0000000222324442444244000000002232bb42443bbbbb000000002232bb42443bbbbb00000
08000800002232bb42443bbbbb000000000222232444244424400000000022202444244424400000002223244424442440000000002223244424442440000000
00808000022232444244424400000000002222202444244424400000000222000044444444000000002220244424442440000000002220244424442440000000
00080000022202444244424400000000000000000044444444000000000200000000444000000000000220004444444400000000000220004444444400000000
0080800002220004444444400000000000000000000044400000000000000000044f744f00000000000020000044400000000000000200000044400000000000
08000800002000000444000000000000000000000044f4470000000000000000444f777440000000000000004f444f4000000000000000004f444f4000000000
0000000000000004f444f40000000000000000000444f774400000000000000044f7774440000000000000044f777f4400000000000000ffff777f4400000000
0000000000000044f77744400000000000000000044f774440000000000000000447744470000000000000fff77777440000000000000f777f77774400000000
00000000000000447777440000000000000000000044744470000000000000ffffbffbbbb000000000000f777f7ff4400000000000000f7777fff44000000000
080008000000000447744700080008000000000000bbfbbbb000000000000f777ff777770000000000000f7777fbbbb00000000000000f777ffbbbbb08000800
0080800000000fff3ffbbb0000808000000000ffffff7777000000000000f7777f7777770000000000000f777ff7777700000000000000fff77777ff00808000
000800000000f777ff7777000008000000000f777f77ff770000000000000f77fff777ff00000000000000fff44f77ff0000000000000000f7777f4400080000
008080000000f777f777ff00008080000000f7777ff744f700000000000000ff444f7f44030000000000000004447f440000000000000000fff0344000808000
080008000000f777ff7f4400080008000000f777f034440000000000000000034444004443000000000000000044004440000000000000000444300008000800
000000000000ffff400044400000000000000fff0300400000000000000000300000000000000000000000003444000440000000000000000044400000000000
00000000000000300000003300000000000000000000330000000000000000000000000000000000000000000300000003300000000000000000330000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800080008000800000000000800080008000800
00eee80000aaab0000aaa900007776000076710000aa9900007a7a00007666000077aa0000766700006d5600008080000080800000777c000080800000808000
00e8880000abbb0000a9990000776d000066dd0000e8820000722a000067750000e882000067750000655d000008000000080000007ccc000008000000080000
0088820000bbb3000099940000766d000071610000a9940000a2890000675600007aa900006775000055d600008080000080800000ccc1000080800000808000
0082220000b3330000944400006dd50000d511000088220000a99900005675000082220000755600006d6d00080008000800080000c111000800080008000800
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08000800000000000000000000000000000000000000000000000000000000000000000000000000000000000800080008000800080008000800080008000800
00808000000000000000000000000000000000000000000000000000000000000000000000000000000000000080800000808000008080000080800000808000
00080000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000080000000800000008000000080000
00808000000000000000000000000000000000000000000000000000000000000000000002222222000000000080800000808000008080000080800000808000
080008000000000000000000000000000000000000000000222222200000000000000002222222bbbbb000000800080008000800080008000800080008000800
000000000000222222200000000000000000000000000022222222222000000000000002222bbb333bbffff00000000000000000000000000000000000000000
0000000000222222222220000000022222222200000000222bbbbbbbbb000000000022322bb4244424f777f00000000000000000000000000000000000000000
0000000000222bbbbbbbbb0002002222222222200002232bb4244423bbb00000000222322444244424f777f024f777f000000000000000000000000000000000
00000002232bb42443bbbbb02200222bbbbbbbb0002223244424442440000000000222022444244424f777f024f777f008000800080008000800080008000800
00000022232444244424400022232bb423bbbbbb002220244424442440000000002220000444444440ffffc040ffff0000808000008080000080800000808000
0000002220244424442440002223244424442440022000004444444000000000002000000004440000f0ccc000f0000000080000000800000008000000080000
00000022200044444444000022202444244424400000000000444000000000000000000004f7ff704f00ccc04f00000000808000008080000080800000808000
00000002000000444000000000000044444444000000000007fff70000000000000000004477f4444000ccc04000000008000800080008000800080008000800
0000000000044f4447f4400000000000444000000000000007f4477000000000000000004077744700000cc00000000000000000000000000000000000000000
0000000000444f7777f444000000000f444f4444000000000774447000000000000000000077777700000cc00000000000000000000000000000000000000000
000000000040077777700444c0000044f77f44040000000007777440000000000000000007bbbbbb0000cc000000000000000000000000000000000000000000
0000ffff0fff077777770000c00000447777700000000000bbbbbbbfff00000000000000077777770000cc000800080008000800080008000800080008000800
000f7777ff0003bbbbbb0000cccc0fff77777700000000007777777ff77ff000000000000ff777ff0000c0000080800000808000008080000080800000808000
000f7777f0000077777ff000ccfffff3bbbbbb0000000000ff777ff0f777f00000000000044f7f440000c0000008000000080000000800000008000000080000
000f777f00000fff77f44000cf777f0ff777f4400000000044f7f440f777f0000000000004440044000c00000080800000808000008080000080800000808000
0000fff000000444f0f44400cf777f044f77f440000000cc444c444ccffff0000000000044400044000000000800080008000800080008000800080008000800
0000000000000440000044000f7773444f0004400000000344ccc44cccc000000000000344000040000000000000000000000000000000000000000000000000
0000000000000300000000330ffff30000000033000000030ccccc33000000000000000300000033000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aaa9a99900000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000a944449900000000
007a7a00007a7a0000d5d500007676000065660000776d0000665d0000dadd0000077800000000000077aa00004942000000000000000000a444444900000000
00722a0000733a0000d5550000722600005886000076dd000062210000d9950000768d000000000000e88200009a940000000000000000009444444900000000
00a2890000a3b90000555100006285000068850000dd610000d2a100005985000067dd0000000000007aa9000049420000000000000000009444449400000000
00a9990000a9990000511100006555000056550000d511000061150000d55100000dd00000000000008222000024220000000000000000009444449400000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009949994400000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009994444400000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08000800000000000000000000000000000000000800080000000000000000000000000000000000000000000000000008000800080008000800080008000800
00808000000000000000000000000000000000000080800000000000000000000000000000000000000000000000000000808000008080000080800000808000
00080000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000080000000800000008000000080000
00808000000000000000000000000000000000000080800000000000000000000000000000000000022222220000000000808000008080000080800000808000
08000800000022222220000000000002222222000800080000000000222222200000000000000002222222222200000008000800080008000800080008000800
00000000002222222222200000000222222222220000000000000022222222222000000000000002222bbbbbbbbb000000000000000000000000000000000000
0000000000222bbbbbbbbb0000000222bbbbbbbb00000000000000222bbbbbbbb0000000000022322bb42444233bb00000000000000000000000000000000000
00000002232bb42443bbbbb0002232bb423bbbbbb00000000002232bb42443bbbbb0000000022232244424442400000000000000240000000000000000000000
00000022232444244424400002223244424442440000000000222324442444244000000000022202244424442400000000000000240000000800080008000800
000000222024442444244000022202444244424400000000002220244424442440000000000220000444444440000ffff000000040000fff0080800000808000
00000fff00004444444400000222000444444440000000000022000044444444000000000020000000044400000cf7777f0000000000f7770008000000080000
0000f777f0000044400000000200000004440000000000000020000000444000000000000000000000ff44f4044f77777f000000044f77770080800000808000
0000f7777f004f444f4000000c000004f444f40000000000000000044f77ff4000000000000000000f4477f44fff7777f00000004fff77770800080008000800
0000f77777f44f77744000000ccc0044f77744000000000000000044f77f77f400000000000000000f44444ffcccffff00000000f000ffff0000000000000000
00000fffffff4774444000000ccfffff777444000000000000000044477f77f4000000000000000000744477cccccc0000000000000000000000000000000000
000000000000ff44447700000cf7777fff444700000000000000c00444ff77f0000000000000000000bbbbbb0000000000000000000000000000000000000000
08000800000007bbbbbb00000cf7777fbbbbb0000800080000000cccbbbbf77f0800080000000000077777770800080008000800080008000800080008000800
00808000000000777777700000f777f77777700000808000000000cc7777f77f00808000000000000ff777770080800000808000008080000080800000808000
00080000000000f7777ff000000fff0f7777f000000800000000000ff7777ff00008000000000000044f77ff0008000000080000000800000008000000080000
00808000000004ff77f4440000000044f77f440000808000000000044f707740008080000000000004447f440080800000808000008080000080800000808000
08000800000004440004440000000444400444400800080000000044440004400800080000000000444004440800080008000800080008000800080008000800
00000000000004400000444000000444000004400000000000000344400004400000000000000003440004400000000000000000000000000000000000000000
00000000000003000000003300000300000000330000000000000300000000330000000000000030000000330000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000ccccccc00000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000800080000ccccccccccccccc0000000000000000000000000000000080008000800080008000800
00000000000000000000000000000ffff00000000000000000808000cc00cccccccccccccc000000000000000000000000000000008080000080800000808000
0000000000000000000000000000cf777f000000000000000008000000000000000cccfffff00000000000000000000000000000000800000008000000080000
000000022222220000000000000ccf77722222220000000000808000000000000000ccf777f00000000000000000000000000000008080000080800000808000
000002222222222200000000000ccf722222222222000000080008000002222222000f7777f0000000000000000000000c000000080008000800080008000800
00000222bbbbbbbbb000000000ccccf222bbbbbbbbb00000000000000222222222220f7777f00000000002222222000000c00000000000000000000000000000
002232bb42443bbbbb00000000cc2232bb42443bbbbb0000000000000222bbbbbbbb0f77ff000000000222222222220000cc0000000000000000000000000000
0222324442444244000000000cc2223244424442440000000000002232bb424442440fff00000000000222bbbbbbbbb0000c0000000000000000000000000000
0222024442444244080008000cc22202444244424400000000000222324442444244ff00000000002232bb42443bbbbb000cc000080008000800080008000800
02220f0444444440008080000cc22000044444444000000000000222024442444244f000000000022232444244424400000cc000008080000080800000808000
0020ff4004440400000800000cc200000004442200000000000020000004444444420000000000022202444244424400000ccc00000800000008000000080000
0ffff044f444f4400080800000cc000444f444f440000000000000000000044400200000000000022000044444444000000ccc00008080000080800000808000
f777f0044f777f400800080000c0004444f777f440000000000000000444f444f4400000000000020000004440000000000ccc00080008000800080008000800
f777f0004f7777f00000000000c000400f77777f00000000000000004444f777f40000000000000000044f444f440000000cccc0000000000000000000000000
f777f00007777770000000000000000007777777000000000000000040ff7777700000000000000000444f777f44400000ccccc0000000000000000000000000
f77f00000bbbbbb000000000000000000bbbbbb00000000000000000077777770000000000000000044ff777770044ff00ccccc0000000000000000000000000
0ff000000777777708000800000000007777777008000800080008000bbbbbbb0800080008000800000bbbbbb000000fffffccc0ffff00000800080008000800
000000007777777700808000000000007777777000808000008080000777777700808000008080000007777770000000f777ffc0f777ff000080800000808000
00000000fff777ff0008000000000000ff777ff000080000000800000ff777ff00080000000800000007ff77f0000000f7777fc0f7777f000008000000080000
00000000444f7f44008080000000000044f7f4400080800000808000044f7f440080800000808000000f44f7400000000f777f000f777f000080800000808000
0000000044400444080008000000000044400440080008000800080004444044080008000800080000004444400000000fffff000fffff000800080008000800
00000003440004400000000000000003440004400000000000000000003440400000000000000000000000444430000000000000000000000000000000000000
00000003000000330000000000000003000000330000000000000000003000330000000000000000000000330300000000000000000000000000000000000000
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

