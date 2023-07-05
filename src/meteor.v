module main

import rand
import math
import gx
import sokol.sapp

enum MeteorStatus {
	alive
	dead
}

struct Meteor {
	size f32
mut:
	status MeteorStatus = .alive
	speed  f32
	x      f32
	y      f32
}

fn Meteor.new(mut game Game) !Meteor {
	mut meteor := Meteor{
		size: rand.f32_in_range(20, 40)!
	}
	if rand.bernoulli(0.5)! {
		meteor.x = rand.f32_in_range(0, game.gg.window_size().width)!
		meteor.y = if rand.bernoulli(0.5)! {
			-meteor.size
		} else {
			game.gg.window_size().height + meteor.size
		}
	} else {
		meteor.x = if rand.bernoulli(0.5)! {
			-meteor.size
		} else {
			game.gg.window_size().width + meteor.size
		}
		meteor.y = rand.f32_in_range(0, game.gg.window_size().height)!
	}
	meteor.speed = 200 - meteor.size * 4
	return meteor
}

fn (mut e Meteor) move(mut game Game) {
	dist := distance(e.x, e.y, game.player.x, game.player.y)
	if dist <= player_radius + e.size {
		game.game_state = .game_over
	}

	angle := f32(math.atan2(game.player.y - e.y, game.player.x - e.x))
	speed := e.speed * sapp.frame_duration()
	e.x += f32(math.cos(angle) * speed)
	e.y += f32(math.sin(angle) * speed)
}

fn (mut e Meteor) render(mut game Game) {
	game.gg.draw_circle_filled(e.x, e.y, e.size, gx.red)
}
