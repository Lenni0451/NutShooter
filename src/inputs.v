module main

import gg
import time

enum Button {
	@none
	start
	scale
}

struct Input {
mut:
	hovered_button   Button
	pressed_anything bool
	w_down           bool
	a_down           bool
	s_down           bool
	d_down           bool
}

fn mousedown(x f32, y f32, button gg.MouseButton, mut game Game) {
	if button == .left {
		match game.game_state {
			.main_menu {
				match game.input.hovered_button {
					.@none {}
					.start {
						game.player = &Player{
							x: game.gg.window_size().width / 2
							y: game.gg.window_size().height / 2
						}
						game.meteors = []Meteor{}
						lock game.nuts {
							game.nuts = []Nut{}
						}
						game.score = 0
						game.last_meteor = time.now()
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
			.ingame {
				game.input.pressed_anything = true
				lock game.nuts {
					game.nuts << Nut.new(mut game)
				}
			}
			.game_over {}
		}
	} else if button == .right {
		if game.input.hovered_button == .scale {
			game.gg.scale -= 0.25
			if game.gg.scale < 1 {
				game.gg.scale = 2
			}
		}
	}
}

fn keydown(key_code gg.KeyCode, modifier gg.Modifier, mut game Game) {
	match game.game_state {
		.main_menu {}
		.ingame {
			match key_code {
				.w {
					game.input.pressed_anything = true
					game.input.w_down = true
				}
				.a {
					game.input.pressed_anything = true
					game.input.a_down = true
				}
				.s {
					game.input.pressed_anything = true
					game.input.s_down = true
				}
				.d {
					game.input.pressed_anything = true
					game.input.d_down = true
				}
				else {}
			}
		}
		.game_over {
			if key_code == .space {
				game.game_state = .main_menu
			}
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
