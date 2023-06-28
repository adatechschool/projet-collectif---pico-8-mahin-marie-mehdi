pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
-- mahin mehdi marie project --

function _init()
	init_start()
end

function _update60()
 if(status==-1) update_start()
 if(status==0 or status==5) then
 	if (cmd==1 or btnp(🅾️)) then 
 		update_game()
 		cmd=1
 	end
 end
	if(status==1) update_game_over()
	if(status==2) update_victory()
	if(status==3) update_story()
	if(status==4) update_story_2()
	if(status==6) update_victory_2()
end

function _draw()
 if(status==-1) draw_start()
	if(status==0 or status==5) draw_game()
	if(status==1) draw_game_over()
	if(status==2) draw_victory()
	if(status==3) draw_story()
	if(status==4) draw_story_2()
	if(status==6) draw_victory_2()
end
-->8
--bullets

function shoot()
	new_bullet={
		x=p.x,
		y=p.y,
		w=4,
		h=4,
		speed=4,
	}
	add(bullets,new_bullet)
	sfx(0)
end


function update_bullets()
	for i in all(bullets) do
		i.x+=i.speed
		if i.x > 129 then
			del(bullets,i)
		end
	end

	for i in all(bullets) do
		for e in all(enemy) do
			if collision(e,i) then
				del(bullets,i)
				e.life-=1
				create_explosions(i.x+8,i.y)
				if e.life==0 then
					del(enemy,e)
				end
			end
		end
		if collide_map(i,"right",0) then
			del(bullets,i)
		end
	end
	if count(enemy)==0 and status==5 then
		init_victory_2()
		status=6
	end
	if count(enemy)==0 and status==0 then
		init_victory()
		status=2
	end
end

-->8
--background

function create_stars()
	stars={}
	for i=1,20 do
		new_star = {
			x = rnd(128),
			y = rnd(128),
			col = rnd({15,6,13}),
			speed = 1+rnd(1)
		}
		add(stars,new_star)
	end
		for i=1,8 do
			new_star = {
				x = rnd(128),
				y = rnd(128),
				col = 1,
				speed = 0.5+rnd(0.5)
			}
			add(stars,new_star)
		end
	end
	
function update_stars()
		for s in all(stars) do
			s.x-=s.speed
			if s.x<0 then
				s.x=128
				s.y=rnd(128)
			end
		end
	end
-->8
--asteroid
	
function create_asteroids(nombre)
	if nombre==1 then
		new_asteroid = {
				x = rnd({130, 136, 142}),
				y = rnd(120),
				style = rnd({6,7,8}),
				speed = rnd({0.5,1,1.5})
			}
			add(asteroids,new_asteroid)
	end
		
			if nombre>1 then
				for i=1,5 do
					new_asteroid = {
						x = rnd({130, 140, 160}),
						y = rnd(120),
						style = rnd({6,7,8}),
						speed = rnd({0.5,1,1.5})
					}
					add(asteroids,new_asteroid)
				end
			end
			
		if nombre>5 then
			for i=1,nombre-5 do
				new_asteroid = {
					x = rnd({150, 170, 190}),
					y = rnd(120),
					style = rnd({6,7,8}),
					speed = rnd({0.5,1,1.5})
				}
				add(asteroids,new_asteroid)
			end
		end
end
	

	function update_asteroids()
	for a in all(asteroids) do
		a.x-=a.speed
		if a.x<-8 then 
			del(asteroids,a)
			create_asteroids(1)
		end
	end
	for a in all(asteroids) do
		if collision(p,a) then
		 del (asteroids,a)
			p.life-=1
			sfx(5)
			if p.life==0 then
				status=1
			end
		end
		for b in all(bullets) do
		 if collision(b,a) then
		 del (bullets,b)
		 create_explosions(a.x,a.y)
			sfx(7)
			end
		end
	end
	end
-->8
-- map --

function draw_map()
	map(0,0,0,0,128,64)
end


-->8
-- player 
function create_player()
	p={x=10,y=30,sprite=1,life=5,h=8,w=8}
end

function draw_player()
	spr(p.sprite,p.x,p.y)
end

