module main

import gg
import time

enum Button {
	start
	scale
}

struct Input {
mut:
	hovered_button Button
	w_down         bool
	a_down         bool
	s_down         bool
	d_down         bool
}

fn mousedown(x f32, y f32, button gg.MouseButton, mut game Game) {
	if button == .left {
		match game.game_state {
			.main_menu {
				match game.input.hovered_button {
					.start {
						game.player = &Player{
							x: game.gg.window_size().width / 2
							y: game.gg.window_size().height / 2
						}
						game.enemies = []Enemy{}
						game.score = 0
						game.last_enemy = time.now()
						game.game_state = .ingame
					}
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
	match game.game_state {
		.main_menu {}
		.ingame {
			match key_code {
				.w {
					game.input.w_down = true
				}
				.a {
					game.input.a_down = true
				}
				.s {
					game.input.s_down = true
				}
				.d {
					game.input.d_down = true
				}
				else {}
			}
		}
		.game_over {
			game.game_state = .main_menu
		}
	}
}

fn keyup(key_code gg.KeyCode, modifier gg.Modifier, mut game Game) {
	match key_code {
		.w {
			game.input.w_down = false
		}
		.a {
			game.input.a_down = false
		}
		.s {
			game.input.s_down = false
		}
		.d {
			game.input.d_down = false
		}
		else {}
	}
}
