module main

import rand
import math
import gx
import sokol.sapp

const meteor_speed = f32(300)

enum MeteorStatus {
	alive
	dead
	ended
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
	meteor.speed = meteor_speed - meteor.size * 4
	return meteor
}

fn (mut m Meteor) move(mut game Game) {
	dist := distance(m.x, m.y, game.player.x, game.player.y)
	if dist <= player_radius + m.size {
		game.game_state = .game_over
		m.status = .ended
		return
	}

	angle := f32(math.atan2(game.player.y - m.y, game.player.x - m.x))
	speed := m.speed * sapp.frame_duration()
	m.x += f32(math.cos(angle) * speed)
	m.y += f32(math.sin(angle) * speed)
}

fn (mut e Meteor) render(mut game Game) {
	game.gg.draw_circle_filled(e.x, e.y, e.size, gx.red)
}