function player_movement()
 
 collide_map(p,aim,0)

	for e in all (enemy) do
	 if collision(e,p) then
	 	sfx(8)
	 	status=1
	 end
 end
 
	if (btn(➡️)) 
		and not collide_map(p,"right",0)
		and p.x<120
	then p.x+=1 
	
	elseif (btn(⬅️))
	 and not collide_map(p,"left",0)
	 and p.x>0
	then p.x-=1 
	
	elseif (btn(⬆️))
	 and not collide_map(p,"up",0)
	 and p.y>0 
	then p.y-=1 
	
	elseif (btn(⬇️))
	 and not collide_map(p,"down",0)
		and p.y<120
	then p.y+=1 
	end
	
end
-->8
-- update game

function update_game()
	-- stars --
	update_stars()	
	if btn(🅾️) then
		cmd=1
	end
		
	if cmd==1 then
		-- update position player --
		position = p.x
		player_movement()
		-- bullet function --
		if (btnp(4)) shoot()
			update_bullets()
		end
		-- asteroides --
		update_asteroids()	
		-- ennemy --
		update_enemies()	
		--shoot_enemy function
		for e in all(enemy) do
			if e.x==110 and #postillons<1
			then
				shoot_enemy(e)
			end
			update_postillons()
	end		
	update_explosions()
end

-- update game over

function update_game_over()
	update_stars()
 if (btnp(❎)) then
  status=0
  init_game()
 end
end

function draw_game_over()
	cls()
		for s in all(stars) do
		pset(s.x,s.y,s.col)
	end
	print("game over",45,50,7)
	print("❎: recommencer",35,110,7)
end

function init_victory()
	cls()
	status=2
	create_stars()
end

function update_victory()
 update_stars()
 if btn(❎) then 
 	status=4
 	init_story_2()
 end
end

function draw_victory()
	cls()
	for s in all(stars) do
		pset(s.x,s.y,s.col)
	end
	spr(66,0,0)
	for i=1,14 do
	spr(67,i*8,0)
	end
	spr(68,120,0)
	for i=1,14 do
	spr(84,120,i*8)
	end
	spr(100,120,120)
	for i=1,14 do
	spr(99,i*8,120)
	end
	spr(98,0,120)
	for i=1,14 do
	spr(82,0,i*8)
	end
	
	print("v",25,30,2)
	print("i",35,30,12)
	print("c",45,30,11)
	print("t",55,30,10)
	print("o",65,30,9)
	print("i",75,30,8)
	print("r",85,30,4)
	print("e",95,30,2)
	print("ce n'est que le debut...",15,60,6)
	
	print("❎: continuer",35,110,7)
end 

-- victoire finale

function init_victory_2()
	cls()
	status=6
	create_stars()
end

function update_victory_2()
 update_stars()
 if btn(❎) then 
 	status=-1
 	init_start()
 end
end

function draw_victory_2()
	cls()
	for s in all(stars) do
		pset(s.x,s.y,s.col)
	end
	spr(66,0,0)
	for i=1,14 do
	spr(67,i*8,0)
	end
	spr(68,120,0)
	for i=1,14 do
	spr(84,120,i*8)
	end
	spr(100,120,120)
	for i=1,14 do
	spr(99,i*8,120)
	end
	spr(98,0,120)
	for i=1,14 do
	spr(82,0,i*8)
	end
	
	print("v",25,30,2)
	print("i",35,30,12)
	print("c",45,30,11)
	print("t",55,30,10)
	print("o",65,30,9)
	print("i",75,30,8)
	print("r",85,30,4)
	print("e",95,30,2)
	print("felicitations",35,60,6)
	print("tu as vaincu le male",22,70,6)
	print("❎: menu principal",28,110,7)
end 


-->8
-- draw game

