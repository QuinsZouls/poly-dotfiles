local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local Animation = require('animations')
local dpi = beautiful.xresources.apply_dpi
panel_visible = false

local vertical_separator =  wibox.widget {
	orientation = 'vertical',
	forced_height = dpi(1),
	forced_width = dpi(1),
	span_ratio = 0.55,
	widget = wibox.widget.separator
}

local tag_center = function(s)
	-- Set the info center geometry
	local panel_width = dpi(350)
	local panel_margins = dpi(5)

	local panel = awful.popup {
		widget = {
			{
				{
					layout = wibox.layout.fixed.vertical,
					forced_width = dpi(panel_width),
					forced_height = s.geometry.height,
					spacing = dpi(10),
				},
				margins = dpi(16),
				widget = wibox.container.margin
			},
			id = 'tag_center',
			bg = beautiful.background,
			widget = wibox.container.background
		},
		screen = s,
		type = 'dock',
		visible = false,
		ontop = true,
		width = dpi(panel_width),
		maximum_width = dpi(panel_width),
		maximum_height = dpi(s.geometry.height),
		bg = beautiful.transparent,
		fg = beautiful.fg_normal,
		shape = gears.shape.rectangle
	}

	awful.placement.top_left(
		panel,
		{
			honor_workarea = true,
			parent = s,
			margins = {
				top = dpi(0),
				right = dpi(0)
			}
		}
	)

	panel.opened = false

	s.backdrop_tag_center = wibox {
		ontop = true,
		screen = s,
		bg = beautiful.transparent,
		type = 'utility',
		x = s.geometry.x,
		y = s.geometry.y,
		width = s.geometry.width,
		height = s.geometry.height
	}

	local open_panel = function()
		local focused = awful.screen.focused()
		panel_visible = true

		focused.backdrop_tag_center.visible = true
		focused.tag_center.visible = true

		panel:emit_signal('opened')
	end

	local close_panel = function()
		local focused = awful.screen.focused()
		panel_visible = false

		focused.tag_center.visible = false
		focused.backdrop_tag_center.visible = false

		panel:emit_signal('closed')
	end

	-- Hide this panel when app dashboard is called.
	function panel:hide_dashboard()
		close_panel()
	end

	function panel:toggle()
		self.opened = not self.opened
		if self.opened then
			open_panel()
		else
			close_panel()
		end
	end

	s.backdrop_tag_center:buttons(
		awful.util.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					panel:toggle()
				end
			)
		)
	)

	return panel
end

return tag_center
