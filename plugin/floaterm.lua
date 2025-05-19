vim.api.nvim_create_user_command("Floaterm", function() require('floaterm').toggle_term {} end, {})