function draw_game()
	cls()
			-- affichage etoiles --
	for s in all(stars) do
		pset(s.x,s.y,s.col)
	end
	
	draw_map()
	if cmd!=1 then
	print("appuyer sur c pour tirer", 20,50,7)
	print("et commencer a jouer", 30,60,7)
	end
	if cmd==1 then
		-- affichage vie player --
		for i=0,p.life-1 do
			spr(37,i*8,0)
		end
		-- affichage vie trump --
			for i=1,count(enemy) do
				print(enemy[i].life.."/"..maxlife_boss,108,2+9*(i-1),7)
			end
		-- affichage bullets --
	for i in all(bullets) do
		spr(3,i.x,i.y)
	end
		-- affichage player --
	draw_player()

		-- affichage asteroides --
	for a in all(asteroids) do
		spr(a.style,a.x,a.y)
	end
	
		-- affichage reacteurs --
	if p.x > position 
		then spr(5,p.x-8,p.y)	
	end

		-- afichage ennemi --
	for e in all(enemy) do
		spr(2,e.x,e.y)
	end
			-- affichage reacteurs trump --
	for e in all(enemy) do
		spr(19,e.x,e.y+8)	
 end
		-- affichage postillons --
	for e in all(enemy) do
		for pt in all(postillons) do
		spr(4,pt.x-8,pt.y)
		end
	end
	
	-- affichage explosions
	draw_explosions()
	end
end
-->8
-- collisions

function collision(a,b)
	if a.y+8 < b.y
	or a.y   > b.y + 8
	or a.x+8 < b.x
	or a.x   > b.x + 8 then 
		return false
	else 
		return true
	end
end


function collide_map(obj,aim,flag)
		local x=obj.x	local y=obj.y
		local w=obj.w	local h=obj.h
		
		local x1=0	local y1=0
		local x2=0	local y2=0
		
		if aim=="left" then
			x1=x-1			y1=y
			x2=x					y2=y+h-1
		
		elseif aim=="right" then
			x1=x+w			y1=y
			x2=x+w+1	y2=y+h-1
		
		elseif	aim=="up" then
			x1=x+1			y1=y-1
			x2=x+w-1	y2=y
		elseif aim=="down" then
			x1=x					y1=y+h
			x2=x+w			y2=y+h
		end
	
	
	x1/=8		y1/=8
	x2/=8		y2/=8
	
	if fget(mget(x1,y1), flag)
	or fget(mget(x1,y2), flag)
	or fget(mget(x2,y1), flag)
	or fget(mget(x2,y2), flag) then
		return true
	else
		return false
	end
	
end
-->8
--enemies

function create_enemies()
		new_e={x=130,y=60,
				life=maxlife_boss,position_trump=0}
		add(enemy,new_e)
	if status==5 then
			new_e_2={x=130,y=30,
				life=maxlife_boss,position_trump=0}
		add(enemy,new_e_2)
			new_e_3={x=130,y=85,
				life=maxlife_boss,position_trump=0}
		add(enemy,new_e_3)
	end
end

function update_enemies()
	for e in all(enemy) do
		if e.x>110 then 
			e.x-=1
		end
		
		if e.x==110 then
			e.position_trump+=1
				
				if e.position_trump==15 then
				e.y+=3
				end
				
				if e.position_trump==30 then
				e.y-=3
				e.position_trump=0
				end
		end
	end
end

-->8
--bullets enemy

function shoot_enemy(e)
		new_postillon={
		x=e.x,
		y=e.y,
		speed=0.5
		}
		sfx(4)
		add(postillons,new_postillon)
end

function update_postillons()
		for pt in all(postillons) do
			pt.x-=pt.speed
			if pt.x<-10 then 
				del(postillons,pt)
			end
		end
		for pt in all(postillons) do
			if collision(p,pt) then
			 del(postillons,pt)
				p.life-=1
				create_explosions(pt.x,pt.y)
				if p.life==0 then
					status=1
				end
			end
		end
end
-->8
--explosions
-- explosions

function create_explosions(x,y)
	sfx(6)
	add(explosions,{x=x,
																	y=y,
																 timer=0})
end

function update_explosions()
	for e in all(explosions) do
		e.timer+=1
		if e.timer==13 then
			del(explosions,e)
		end
	end
end
	
function draw_explosions()
		circ(x,y,rayon,couleur)
		
		for e in all(explosions) do
			circ(e.x,e.y,e.timer/3,
								8+e.timer%3)
		end
end
-->8
--ecran d'accueil

function init_start()
 cls()
 music(0,0,0)
 status=-1
 create_stars()
end


-------------------------------
-- mise a jour ecran accueil --
-------------------------------

