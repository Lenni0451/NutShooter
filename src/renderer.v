module main

import gg
import gx

struct Renderer {}

fn (r Renderer) render_text(ctx gg.Context, x f32, y f32, text string, cfg gx.TextCfg) {
	ctx.set_text_cfg(cfg)
	ctx.ft.fons.set_size(cfg.size * ctx.scale)
	ctx.ft.fons.draw_text(x * ctx.scale, y * ctx.scale, text)
}

fn (r Renderer) render_button(ctx gg.Context, x f32, y f32, width f32, height f32, text string) bool {
	mouse_over := ctx.mouse_pos_x >= x - 5 && ctx.mouse_pos_x <= x + width
		&& ctx.mouse_pos_y >= y - 5 && ctx.mouse_pos_y <= y + height

	offset := if mouse_over {
		3
	} else {
		5
	}
	ctx.draw_rect_filled(x, y, width, height, gx.rgb(4, 57, 94))
	ctx.draw_rect_filled(x - offset, y - offset, width, height, gx.rgb(7, 103, 170))

	r.render_text(ctx, x - offset + width / 2, y - offset + height / 2, text, gx.TextCfg{
		size: 35
		align: gx.HorizontalAlign.center
		vertical_align: gx.VerticalAlign.middle
		color: gx.light_gray
	})

	return mouse_over
}
