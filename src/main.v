module main

import os
import gg
import gx

enum GameState {
	main_menu
	ingame
	game_over
}

struct Game {
	renderer Renderer
mut:
	gg         &gg.Context = unsafe { nil }
	game_state GameState   = GameState.main_menu
	input      Input
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
		move_fn: mousemove
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
			game.renderer.render_text(ctx, half_width+5, 35, game_name, gx.TextCfg{
				size: 100
				bold: true
				color: gx.dark_green
				align: gx.HorizontalAlign.center
			})
			game.renderer.render_text(ctx, half_width, 30, game_name, gx.TextCfg{
				size: 100
				bold: true
				color: gx.green
				align: gx.HorizontalAlign.center
			})
			game.renderer.render_button(ctx, 50, height - 175, width - 100, 50, 'Start Game!')
			game.renderer.render_button(ctx, 50, height - 100, width - 100, 50, 'Scale: ${ctx.scale}')
		}
		.ingame {}
		.game_over {}
	}
	ctx.end()
}