function update_start()

 update_stars()
 
 if (btnp(❎)) then
 status=0
	init_game()
 end
 
 if (btnp(🅾️)) then
 status=3
 init_story()
 end
 
end


function draw_start()
	cls()
	for s in all(stars) do
		pset(s.x,s.y,s.col)
	end
	print("❎ : jouer",
        45, 68, 7)
 print("🅾️ : intro",
        45, 75, 7)
end
-->8
-- init_game

function init_game()
 music(-1,0,0)
	create_player()
	if status==5 then
		maxlife_boss=15
	else
		maxlife_boss=30
	end
	enemy={}
	create_enemies()
	asteroids={}
	postillons={}
	bullets={}	
	position = p.x
	create_stars()
	if status==5 then
	 create_asteroids(8)
	else
		create_asteroids(10)
	end
	explosions={}
end
-->8
-- init_story

function init_story()
	cls()
	status=3
	create_stars()

end

function update_story()
 update_stars()
 if (btnp(❎)) then 
 	init_game()	
 	status=0
	end
end


function draw_story()
	cls()
	for s in all(stars) do
		pset(s.x,s.y,s.col)
	end
	print("❎ : jouer",
       50, 100, 7)
-- print("🅾️ : menu",
--        80, 120, 7)
 print("dans un passe pas si lointain",10,10)
 print("un certain donald",34,20)
 print("prit le controle de l'empire.",10,30)
 print("tu es le dernier espoir",20,50)
 print("pour renverser l'oppresseur",12,60)
 print("et retablir l'egalite...",20,70)
 
end

-- init story 2

function init_story_2()
	cls()
	status=4
	create_stars()
end

function update_story_2()
	 update_stars()
 if (btnp(🅾️)) then
 		status=5
			init_game()
 end
end

function draw_story_2()
		cls()
	for s in all(stars) do
		pset(s.x,s.y,s.col)
	end
	print("🅾️: niveau 2",
       43, 110, 7)
 print("tu n'as gagne qu'une bataille",8,10)
 print("il te faut gagner la guerre",12,20)
 print("",10,30)
 print("des groupuscules subsistent",15,50)
 print("a toi de terminer le travail",13,60)
 print("bon chance.",45,90)
