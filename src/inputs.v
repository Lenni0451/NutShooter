module main

import gg

enum Button {
	start
	scale
}

struct Input {
mut:
	hovered_button Button
}

fn mousedown(x f32, y f32, button gg.MouseButton, mut game Game) {
	if button == .left {
		match game.game_state {
			.main_menu {
				match game.input.hovered_button {
					.start {}
					.scale {
						game.gg.scale += 0.25
						if game.gg.scale > 2 {
							game.gg.scale = 1
						}
					}
				}
			}
			.ingame {}
			.game_over {}
		}
	}
}

fn keydown(key_code gg.KeyCode, modifier gg.Modifier, mut game Game) {
}
