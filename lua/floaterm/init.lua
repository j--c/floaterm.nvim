local M = {}


-- floating terminal state
local floaterm_state = {
    buf = -1,
    win = -1
}

local function get_float_cfg(opts)

    -- get height and width of window
    local ui = vim.api.nvim_list_uis()[1]

    -- calc float size
    local width = opts.width or math.floor(ui.width * 0.8)
    local height = opts.height or math.floor(ui.height * 0.8)
    return {
        relative = 'editor',
        width = width,
        height = height,
        col = math.floor((ui.width - width) / 2),
        row = math.floor((ui.height - height) / 2),
        style = 'minimal',
        border = 'rounded',
    }
end

local function create_floating_win(opts)
    opts = opts or {}

    -- create or use existing buffer
    local float_buf = nil
    if vim.api.nvim_buf_is_valid(opts.buf) then
        float_buf = opts.buf
    else
        float_buf = vim.api.nvim_create_buf(false, true)
    end

    -- define window config
    local float_cfg = get_float_cfg(opts)

    -- create a window
    local float_win = vim.api.nvim_open_win(float_buf, true, float_cfg)

    -- return buffer and window
    return  { buf = float_buf, win = float_win }
end

local function create_floating_term(opts)

    local float_win = create_floating_win(opts)

    -- turn it into terminal if necessary
    if vim.bo[float_win.buf].buftype ~= 'terminal' then
        vim.cmd.terminal()
    end

    -- return buffer and window
    return  { buf = float_win.buf, win = float_win.win }
end


---------------------------
--   Public Interface    --
--       (below)         --
---------------------------

-- toggle the terminal
M.toggle_term = function(opts)
    opts.buf = floaterm_state.buf
    if vim.api.nvim_win_is_valid(floaterm_state.win) then
        vim.api.nvim_win_hide(floaterm_state.win)
    else
        opts.buf = floaterm_state.buf
        floaterm_state = create_floating_term(opts)
    end
end

return M
