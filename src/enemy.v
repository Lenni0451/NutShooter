module main

import rand
import math
import gx
import sokol.sapp

enum EnemyStatus {
	alive
	dead
}

struct Enemy {
	size f32
mut:
	speed f32
	x     f32
	y     f32
}

fn Enemy.new(mut game Game) !Enemy {
	mut enemy := Enemy{
		size: rand.f32_in_range(20, 40)!
	}
	if rand.bernoulli(0.5)! {
		enemy.x = rand.f32_in_range(0, game.gg.window_size().width)!
		enemy.y = if rand.bernoulli(0.5)! {
			-enemy.size
		} else {
			game.gg.window_size().height + enemy.size
		}
	} else {
		enemy.x = if rand.bernoulli(0.5)! {
			-enemy.size
		} else {
			game.gg.window_size().width + enemy.size
		}
		enemy.y = rand.f32_in_range(0, game.gg.window_size().height)!
	}
	enemy.speed = 200 - enemy.size * 4
	return enemy
}

fn (mut e Enemy) move(mut game Game) {
	_ := distance(e.x, e.y, game.player.x, game.player.y)

	angle := f32(math.atan2(game.player.y - e.y, game.player.x - e.x))
	speed := e.speed * sapp.frame_duration()
	e.x += f32(math.cos(angle) * speed)
	e.y += f32(math.sin(angle) * speed)
}

fn (mut e Enemy) render(mut game Game) {
	game.gg.draw_circle_filled(e.x, e.y, e.size, gx.red)
}
