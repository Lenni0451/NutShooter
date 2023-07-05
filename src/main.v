module main

import gg
import gx
import time

enum GameState {
	main_menu
	ingame
	game_over
}

struct Game {
mut:
	gg          &gg.Context = unsafe { nil }
	game_state  GameState   = GameState.main_menu
	input       Input
	player      &Player = unsafe { nil }
	meteors     []Meteor
	nuts        shared []Nut
	score       int
	last_meteor time.Time
}

fn main() {
	mut game := &Game{}
	game.gg = gg.new_context(gg.Config{
		width: 700
		height: 500
		create_window: true
		bg_color: gx.rgb(120, 120, 120)
		window_title: game_name
		user_data: game
		font_bytes_normal: assets_font_regular.to_bytes()
		font_bytes_bold: assets_font_bold.to_bytes()
		frame_fn: render_loop
		keydown_fn: keydown
		keyup_fn: keyup
		click_fn: mousedown
	})
	game.gg.run()
}

fn render_loop(mut game Game) {
	ctx := game.gg

	width := ctx.window_size().width
	height := ctx.window_size().height
	half_width := width / 2

	ctx.begin()
	match game.game_state {
		.main_menu {
			Renderer.render_text(ctx, half_width + 5, 35, game_name, gx.TextCfg{
				size: 100
				bold: true
				color: gx.dark_green
				align: gx.HorizontalAlign.center
			})
			Renderer.render_text(ctx, half_width, 30, game_name, gx.TextCfg{
				size: 100
				bold: true
				color: gx.green
				align: gx.HorizontalAlign.center
			})

			mut has_hovered := false
			if Renderer.render_button(ctx, 50, height - 175, width - 100, 50, 'Start Game!') {
				game.input.hovered_button = .start
				has_hovered = true
			}
			if Renderer.render_button(ctx, 50, height - 100, width - 100, 50, 'Scale: ${ctx.scale}') {
				game.input.hovered_button = .scale
				has_hovered = true

				Renderer.render_text(ctx, ctx.mouse_pos_x + 10, ctx.mouse_pos_y + 10,
					r"If it's broken choose another one ¯\_:)_/¯", &gx.TextCfg{
					size: 20
					color: gx.rgb(255, 255, 0)
				})
			}
			if !has_hovered {
				game.input.hovered_button = .@none
			}
		}
		.ingame {
			mut to_remove := []int{}
			lock game.nuts {
				for i, mut nut in game.nuts {
					nut.move(mut game)
					if nut.status == .dead {
						to_remove << i
					} else {
						nut.render(mut game)
					}
				}
				to_remove.reverse_in_place()
				for i in to_remove {
					game.nuts.delete(i)
				}
			}

			game.player.move(mut game)
			game.player.render(mut game)

			now := time.now()
			if now - game.last_meteor >= 500 * time.millisecond {
				game.last_meteor = now
				game.meteors << Meteor.new(mut game) or { panic(err) }
			}

			to_remove.clear()
			for i, mut meteor in game.meteors {
				if meteor.status == .alive {
					meteor.move(mut game)
					if meteor.status == .ended {
						return
					}
				}
				if meteor.status == .dead {
					to_remove << i
				} else {
					meteor.render(mut game)
				}
			}
			to_remove.reverse_in_place()
			for i in to_remove {
				game.meteors.delete(i)
			}

			if !game.input.pressed_anything {
				Renderer.render_text(ctx, 10, height - 50, 'WASD to move', gx.TextCfg{
					size: 30
					color: gx.white
				})
				Renderer.render_text(ctx, 10, height - 30, 'LMB to shoot', gx.TextCfg{
					size: 30
					color: gx.white
				})
			}
		}
		.game_over {
			Renderer.render_text(ctx, half_width + 5, 35, 'Game Over', gx.TextCfg{
				size: 100
				bold: true
				color: gx.dark_red
				align: gx.HorizontalAlign.center
			})
			Renderer.render_text(ctx, half_width, 30, 'Game Over', gx.TextCfg{
				size: 100
				bold: true
				color: gx.red
				align: gx.HorizontalAlign.center
			})
			Renderer.render_text(ctx, half_width + 5, 150, 'Score: ${game.score}', gx.TextCfg{
				size: 50
				bold: true
				color: gx.white
				align: gx.HorizontalAlign.center
			})
			Renderer.render_text(ctx, half_width, height - 50, 'Press space to return to main menu...',
				gx.TextCfg{
				size: 30
				color: gx.white
				align: gx.HorizontalAlign.center
			})
		}
	}
	ctx.end()
}