end
-->8
--level 2--
__gfx__
0000000006bb000009999990000000000000000008089a7000066600000000000000000000000000000000000000000000000000000000000000000000000000
000000000033333000aaaa9002c3a98000600000000000000066656000066000000566000000feee222999eeeee0000008000000000000000000000000000000
007007006b3bbb000aacacaa00000000000070008089a700065666600656660006666660000fee88882299999e88800000000000000000000000000000000000
000770000b337cbb00aaaaa000000000000000600000000065666666066666006655656600fee88888822999eeee880000000000000000000000000000000000
000770000b33ccbb00a00aa00000000006000600000000006666666006665600066566560fee88888828229eeee8800000000000000000000000000000000000
007007006b3bbb000117871100000000000000008089a700066655600066000000666660fee88888828222299e88888000000000000000000000000000000000
00000000003333300a17871a02c3a9800070000000000000006656000000000000066000feee88888828222999e8888880080000000000000000000000000000
0000000006bb000009178719000000000000000008089a70000660000000000000000000fee8e88888822229999ee88000000000000000000000000000000000
000000000000000001007001000000000000000000000800000000000000000000000000feee88882822222999eeeee800000000000000000000000000000000
000000000000000001077701007000700000000000000900000000000000000000000000fee8e888828222299eeee88880000800000000000000000000000000
00000000000000000800700800a000a00000000000000a70000000000000000000000000fee8888888282229eeee880000000000000000000000000000000000
0000000000000000070070070090009000000000000800000000000000000000000000000fee88888882229eee88888800000000000000000000000000000000
00000000000000000800000800900090000000000008000000000000000000000000000000fee88882822999e888800000000000000000000000000000000000
000000000000000007007007008000800000000000080000000000000000000000000000000fee8888229eeeee80008000000000000000000000000000000000
000000000000000000000000000000000000000000099a700000000000000000000000000000feee222999000000000000000000000000000000000000000000
00000000000000000a00700a00800080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000666666660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000006dddddd10000000000000000000000000007070000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000006d1111d10000000000000000000000000078787000080800000808000000000000000000000000000000000000000000000000000000000000000000
000000006d1dd6d10000000000000000000000000788888700878880008788800000000000000000000000000000000000000000000000000000000000000000
000000006d1dd6d10000000000000000000000000787888700888880008888800000000000000000000000000000000000000000000000000000000000000000
000000006d1666d10000000000000000000000000078887000088800000888000000000000000000000000000000000000000000000000000000000000000000
000000006dddddd10000000000000000000000000007870000008000000080000000000000000000000000000000000000000000000000000000000000000000
00000000111111110000000000000000000000000000700000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000a070000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000099aa0000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000aa0000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000aaaa00000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000aaaaa0000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000aaaa00000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000090900000000000000000000000000000000000000000000000000
00000000000000002222222222222222222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002cccccccccccccccccccccc20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002c33333333333333333333c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002c3aaaaaaaaaaaaaaaaaa3c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002c3a9999999999999999a3c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002c3a9888888888888889a3c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002c3a9800000000000089a3c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002c3a9800000000000089a3c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002c3a9800000000000089a3c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002c3a9800000000000089a3c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002c3a9800000000000089a3c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002c3a9800000000000089a3c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002c3a9800000000000089a3c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002c3a9800000000000089a3c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002c3a9800000000000089a3c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002c3a9800000000000089a3c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002c3a9800000000000089a3c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002c3a9800000000000089a3c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002c3a9888888888888889a3c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002c3a9999999999999999a3c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002c3aaaaaaaaaaaaaaaaaa3c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002c33333333333333333333c20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002cccccccccccccccccccccc20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000002222222222222222222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000010000000101010000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000002100000000210000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000002100000000210000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000002100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000002100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000002100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000021000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000021000000000021000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000021000000000021000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000021000000000021000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000021000000000021000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000021000000000021000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000002100000000210000002100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0001000039050380503705036050350503305032050300402c0402802025010210101b050120500e0500905006050040500000000000000000000000000000000000000000000000000000000000000000000000
0010000000000260502605025050220501f0501d0501b05019050190501b0501d0501f0501b0501b05016050120500b050090500f0500a0500905005050050500000000000000000000000000000000000000000
00040000000002415022150201501d1501b15016150151500f1500b15009150051500315002150011500115002150000000115001150000000000000000000000000000000000000000000000000000000000000
0010000034550345503455033550315502f5502c5502a55027550255502355021550205501d5501b5501a550155501a5501b5501d5501d5501f5502255025550285502a5502d5502f55030550315503255032550
000200000735008350083500835008350063500435000350003500f3000f3000e3000d3000b300073000530003300013000030007300023000130000300023000b30000300003000030000300003000130000300
001000000060004650026500065007600056000360002600016000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
00010000196501d6501f65024650226501b65018650146501d60017600316003160032600336003360034600346003460002600346003460034600346003360032600316002e6002a60026600206001c60011600
0004000027650186500b6500665003650026500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000f00001d6501d6501c6501865015650116500d65008650056500265001650006500065000650006000060000600006000060000600076000160000600006000560004600026000060000600006000060000600
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000002d7402d725307452d7352d7402d7202d715000002d7402d725307452d74528740287252b745287452d7402d725307452d7352d7402d7202d715000002d7402d725307452d74528740287252b74528745
001000001c1001c0002110021000210002100015100150001500015000000000000000000000001c1401c03021140210302102021010151401503015020150100000000000000000000000000000001014010030
001000011572400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000002d7402d7302d725000001c7401c7201f7401c7102174021730217200000028740287202b740287102d7402d7302d72500000347403472037740347103974039730397250000004140040200714004140
001000001514015030150250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000914409144091440914409144091440914409144091440914409144091440914409144091440914409144091440914409144091440914409144091440914409144091440914409144091440914409144
00100000285471c537285271c517265471a537265271a517285471c547285371c53700000180002454024530265471a537265271a51723547175372352717517285471c547285371c537285271c527285171c517
001000040c04300015000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000002403024720247102471023030237202371023710240302472024710247102471500000210302172023030237202371023710210302172021710217102403024730247202472024020247102471024715
001000000e1400e1300e1200e1100c1400c1300c1200c1100b1400b1300b1200b1100914009130091200911007140071300712007110051400513005120051100414004130041200411002140021300212002110
001000002104021025240452103521040210202101500000210402102526045210352104021020210150000021040210252804521035210402102021015000002104021025290452103521040210202101500000
0010000021736287362d7262872621516287162d5162871621736287362d7262872621516287162d5162871621736287362d7262872621516287162d5162871621716287162d7162871621516287162d51628716
00100000155601555015540155321856018550185401853210560105601055010550105421054215560155501a5601a5501a5401a5321c5601c5601c5601c5501c5501c5501c5421c5321c525000000000000000
00100000215602156021550215502154021540215322152221515000001f5601f53018560185301d5601d5301a5601a5601a5501a5501a5401a5321a5201a5101a5621a5601a5501a5501a5401a5301a5221a512
001000000914009130091200911509140091300912009115091400913009120091150914009130091200911509140091300912009115091400913009120091150914009130091200911509140091300912009115
00100000150201571018020187101a0201a7101c0201c71015020157101c0201c71024020247101c0201c71015020157101c0201c7102402024710307452d7352d7402d725307452d7302d7452d7201c0201c710
001000001556015550155401553215532155321a56018560175601755017540175321856018550185421853215560155601556015550155501555015540155401554015530155321553215535000000000000000
0010000015020157101c0201c71024020247101c0201c71015020157101c0201c71018020187101c0201c7101e0301e0201e0101e0102d7402d725307452d7352d7402d725327452d7352d7402d725307452d735
001000000914009130091200911509140091300912009115091400913009120091150914009130091200911509140091300912009115091400913009120091150914009130091200911509140091300912009115
0010000015560155501554015532185601855018540185321556015560155501555215540155401c5601c5501e5601e5501e5401e5321a5601a5601a5601a5501a5501a5501a5431a5351a525000000000000000
001000002d7402d7201c0201c71024020247101c0201c71015020157101c0201c71018020187101c0201c7100e0200e71015020157101e0201e7102102021710240202471021020217101e0201e7101502015710
00100000091400913009120091150914009130091200911509140091300912009115091400913009120091150a1400a1300a1200a1150a1400a1300a1200a1150a1400a1300a1200a1150a1400a1300a1200a115
00100000000000000015020157101c0201c71021020217102402024020240202402024010247102401024710000000000016020167101d0201d7102202022710260202671022020227101d0201d7101602016710
001000000514005130051200511505140051300512005115051400513005120051150514005130051200511504140041300412004115041400413004120041150214002130021200211502140021300212002115
001000000014000130001200011500140001300012000115051400513005120051150514005130051200511505140051300512005115051400513005120051150714007130071200711507140071300712007115
001000001d5601d5601d5501d5501d5401d5401d5321d5221d515000001c5601c53010560105301a5601a53017560175601755017550175401753017522175121756017560175501755017540175321752017512
001000001856018560185501855018540185401853218522185150000017560175300e5600e530175601753015560155601555015550155401553015522155121356013560135501355013540135321352213512
001000000000000000110201171018020187101d0201d710210202102021020210202101021710210102171000000000002002020710230202371020020207101a0201a7101e0201e71023020237101e0201e710
0010000000000000001c0201c7101f0201f7101c0201c71021020217101f0201f7101d0201d7101f0201f7101d7101d710180201871021020217101d0201d71023020237101a0201a7101f0201f7102302023710
001000001556015560155601555015550155501554015540155401553015530155301552015520155201552015520155201552015520155201552015520155201552015520155101551015512155121551215510
001000000914009130091200911009110091100911009110091100911009110091150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000002151021510215102151021510215102151021510215102151021510215102151021510215102151021510215102151021510215102151021510215102151021512215122151221515000000000000000
__music__
01 10421244
00 10111244
00 13141244
00 16181715
00 16181715
00 10121715
00 1a1b1719
00 1c1f171e
00 20211722
00 23241722
00 1d261725
00 292b1727
00 2a2c1728
00 2d16182e
02 2f161844

