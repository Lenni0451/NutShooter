module main

import gg

struct Input {
mut:
	mouse_x f32
	mouse_y f32
}

fn mousemove(x f32, y f32, mut game Game) {
	game.input.mouse_x = x
	game.input.mouse_y = y
}

fn keydown(key_code gg.KeyCode, modifier gg.Modifier, mut game Game) {
	game.gg.scale += 0.25
	if game.gg.scale > 2 {
		game.gg.scale = 1
	}
	println(game.gg.scale)
}
