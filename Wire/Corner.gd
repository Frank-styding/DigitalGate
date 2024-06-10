extends Node2D
func set_color(n_color):
    var stylebox = StyleBoxFlat.new()
    stylebox.bg_color = n_color
    var radius = 5
    stylebox.corner_radius_bottom_left = radius
    stylebox.corner_radius_bottom_right = radius
    stylebox.corner_radius_top_right = radius
    stylebox.corner_radius_top_left = radius
    stylebox.draw_center = true
    $Panel.add_theme_stylebox_override("panel", stylebox)