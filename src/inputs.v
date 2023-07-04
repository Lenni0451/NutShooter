module main

import gg

struct Input {
}

fn mousedown(x f32, y f32, button gg.MouseButton, mut game Game) {
	println(button)
}

fn keydown(key_code gg.KeyCode, modifier gg.Modifier, mut game Game) {
	game.gg.scale += 0.25
	if game.gg.scale > 2 {
		game.gg.scale = 1
	}
	println(game.gg.scale)
}
