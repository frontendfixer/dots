local colors = require("lib.colors")

hl.config({
    dwindle = {
        preserve_split = true,
        special_scale_factor = 0.8,
    },
})

hl.config({
    master = {
        new_status = "master",
        new_on_top = 1,
        mfact = 0.5,
    },
})

hl.config({
    general = {
        border_size = 2,
        gaps_in = 6,
        gaps_out = 8,
        resize_on_border = true,
        layout = "dwindle",
        col = {
            active_border = colors.color12,
            inactive_border = colors.background,
        },
    },
})

hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        repeat_rate = 50,
        repeat_delay = 300,
        sensitivity = 0,
        numlock_by_default = true,
        left_handed = false,
        follow_mouse = true,
        float_switch_override_focus = false,
        touchpad = {
            disable_while_typing = true,
            natural_scroll = false,
            clickfinger_behavior = false,
            middle_button_emulation = true,
            tap_to_click = true,
            drag_lock = false,
        },
        touchdevice = {
            enabled = true,
        },
        tablet = {
            transform = 0,
            left_handed = 0,
        },
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

hl.config({
    gestures = {
        workspace_swipe_distance = 500,
        workspace_swipe_invert = true,
        workspace_swipe_min_speed_to_force = 30,
        workspace_swipe_cancel_ratio = 0.5,
        workspace_swipe_create_new = true,
        workspace_swipe_forever = true,
    },
})

hl.config({
    group = {
        col = {
            border_active = colors.color15,
        },
        groupbar = {
            col = {
                active = colors.color0,
            },
        },
    },
})

hl.config({
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        vrr = 2,
        mouse_move_enables_dpms = true,
        enable_swallow = true,
        swallow_regex = "^(kitty)$",
        focus_on_activate = false,
        initial_workspace_tracking = 0,
        middle_click_paste = false,
    },
})

hl.config({
    binds = {
        workspace_back_and_forth = true,
        allow_workspace_cycles = true,
        pass_mouse_when_bound = false,
    },
})

hl.config({
    xwayland = {
        enabled = true,
        force_zero_scaling = true,
    },
})

hl.config({
    render = {
        direct_scanout = false,
    },
})

hl.config({
    cursor = {
        sync_gsettings_theme = true,
        no_hardware_cursors = 2,
        enable_hyprcursor = true,
        warp_on_change_workspace = 2,
        no_warps = true,
    },
})
